const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();

    try router.staticFile("/", "examples/serving-static-files/index.html");
    try router.staticDir("/assets", "examples/serving-static-files/assets");

    for (router.getRoutes().items) |route| {
        std.debug.print("Route: {s}\n", .{route.path});
    }

    try z.run();
}
