const zinc = @import("zinc");
const std = @import("std");
pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080, .num_threads = 100 });
    defer z.deinit();

    try z.use(&.{ logger, logger2, logger3, logger4 });

    var router = z.getRouter();
    try router.get("/", helloWorld);

    try z.run();
}

fn helloWorld(ctx: *zinc.Context) anyerror!void {
    std.debug.print("Hello, World!\n", .{});
    try ctx.text("Hello, World!", .{});
}
fn logger(ctx: *zinc.Context) anyerror!void {
    const t = try std.time.Instant.now();
    std.debug.print("logger1\n", .{});
    // before request
    try ctx.next();
    // after request
    const now = try std.time.Instant.now();
    const latency_ns = now.since(t);
    const latency_us = latency_ns / std.time.ns_per_us;
    std.debug.print("Done all. latency: {}\n", .{latency_us});
}
fn logger2(ctx: *zinc.Context) anyerror!void {
    std.debug.print("logger2\n", .{});
    try ctx.json(.{ .message = "logger2" }, .{});
    try ctx.next();
}
fn logger3(ctx: *zinc.Context) anyerror!void {
    std.debug.print("logger3\n", .{});
    // Invoke next handler (logger4) in the chain.
    try ctx.next();
    // This line is executed after the next handler in the chain.
    std.debug.print("logger3 done.\n", .{});
}
fn logger4(ctx: *zinc.Context) anyerror!void {
    std.debug.print("logger4\n", .{});
    try ctx.html("<h1>logger4<h1>", .{});
    // Invoke the last handler (helloWorld) in the chain.
    try ctx.next();
}
