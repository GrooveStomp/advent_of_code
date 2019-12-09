/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: main.odin
  Created: 2019-12-08
  Updated: 2019-12-08
  Author: Aaron Oman (GrooveStomp)

  Notice: CC BY 4.0 License

  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it under certain
  conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
 ******************************************************************************/
package main

import "core:fmt"
import "core:os"

read_grids :: proc(f: os.Handle) -> [dynamic]^Grid {
    grids: [dynamic]^Grid;

    for {
        grid := new_grid(f);
        if len(grid.segments) == 0 {
            break;
        }

        append(&grids, grid);
    }

    return grids;
}

main :: proc() {
    if len(os.args) != 2 {
        fmt.println("Wrong number of arguments");
        os.exit(1);
    }

    f, err := os.open(os.args[1]);
    if err != 0 {
        fmt.printf("Couldn't open %v\n", os.args[1]);
        os.exit(1);
    }
    defer os.close(f);

    grids := read_grids(f);

    fmt.printf("%v\n", grids);
    os.exit(0);
}
