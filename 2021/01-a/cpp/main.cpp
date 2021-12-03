//******************************************************************************
// File: 2021/01-a/cpp/main.cpp
// Created: 2021-12-02
// Updated: 2021-12-02
// Package: advent_of_code
// Creator: Aaron Oman (GrooveStomp)
// Homepage: https://git.sr.ht/~groovestomp/advent_of_code/
// Copyright 2019 - 2021, Aaron Oman and the advent_of_code contributors
// SPDX-License-Identifier: AGPL-3.0-only
//******************************************************************************
#include <iostream>
#include <fstream>

using namespace std;

void usage() {
        cout << "Usage: runme FILE" << endl;
}

int main(int argc, char **argv) {
        int increments = 0;

        if (argc != 2) {
                usage();
                exit(1);
        }

        ifstream in;
        in.open(argv[1]);
        if (in.is_open()) {
                int curr_depth;
                int last_depth;
                bool is_first = true;
                while (in >> curr_depth) {
                        if (is_first) {
                                is_first = false;
                                last_depth = curr_depth;
                                continue;
                        }

                        if (curr_depth > last_depth) {
                                ++increments;
                        }

                        last_depth = curr_depth;
                }
                in.close();
        } else {
                cerr << "Couldn't open file " << argv[1] << endl;
                exit(1);
        }

        cout << increments << endl;
        return 0;
}
