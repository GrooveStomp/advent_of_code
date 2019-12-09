package main

import (
	"math"
)

type Point struct {
	X int64
	Y int64
}

func (p Point) ManhattanDistance() int64 {
	return int64(math.Abs(float64(p.X)) + math.Abs(float64(p.Y)))
}
