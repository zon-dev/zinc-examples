const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });
    defer z.deinit();

    var router = z.getRouter();

    try router.staticFile("/", "examples/favicon/index.html");
    try router.staticFile("/favicon.ico", "examples/favicon/favicon.ico");

    try z.run();
}
