const zinc = @import("zinc");
const std = @import("std");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var middleware = zinc.Middleware.init(.{});
    try middleware.add(&.{}, logger);
    try middleware.add(&.{}, logger2);

    try z.use(middleware);

    var router = z.getRouter();
    try router.get("/", helloWorld);

    try z.run();
}

fn helloWorld(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    try ctx.JSON(.{}, .{ .message = "Hello, World!" });
}

fn logger(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    const t = std.time.milliTimestamp();
    std.debug.print("logger1\n", .{});

    std.time.sleep(1);
    // before request
    try ctx.next();
    // after request
    const latency = std.time.milliTimestamp() - t;
    std.debug.print("latency: {}\n", .{latency});
}

fn logger2(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    try ctx.next();
    std.debug.print("logger2\n", .{});
}
