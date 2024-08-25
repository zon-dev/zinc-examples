const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    var z = try zinc.init(.{ .port = 8080 });

    var router = z.getRouter();
    try router.post("/post", queryAndForm);

    try z.run();
}

/// POST /post?id=1234&message=hello&message=world HTTP/1.1
/// Content-Type: application/x-www-form-urlencoded
///
/// name:jack
/// friend:mike
///
fn queryAndForm(ctx: *zinc.Context) anyerror!void {
    const id = try ctx.queryString("id");

    const messages: std.ArrayList([]const u8) = try ctx.queryValues("message");

    const form = ctx.postFormMap().?; // form is a map
    const name = form.get("name").?;
    const friend = form.get("friend").?;

    const bf = try std.fmt.allocPrint(std.heap.page_allocator, "id: {s}\nname: {s} \nfriend: {s}\nmessages: {s} {s}", .{ id, name, friend, messages.items[0], messages.items[1] });

    try ctx.text(bf, .{});
}
