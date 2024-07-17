const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zinc-examples",
        .root_source_file = b.path( "src/main.zig" ),
        .target = target,
        .optimize = optimize,
    });

    const zinc = b.dependency("zinc", .{
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
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
