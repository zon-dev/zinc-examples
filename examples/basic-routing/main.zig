const z = @import("zinc");

pub fn main() !void {
    var engine = try z.Engine.new(.{ .port = 8080 });

    var router = &engine.router;
    try router.get("/hello", hello);

    try engine.run();
}

fn hello(_: *z.Context, _: *z.Request, res: *z.Response) anyerror!void {
    try res.send("Hello!");
}
