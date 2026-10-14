#!/bin/sh

nasm -f elf64 hello.s
gcc hello.o
./a.out