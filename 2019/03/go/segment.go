package main

import (
	"fmt"
	"strconv"
)

type Segment struct {
	Points [2]Point
}

func NewSegment(start Point, str string) (*Segment, error) {
	if str == "" {
		return nil, fmt.Errorf("Empty source string")
	}

	magnitude, err := strconv.ParseInt(str[1:], 10, 32)
	if err != nil {
		return nil, err
	}

	segment := Segment{}
	segment.Points[0] = start

	switch str[0] {
	case 'U':
		segment.Points[1] = Point{start.X, start.Y + magnitude}
	case 'D':
		segment.Points[1] = Point{start.X, start.Y - magnitude}
	case 'L':
		segment.Points[1] = Point{start.X - magnitude, start.Y}
	case 'R':
		segment.Points[1] = Point{start.X + magnitude, start.Y}
	default:
		return nil, fmt.Errorf("Invalid character in source string start: %v", str[0])
	}

	return &segment, nil
}

func (s Segment) IsVertical() bool {
	if s.Points[0].X == s.Points[1].X {
		return true
	} else {
		return false
	}
}

func (s Segment) IsHorizontal() bool {
	if s.Points[0].Y == s.Points[1].Y {
		return true
	} else {
		return false
	}
}
