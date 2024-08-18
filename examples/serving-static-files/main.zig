const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();

    try router.get("/", index);
    try router.add(&.{ .GET, .HEAD }, "/assets", assets);

    for (router.getRoutes().items) |route| {
        std.debug.print("Route: {s}\n", .{route.path});
    }

    try z.run();
}

pub fn index(ctx: *zinc.Context) anyerror!void {
    try ctx.file("examples/serving-static-files/index.html", .{});
}

pub fn assets(ctx: *zinc.Context) anyerror!void {
    ctx.dir("examples/serving-static-files/assets", .{}) catch {
        try ctx.text("Not found", .{ .status = .not_found });
    };
}
