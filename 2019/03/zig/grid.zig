//------------------------------------------------------------------------------
// GrooveStomp's Advent of Code
// Copyright (c) 2019 Aaron Oman (GrooveStomp)
//
// File: grid.zig
// Created: 2019-12-10
// Updated: 2019-12-10
// Author: Aaron Oman (GrooveStomp)
//
// Notice: CC BY 4.0 License
//
// This program comes with ABSOLUTELY NO WARRANTY.
// This is free software, and you are welcome to redistribute it under certain
// conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
//------------------------------------------------------------------------------
const std = @import("std");
const lib_point = @import("point.zig");
const lib_segment = @import("segment.zig");
const alloc = std.heap.direct_allocator;
const os = std.os;

pub const Grid = struct {
    segments: std.ArrayList(lib_segment.Segment),
};

pub fn NewGrid(fd: c_int) !*Grid {
    var cursor = lib_point.Point{ .x = 0, .y = 0};
    var grid = try alloc.create(Grid);

    grid.segments = std.ArrayList(lib_segment.Segment).init(alloc);

    var str = try std.Buffer.init(alloc, [_]u8{});
    defer str.deinit();

    while (true) {
        var err = false;
        var ch: [1]u8 = undefined;
        var n = try os.read(fd, ch[0..]);

        if (err or n == 0 or ch[0] == '\n' or ch[0] == ',') {
            var segment = try lib_segment.NewSegment(cursor, str.toSlice());
            cursor = segment.points[1];
            try grid.segments.append(segment.*);
            try str.replaceContents("");

            if (ch[0] == ',') continue;

            break;
        }

        try str.append(ch);
    }

    return grid;
}
