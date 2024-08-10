const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();
    try router.get("/", helloWorld);

    // /api
    var group = try router.group("/api", api);
    // /api/v1
    try group.get("/v1", v1);
    // /api/v2
    try group.get("/v2", v2);

    for (router.routes.items) |route| {
        std.debug.print("Route: {s}\n", .{route.path});
    }

    try z.run();
}

fn helloWorld(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    try ctx.Text(.{}, "Hello world!");
}

fn api(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    try ctx.JSON(.{}, .{
        .message = "api home",
    });
}

fn v1(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    try ctx.JSON(.{}, .{
        .version = "v1",
    });
}

fn v2(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    try ctx.JSON(.{}, .{
        .version = "v2",
    });
}
