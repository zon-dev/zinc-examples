const std = @import("std");
const z = @import("zinc");

pub fn main() !void {
    const engine = try z.Engine.default();

    std.debug.print("Listening on: 127.0.0.1:{any}\n", .{engine.getPort()});

    var router = engine.getRouter();
    try router.get("/hello", hello);
    try router.post("/hi", hi);
    try router.add(std.http.Method.GET, "/ping", ping);

    for (router.getRoutes().items) |r| {
        std.debug.print("Route {d}, path: {s}\n", .{ r.http_method, r.path });
    }
    _ = try engine.run();
}

fn hello(_: z.Context, _: z.Request, res: z.Response) anyerror!void {
    try res.sendBody("Hello!");
}

fn hi(_: z.Context, _: z.Request, res: z.Response) anyerror!void {
    _ = try res.sendBody("Hi!");
}

fn ping(_: z.Context, _: z.Request, res: z.Response) anyerror!void {
    _ = try res.sendBody("pong!");
}
