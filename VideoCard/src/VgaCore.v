
module VideoCore (
    input  wire i_clk_50mhz, i_n_reset,

    /* video outputs TODO Move this to */
    // output wire [5:0] o_red, o_green , o_blue,

    output wire o_hsync, o_vsync,
    output wire [9:0] o_x_pixel, o_y_pixel,
    output wire o_drawing
);

wire clk_25mhz;
wire hc_endOfLine;
wire [9:0] vCount;
wire [9:0] hCount;

ClockHalfer ch0 
(
    .i_clk(i_clk_50mhz),
    .i_n_reset(i_n_reset),
    .o_clk(clk_25mhz)
);

HorizontalCounter hc0
(
    .i_pixelClock(clk_25mhz),
    .i_n_reset(i_n_reset),
    .o_endOfLine(hc_endOfLine),
    .o_hCount(hCount)
);

HorSyncGenerator hsg0 
(
    .i_hCount(hCount),
    .o_hsync(o_hsync)
);

VertSyncGenerator vsg0 
(
    .i_vCount(vCount),
    .o_vsync(o_vsync)
);

VerticalCounter vc0
(
    .i_pixelClock(clk_25mhz),
    .i_n_reset(i_n_reset),
    .i_enable(hc_endOfLine),
    .o_vCount(vCount)
);

XYDrawGenerator xydg0 
(
    .i_hCount(hCount),
    .i_vCount(vCount),
    .o_x_pixel(o_x_pixel),
    .o_y_pixel(o_y_pixel),
    .o_drawing(o_drawing)
);
    
endmodule
