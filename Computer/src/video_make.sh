#!/bin/bash
#rm -rf ./obj_dir/Vvideo_controller

set -xe
verilator --Wall --trace -cc video_controller.v --exe video_tb.cpp -CFLAGS "-ggdb" \
                                                           -LDFLAGS "-lraylib -lm"
make -C obj_dir -f Vvideo_controller.mk Vvideo_controller
./obj_dir/Vvideo_controller
