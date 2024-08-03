const std = @import("std");
const z = @import("zinc");

pub fn main() !void {
    var zinc = try z.Engine.init(.{
        .allocator = std.heap.page_allocator,
        .port = 8080,
    });

    std.debug.print("Listening on: {any}\n", .{zinc.getAddress()});

    var router = zinc.getRouter();
    try router.get("/hello", hello);
    try router.post("/hi", hi);
    try router.add(&.{ .GET, .POST }, "/ping", pong);

    for (router.getRoutes().items) |r| {
        for (r.methods) |m| {
            std.debug.print("{s} | {s}\n", .{ @tagName(m), r.path });
        }
    }

    try zinc.run();
}

fn hello(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    std.debug.print("Hello!\n", .{});
    try ctx.Text(.{}, "Hello!");
}

fn hi(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    std.debug.print("hi!\n", .{});
    try ctx.Text(.{}, "hi!");
}

fn pong(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    std.debug.print("pong!\n", .{});
    try ctx.Text(.{}, "pong!");
}
