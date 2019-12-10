//------------------------------------------------------------------------------
// GrooveStomp's Advent of Code
// Copyright (c) 2019 Aaron Oman (GrooveStomp)
//
// File: point.zig
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
const math = std.math;

pub const Point = struct {
    x: isize,
    y: isize,

    pub fn distance(p: Point) isize {
        var x = math.absInt(p.x) catch unreachable;
        var y = math.absInt(p.y) catch unreachable;
        return x + y;
    }

    pub fn equal(p1: Point, p2: Point) bool {
        return (p1.x == p2.x and p1.y == p2.y);
    }
};

pub fn sortPoints(a: Point, b: Point) bool {
    return a.distance() < b.distance();
}
