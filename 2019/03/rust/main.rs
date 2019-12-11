/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: main.rs
  Created: 2019-12-10
  Updated: 2019-12-10
  Author: Aaron Oman (GrooveStomp)

  Notice: CC BY 4.0 License

  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it under certain
  conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
 ******************************************************************************/
use std::env;
use std::fs::File;
use std::process::exit;
use std::io::Read;
use std::error::Error as StdError;

#[derive(Copy,Clone)]
struct Point {
    x: isize,
    y: isize,
}

impl Point {
    fn distance(&self) -> isize {
        return self.x.abs() + self.y.abs();
    }

    fn equal(&self, other: Point) -> bool {
        return self.x == other.x && self.y == other.y;
    }
}

#[derive(Copy,Clone)]
struct Segment {
    points: [Point; 2],
}

#[derive(Debug)]
enum Error {
    SegmentSourceStringEmpty,
    SegmentUnknownDirection,
    CollisionBothSegmentsVertical,
    CollisionBothSegmentsHorizontal,
    CollisionNone,
    CollisionSegmentsShareVertex,
}

impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match &*self {
            Error::SegmentSourceStringEmpty => f.write_str("Segment: Source string is empty"),
            Error::SegmentUnknownDirection => f.write_str("Segment: Unknown direction specifier"),
            Error::CollisionBothSegmentsVertical => f.write_str("Collsion: Both segments are vertical"),
            Error::CollisionBothSegmentsHorizontal => f.write_str("Collision: Both segments are horizontal"),
            Error::CollisionNone => f.write_str("Collision: No collision exists between segments"),
            Error::CollisionSegmentsShareVertex => f.write_str("Collision: Collision is at shared vertex between segments"),
        }
    }
}

impl StdError for Error {
    fn description(&self) -> &str {
        match &*self {
            Error::SegmentSourceStringEmpty => "Segment source string is empty",
            Error::SegmentUnknownDirection => "Segment unknown direction specifier",
            Error::CollisionBothSegmentsVertical => "Collsion: Both segments are vertical",
            Error::CollisionBothSegmentsHorizontal => "Collision: Both segments are horizontal",
            Error::CollisionNone => "Collision: No collision exists between segments",
            Error::CollisionSegmentsShareVertex => "Collision: Collision is at shared vertex between segments",
        }
    }
}

impl Segment {
    fn is_vertical(&self) -> bool {
        return self.points[0].x == self.points[1].x;
    }

    fn is_horizontal(&self) -> bool {
        return self.points[0].y == self.points[1].y;
    }

    fn new_segment(p: Point, src: &str) -> Result<*const Segment, Box<dyn StdError>> {
        if src.eq("") {
            eprintln!("Segment source string empty");
            return Err(Box::new(Error::SegmentSourceStringEmpty));
        }

        let magnitude = src.parse::<isize>()?;
        let mut segment = Segment{points: [Point{x:0,y:0}; 2]};
        segment.points[0] = Point{x:p.x, y:p.y};
        segment.points[1] = Point{x:0,y:0};

        match src.chars().nth(0) {
            Some('U') => segment.points[1] = Point{x: p.x, y: p.y + magnitude },
            Some('D') => segment.points[1] = Point{x: p.x, y: p.y - magnitude },
            Some('L') => segment.points[1] = Point{x: p.x - magnitude, y: p.y },
            Some('R') => segment.points[1] = Point{x: p.x + magnitude, y: p.y },
            _ => {
                println!("Unknown direction\n");
                return Err(Box::new(Error::SegmentUnknownDirection));
            }
        }
        return Ok(&segment);
    }
}

struct Grid {
    segments: Vec<Segment>,
}

