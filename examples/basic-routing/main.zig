const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();
    try router.get("/hello", helloWorld);
    try router.post("/hi", hi);
    try router.addAny(&.{ .GET, .POST }, "/ping", pong);
    try z.run();
}

fn helloWorld(ctx: *zinc.Context) anyerror!void {
    try ctx.json(.{ .message = "Hello, World!" }, .{});
}

fn hi(ctx: *zinc.Context) anyerror!void {
    try ctx.html("<h1>Hi!</h1>", .{});
}

fn pong(ctx: *zinc.Context) anyerror!void {
    try ctx.text("pong!", .{});
}
