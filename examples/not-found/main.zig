const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var catchers = z.getCatchers();
    try catchers.setNotFound(notFound);

    try z.run();
}

fn notFound(ctx: *zinc.Context) anyerror!void {
    try ctx.html("<h1>404 Not Found</h1>", .{
        .status = .not_found,
    });
}
