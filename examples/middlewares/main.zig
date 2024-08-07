const z = @import("zinc");
const std = @import("std");

pub fn main() !void {
    var zinc = try z.init(.{ .port = 8080 });

    _ = try zinc.use(.{ .handler_fn = logger });

    var router = zinc.getRouter();
    try router.get("/", helloWorld);

    try zinc.run();
}

fn helloWorld(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.JSON(.{}, .{ .message = "Hello, World!" });
}

fn logger() z.HandlerFn {
    return struct {
        fn handle(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
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
