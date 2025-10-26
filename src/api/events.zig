const std = @import("std");
const kwatcher = @import("kwatcher");
const tk = @import("tokamak");
const zmpl = @import("zmpl");
const metrics = @import("../metrics.zig");

const Cursor = @import("kwatcher-event").models.Cursor;

const EventService = @import("../service/events.zig");
const model = @import("../model.zig");
const template = @import("../template.zig");

pub fn @"GET /get?"(res: *tk.Response, tdata: template.Data, event_service: *EventService, cursor: Cursor) !template.Template {
    var instr = metrics.instrumentAllocator(res.arena);
    const alloc = instr.allocator();
    const rows = try event_service.get(alloc, cursor);
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
    try root.put("index", cursor.drop + @min(rows.items.len, cursor.take));
    try root.put("is_at_end", rows.items.len < cursor.take);
    return template.Template.init("list_events");
}

pub fn @"GET /"(data: template.Data) !template.Template {
    _ = try data.data.object();
    return template.Template.init("event");
}
