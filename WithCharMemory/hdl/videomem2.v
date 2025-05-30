/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */
module videomem2 (
    input  wire [9:0] vm_px, vm_py, // px being scanned right now
    input  wire [7:0] vm_ch_in,
    input  wire       vm_ch_write_enable, write_clk,
    output wire [5:0] vm_r, vm_g, vm_b, // output rgb colors
    output wire [7:0] debug_curr_ch_out
);

parameter DISP_WIDTH_PX  = 640;
parameter DISP_HEIGHT_PX = 480;
parameter CH_WIDTH = 4;
parameter CH_HEIGHT = 8;
parameter CH_WIDTH_SCREEN = DISP_WIDTH_PX / CH_WIDTH;
parameter CH_HEIGHT_SCREEN = DISP_HEIGHT_PX / CH_HEIGHT;
parameter CH_SCREENSIZE = CH_WIDTH_SCREEN * CH_HEIGHT_SCREEN;

  // 640 x 480 px screen size
  // 160 x  60 chars on screen 
  //   4 x   8 px char size
  //      9600 chars in video memory
reg [7:0] vmem [CH_SCREENSIZE-1:0]; // 9600x  8 bit values


wire  [7:0] char_out;
wire [31:0] char_gfx;
fontrom fr(char_out, char_gfx);


assign char_out = vmem [(vm_py / CH_HEIGHT) * CH_WIDTH_SCREEN + (vm_px / CH_WIDTH)];
// assign char_out = 8'd87;
assign debug_curr_ch_out = char_out;
//abcdefghijklmnopqrstuvwxyz

/*
char_x_px = vm_px / CH_WIDTH;
char_y_px = vm_py / CH_HEIGHT;
bit = char_y_px * CH_WIDTH + char_x_px;
r g b = bit ? 1 : 0

                int bit = (gfx >> (y * 4 + x)) & 1; 
*/
assign vm_r = char_gfx[((vm_py % CH_HEIGHT) * CH_WIDTH) + (vm_px % CH_WIDTH)] ? 6'b111111 : 6'b000000;
assign vm_g = char_gfx[((vm_py % CH_HEIGHT) * CH_WIDTH) + (vm_px % CH_WIDTH)] ? 6'b111111 : 6'b000000;
assign vm_b = char_gfx[((vm_py % CH_HEIGHT) * CH_WIDTH) + (vm_px % CH_WIDTH)] ? 6'b111111 : 6'b000000;

always @(posedge write_clk) begin
    if(vm_ch_write_enable == 1'b1) begin // write
        // todo : write into vmem
    end
end

integer i;
initial begin
    for (i = 0; i < CH_SCREENSIZE; i = i + 1) begin
        vmem[i] = 8'd32; // ASCII for space ' '
    end

    vmem [1200 + 0] = 8'd87; 
    vmem [1200 + 1] = 8'd101; 
    vmem [1200 + 2] = 8'd108; 
    vmem [1200 + 3] = 8'd99; 
    vmem [1200 + 4] = 8'd111; 
    vmem [1200 + 5] = 8'd109; 
    vmem [1200 + 6] = 8'd101; 
    vmem [1200 + 7] = 8'd32; 
    vmem [1200 + 8] = 8'd116; 
    vmem [1200 + 9] = 8'd111; 
    vmem [1200 + 10] = 8'd32; 
    vmem [1200 + 11] = 8'd116; 
    vmem [1200 + 12] = 8'd104; 
    vmem [1200 + 13] = 8'd101; 
    vmem [1200 + 14] = 8'd32; 
    vmem [1200 + 15] = 8'd82; 
    vmem [1200 + 16] = 8'd111; 
    vmem [1200 + 17] = 8'd116; 
    vmem [1200 + 18] = 8'd116;
    vmem [1200 + 19] = 8'd105;
    vmem [1200 + 20] = 8'd110;
    vmem [1200 + 21] = 8'd103;
    vmem [1200 + 22] = 8'd32; 
    vmem [1200 + 23] = 8'd50; 
    vmem [1200 + 24] = 8'd48; 
    vmem [1200 + 25] = 8'd115;

    vmem [CH_SCREENSIZE-1] = 8'b11111111;
    vmem [CH_SCREENSIZE-3] = 8'b11111110;

end

endmodule
