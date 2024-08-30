const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{
        .allocator = std.heap.page_allocator,
        .port = 8080,
    });

    std.debug.print("Listening on: {any}\n", .{z.getAddress()});

    var router = z.getRouter();
    try router.get("/hello", hello);
    try router.post("/hi", hi);
    try router.addAny(&.{ .GET, .POST }, "/ping", pong);

    for (router.getRoutes().items) |r| {
        std.debug.print("{s} | {s}\n", .{ @tagName(r.method), r.path });
    }

    try z.run();
}

fn hello(ctx: *zinc.Context) anyerror!void {
    std.debug.print("Hello!\n", .{});
    try ctx.text("Hello!", .{});
}

fn hi(ctx: *zinc.Context) anyerror!void {
    std.debug.print("hi!\n", .{});
    try ctx.text("hi!", .{});
}

fn pong(ctx: *zinc.Context) anyerror!void {
    std.debug.print("pong!\n", .{});
    try ctx.text("pong!", .{});
}
