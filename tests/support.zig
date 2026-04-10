const std = @import("std");
const fixtures = @import("fixtures");
const ztoon = @import("ztoon");

pub fn encodeJsonFixture(
    allocator: std.mem.Allocator,
    json_bytes: []const u8,
    options: ztoon.EncodeOptions,
) ![]u8 {
    _ = fixtures;
    const parsed = try std.json.parseFromSliceLeaky(std.json.Value, allocator, json_bytes, .{});
    const value = try ztoon.Value.fromJsonValue(allocator, parsed);
    return ztoon.encodeAlloc(allocator, value, options);
}
