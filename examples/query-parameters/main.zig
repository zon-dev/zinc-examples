const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });
    defer z.deinit();

    var router = z.getRouter();
    try router.get("/query", queryParamters);

    try z.run();
}

/// GET /query?id=1234&message=hello&message=world HTTP/1.1
fn queryParamters(ctx: *zinc.Context) anyerror!void {
    const id = try ctx.queryString("id");
    const messages = try ctx.queryValues("message");

    try ctx.json(.{
        .id = id,
        .message = .{ messages.items[0], messages.items[1] },
    }, .{});
}
