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
const p = @import("point.zig");
const s = @import("segment.zig");
const g = @import("grid.zig");
const alloc = std.heap.direct_allocator;
const os = std.os;
const warn = std.debug.warn;
const math = std.math;

const CollisionError = error {
    BothSegmentsVertical,
    BothSegmentsHorizontal,
    SegmentsDoNotCollide,
    SegmentsShareEndpoint,
};

fn findCollision(s1: s.Segment, s2: s.Segment) !p.Point {
    if (s1.isVertical() and s2.isVertical()) {
        return CollisionError.BothSegmentsVertical;
    }

    if (s1.isHorizontal() and s2.isHorizontal()) {
        return CollisionError.BothSegmentsHorizontal;
    }

    var hz: s.Segment = undefined;
    var vt: s.Segment = undefined;

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

    if (vt.points[0].x < min_x
            or vt.points[0].x > max_x
            or hz.points[0].y < min_y
            or hz.points[0].y > max_y) {
        return CollisionError.SegmentsDoNotCollide;
    }

    var collision = p.Point{ .x = vt.points[0].x, .y = hz.points[0].y };

    if (collision.equal(hz.points[0])
            or collision.equal(hz.points[1])
            or collision.equal(vt.points[0])
            or collision.equal(vt.points[1])) {
        return CollisionError.SegmentsShareEndpoint;
    }

    return collision;
}

fn findAllCollisions(g1: g.Grid, g2: g.Grid) std.ArrayList(p.Point) {
    var collisions = std.ArrayList(p.Point).init(alloc);

    for (g1.segments.toSliceConst()) |s1| {
        for (g2.segments.toSliceConst()) |s2| {
            var collision = findCollision(s1, s2) catch continue;
            collisions.append(collision) catch break;
        }
    }

    return collisions;
}

fn readGrids(fd: c_int) std.ArrayList(g.Grid) {
    var grids = std.ArrayList(g.Grid).init(alloc);

    while (true) {
        var grid = g.NewGrid(fd) catch break;
        if (grid.segments.len == 0) break;
        grids.append(grid.*) catch break;
    }

    return grids;
}

pub fn main() u8 {
    var args = std.process.argsAlloc(alloc) catch {
        warn("Couldn't parse args\n");
        return 1;
    };
    defer std.process.argsFree(alloc, args);

    if (args.len != 2) {
        warn("Wrong number of arguments\n");
        return 1;
    }

    var fd = os.open(args[1], os.O_RDONLY, 0755) catch {
        warn("Couldn't open {}\n", args[1]);
        return 1;
    };
    defer os.close(fd);

    var grids = readGrids(fd);
    defer grids.deinit();

    var collisions = findAllCollisions(grids.at(0), grids.at(1));
    defer collisions.deinit();

    var slice = collisions.toSlice();
    std.sort.insertionSort(p.Point, slice, p.sortPoints);

    warn("{}\n", slice[0].distance());

    return 0;
}
