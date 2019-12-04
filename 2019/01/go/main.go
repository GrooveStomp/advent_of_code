/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: main.go
  Created: 2019-12-03
  Updated: 2019-12-04
  Author: Aaron Oman (GrooveStomp)

  Notice: CC BY 4.0 License

  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it under certain
  conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
 ******************************************************************************/
package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
)

func main() {
	if len(os.Args) != 2 {
		os.Exit(1)
	}

	f, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}
	defer f.Close()

	var sum uint64 = 0

	for {
		var str string
		_, err := fmt.Fscan(f, &str)
		if err != nil {
			break
		}

		mass, err := strconv.ParseInt(str, 10, 64)
		if err != nil {
			break
		}

		fuel := uint64(math.Floor(float64(mass)/3.0)) - 2
		sum += fuel
	}

	fmt.Println(sum)

	os.Exit(0)
}
