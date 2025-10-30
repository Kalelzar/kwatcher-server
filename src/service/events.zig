const std = @import("std");
const kwatcher = @import("kwatcher");

const KEventRepo = @import("kwatcher-event").repo.KEvent;
const models = @import("kwatcher-event").models;

const EventService = @This();

repo_factory: *KEventRepo.FromPool,

pub fn init(repo: *KEventRepo.FromPool) EventService {
    return .{
        .repo_factory = repo,
    };
}

pub fn get(self: *const EventService, allocator: std.mem.Allocator, query: models.PaginatedEventsQuery) !std.ArrayList(KEventRepo.KEventRow) {
    var repo = try self.repo_factory.yield();
    defer repo.deinit();
    return repo.get(allocator, query);
}

pub fn types(self: *const EventService, allocator: std.mem.Allocator) !std.ArrayList([]const u8) {
    var repo = try self.repo_factory.yield();
    defer repo.deinit();
    return repo.types(allocator);
}
