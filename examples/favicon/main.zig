const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();

    try router.get("/", index);
    try router.add(&.{ .GET, .HEAD }, "/favicon.ico", favicon);

    try z.run();
}

pub fn index(ctx: *zinc.Context) anyerror!void {
    try ctx.file("examples/favicon/index.html", .{});
}

pub fn favicon(ctx: *zinc.Context) anyerror!void {
    try ctx.file("examples/favicon/favicon.ico", .{});
}
