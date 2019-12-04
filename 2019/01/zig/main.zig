//------------------------------------------------------------------------------
// GrooveStomp's Advent of Code
// Copyright (c) 2019 Aaron Oman (GrooveStomp)
//
// File: main.zig
// Created: 2019-12-03
// Updated: 2019-12-04
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

fn read_string(fd: c_int) ![]u8 {
    var buf = try std.Buffer.init(alloc, [_]u8{});
    defer buf.deinit();

    while (true) {
        var chr_buf: [1]u8 = undefined;
        var bytes_read = try os.read(fd, chr_buf[0..]);
        if (bytes_read == 0) { // eof
            return "";
        }

        if ((chr_buf[0] == ' ') or (chr_buf[0] == '\n')) {
            return buf.toOwnedSlice();
        }

        try buf.append(chr_buf);
    }

    return buf.toOwnedSlice();
}

pub fn main() !void {
    var fd = try os.open("../input.txt", os.O_RDONLY, 0755);
    defer os.close(fd);

    var sum: u64 = 0;

    while (true) {
        var str = try read_string(fd);
        if (std.mem.compare(u8, str, "") == std.mem.Compare.Equal) {
            break;
        }

        var mass = try std.fmt.parseInt(u64, str, 10);

        sum += @floatToInt(u64, std.math.floor(@intToFloat(f32, mass) / 3.0)) - 2;
    }

    std.debug.warn("{}\n", sum);
}
