#******************************************************************************
# GrooveStomp's Advent of Code
# Copyright (c) 2019 Aaron Oman (GrooveStomp)
#
# File: Makefile
# Created: 2019-12-03
# Updated: 2019-12-03
# Author: Aaron Oman (GrooveStomp)
#
# Notice: CC BY 4.0 License
# This program comes with ABSOLUTELY NO WARRANTY.
# This is free software, and you are welcome to redistribute it under certain
# conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
#******************************************************************************
CC       = /usr/bin/gcc
INC     +=
HEADERS  =
LIBS    += -lm
CFLAGS  += -std=c11 -pedantic -Wall -D_GNU_SOURCE

SRC_DEP  =
SRC      = $(wildcard *.c)
OBJFILES = $(patsubst %.c,%.o,$(SRC))

DBGDIR = debug
DBGOBJ = $(addprefix $(DBGDIR)/,$(OBJFILES))
DBGEXE = $(DBGDIR)/exe
DBGFLG = -g -Og

DEFAULT_GOAL := $(debug)
.PHONY: clean debug docs release

debug: $(DBGEXE)

$(DBGEXE): $(DBGOBJ)
	$(CC) -o $@ $^ $(LIBS)

$(DBGDIR)/%.o: %.c $(HEADERS) $(SRC_DEP)
	@mkdir -p $(@D)
	$(CC) -c $*.c $(INC) $(CFLAGS) $(DBGFLG) -o $@

clean:
	rm -rf core debug ${DBGOBJ}
