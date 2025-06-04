
module VgaCore (
    input  wire i_clk_50mhz, i_n_reset,
    output wire o_hsync, o_vsync,
    output wire [9:0] o_x_pixel, o_y_pixel,
    output wire o_drawing
);

wire clk_25mhz;
wire hc_endOfLine;
wire [9:0] vCount;
wire [9:0] hCount;

ClockHalfer clock_halfer_0 
(
    .i_clk(i_clk_50mhz),
    .i_n_reset(i_n_reset),
    .o_clk(clk_25mhz)
);

HorizontalCounter horizontal_counter_0
(
    .i_pixelClock(clk_25mhz),
    .i_n_reset(i_n_reset),
    .o_endOfLine(hc_endOfLine),
    .o_hCount(hCount)
);

HorSyncGenerator hor_sync_generator_0 
(
    .i_hCount(hCount),
    .o_hsync(o_hsync)
);

VertSyncGenerator vert_sync_generator_0 
(
    .i_vCount(vCount),
    .o_vsync(o_vsync)
);

VerticalCounter vertical_counter_0
(
    .i_pixelClock(clk_25mhz),
    .i_n_reset(i_n_reset),
    .i_enable(hc_endOfLine),
    .o_vCount(vCount)
);

XYDrawGenerator xy_draw_generator0 
(
    .i_hCount(hCount),
    .i_vCount(vCount),
    .o_x_pixel(o_x_pixel),
    .o_y_pixel(o_y_pixel),
    .o_drawing(o_drawing)
);
    
endmodule
