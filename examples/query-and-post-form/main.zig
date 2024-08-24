const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();
    // /post?id=1234&page=1&message=hello&message=world
    try router.post("/post", postForm);

    try z.run();
}

fn postForm(ctx: *zinc.Context) anyerror!void {
    const ids = ctx.queryValues("id") orelse return try ctx.text("id not found", .{});

    const id = ids.items[0];
    std.debug.print("id: {s}\n", .{id});

    const messages = ctx.query("message") orelse return try ctx.text("message not found", .{});
    for (messages.items) |message| {
        std.debug.print("message: {s}\n", .{message});
    }

    try ctx.text("hello", .{});
}
