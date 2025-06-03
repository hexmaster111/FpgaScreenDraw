#!/bin/bash
set -xe
verilator --Wall --trace -cc src/VerticalCounter.v --exe test_verticalcounter.cpp -CFLAGS "-ggdb" \
                                                           -LDFLAGS "-lraylib -lm"
make -C obj_dir -f VVerticalCounter.mk VVerticalCounter
./obj_dir/VVerticalCounter
