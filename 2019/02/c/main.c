/******************************************************************************
  GrooveStomp's Advent of Code
  Copyright (c) 2019 Aaron Oman (GrooveStomp)

  File: main.c
  Created: 2019-12-05
  Updated: 2019-12-05
  Author: Aaron Oman (GrooveStomp)

  Notice: CC BY 4.0 License

  This program comes with ABSOLUTELY NO WARRANTY.
  This is free software, and you are welcome to redistribute it under certain
  conditions; See https://creativecommons.org/licenses/by/4.0/ for details.
 ******************************************************************************/
#include <stdio.h>
#include <stdlib.h> // exit, atol
#include <math.h> // floor

int ReadInt(FILE *f) {
        int i = 0;
        char buf[99] = { 0 };

        while (1) {
                int ch = fgetc(f);
                if (EOF == ch) break;

                if (',' == ch) break;

                buf[i++] = (char)ch;
        }

        int result = atol(buf);
        if (result == 0 && buf[0] != '0') {
                result = -1;
        }

        return result;
}

void PrintProgram(unsigned int *program, int numCodes) {
        for (int i = 0; i < numCodes; i++) {
                printf("%d", program[i]);
                if (i < numCodes - 1)
                        printf(",");
        }
        printf("\n");
}

int main(int argc, char *argv[]) {
        unsigned int capacity = 100;
        unsigned int numCodes = 0;
        unsigned int *program = (unsigned int *)calloc(capacity, sizeof(unsigned int));
        if (NULL == program) {
                fprintf(stderr, "Couldn't allocate space for intcode program\n");
                exit(1);
        }

        FILE *input = fopen(argv[1], "r");
        if (NULL == input) {
                fprintf(stderr, "Couldn't open file %s for reading\n", argv[1]);
                exit(1);
        }

        // Create the program
        while (1) {
                int code = ReadInt(input);
                if (-1 == code) break;

                numCodes++;
                if (numCodes > capacity) {
                        capacity += capacity;
                        program = (unsigned int *)realloc(program, capacity * sizeof(unsigned int));
                        if (NULL == program) {
                                fclose(input);
                                fprintf(stderr, "Couldn't realloc program\n");
                                exit(1);
                        }
                }
                program[numCodes - 1] = (unsigned int)code;
        }
        fclose(input);

        program[1] = 12;
        program[2] = 2;

        // Execute the program
        for (int i = 0; i < numCodes; i+=4) {
                unsigned int opcode = program[i];
                unsigned int op1 = program[i+1];
                unsigned int op2 = program[i+2];
                unsigned int storage = program[i+3];

                switch (opcode) {
                        case 1:
                                program[storage] = program[op1] + program[op2];
                                break;
                        case 2:
                                program[storage] = program[op1] * program[op2];
                                break;
                        case 99:
                                break;
                        default:
                                // Something went wrong!
                                // Buf for this problem, this is how we get to the answer.
                                printf("%d\n", program[0]);
                                exit(1);
                                break;
                }
        }

        printf("%d\n", program[0]);

        exit(0);
}
