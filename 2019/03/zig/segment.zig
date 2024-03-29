//------------------------------------------------------------------------------
// GrooveStomp's Advent of Code
// Copyright (c) 2019 Aaron Oman (GrooveStomp)
//
// File: segment.zig
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
const p = @import("point.zig");
const alloc = std.heap.direct_allocator;
const warn = std.debug.warn;
const math = std.math;

pub const Segment = struct {
    points: [2]p.Point,

    pub fn isVertical(s: Segment) bool {
        return s.points[0].x == s.points[1].x;
    }

    pub fn isHorizontal(s: Segment) bool {
        return s.points[0].y == s.points[1].y;
    }
};

pub fn NewSegment(point: p.Point, str: []u8) !*Segment {
    if (std.mem.eql(u8, str, "")) {
        return error.Unexpected;
    }

    var magnitude = @intCast(isize, try std.fmt.parseInt(usize, str[1..], 10));
    var segment = try alloc.create(Segment);
    segment.points[0] = point;

    switch (str[0]) {
        'U' => segment.points[1] = p.Point{ .x = point.x, .y = point.y + magnitude },
        'D' => segment.points[1] = p.Point{ .x = point.x, .y = point.y - magnitude },
        'L' => segment.points[1] = p.Point{ .x = point.x - magnitude, .y = point.y },
        'R' => segment.points[1] = p.Point{ .x = point.x + magnitude, .y = point.y },
        else => {
            warn("Unknown direction\n");
            return error.Unexpected;
        }
    }

    return segment;
}
