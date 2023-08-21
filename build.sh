#!/bin/bash
set -e

zig build-exe main.zig
mkdir -p bin
mv main bin
rm *.o
