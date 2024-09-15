const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{
        .port = 8080,
        .num_threads = 255,
        .stack_size = 10 * 1024 * 1024,
    });

    var router = z.getRouter();
    var group = try router.group("/api");
    var v2group = try group.group("/v2/user");
    // /api/v2/user/login
    try v2group.addAny(&.{ .GET, .POST, .OPTIONS }, "/login", v2);
    // /api/v2/user/logout
    try v2group.get("/logout", v2);
    try v2group.post("/logout", v2);

    router.printRouter();

    try z.run();
}

fn v2(ctx: *zinc.Context) anyerror!void {
    try ctx.json(.{ .version = "v2" }, .{});
}
