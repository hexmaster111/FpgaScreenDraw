
#!/bin/bash
set -xe
verilator --Wall --trace -cc src/VgaTextModeCore.v  -Isrc \
          --exe test_vgatextmodecore.cpp -CFLAGS "-ggdb" \
          -LDFLAGS "-lraylib -lm"
make -C obj_dir -f VVgaTextModeCore.mk VVgaTextModeCore
./obj_dir/VVgaTextModeCore