impl Grid {
    fn new_grid(mut fd: &File) -> Result<*const Grid, Box<dyn StdError>> {
        let mut cursor = Point{x: 0, y: 0};
        let mut grid = Grid{segments: vec![]};

        grid.segments = Vec::new();

        loop {
            let mut buf: [u8; 1] = [0; 1];
            let mut n: usize = 0;
            let mut str_buf = String::new();
            let mut err = false;
            let res = fd.read(&mut buf[..]);

            match res {
                Ok(v) => n = v,
                Err(_) => err = true,
            }

            let ch = buf[0] as char;

            if err || n == 0 || ch == ',' || ch == '\n' {
                let segment = Segment::new_segment(cursor, str_buf.as_str())?;
                unsafe {
                    cursor = (*segment).points[1];
                    grid.segments.push(*segment);
                }
                str_buf = "".to_string();

                if ch == ',' {
                    continue;
                }

                break;
            }

            str_buf.push(ch);
        }

        return Ok(&grid);
    }
}

fn find_collision(s1: Segment, s2: Segment) -> Result<Point, Box<dyn StdError>> {
    if s1.is_vertical() && s2.is_vertical() {
        return Err(Box::new(Error::CollisionBothSegmentsVertical));
    }

    if s1.is_horizontal() && s2.is_horizontal() {
        return Err(Box::new(Error::CollisionBothSegmentsHorizontal));
    }

    let hz: Segment;
    let vt: Segment;

    if s1.is_vertical() {
        vt = s1;
        hz = s2;
    } else {
        vt = s2;
        hz = s1;
    }

    let min_x = std::cmp::min(hz.points[0].x, hz.points[1].x);
    let max_x = std::cmp::max(hz.points[0].x, hz.points[1].x);
    let min_y = std::cmp::min(vt.points[0].y, vt.points[1].y);
    let max_y = std::cmp::max(vt.points[0].y, vt.points[1].y);

    if vt.points[0].x < min_x
        || vt.points[0].x > max_x
        || hz.points[0].y < min_y
        || hz.points[0].y > max_y {
            return Err(Box::new(Error::CollisionNone));
        }

    let collision = Point{ x: vt.points[0].x, y: hz.points[0].y };

    if collision.equal(hz.points[0])
        || collision.equal(hz.points[1])
        || collision.equal(vt.points[0])
        || collision.equal(vt.points[1]) {
            return Err(Box::new(Error::CollisionSegmentsShareVertex));
        }

    return Ok(collision);
}

fn find_all_collisions(g1: *const Grid, g2: *const Grid) -> Vec<Point> {
    let mut collisions: Vec<Point> = Vec::new();

    unsafe {
        for s1 in (*g1).segments.iter() {
            for s2 in (*g2).segments.iter() {
                match find_collision(*s1, *s2) {
                    Ok(p) => collisions.push(p),
                    Err(_) => continue,
                }
            }
        }
    }

    return collisions;
}

fn read_grids(fd: &File) -> Vec<*const Grid> {
    let mut grids: Vec<*const Grid> = Vec::new();

    loop {
        match Grid::new_grid(fd) {
            Ok(grid) => {
                unsafe {
                    if (*grid).segments.len() == 0 {
                        break;
                    }
                    grids.push(grid);
                }
            },
            Err(_) => break,
        }
    }

    return grids;
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Wrong number of arguments");
        exit(1);
    }

    let fd = match File::open(&args[1]) {
        Ok(f) => f,
        Err(_) => {
            eprintln!("Couldn't open {}", &args[1]);
            exit(1);
        },
    };

    let grids = read_grids(&fd);

    println!("Num grids: {} (expect 2)", grids.len());
    for i in 0..grids.len() {
        unsafe {
            for j in 0..(*grids[i]).segments.len() {
                println!(
                    "grid[{}] [({} {}) ({} {})]",
                    i,
                    (*grids[i]).segments[j].points[0].x,
                    (*grids[i]).segments[j].points[0].y,
                    (*grids[i]).segments[j].points[1].x,
                    (*grids[i]).segments[j].points[1].y,
                );
            }
        }
    }
    let collisions = find_all_collisions(grids[0], grids[1]);

    for p in collisions {
        println!("{{{} {}}}\n", p.x, p.y);
    }

    exit(0);
}
