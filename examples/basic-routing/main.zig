const z = @import("zinc");

pub fn main() !void {
    var zinc = try z.Engine.init(.{ .port = 8080 });

    var router = &zinc.router;
    try router.get("/", hello_world);

    try zinc.run();
}

fn hello_world(_: *z.Context, _: *z.Request, res: *z.Response) anyerror!void {
    try res.sendBody("Hello world!");
}
