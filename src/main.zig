const std = @import("std");
const tk = @import("tokamak");
const zmpl = @import("zmpl");
const pg = @import("pg");
const kwatcher = @import("kwatcher");
const kserver = @import("kwatcher-server");
const KEventRepo = @import("kwatcher-event").repo.KEvent;
const Config = @import("config.zig").Config;
const builtin = @import("builtin");

fn dumpInj(inj: *tk.Injector) void {
    std.debug.print("Contents:\n", .{});
    for (inj.refs) |ref| {
        std.debug.print("  {s} (const? {}): {any}\n", .{ ref.tid.name, ref.is_const, ref.ptr });
    }
}

fn notFound(context: *tk.Context, inj: *tk.Injector) !kserver.template.Template {
    dumpInj(inj);
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
                .get("/metrics", kserver.metrics.route()),
                kserver.template.templates(&.{
                    .group("/api/system", &.{.router(kserver.api.system)}),
                    .group("/api/events", &.{.router(kserver.api.events)}),
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
        bundle.addDeinitHook(pgDeinit);
    }

    pub fn pgDeinit(repo: KEventRepo.FromPool) void {
        repo.pool.deinit();
    }

    pub fn pgFactory(alloc: std.mem.Allocator) !KEventRepo.FromPool {
        const config = try kwatcher.config.findConfigFile(
            Config,
            alloc,
            "server",
        ) orelse return error.ConfigNotFound;

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

    pub fn serverOptionsFactory(allocator: std.mem.Allocator) !tk.ServerOptions {
        const config = try kwatcher.config.findConfigFile(
            Config,
            allocator,
            "server",
        ) orelse return error.ConfigNotFound;

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
    defer _ = gpa.deinit();
    {
        const allocator = gpa.allocator();

        var instr_allocator = kserver.metrics.instrumentAllocator(allocator);
        const alloc = instr_allocator.allocator();
        try kserver.metrics.initialize(alloc, .{});
        defer kserver.metrics.deinitialize();

        var instr_page_allocator = kserver.metrics.instrumentAllocator(std.heap.page_allocator);
        const page_allocator = instr_page_allocator.allocator();
        var arena = std.heap.ArenaAllocator.init(page_allocator);
        defer arena.deinit();

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
    _ = gpa.detectLeaks();
}

var server_instance: ?*tk.Server = null;

fn shutdown(_: c_int) callconv(.c) void {
    if (server_instance) |server| {
        server_instance = null;
        server.stop();
    }
}
