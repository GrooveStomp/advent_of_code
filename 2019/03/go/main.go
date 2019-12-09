/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: main.go
  Created: 2019-12-06
  Updated: 2019-12-08
  Author: Aaron Oman (GrooveStomp)

  Notice: CC BY 4.0 License

  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it under certain
  conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
 ******************************************************************************/
package main

import (
	"os"
	"fmt"
	"math"
	"sort"
)

func Collision(s1, s2 Segment) (Point, bool) {
	if s1.IsVertical() && s2.IsVertical() {
		return Point{}, false
	}

	if s1.IsHorizontal() && s2.IsHorizontal() {
		return Point{}, false
	}

	var hz Segment
	var vt Segment
	if s1.IsVertical() {
		vt = s1
		hz = s2
	} else {
		vt = s2
		hz = s1
	}

	minX := math.Min(float64(hz.Points[0].X), float64(hz.Points[1].X))
	maxX := math.Max(float64(hz.Points[0].X), float64(hz.Points[1].X))
	minY := math.Min(float64(vt.Points[0].Y), float64(vt.Points[1].Y))
	maxY := math.Max(float64(vt.Points[0].Y), float64(vt.Points[1].Y))

	if float64(vt.Points[0].X) < minX || float64(vt.Points[0].X) > maxX ||
		float64(hz.Points[0].Y) < minY || float64(hz.Points[1].Y) > maxY {
		return Point{}, false
	}

	collision := Point{vt.Points[0].X, hz.Points[0].Y}

	if collision == hz.Points[0] ||
		collision == hz.Points[1] ||
		collision == vt.Points[0] ||
		collision == vt.Points[1] {
		return Point{}, false
	}

	return collision, true
}

func FindCollisions(left, right *Grid) []Point {
	var collisions []Point

	for _, s1 := range left.Segments {
		for _, s2 := range right.Segments {
			collision, happened := Collision(s1, s2)
			if happened {
				collisions = append(collisions, collision)
			}
		}
	}

	return collisions
}

func ReadGrids(f *os.File) []*Grid {
	var grids []*Grid
	
	for {
		grid := NewGrid(f)
		if len(grid.Segments) == 0 {
			break
		}

		grids = append(grids, grid)
	}

	return grids
}

type ByManhattanDistance []Point
func (a ByManhattanDistance) Len() int           { return len(a) }
func (a ByManhattanDistance) Swap(i, j int)      { tmp := a[i]; a[i] = a[j]; a[j] = tmp; }
func (a ByManhattanDistance) Less(i, j int) bool { return a[i].ManhattanDistance() < a[j].ManhattanDistance() }

func main() {
	if len(os.Args) != 2 {
		os.Exit(1)
	}

	f, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}
	defer f.Close()

	grids := ReadGrids(f)
	collisions := FindCollisions(grids[0], grids[1])
	sort.Sort(ByManhattanDistance(collisions))

	fmt.Printf("%+v\n", collisions[0].ManhattanDistance())
}
