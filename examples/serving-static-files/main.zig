const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });
    defer z.deinit();

    var router = z.getRouter();

    try router.staticFile("/", "examples/serving-static-files/index.html");
    try router.staticDir("/assets", "examples/serving-static-files/assets");
    // try router.staticFile("/assets/style.css", "examples/serving-static-files/assets/style.css");

    router.printRouter();

    try z.run();
}
