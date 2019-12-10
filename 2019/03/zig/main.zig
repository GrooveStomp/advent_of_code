//------------------------------------------------------------------------------
// GrooveStomp's Advent of Code
// Copyright (c) 2019 Aaron Oman (GrooveStomp)
//
// File: main.zig
// Created: 2019-12-09
// Updated: 2019-12-09
// Author: Aaron Oman (GrooveStomp)
//
// Notice: CC BY 4.0 License
//
// This program comes with ABSOLUTELY NO WARRANTY.
// This is free software, and you are welcome to redistribute it under certain
// conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
//------------------------------------------------------------------------------
const std = @import("std");
const alloc = std.heap.direct_allocator;
const os = std.os;
const warn = std.debug.warn;
const sort = std.sort;
const math = std.math;

const Point = struct {
    x: isize,
    y: isize,

    pub fn distance(p: Point) isize {
        var x = math.absInt(p.x) catch 0;
        var y = math.absInt(p.y) catch 0;
        return x + y;
    }
};

fn sortPoints(a: Point, b: Point) bool {
    return a.distance() < b.distance();
}

const Segment = struct {
    points: [2]Point,

    pub fn isVertical(s: Segment) bool {
        return s.points[0].x == s.points[1].x;
    }

    pub fn isHorizontal(s: Segment) bool {
        return s.points[0].y == s.points[1].y;
    }
};

pub fn NewSegment(start: Point, str: std.Buffer) !*Segment {
    // TODO: Implement me
    return error.Unexpected;
}

const Grid = struct {
    segments: std.ArrayList(Segment),
};

pub fn NewGrid(fd: c_int) !*Grid {
    var cursor = Point{ .x = 0, .y = 0};
    var grid = try alloc.create(Grid);

    grid.segments = std.ArrayList(Segment).init(alloc);

    var str = try std.Buffer.init(alloc, [_]u8{});
    defer str.deinit();

    while (true) {
        var err = false;
        var ch: [1]u8 = undefined;
        var n: usize = undefined;
        if (os.read(fd, ch[0..])) |num| {
            n = num;
        } else |_| {
            err = true;
        }

        if (err or n == 0 or ch[0] == '\n' or ch[0] == ',') {
            var segment: *Segment = undefined;
            if (NewSegment(cursor, str)) |seg| {
                segment = seg;
            } else |_| { break; }

            cursor = segment.points[0];
            grid.segments.append(segment.*) catch break;

            str.replaceContents("") catch break;

            if (ch[0] == ',') continue;

            break;
        }

        try str.append(ch);
    }

    return grid;
}

fn readInt(fd: c_int) !usize {
    var buf = try std.Buffer.init(alloc, [_]u8{});
    defer buf.deinit();

    while (true) {
        var chr: [1]u8 = undefined;
        var bytes_read = try os.read(fd, chr[0..]);

        if (bytes_read == 0) break; // eof

        if (chr[0] == ',') break;

        try buf.append(chr);
    }

    var result = try std.fmt.parseInt(usize, buf.toSlice(), 10);
    return result;
}

fn findCollision(s1: Segment, s2: Segment) !Point {
    if (s1.isVertical() and s2.isVertical()) {
        return error.Unexpected;
    }

    if (s1.isHorizontal() and s2.isHorizontal()) {
        return error.Unexpected;
    }

    var hz: Segment = undefined;
    var vt: Segment = undefined;

    if (s1.isVertical()) {
        vt = s1;
        hz = s2;
    } else {
        vt = s2;
        hz = s1;
    }

    var min_x = math.min(hz.points[0].x, hz.points[1].x);
    var max_x = math.max(hz.points[0].x, hz.points[1].x);
    var min_y = math.min(vt.points[0].y, vt.points[1].y);
    var max_y = math.max(vt.points[0].y, vt.points[1].y);

    // TODO: Finish me
    return error.Unexpected;
}

fn findAllCollisions(g1: Grid, g2: Grid) std.ArrayList(Point) {
    var collisions = std.ArrayList(Point).init(alloc);

    for (g1.segments.toSlice()) |s1| {
        for (g2.segments.toSlice()) |s2| {
            var collision = findCollision(s1, s2) catch continue;
            collisions.append(collision) catch break;
        }
    }

    return collisions;
}

fn readGrids(fd: c_int) std.ArrayList(Grid) {
    var grids = std.ArrayList(Grid).init(alloc);

    while (true) {
        var grid = NewGrid(fd) catch break;
        if (grid.segments.len == 0) {
            break;
        }

        grids.append(grid.*) catch break;
    }

    return grids;
}

pub fn main() u8 {
    var args = std.process.argsAlloc(alloc) catch |_| {
        warn("Couldn't parse args\n");
        return 1;
    };
    defer std.process.argsFree(alloc, args);

    if (args.len != 2) {
        warn("Wrong number of arguments\n");
        return 1;
    }

    var fd = os.open(args[1], os.O_RDONLY, 0755) catch |_| {
        warn("Couldn't open {}\n", args[1]);
        return 1;
    };
    defer os.close(fd);

    var grids = readGrids(fd);
    defer grids.deinit();

    var collisions = findAllCollisions(grids.at(0), grids.at(1));
    defer collisions.deinit();

    var slice = collisions.toSlice();

    sort.sort(Point, slice, sortPoints);

    warn("{}\n", slice[0]);

    return 0;
}
