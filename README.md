# [Advent of Code](https://adventofcode.com/)

Advent of Code is an Advent calendar of small programming puzzles for a variety
of skill sets and skill levels.

This repo contains my solutions to various advent of code challenges.

The organization of this repo is by date, then by languages, for example:

    └── advent_of_code
         └── 2019
             └── 01
                 ├── c
                 ├── go
                 ├── odin
                 ├── rust
                 └── zig

Unless otherwise specified, all programs are written with no option switches and
no usage text.  If input is required, it is taken as a command line argument.
Typical input involves specifying a filename as a CLI parameter.  Any output is
written directly to stdout without any kind of formatting or context.

All implementations have a corresponding Makefile and are configured to build a
default executable called `main` in the same directory as the Makefile.