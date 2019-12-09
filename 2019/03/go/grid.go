package main

import (
	"os"
)

type Grid struct {
 	Segments []Segment
}

func NewGrid(f *os.File) *Grid {
	cursor := Point{}
	grid := Grid{}

	str := ""
	var chBuf []byte = []byte{0}

	for {
		n, err := f.Read(chBuf)
		ch := string(chBuf)

		if err != nil || n == 0 || ch == "\n" || ch == "," {
			segment, err := NewSegment(cursor, str)
			if err != nil {
				break
			}

			cursor = segment.Points[1]
			grid.Segments = append(grid.Segments, *segment)
			str = ""

			if ch == "," {
				continue
			}

			break;
		}

		str += string(chBuf)
	}

	return &grid
}
