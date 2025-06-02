#!/bin/bash
set -xe
verilator --Wall --trace -cc src/HorizontalCounter.v --exe test_horizontalcounter.cpp -CFLAGS "-ggdb" \
                                                           -LDFLAGS "-lraylib -lm"
make -C obj_dir -f VHorizontalCounter.mk VHorizontalCounter
./obj_dir/VHorizontalCounter
