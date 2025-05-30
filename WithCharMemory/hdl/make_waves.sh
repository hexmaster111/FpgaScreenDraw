#!/bin/bash
#rm -rf ./obj_dir/Vbench

set -xe
verilator --Wall --trace -cc WithCharMemory.v --exe tb.cpp -CFLAGS "-ggdb" \
                                                           -LDFLAGS "-lraylib -lm"
make -C obj_dir -f VWithCharMemory.mk VWithCharMemory
./obj_dir/VWithCharMemory
