//------------------------------------------------------------------------------
// GrooveStomp's Advent of Code
// Copyright (c) 2019 Aaron Oman (GrooveStomp)
//
// File: main.zig
// Created: 2019-12-09
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
const alloc = std.heap.direct_allocator;
const os = std.os;
const warn = std.debug.warn;
const math = std.math;

const Point = struct {
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

pub fn NewSegment(p: Point, str: []u8) !*Segment {
    if (std.mem.eql(u8, str, "")) {
        return error.Unexpected;
    }

    var magnitude = @intCast(isize, try std.fmt.parseInt(usize, str[1..], 10));
    var segment = try alloc.create(Segment);
    segment.points[0] = p;

    switch (str[0]) {
        'U' => segment.points[1] = Point{ .x = p.x, .y = p.y + magnitude },
        'D' => segment.points[1] = Point{ .x = p.x, .y = p.y - magnitude },
        'L' => segment.points[1] = Point{ .x = p.x - magnitude, .y = p.y },
        'R' => segment.points[1] = Point{ .x = p.x + magnitude, .y = p.y },
        else => {
            warn("Unknown direction\n");
            return error.Unexpected;
        }
    }

    return segment;
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
        var n = try os.read(fd, ch[0..]);

        if (err or n == 0 or ch[0] == '\n' or ch[0] == ',') {
            var segment = try NewSegment(cursor, str.toSlice());
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

const CollisionError = error {
    BothSegmentsVertical,
    BothSegmentsHorizontal,
    SegmentsDoNotCollide,
    SegmentsShareEndpoint,
};

fn findCollision(s1: Segment, s2: Segment) !Point {
    if (s1.isVertical() and s2.isVertical()) {
        return CollisionError.BothSegmentsVertical;
    }

    if (s1.isHorizontal() and s2.isHorizontal()) {
        return CollisionError.BothSegmentsHorizontal;
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

    if (vt.points[0].x < min_x or vt.points[0].x > max_x or
            hz.points[0].y < min_y or hz.points[0].y > max_y) {
        return CollisionError.SegmentsDoNotCollide;
    }

    var collision = Point{ .x = vt.points[0].x, .y = hz.points[0].y };

    if (collision.equal(hz.points[0]) or
            collision.equal(hz.points[1]) or
            collision.equal(vt.points[0]) or
            collision.equal(vt.points[1])) {
        return CollisionError.SegmentsShareEndpoint;
    }

    return collision;
}

fn findAllCollisions(g1: Grid, g2: Grid) std.ArrayList(Point) {
    var collisions = std.ArrayList(Point).init(alloc);

    for (g1.segments.toSliceConst()) |s1| {
        for (g2.segments.toSliceConst()) |s2| {
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
    std.sort.insertionSort(Point, slice, sortPoints);

    warn("{}\n", slice[0].distance());

    return 0;
}
