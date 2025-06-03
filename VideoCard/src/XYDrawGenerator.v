module XYDrawGenerator (
    input wire [9:0] i_hCount, i_vCount,
    output wire o_drawing,
    output wire [9:0] o_x_pixel, o_y_pixel
);


parameter HPIXEL = 640;
parameter VPIXEL = 480;

    
assign o_drawing = (i_hCount < HPIXEL) && (i_vCount < VPIXEL); 
assign o_x_pixel = (o_drawing == 1) ? i_hCount : 0;
assign o_y_pixel = (o_drawing == 1) ? i_vCount : 0;

endmodule
