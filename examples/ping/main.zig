const z = @import("zinc");

pub fn main() !void {
    var zinc = try z.init(.{ .port = 8080 });

    var router = zinc.getRouter();
    try router.get("/ping", pong);

    try zinc.run();
}

fn pong(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.Text(.{}, "pong!");
}
