/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: main.rs
  Created: 2019-12-04
  Updated: 2019-12-04
  Author: Aaron Oman (GrooveStomp)

  Notice: CC BY 4.0 License

  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it under certain
  conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
 ******************************************************************************/
use std::env;
use std::fs::File;
use std::process::exit;
use std::io::{Error, ErrorKind, Read};
use std::f32;

fn read_string(mut fd: &File) -> Result<String, Error> {
    let mut read = String::new();

    loop {
        let mut buf: [u8; 1] = [0; 1];
        let n = match fd.read(&mut buf[..]) {
            Ok(n) => n,
            Err(e) => return Err(e),
        };

        if n == 0 {
            return Err(Error::new(ErrorKind::Other, "EOF"));
        }

        let ch = buf[0] as char;
        if ch == ' ' || ch == '\n' {
            return Ok(read);
        }

        read.push(ch);
    };
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() != 2 {
        eprintln!("Wrong number of arguments");
        exit(1);
    }

    let filename = &args[1];

    let fd = match File::open(filename) {
        Ok(f) => f,
        Err(_) => {
            eprintln!("Couldn't open {}", filename);
            exit(1);
        },
    };

    let mut sum: u64 = 0;

    loop {
        let my_str = match read_string(&fd) {
            Ok(s) => s,
            Err(_) => break,
        };

        let mass = match my_str.parse::<u32>() {
            Ok(f) => f as f32,
            Err(_) => break,
        };

        sum += ((f32::floor(mass / 3.0)) as u64) - 2;
    }
    println!("{}", sum);

    exit(0);
}
