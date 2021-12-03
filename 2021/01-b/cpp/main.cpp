//******************************************************************************
// File: 2021/01-b/cpp/main.cpp
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

struct Window {
        int a;
        int b;
        int c;
        int read;

        Window() : a{0}, b{0}, c{0}, read{0} {};
        void add(int in) {
                c = in;
                ++read;
        }
        void slide() {
                a = b;
                b = c;
        }
        int sum() const {
                return a + b + c;
        }

        friend ostream &operator<<(ostream &output, const Window w) {
                output << "{[" << w.c << "," << w.b << "," << w.a << "], " << w.sum() << "}";
                return output;
        }
};


int main(int argc, char **argv) {
        int increments = 0;

        if (argc != 2) {
                usage();
                exit(1);
        }

        ifstream in;
        in.open(argv[1]);
        if (in.is_open()) {
                Window w1, w2;
                int depth;

                while (in >> depth) {
                        w1.slide();
                        w1.add(depth);
                        w2.slide();
                        w2.add(w1.b);

                        // This ensures the second window has three values.
                        // We can't rely on w2.read because we read a "default"
                        // value from w1 before w1 has read a full window.
                        if (w1.read < 4) continue;

                        if (w1.sum() > w2.sum()) ++increments;
                }
                in.close();
        } else {
                cerr << "Couldn't open file " << argv[1] << endl;
                exit(1);
        }

        cout << increments << endl;

        return 0;
}
