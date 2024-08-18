const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();
    try router.get("/", helloWorld);

    try z.run();
}

fn helloWorld(ctx: *zinc.Context) anyerror!void {
    try ctx.text("Hello world!", .{});
}
