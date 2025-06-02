# Specs
- Supports 640x480 @ 60fps


# inputs
- System Clock (50 mhz)
- reset (active low)
  





## Data for me

``` verilog
// video structure constants
parameter hpixels = 800; // horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 	// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480
```





# Resources
- https://github.com/narendiran1996/vga_controller/blob/main/VivadoProjects/VGA_TextMode_HelloWorld/VGA_TextMode_HelloWorld.srcs/sources_1/new

