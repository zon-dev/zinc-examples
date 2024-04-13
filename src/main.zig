const zinc = @import("zinc");
pub fn main() !void {
    const engine = zinc.Engine.default();
    _ = try engine.run();
}
