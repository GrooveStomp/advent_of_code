/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: main.go
  Created: 2019-12-05
  Updated: 2019-12-05
  Author: Aaron Oman (GrooveStomp)

  Notice: CC BY 4.0 License

  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it under certain
  conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
 ******************************************************************************/
package main

import (
	"fmt"
	"os"
	"strconv"
)

func ReadInt(f *os.File) (uint, error) {
	str := ""
	var chBuf []byte = []byte{0}
	
	for {
		n, err := f.Read(chBuf)
		if err != nil {
			break
		}

		if n == 0 {
			break
		}

		if string(chBuf) == "," {
			break
		}

		str += string(chBuf)
	}

	result, err := strconv.ParseInt(str, 10, 32)
	if err != nil {
		return 0, err
	}

	return uint(result), nil
}

func main() {
	if len(os.Args) != 2 {
		os.Exit(1)
	}

	f, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}
	defer f.Close()

	var program []uint

	// Construct the program.
	for {
		myInt, err := ReadInt(f)
		if err != nil {
			break
		}

		program = append(program, myInt)
	}

	program[1] = 12
	program[2] = 2;

	// Execute the program.
	for i := 0; i < len(program) - 3; i += 4 {
		op := program[i]
		arg1 := program[i+1]
		arg2 := program[i+2]
		dest := program[i+3]

		switch op {
		case 1:
			program[dest] = program[arg1] + program[arg2]
		case 2:
			program[dest] = program[arg1] * program[arg2]
		case 99:
			break
		default:
			// Normally this is an error condition, but for this program we
			// get the result here.
			fmt.Printf("%v\n", program[0]);
			os.Exit(1);
		}
	}

	fmt.Printf("%v\n", program[0]);
	os.Exit(0)
}
