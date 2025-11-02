const std = @import("std");
const tk = @import("tokamak");
const zmpl = @import("zmpl");
const pg = @import("pg");
const kwatcher = @import("kwatcher");
const kserver = @import("kwatcher-server");
const kw_web = @import("kwatcher-web-utils");
const KEventRepo = @import("kwatcher-event").repo.KEvent;
const KClientRepo = @import("kwatcher-event").repo.KClient;
const Config = @import("config.zig").Config;
const builtin = @import("builtin");

fn notFound(context: *tk.Context, inj: *tk.Injector) !kserver.template.Template {
    var data = try inj.get(kserver.template.Data);
    _ = try data.data.object();
    context.res.status = 404;
    return kserver.template.Template.init("not_found");
}

const App = struct {
    system_service: kserver.model.SystemService,
    event_service: kserver.EventService,
    server: tk.Server,
    routes: []const tk.Route = &.{
        tk.logger(.{}, &.{
            kserver.metrics.track(&.{
                .get("/", tk.static.file("static/index.html")),
                .get("/static/*", tk.static.dir("static", .{ .index = null })),
                .get("/metrics", kserver.metrics.route()),
                kserver.template.templates(&.{
                    .group("/api", &.{kw_web.middleware.authn(&.{
                        .group("/system", &.{.router(kserver.api.system)}),
                        .group("/events", &.{.router(kserver.api.events)}),
                    })}),
                    .get("/openapi.json", tk.swagger.json(.{ .info = .{ .title = "KWatcher Server" } })),
                    .get("/swagger-ui", tk.swagger.ui(.{ .url = "openapi.json" })),
                    .get("/*", notFound),
                }),
            }),
        }),
    },

    pub fn configure(bundle: *tk.Bundle) void {
        bundle.add(tk.ServerOptions, .factory(serverOptionsFactory));
        bundle.add(KEventRepo.FromPool, .factory(pgFactory));
        bundle.add(KClientRepo.FromPool, .factory(clientFactory));
        bundle.addDeinitHook(pgDeinit);
        kw_web.auth.addToBundle(bundle);
        kw_web.config.addToBundle(Config, "server", bundle);
        kw_web.config.addChildToBundle(Config, "auth", bundle);
    }

    pub fn pgDeinit(repo: KEventRepo.FromPool) void {
        repo.pool.deinit();
    }

    pub fn clientFactory(ev: KEventRepo.FromPool) !KClientRepo.FromPool {
        return .init(ev.pool);
    }

    pub fn pgFactory(alloc: std.mem.Allocator, config: *Config) !KEventRepo.FromPool {
        return .init(try pg.Pool.init(alloc, .{
            .size = config.daemon.postgre.pool_size,
            .connect = .{
                .port = config.daemon.postgre.port,
                .host = config.daemon.postgre.host,
            },
            .auth = .{
                .username = config.daemon.postgre.auth.username,
                .password = config.daemon.postgre.auth.password,
                .database = config.daemon.postgre.auth.database,
                .timeout = config.daemon.postgre.auth.timeout,
            },
        }));
    }

    pub fn serverOptionsFactory(config: *Config) !tk.ServerOptions {
        std.log.info("Starting web server on: {s}:{}", .{ config.web.hostname, config.web.port });

        return tk.ServerOptions{
            .listen = .{
                .hostname = config.web.hostname,
                .port = config.web.port,
            },
        };
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    {
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        var instr_allocator = kserver.metrics.instrumentAllocator(allocator);
        const alloc = instr_allocator.allocator();
        try kserver.metrics.initialize(alloc, .{});
        defer kserver.metrics.deinitialize();

        const container = try tk.Container.init(alloc, &.{App});
        defer container.deinit();

        if (comptime builtin.os.tag == .linux) {
            // call our shutdown function (below) when
            // SIGINT or SIGTERM are received
            std.posix.sigaction(std.posix.SIG.INT, &.{
                .handler = .{ .handler = shutdown },
                .mask = std.posix.sigemptyset(),
                .flags = 0,
            }, null);
            std.posix.sigaction(std.posix.SIG.TERM, &.{
                .handler = .{ .handler = shutdown },
                .mask = std.posix.sigemptyset(),
                .flags = 0,
            }, null);
        }

        var server = try container.injector.get(*tk.Server);
        server.injector = &container.injector;
        server_instance = server;
        try server.start();
    }
}

var server_instance: ?*tk.Server = null;

fn shutdown(_: c_int) callconv(.c) void {
    if (server_instance) |server| {
        server_instance = null;
        server.stop();
    }
}
