const zinc = @import("zinc");
const std = @import("std");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    _ = try z.use(.{ .handler_fn = logger });

    var router = z.getRouter();
    try router.get("/", helloWorld);

    try z.run();
}

fn helloWorld(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    try ctx.JSON(.{}, .{ .message = "Hello, World!" });
}

fn logger() zinc.HandlerFn {
    return struct {
        fn handle(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
            const t = std.time.milliTimestamp();
            std.time.sleep(1);
            // before request
            try ctx.next();
            // after request
            const latency = std.time.milliTimestamp() - t;
            std.debug.print("latency: {}\n", .{latency});
        }
    }.handle;
}
