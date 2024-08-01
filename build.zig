const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zinc = b.dependency("zinc", .{
        .target = target,
        .optimize = optimize,
    });

    // const exe = b.addExecutable(
    //     .{
    //     .name = "basic",
    //     .root_source_file = b.path( "examples/basic/main.zig" ),
    //     .target = target,
    //     .optimize = optimize,
    // }
    // );
    // exe.root_module.addImport("zinc", zinc.module("zinc"));
    // b.installArtifact(exe);
    // const run_cmd = b.addRunArtifact(exe);

    inline for ([_]struct {
        name: []const u8,
        src: []const u8,
    }{
        .{ .name = "basic", .src = "examples/basic/main.zig" },
        .{ .name = "simple", .src = "examples/simple/main.zig" },
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
