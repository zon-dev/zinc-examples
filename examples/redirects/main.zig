const zinc = @import("zinc");
const std = @import("std");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();
    try router.get("/test", redirect);
    try router.get("/github", redirectToGitHub);
    try router.get("/hello", helloWorld);

    try z.run();
}

fn redirect(ctx: *zinc.Context) anyerror!void {
    // Redirect to /hello, with a 302 status code
    try ctx.redirect(.found, "/hello");
}
fn redirectToGitHub(ctx: *zinc.Context) anyerror!void {
    // Redirect to https://github.com, with a 301 status code
    try ctx.redirect(.moved_permanently, "https://github.com");
}

fn helloWorld(ctx: *zinc.Context) anyerror!void {
    try ctx.text("Hello world!", .{});
}
