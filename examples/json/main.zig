const zinc = @import("zinc");
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{
        // .thread_safe = true,
    }){};
    const allocator = gpa.allocator();

    var z = try zinc.init(.{
        .port = 8080,
        .allocator = allocator,
    });
    defer z.deinit();

    var router = z.getRouter();
    try router.get("/", helloWorld);

    std.debug.print("Starting server on {any}\n", .{z.getAddress()});
    try z.run();
    std.debug.print("Server stopped\n", .{});
    // z.wait();
}

fn helloWorld(ctx: *zinc.Context) anyerror!void {
    try ctx.json(.{ .message = "Hello, World!" }, .{});
}
