const zinc = @import("zinc");
pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080, .num_threads = 16 });
    defer z.deinit();

    var router = z.getRouter();

    try router.use(&.{zinc.Middleware.cors()});

    try router.get("/cors", cors);

    try z.run();
}

fn cors(ctx: *zinc.Context) anyerror!void {
    try ctx.text("cors!", .{});
}
