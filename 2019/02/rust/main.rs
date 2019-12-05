/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: main.rs
  Created: 2019-12-05
  Updated: 2019-12-05
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
use std::error::Error;

fn read_int(mut fd: &File) -> Result<usize, Box<dyn Error>> {
    let mut read = String::new();

    loop {
        let mut buf: [u8; 1] = [0; 1];
        let n = fd.read(&mut buf[..])?;

        if n == 0 { // EOF
            break;
        }

        if buf[0] as char == ',' {
            break;
        }

        read.push(buf[0] as char);
    };

    let result = read.parse::<usize>()?;
    return Ok(result);
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

    let mut program: Vec<usize> = Vec::new();

    // Construct the program.
    loop {
        let my_int = match read_int(&fd) {
            Ok(i) => i,
            Err(_) => break,
        };

        program.push(my_int);
    }

    program[1] = 12;
    program[2] = 2;

    let mut i = 0;
    // Run the program.
    while i < program.len() {
        let op   = program[i];
        let arg1 = program[i+1];
        let arg2 = program[i+2];
        let dest = program[i+3];

        match op {
            1 => { program[dest] = program[arg1] + program[arg2] },
            2 => { program[dest] = program[arg1] * program[arg2] },
            99 => break,
            _ => {
                // Normally this is an error condition, but for this program we get the result here.
                println!("{}", program[0]);
                exit(1);
            },
        };

        i += 4;
    }

    println!("{}", program[0]);

    exit(0);
}
