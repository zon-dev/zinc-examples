const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{
        .port = 8080,
        .num_threads = 254,
    });
    defer z.deinit();

    var router = z.getRouter();

    // Route for /user/:name
    try router.get("/user/:name", userHandler);

    // Route for /user/:name/*
    try router.get("/user/:name/*action", userActionHandler);

    try z.run();
}

fn userHandler(ctx: *zinc.Context) !void {
    const name = ctx.getParam("name") orelse return ctx.text("Not Found", .{ .status = .not_found });
    try ctx.text(name.value, .{});
}

fn userActionHandler(ctx: *zinc.Context) !void {
    const name = ctx.getParam("name").?;
    const action = ctx.getParam("action").?;

    try ctx.json(.{ .name = name.value, .action = action.value }, .{});
}
