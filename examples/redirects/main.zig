const z = @import("zinc");

pub fn main() !void {
    var zinc = try z.Engine.init(.{ .port = 8080 });

    var router = zinc.getRouter();
    try router.get("/test", redirect);
    try router.get("/hello", helloWorld);

    try zinc.run();
}

fn redirect(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.redirect("/hello");
}

fn helloWorld(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.Text(.{}, "Hello world!");
}
