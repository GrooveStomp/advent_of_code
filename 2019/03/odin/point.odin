/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: point.odin
  Created: 2019-12-09
  Updated: 2019-12-09
  Author: Aaron Oman (GrooveStomp)

  Notice: CC BY 4.0 License

  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it under certain
  conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
 ******************************************************************************/
package main

Point :: struct {
    x: int,
    y: int,
}

manhattan_distance :: proc(p: Point) -> int {
    return abs(p.x) + abs(p.y);
}
