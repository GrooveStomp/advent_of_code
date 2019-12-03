/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: main.c
  Created: 2019-12-03
  Updated: 2019-12-03
  Author: Aaron Oman (GrooveStomp)

  Notice: CC BY 4.0 License

  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it under certain
  conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
 ******************************************************************************/
#include <stdio.h>
#include <stdlib.h> // exit, atof
#include <getopt.h>
#include <math.h> // floor

static FILE *input;

void Usage() {
        printf("Usage: exe file\n");
}

void Deinit(int exitCode) {
        if (NULL != input) {
                fclose(input);
        }

        exit(exitCode);
}

int main(int argc, char *argv[]) {
        while (1) {
                #pragma GCC diagnostic push
                #pragma GCC diagnostic ignored "-Wgnu-empty-initializer"
                #pragma GCC diagnostic ignored "-Wzero-length-array"
                static struct option longOptions[] = {
                };
                #pragma GCC diagnostic pop
                int optionIndex = 0;

                int c = getopt_long(argc, argv, "", longOptions, &optionIndex);
                if (c == -1) break;

                switch (c) {
                        default:
                                abort();
                };
        }

        if ((argc - optind) != 1) {
                Usage();
                Deinit(1);
        }

        input = fopen(argv[1], "r");
        if (NULL == input) {
                fprintf(stderr, "Couldn't open file %s for reading", argv[1]);
                Deinit(1);
        }

        unsigned int sum = 0;

        while (1) {
                char str[256] = { 0 };
                int err = fscanf(input, "%s\n", str);
                if (EOF == err) break;

                int mass = atol(str);
                int fuelRequired = (int)floorf((float)mass / 3.0f) - 2;

                sum += (unsigned int)fuelRequired;
        }

        printf("Total: %d\n", sum);

        Deinit(0);
}
