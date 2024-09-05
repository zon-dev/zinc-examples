const zinc = @import("zinc");
const std = @import("std");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    // Middlwares are executed in the order they are added
    try z.use(&.{ logger, logger2, logger3, logger4 });

    var router = z.getRouter();

    try router.get("/", helloWorld);

    for (router.getRoutes().items) |route| {
        std.debug.print("route {s} method: {any}\r\n", .{ route.path, route.method });
        for (route.handlers_chain.items) |handler| {
            std.debug.print("handler: {any}\r\n", .{handler});
        }
    }

    try z.run();
}

fn helloWorld(ctx: *zinc.Context) anyerror!void {
    std.debug.print("helloWorld\n", .{});
    try ctx.json(.{ .message = "Hello, World!" }, .{});
}

fn logger(ctx: *zinc.Context) anyerror!void {
    const t = std.time.microTimestamp();
    std.debug.print("logger1\n", .{});
    std.time.sleep(1);
    // before request
    try ctx.next();
    // after request
    // _ = ctx;
    const latency = std.time.microTimestamp() - t;
    std.debug.print("latency: {}\n", .{latency});
    std.debug.print("logger1 done...\n", .{});
}

fn logger2(ctx: *zinc.Context) anyerror!void {
    std.debug.print("logger2\n", .{});
    try ctx.json(.{ .message = "logger2" }, .{});
    try ctx.next();
}

fn logger3(ctx: *zinc.Context) anyerror!void {
    std.debug.print("logger3\n", .{});
    try ctx.json(.{ .message = "logger3" }, .{});
    try ctx.next();
}

fn logger4(ctx: *zinc.Context) anyerror!void {
    std.debug.print("logger4\n", .{});
    try ctx.json(.{ .message = "logger4" }, .{});
    try ctx.next();
}
