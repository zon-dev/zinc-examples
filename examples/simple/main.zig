const std = @import("std");
const z = @import("zinc");

pub fn main() !void {
    var engine = try z.Engine.default();
    // var engine = try z.Engine.new(8080);

    std.debug.print("Listening on: 127.0.0.1:{any}\n", .{engine.getPort()});

    var router = &engine.router;
    try router.get("/hello", hello);
    try router.post("/hi", hi);
    try router.add(std.http.Method.GET, "/ping", ping);

    for (router.getRoutes().items) |r| {
        std.debug.print("{s} | {s}\n", .{ @tagName(r.http_method), r.path });
    }

    _ = try engine.run();
}

fn hello(_: *z.Context, _: *z.Request, res: *z.Response) anyerror!void {
    std.debug.print("Hello!\n", .{});
    try res.send("Hello!");
}

fn hi(_: *z.Context, _: *z.Request, res: *z.Response) anyerror!void {
    std.debug.print("hi!\n", .{});
    try res.send("hi!");
}

fn ping(_: *z.Context, _: *z.Request, res: *z.Response) anyerror!void {
    std.debug.print("pong!\n", .{});
    try res.send("pong!");
}
