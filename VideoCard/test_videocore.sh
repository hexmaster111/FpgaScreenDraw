#!/bin/bash
set -xe
verilator --Wall --trace -cc src/VgaCore.v  -Isrc \
          --exe test_vgacore.cpp -CFLAGS "-ggdb" \
                                                           -LDFLAGS "-lraylib -lm"
make -C obj_dir -f VVgaCore.mk VVgaCore
./obj_dir/VVgaCore
