module VgaTextModeCore (
    input  wire i_clk_50mhz, i_n_reset,
    output wire o_hsync, o_vsync
);
    
wire [9:0] x_pixel, y_pixel;
wire drawing;

VgaCore vga_core_0
(
    .i_clk_50mhz(i_clk_50mhz),
    .i_n_reset(i_n_reset),
    .o_hsync(o_hsync), 
    .o_vsync(o_vsync),
    .o_x_pixel(x_pixel), 
    .o_y_pixel(y_pixel),
    .o_drawing(drawing)
);


TextIndexGenerator text_index_generator_0  
(
    .i_xPixel(x_pixel),
    .i_yPixel(y_pixel),
);


endmodule
