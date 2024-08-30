const zinc = @import("zinc");
const std = @import("std");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var middleware = zinc.Middleware.init(.{});
    try middleware.any(&.{}, logger);
    try middleware.any(&.{}, logger2);

    try z.use(middleware);

    var router = z.getRouter();

    try router.get("/", helloWorld);
    try router.get("/", logger);
    try router.get("/", logger2);
    try router.get("/", logger2);

    try router.post("/", logger2);
    try router.post("/", logger2);

    // try router.use("*", logger);

    for (router.getRoutes().items) |route| {
        std.debug.print("route {s} method: {any}\r\n", .{ route.path, route.method });
        for (route.handlers_chain.items) |handler| {
            std.debug.print("handler: {any}\r\n", .{handler});
        }
    }

    try z.run();
}

fn helloWorld(ctx: *zinc.Context) anyerror!void {
    try ctx.json(.{ .message = "Hello, World!" }, .{});
}

fn logger(ctx: *zinc.Context) anyerror!void {
    const t = std.time.microTimestamp();
    std.debug.print("logger1 1\n", .{});
    std.time.sleep(1);
    // before request
    try ctx.next();
    // after request
    const latency = std.time.microTimestamp() - t;
    std.debug.print("latency: {}\n", .{latency});
}

fn logger2(ctx: *zinc.Context) anyerror!void {
    std.debug.print("logger2\n", .{});
    try ctx.json(.{ .message = "logger2" }, .{});
    try ctx.next();
}
