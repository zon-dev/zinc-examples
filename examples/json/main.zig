const std = @import("std");
const http = std.http;
const z = @import("zinc");

pub fn main() !void {
    var engine = try z.Engine.new(.{ .port = 8080 });

    var router = &engine.router;
    try router.get("/", jsonString);

    _ = try engine.run();
}

fn jsonString(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.JSON(.{}, .{ .message = "Hello, World!" });
}
