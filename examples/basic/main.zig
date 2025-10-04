const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.default();
    defer z.deinit();

    std.debug.print("Listening on: 127.0.0.1:{any}\n", .{z.getAddress().getPort()});

    try z.run();
    std.debug.print("Done\n", .{});
}
