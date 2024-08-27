const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();
    try router.post("/post", queryAndForm);

    try z.run();
}

/// POST /post?id=1234&message=hello&message=world HTTP/1.1
/// Content-Type: application/x-www-form-urlencoded
///
/// name=jack&friend=mike
///
fn queryAndForm(ctx: *zinc.Context) anyerror!void {
    const id = try ctx.queryString("id");
    const messages = try ctx.queryValues("message");

    const form = ctx.getPostFormMap().?;
    const name = form.get("name").?;
    const friend = form.get("friend").?;

    try ctx.json(.{
        .id = id,
        .name = name,
        .friend = friend,
        .messages = .{ messages.items[0], messages.items[1] },
    }, .{});
}
