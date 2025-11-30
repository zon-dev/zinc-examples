const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{
        .port = 5882,
        .num_threads = 254,
    });

    var router = z.getRouter();
    try router.get("/", home);

    try router.get("/hello", helloWorld);
    try router.post("/hi", hi);
    try router.addAny(&.{ .GET, .POST }, "/ping", pong);

    // add a group
    var usergroup = try router.group("/user");
    try usergroup.addAny(&.{ .GET, .POST }, "/login", user);
    try usergroup.post("/logout", user);

    // add a group
    var admingroup = try router.group("/admin");
    try admingroup.addAny(&.{ .GET, .POST }, "/login", user);
    try admingroup.post("/logout", user);

    // print the router
    router.printRouter();

    try z.run();
}

fn home(ctx: *zinc.Context) anyerror!void {
    try ctx.setHeader("Connection", "keep-alive");
    try ctx.text("hello world!", .{});
}
fn helloWorld(ctx: *zinc.Context) anyerror!void {
    try ctx.json(.{ .message = "Hello, World!" }, .{});
}
fn hi(ctx: *zinc.Context) anyerror!void {
    try ctx.html("<h1>Hi!</h1>", .{});
}
fn pong(ctx: *zinc.Context) anyerror!void {
    try ctx.text("pong!", .{});
}
fn user(ctx: *zinc.Context) anyerror!void {
    try ctx.text("User group.", .{});
}
