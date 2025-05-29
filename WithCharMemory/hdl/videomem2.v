/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */
module videomem2 (
    input  wire [9:0] vm_px, vm_py, // px being scanned right now
    input  wire [7:0] vm_ch_in,
    input  wire       vm_ch_write_enable, write_clk,
    output wire [5:0] vm_r, vm_g, vm_b // output rgb colors
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
initial begin

    vmem [0] = 8'd87; 
    vmem [1] = 8'd101; 
    vmem [2] = 8'd108; 
    vmem [3] = 8'd99; 
    vmem [4] = 8'd111; 
    vmem [5] = 8'd109; 
    vmem [6] = 8'd101; 
    vmem [7] = 8'd32; 
    vmem [8] = 8'd116; 
    vmem [9] = 8'd111; 
    vmem [10] = 8'd32; 
    vmem [11] = 8'd116; 
    vmem [12] = 8'd104; 
    vmem [13] = 8'd101; 
    vmem [14] = 8'd32; 
    vmem [15] = 8'd82; 
    vmem [16] = 8'd111; 
    vmem [17] = 8'd116; 
    vmem [18] = 8'd116; 
    vmem [19] = 8'd105; 
    vmem [21] = 8'd110; 
    vmem [22] = 8'd103; 
    vmem [23] = 8'd32; 
    vmem [24] = 8'd50; 
    vmem [25] = 8'd48; 
    vmem [26] = 8'd115;
    vmem [27] = 8'd0;

    // VVVVVVVV Test Data VVVVVVVVV
    vmem [28] = 8'd32;
    vmem [29] = 8'd87;
    vmem [30] = 8'd111;
    vmem [31] = 8'd114;
    vmem [32] = 8'd108;
    vmem [33] = 8'd100;
end

reg  [7:0] char_out;
wire [31:0] char_gfx;
fontrom fr(char_out, char_gfx);

assign char_out = vmem [(vm_py / CH_WIDTH) * CH_HEIGHT + (vm_px / CH_HEIGHT)];

// always @(posedge write_clk) begin
// end

always @(posedge write_clk) begin
    if(vm_ch_write_enable == 1'b1) begin // write
        // todo : write into vmem
    end
end

endmodule
