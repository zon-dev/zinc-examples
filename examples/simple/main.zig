const std = @import("std");
const z = @import("zinc");

pub fn main() !void {
    var zinc = try z.Engine.init(.{ .port = 8080 });

    std.debug.print("Listening on: {any}\n", .{zinc.getAddress()});

    var router = zinc.getRouter();
    try router.get("/hello", hello);
    try router.post("/hi", hi);
    try router.add(std.http.Method.GET, "/ping", ping);

    for (router.getRoutes().items) |r| {
        std.debug.print("{s} | {s}\n", .{ @tagName(r.http_method), r.path });
    }

    _ = try zinc.run();
}

fn hello(_: *z.Context, _: *z.Request, res: *z.Response) anyerror!void {
    std.debug.print("Hello!\n", .{});
    try res.sendBody("Hello!");
}

fn hi(_: *z.Context, _: *z.Request, res: *z.Response) anyerror!void {
    std.debug.print("hi!\n", .{});
    try res.sendBody("hi!");
}

fn ping(_: *z.Context, _: *z.Request, res: *z.Response) anyerror!void {
    std.debug.print("pong!\n", .{});
    try res.sendBody("pong!");
}
