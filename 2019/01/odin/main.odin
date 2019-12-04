package main

import "core:fmt"
import "core:os"
import "core:mem"
import "core:strings"
import "core:strconv"
import "core:math"

read_string :: proc(f: os.Handle) -> (string, bool) {
    str: strings.Builder;
    buf: [1]u8;

    for {
        bytes_read, err := os.read(f, buf[:]);
        if err != os.ERROR_NONE {
            return strings.to_string(str), false;
        }

        if bytes_read == 0 {
            return strings.to_string(str), false;
        }

        if buf[0] == ' ' || buf[0] == '\n' {
            return strings.to_string(str), true;
        }

        strings.write_rune(&str, rune(buf[0]));
    }

    return strings.to_string(str), true;
}

main :: proc() {
    f, err := os.open("../input.txt");
    if err != 0 {
        fmt.println("Couldn't open input");
    }
    defer os.close(f);

    sum: u64 = 0;

    for {
        str, success := read_string(f);
        if !success {
            break;
        }

        mass := strconv.parse_f32(str);
        sum += u64(math.floor_f32(mass / 3.0)) - 2;
    }

    fmt.printf("Total: %v\n", sum);
}
