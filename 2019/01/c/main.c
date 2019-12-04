/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: main.c
  Created: 2019-12-03
  Updated: 2019-12-04
  Author: Aaron Oman (GrooveStomp)

  Notice: CC BY 4.0 License

  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it under certain
  conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
 ******************************************************************************/
#include <stdio.h>
#include <stdlib.h> // exit, atol
#include <math.h> // floor

int main(int argc, char *argv[]) {
        FILE *input = fopen(argv[1], "r");
        if (NULL == input) {
                fprintf(stderr, "Couldn't open file %s for reading", argv[1]);
                return 1;
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

        printf("%d\n", sum);
        fclose(input);

        return 0;
}
