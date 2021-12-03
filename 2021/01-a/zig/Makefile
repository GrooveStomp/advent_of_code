#******************************************************************************
# File: 2021/01-a/zig/Makefile
# Created: 2021-12-02
# Updated: 2021-12-02
# Package: advent_of_code
# Creator: Aaron Oman (GrooveStomp)
# Homepage: https://git.sr.ht/~groovestomp/advent_of_code/
# Copyright 2019 - 2021, Aaron Oman and the advent_of_code contributors
# SPDX-License-Identifier: AGPL-3.0-only
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
