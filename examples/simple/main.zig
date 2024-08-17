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
    try router.add(&.{ .GET, .POST }, "/ping", pong);

    for (router.getRoutes().items) |r| {
        for (r.methods) |m| {
            std.debug.print("{s} | {s}\n", .{ @tagName(m), r.path });
        }
    }

    try z.run();
}

fn hello(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    std.debug.print("Hello!\n", .{});
    try ctx.text(.{}, "Hello!");
}

fn hi(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    std.debug.print("hi!\n", .{});
    try ctx.text(.{}, "hi!");
}

fn pong(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    std.debug.print("pong!\n", .{});
    try ctx.text(.{}, "pong!");
}
