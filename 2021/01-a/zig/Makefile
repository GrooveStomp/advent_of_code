CC  = $(shell which zig)
SRC = $(wildcard *.zig)
EXE = main

DEFAULT_GOAL := $(debug)
.PHONY: clean

debug:
	$(CC) build-exe $(SRC) --name $(EXE)

clean:
	rm -rf $(EXE) *.o
