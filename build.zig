const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zinc = b.dependency("zinc", .{
        .target = target,
        .optimize = optimize,
    });

    inline for ([_]struct {
        name: []const u8,
        src: []const u8,
    }{
        .{ .name = "basic", .src = "examples/basic/main.zig" },
        .{ .name = "basic-routing", .src = "examples/basic-routing/main.zig" },
        .{ .name = "simple", .src = "examples/simple/main.zig" },
        .{ .name = "json", .src = "examples/json/main.zig" },
        .{ .name = "map-as-post-form", .src = "examples/map-as-post-form/main.zig" },
        .{ .name = "map-as-query-parameters", .src = "examples/map-as-query-parameters/main.zig" },
        .{ .name = "middlewares", .src = "examples/middlewares/main.zig" },
        .{ .name = "ping", .src = "examples/ping/main.zig" },
        .{ .name = "not-found", .src = "examples/not-found/main.zig" },
        .{ .name = "redirects", .src = "examples/redirects/main.zig" },
        .{ .name = "grouping-routes", .src = "examples/grouping-routes/main.zig" },
        .{ .name = "serving-static-files", .src = "examples/serving-static-files/main.zig" },
        .{ .name = "favicon", .src = "examples/favicon/main.zig" },
        .{ .name = "query-and-post-form", .src = "examples/query-and-post-form/main.zig" },
        .{ .name = "query-parameters", .src = "examples/query-parameters/main.zig" },
    }) |execfg| {
        const exe_name = execfg.name;

        const exe = b.addExecutable(.{
            .name = exe_name,
            .root_source_file = b.path(execfg.src),
            .target = target,
            .optimize = optimize,
        });

        exe.root_module.addImport("zinc", zinc.module("zinc"));

        b.installArtifact(exe);
        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }
        const step_name = "run-" ++ exe_name;
        const run_step = b.step(step_name, "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
}
