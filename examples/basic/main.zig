const std = @import("std");
const zinc = @import("zinc");
pub fn main() !void {
    var z = try zinc.default();
    std.debug.print("Listening on: {any}\n", .{z.getAddress()});
    try z.run();
}
