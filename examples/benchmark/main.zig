const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    const allocator = std.heap.smp_allocator;

    var z = try zinc.init(.{
        .port = 3000,
        .allocator = allocator,
        .num_threads = 16 * @as(u8, @intCast(std.Thread.getCpuCount() catch 1)),
        .read_buffer_len = 10 * 1024,
        .stack_size = 10 * 1024 * 1024,
        // .max_connections = 1000,
    });
    defer z.deinit();

    var router = z.getRouter();
    try router.get("/plaintext", plaintext);

    try z.run();
}

fn plaintext(ctx: *zinc.Context) anyerror!void {
    try ctx.text("Hello, world!", .{});
}
