const z = @import("zinc");

pub fn main() !void {
    var zinc = try z.Engine.init(.{ .port = 8080 });

    var router = zinc.getRouter();
    try router.get("/test", redirect);
    try router.get("/github", redirectToGitHub);
    try router.get("/hello", helloWorld);

    try zinc.run();
}

fn redirect(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    // Redirect to /hello, with a 302 status code
    try ctx.redirect(.found, "/hello");
}
fn redirectToGitHub(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    // Redirect to https://github.com, with a 301 status code
    try ctx.redirect(.moved_permanently,"https://github.com");
}

fn helloWorld(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.Text(.{}, "Hello world!");
}