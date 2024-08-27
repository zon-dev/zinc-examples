const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();
    try router.get("/query", queryParamters);

    try z.run();
}

/// GET /query?ids[a]=1234&ids[b]=hello&ids[b]=world HTTP/1.1
fn queryParamters(ctx: *zinc.Context) anyerror!void {
    var ids = ctx.queryMap("ids") orelse return ctx.text("ids not found", .{});
    const ids_a = ids.get("a").?.items;
    const ids_b = ids.get("b").?.items;

    try ctx.json(.{
        .a = ids_a[0],
        .b = .{ ids_b[0], ids_b[1] },
    }, .{});
}
