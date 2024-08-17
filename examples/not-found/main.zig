const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var catchers = z.getCatchers();
    try catchers.setNotFound(notFound);

    try z.run();
}

fn notFound(ctx: *zinc.Context, _: *zinc.Request, _: *zinc.Response) anyerror!void {
    try ctx.html(.{
        .status = .not_found,
    }, "<h1>404 Not Found</h1>");
}
