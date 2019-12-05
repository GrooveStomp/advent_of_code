//------------------------------------------------------------------------------
// GrooveStomp's Advent of Code
// Copyright (c) 2019 Aaron Oman (GrooveStomp)
//
// File: main.zig
// Created: 2019-12-05
// Updated: 2019-12-05
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

fn read_int(fd: c_int) !usize {
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

    var program_data = std.ArrayList(usize).init(alloc);
    defer program_data.deinit();

    // Build the program.
    while (true) {
        var int = read_int(fd) catch break;
        program_data.append(int) catch break;
    }

    var program = program_data.toSlice();

    program[1] = 12;
    program[2] = 2;

    var i:usize = 0;

    // Execute the program.
    while (i < program.len) {
        var op   = program[i];
        var arg1 = program[i+1];
        var arg2 = program[i+2];
        var dest = program[i+3];

        switch (op) {
            1 => program[dest] = program[arg1] + program[arg2],
            2 => program[dest] = program[arg1] * program[arg2],
            99 => break,
            else => {
                // Normally this is an error condition, but for this program we
                // get the result here.
                warn("{}\n", program[0]);
                return 1;
            }
        }

        i += 4;
    }

    warn("{}\n", program[0]);

    return 0;
}
