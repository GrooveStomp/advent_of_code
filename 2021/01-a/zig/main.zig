const std = @import("std");
const os = std.os;
const warn = std.debug.warn;

const EofError = error{
    Eof,
};

pub fn main() u8 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = &arena.allocator;

    var args = std.process.argsAlloc(alloc) catch |err| {
        warn("{s}\n", .{"Couldn't parse args"});
        return 1;
    };
    defer std.process.argsFree(alloc, args);

    if (args.len != 2) {
        warn("{s}\n", .{"Wrong number of arguments"});
        return 1;
    }

    var fd = os.open(args[1], os.O_RDONLY, 0755) catch |err| {
        warn("{s} {s}\n", .{ "Couldn't open", args[1] });
        return 1;
    };
    defer os.close(fd);

    warn("{s}\n", .{"Done"});
    return 0;
}
