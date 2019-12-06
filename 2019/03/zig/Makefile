#******************************************************************************
# GrooveStomp's Advent of Code
# Copyright (c) 2019 Aaron Oman (GrooveStomp)
#
# File: Makefile
# Created: 2019-12-05
# Updated: 2019-12-05
# Author: Aaron Oman (GrooveStomp)
#
# Notice: CC BY 4.0 License
# This program comes with ABSOLUTELY NO WARRANTY.
# This is free software, and you are welcome to redistribute it under certain
# conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
#******************************************************************************
CC  = $(shell which zig)
SRC = $(wildcard *.zig)
EXE = main

DEFAULT_GOAL := $(debug)
.PHONY: clean

debug:
	$(CC) build-exe $(SRC) --name $(EXE)

clean:
	rm -rf $(EXE) *.o
