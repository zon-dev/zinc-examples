const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();
    try router.get("/query", queryParamters);

    try z.run();
}

/// GET /query?id=1234&message=hello&message=world HTTP/1.1
fn queryParamters(ctx: *zinc.Context) anyerror!void {
    const id = try ctx.queryString("id");
    const messages: std.ArrayList([]const u8) = try ctx.queryValues("message");

    const bf = try std.fmt.allocPrint(std.heap.page_allocator, "id: {s}\nmessages: {s} {s}", .{ id, messages.items[0], messages.items[1] });

    try ctx.text(bf, .{});
}
