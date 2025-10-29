const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const googletest_dep = b.dependency("googletest", .{});

    const gtest = b.addLibrary(.{
        .name = "gtest",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = true,
        }),
    });
    gtest.addCSourceFile(.{
        .file = googletest_dep.path("googletest/src/gtest-all.cc"),
        .flags = &.{},
    });
    gtest.addIncludePath(googletest_dep.path("googletest/include"));
    gtest.addIncludePath(googletest_dep.path("googletest"));
    gtest.installHeadersDirectory(googletest_dep.path("googletest/include"), ".", .{});

    b.installArtifact(gtest);

    const gmock = b.addLibrary(.{
        .name = "gmock",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = true,
        }),
    });
    gmock.addCSourceFile(.{
        .file = googletest_dep.path("googlemock/src/gmock-all.cc"),
        .flags = &.{},
    });
    gmock.addIncludePath(googletest_dep.path("googlemock/include"));
    gmock.addIncludePath(googletest_dep.path("googlemock"));
    gmock.installHeadersDirectory(googletest_dep.path("googlemock/include"), ".", .{});

    gmock.linkLibrary(gtest);
    b.installArtifact(gmock);

    const gtest_main = b.addLibrary(.{
        .name = "gtest_main",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = true,
        }),
    });
    gtest_main.addCSourceFile(.{
        .file = googletest_dep.path("googletest/src/gtest_main.cc"),
        .flags = &.{},
    });
    gtest_main.addIncludePath(googletest_dep.path("googletest/include"));
    gtest_main.addIncludePath(googletest_dep.path("googletest"));
    gtest_main.installHeadersDirectory(googletest_dep.path("googletest/include"), ".", .{});
    b.installArtifact(gtest_main);
}
