const std = @import("std");
const kwatcher = @import("kwatcher");
const tk = @import("tokamak");
const zmpl = @import("zmpl");
const metrics = @import("../metrics.zig");

const models = @import("kwatcher-event").models;

const EventService = @import("../service/events.zig");
const model = @import("../model.zig");
const template = @import("../template.zig");

pub fn @"GET /get?"(
    res: *tk.Response,
    tdata: template.Data,
    event_service: *EventService,
    query: models.PaginatedEventsQuery,
) !template.Template {
    var instr = metrics.instrumentAllocator(res.arena);
    const alloc = instr.allocator();
    const rows = try event_service.get(alloc, query);
    var data = tdata.data;
    const root = try data.object();
    const events = try data.array();
    try root.put("events", events);
    for (rows.items) |event| {
        const obj = try data.object();
        try obj.put("event_type", event.event_type);
        try obj.put("from", event.start_time);
        try obj.put("to", event.end_time);
        try obj.put("duration", event.end_time - event.start_time);
        try obj.put("user_id", event.user_id);
        try obj.put("data", event.properties);
        try events.append(obj);
    }
    try root.put("index", query.drop + @min(rows.items.len, query.take));
    try root.put("is_at_end", rows.items.len < query.take);
    return template.Template.init("list_events");
}

pub fn @"GET /recent"(
    res: *tk.Response,
    tdata: template.Data,
    event_service: *EventService,
) !template.Template {
    var instr = metrics.instrumentAllocator(res.arena);
    const alloc = instr.allocator();
    const rows = try event_service.recent(alloc);
    var data = tdata.data;
    const root = try data.object();
    const events = try data.array();
    try root.put("events", events);
    for (rows.items) |event| {
        const obj = try data.object();
        try obj.put("event_type", event.event_type);
        try obj.put("from", event.start_time);
        try obj.put("to", event.end_time);
        try obj.put("duration", event.end_time -| event.start_time);
        try obj.put("user_id", event.user_id);
        try obj.put("data", event.properties);
        const client = try data.object();
        try client.put("name", event.client_name);
        try client.put("version", event.client_version);
        try client.put("host", event.client_host);
        try obj.put("client", client);
        try events.append(obj);
    }
    return template.Template.init("list_activity");
}

pub fn @"GET /types?"(
    res: *tk.Response,
    tdata: template.Data,
    event_service: *EventService,
    query: models.EventFilters,
) !template.Template {
    var instr = metrics.instrumentAllocator(res.arena);
    const alloc = instr.allocator();
    const rows = try event_service.types(alloc, query);
    var data = tdata.data;
    const root = try data.object();
    const types = try data.array();
    try root.put("options", types);
    for (rows.items) |event| {
        try types.append(event);
    }
    res.headers.add("cache-control", "public, max-age=60");
    return template.Template.init("list_options");
}

pub fn @"GET /clients?"(
    res: *tk.Response,
    tdata: template.Data,
    event_service: *EventService,
    query: models.EventFilters,
) !template.Template {
    var instr = metrics.instrumentAllocator(res.arena);
    const alloc = instr.allocator();
    const rows = try event_service.clients(alloc, query);
    var data = tdata.data;
    const root = try data.object();
    const clients = try data.array();
    try root.put("options", clients);
    for (rows.items) |event| {
        try clients.append(event);
    }
    res.headers.add("cache-control", "public, max-age=300");
    return template.Template.init("list_options");
}

pub fn @"GET /hosts?"(
    res: *tk.Response,
    tdata: template.Data,
    event_service: *EventService,
    query: models.EventFilters,
) !template.Template {
    var instr = metrics.instrumentAllocator(res.arena);
    const alloc = instr.allocator();
    const rows = try event_service.hosts(alloc, query);
    var data = tdata.data;
    const root = try data.object();
    const hosts = try data.array();
    try root.put("options", hosts);
    for (rows.items) |event| {
        try hosts.append(event);
    }
    res.headers.add("cache-control", "public, max-age=300");
    return template.Template.init("list_options");
}

pub fn @"GET /activity_card?"(
    res: *tk.Response,
    tdata: template.Data,
    params: struct { event_type: []const u8 },
) !template.Template {
    var instr = metrics.instrumentAllocator(res.arena);
    const alloc = instr.allocator();
    var data = tdata.data;
    _ = try data.object();
    const tmpl = try std.fmt.allocPrint(
        alloc,
        "activity_card_{s}",
        .{params.event_type},
    );
    //    res.headers.add("cache-control", "public, max-age=300");
    return template.Template.init(tmpl);
}

pub fn @"GET /"(data: template.Data) !template.Template {
    _ = try data.data.object();
    return template.Template.init("event");
}

pub fn @"GET /table"(data: template.Data) !template.Template {
    _ = try data.data.object();
    return template.Template.init("event_table");
}
