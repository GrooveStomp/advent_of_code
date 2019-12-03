package main

import (
	"os"
	"fmt"
	"strconv"
	"math"
)

func Usage() {
	desc := `
exe file
`
	fmt.Printf(desc)
}

func main() {
	if len(os.Args) != 2 {
		Usage()
		os.Exit(1)
	}

	f, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}
	defer f.Close();

	var sum uint64 = 0;

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

		fuel := uint64(math.Floor(float64(mass) / 3.0)) - 2
		sum += fuel
	}

	fmt.Printf("Total: %v\n", sum)
	
	os.Exit(0)
}
