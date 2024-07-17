const std = @import("std");
const zinc = @import("zinc");
pub fn main() !void {
    const engine = try zinc.Engine.default();
    std.debug.print("Listening on: 127.0.0.1:{any}\n", .{ engine.get_port() });
    _ = try engine.run();
}
