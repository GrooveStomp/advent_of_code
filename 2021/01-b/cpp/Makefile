#******************************************************************************
# File: 2021/01-b/cpp/Makefile
# Created: 2021-12-02
# Updated: 2021-12-02
# Package: advent_of_code
# Creator: Aaron Oman (GrooveStomp)
# Homepage: https://git.sr.ht/~groovestomp/advent_of_code/
# Copyright 2019 - 2021, Aaron Oman and the advent_of_code contributors
# SPDX-License-Identifier: AGPL-3.0-only
#******************************************************************************
CC      = /usr/bin/g++
INC     = $(shell sdl2-config --cflags) -I.
HEADERS =
LIBS    =
CFLAGS  = -std=c++17 -fno-exceptions -pedantic -Wall -Wno-unused-function

SRC_DEP   =
SRC       = main.cpp
OBJFILES  = $(patsubst %.cpp,%.o,$(SRC))
LINTFILES = $(patsubst %.cpp,__%.cpp,$(SRC)) $(patsubst %.cpp,_%.cpp,$(SRC))

RELDIR = release
RELOBJ = $(addprefix $(RELDIR)/,$(OBJFILES))
RELEXE = $(RELDIR)/runme
RELFLG = -O3

DBGDIR = debug
DBGOBJ = $(addprefix $(DBGDIR)/,$(OBJFILES))
DBGEXE = $(DBGDIR)/runme
DBGFLG = -gdwarf-4 -g3 -fno-eliminate-unused-debug-symbols -fvar-tracking -fvar-tracking-assignments

DEFAULT_GOAL := $(release)
.PHONY: clean debug release

release: $(RELEXE)

$(RELEXE): $(RELOBJ)
	$(CC) -o $@ $^ $(LIBS)

$(RELDIR)/%.o: %.cpp $(HEADERS) $(SRC_DEP)
	@mkdir -p $(@D)
	$(CC) -c $*.cpp $(INC) $(CFLAGS) $(RELFLG) -o $@

debug: $(DBGEXE)

$(DBGEXE): $(DBGOBJ)
	$(CC) -o $@ $^ $(LIBS)

$(DBGDIR)/%.o: %.cpp $(HEADERS) $(SRC_DEP)
	@mkdir -p $(@D)
	$(CC) -c $*.cpp $(INC) $(CFLAGS) $(DBGFLG) -o $@

clean:
	rm -rf core debug release ${DBGOBJ} ${RELOBJ}
