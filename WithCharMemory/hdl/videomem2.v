/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */
module videomem2 (
    input  wire [9:0] vm_px, vm_py,
    input  wire [7:0] vm_ch_in,
    input  wire       vm_ch_write_enable, write_clk,
    output wire [5:0] vm_r, vm_g, vm_b
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
    vmem [0] = 8'd72;
    vmem [1] = 8'd101;
    vmem [2] = 8'd108;
    vmem [3] = 8'd108;
    vmem [4] = 8'd111;
    vmem [5] = 8'd32;
    vmem [6] = 8'd87;
    vmem [7] = 8'd111;
    vmem [8] = 8'd114;
    vmem [9] = 8'd108;
    vmem[10] = 8'd100;
end

always @(posedge write_clk) begin
    if(vm_ch_write_enable == 1'b1) begin // write
        /* verilator lint_off WIDTH */
        vmem[ch_h * CH_WIDTH_SCREEN + ch_v] <= ch_in;
        /* verilator lint_on WIDTH */
    end
end

endmodule
