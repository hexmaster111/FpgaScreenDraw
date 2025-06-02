#!/bin/bash
set -xe
verilator --Wall --trace -cc src/ClockHalfer.v --exe test_clockhalfer.cpp -CFLAGS "-ggdb" \
                                                           -LDFLAGS "-lraylib -lm"
make -C obj_dir -f VClockHalfer.mk VClockHalfer
./obj_dir/VClockHalfer
