const std = @import("std");
const fixtures = @import("fixtures");
const support = @import("support.zig");
const ztoon = @import("ztoon");

test "encodes empty arrays using a counted header" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    const actual = try support.encodeJsonFixture(arena.allocator(), fixtures.empty_array_json, .{});
    try std.testing.expectEqualStrings(fixtures.empty_array_toon, actual);
}

test "encodes tabular arrays with a pipe delimiter" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    const actual = try support.encodeJsonFixture(arena.allocator(), fixtures.pipe_delimiter_json, .{
        .delimiter = .pipe,
    });
    try std.testing.expectEqualStrings(fixtures.pipe_delimiter_toon, actual);
}

test "normalizes unsupported floating point values to null" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    const value = ztoon.Value{
        .object = &.{
            .{ .key = "negative_zero", .value = .{ .float = -0.0 } },
            .{ .key = "infinity", .value = .{ .float = std.math.inf(f64) } },
        },
    };

    const actual = try ztoon.encodeAlloc(arena.allocator(), value, .{});
    try std.testing.expectEqualStrings(
        "negative_zero: null\ninfinity: null",
        actual,
    );
}
