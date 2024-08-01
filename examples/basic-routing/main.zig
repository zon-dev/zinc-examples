const std = @import("std");
const z = @import("zinc");

pub fn main() !void {
    var engine = try z.Engine.new(8080);
    std.debug.print("Listening on: 127.0.0.1:{any}\n", .{engine.getPort()});

    var router = &engine.router;
    try router.get("/hello", hello);

    try engine.run();
}

fn hello(_: *z.Context, _: *z.Request, res: *z.Response) anyerror!void {
    std.debug.print("Hello!\n", .{});
    try res.send("Hello!");
}