#!/bin/bash
#rm -rf ./obj_dir/Vbench

set -xe
verilator --Wall --trace -cc FPGAScreenDraw.v --exe tb.cpp -CFLAGS "-ggdb"
make -C obj_dir -f VFPGAScreenDraw.mk VFPGAScreenDraw
./obj_dir/VFPGAScreenDraw
