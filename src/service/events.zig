const std = @import("std");
const kwatcher = @import("kwatcher");

const repo = @import("kwatcher-event").repo;
const models = @import("kwatcher-event").models;

const EventService = @This();

repo_factory: *repo.KEvent.FromPool,
client_repo_factory: *repo.KClient.FromPool,

pub fn init(
    erepo: *repo.KEvent.FromPool,
    crepo: *repo.KClient.FromPool,
) EventService {
    return .{
        .repo_factory = erepo,
        .client_repo_factory = crepo,
    };
}

pub fn get(self: *const EventService, allocator: std.mem.Allocator, query: models.PaginatedEventsQuery) !std.ArrayList(repo.KEvent.KEventRow) {
    var erepo = try self.repo_factory.yield();
    defer erepo.deinit();
    return erepo.get(allocator, query);
}

pub fn recent(self: *const EventService, allocator: std.mem.Allocator) !std.ArrayList(repo.KEvent.KEventWithClientRow) {
    var erepo = try self.repo_factory.yield();
    defer erepo.deinit();
    return erepo.getRecent(allocator);
}

pub fn types(
    self: *const EventService,
    allocator: std.mem.Allocator,
    query: models.EventFilters,
) !std.ArrayList([]const u8) {
    var erepo = try self.repo_factory.yield();
    defer erepo.deinit();
    return erepo.types(allocator, query);
}

pub fn clients(
    self: *const EventService,
    allocator: std.mem.Allocator,
    query: models.EventFilters,
) !std.ArrayList([]const u8) {
    var crepo = try self.client_repo_factory.yield();
    defer crepo.deinit();
    return crepo.getClients(allocator, query);
}

pub fn hosts(
    self: *const EventService,
    allocator: std.mem.Allocator,
    query: models.EventFilters,
) !std.ArrayList([]const u8) {
    var crepo = try self.client_repo_factory.yield();
    defer crepo.deinit();
    return crepo.getHosts(allocator, query);
}
