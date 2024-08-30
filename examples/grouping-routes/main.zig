const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();


    var group = try router.group("/api");
    // /api
    try group.get("", api);
    // /api/v1
    try group.get("/v1", v1);
    // /api/v2
    try group.post("/v2", v2);

    for (router.getRoutes().items) |route| {
        std.debug.print("Route: {s} {s}\n", .{ @tagName(route.method), route.path });
    }

    try z.run();
}

fn api(ctx: *zinc.Context) anyerror!void {
    try ctx.json(.{
        .message = "api home",
    }, .{});
}

fn v1(ctx: *zinc.Context) anyerror!void {
    try ctx.json(.{ .version = "v1" }, .{});
}

fn v2(ctx: *zinc.Context) anyerror!void {
    try ctx.json(.{ .version = "v2" }, .{});
}

fn v3(ctx: *zinc.Context) anyerror!void {
    try ctx.json(.{}, .{});
}
