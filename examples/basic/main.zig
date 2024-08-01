const std = @import("std");
const z = @import("zinc");
pub fn main() !void {
    var zinc = try z.Engine.default();
    std.debug.print("Listening on: {any}\n", .{zinc.getAddress()});
    try zinc.run();
}
