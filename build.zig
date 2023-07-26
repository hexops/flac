const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const config_header = b.addConfigHeader(
        .{
            .style = .{ .cmake = .{ .path = "config.cmake.h.in" } },
            .include_path = "config.h",
        },
        .{
            .CPU_IS_BIG_ENDIAN = builtin.target.cpu.arch.endian() == .Big,
            .FLAC__CPU_ARM64 = builtin.target.cpu.arch.isAARCH64(),
            .ENABLE_64_BIT_WORDS = builtin.target.ptrBitWidth() == 64,
            .FLAC__ALIGN_MALLOC_DATA = builtin.target.cpu.arch.isX86(),
            .FLAC__SYS_DARWIN = builtin.target.isDarwin(),
            .FLAC__SYS_LINUX = builtin.target.os.tag == .linux,
            .HAVE_BYTESWAP_H = true,
            .HAVE_CPUID_H = true,
            .HAVE_FSEEKO = true,
            .HAVE_INTTYPES_H = true,
            .HAVE_MEMORY_H = true,
            .HAVE_STDINT_H = true,
            .HAVE_STDLIB_H = true,
            .HAVE_STRING_H = true,
            .HAVE_TYPEOF = true,
            .HAVE_UNISTD_H = true,
        },
    );

    const lib = b.addStaticLibrary(.{
        .name = "flac",
        .target = target,
        .optimize = optimize,
    });
    lib.addConfigHeader(config_header);
    lib.addIncludePath("include");
    lib.addIncludePath("src/libFLAC/include");
    lib.addCSourceFiles(&sources, &.{});
    lib.defineCMacro("HAVE_CONFIG_H", null);
    lib.linkLibC();
    b.installArtifact(lib);
}

const sources = [_][]const u8{
    "src/libFLAC/bitmath.c",
    "src/libFLAC/bitreader.c",
    "src/libFLAC/bitwriter.c",
    "src/libFLAC/cpu.c",
    "src/libFLAC/crc.c",
    "src/libFLAC/fixed.c",
    "src/libFLAC/fixed_intrin_sse2.c",
    "src/libFLAC/fixed_intrin_ssse3.c",
    "src/libFLAC/fixed_intrin_sse42.c",
    "src/libFLAC/fixed_intrin_avx2.c",
    "src/libFLAC/float.c",
    "src/libFLAC/format.c",
    "src/libFLAC/lpc.c",
    "src/libFLAC/lpc_intrin_neon.c",
    "src/libFLAC/lpc_intrin_sse2.c",
    "src/libFLAC/lpc_intrin_sse41.c",
    "src/libFLAC/lpc_intrin_avx2.c",
    "src/libFLAC/lpc_intrin_fma.c",
    "src/libFLAC/md5.c",
    "src/libFLAC/memory.c",
    "src/libFLAC/metadata_iterators.c",
    "src/libFLAC/metadata_object.c",
    "src/libFLAC/stream_decoder.c",
    "src/libFLAC/stream_encoder.c",
    "src/libFLAC/stream_encoder_intrin_sse2.c",
    "src/libFLAC/stream_encoder_intrin_ssse3.c",
    "src/libFLAC/stream_encoder_intrin_avx2.c",
    "src/libFLAC/stream_encoder_framing.c",
    "src/libFLAC/window.c",
};
