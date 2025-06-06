/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */
module video_mem (
    input  wire [9:0]  vm_px, vm_py, // px being scanned right now
    output wire [5:0]  vm_r, vm_g, vm_b, // output rgb colors

    input  wire [7:0]  vm_ch_in,
    input  wire [12:0] vm_ch_addr,
    input  wire        vm_ch_write_enable, write_clk
    
);

parameter DISP_WIDTH_PX  = 640 + 5; // hack to fix rounding error
parameter DISP_HEIGHT_PX = 480;
parameter CH_WIDTH = 6;
parameter CH_HEIGHT = 12;
parameter CH_WIDTH_SCREEN = DISP_WIDTH_PX / CH_WIDTH;
parameter CH_HEIGHT_SCREEN = DISP_HEIGHT_PX / CH_HEIGHT;
parameter CH_SCREENSIZE = CH_WIDTH_SCREEN * CH_HEIGHT_SCREEN;

reg  [ 7:0] vmem [CH_SCREENSIZE-1:0];
wire [ 7:0] char_out;
wire [71:0] char_gfx;
video_fontrom fr(char_out, char_gfx);

assign char_out = vmem [(vm_py / CH_HEIGHT) * CH_WIDTH_SCREEN + (vm_px / CH_WIDTH)];
assign vm_r = char_gfx[((vm_py % CH_HEIGHT) * CH_WIDTH) + (vm_px % CH_WIDTH)] ? 6'b111111 : 6'b000000;
assign vm_g = char_gfx[((vm_py % CH_HEIGHT) * CH_WIDTH) + (vm_px % CH_WIDTH)] ? 6'b111111 : 6'b000000;
assign vm_b = char_gfx[((vm_py % CH_HEIGHT) * CH_WIDTH) + (vm_px % CH_WIDTH)] ? 6'b111111 : 6'b000000;

always @(posedge write_clk)begin
    if(vm_ch_write_enable) begin
        vmem[vm_ch_addr] <= vm_ch_in; 
    end
end

integer i;
initial begin   
    for (i = 0; i < CH_SCREENSIZE; i = i + 1) begin
        vmem[i] = 8'd32; // ASCII for space ' '
    end
    
    for (i = 0; i < 30; i = i + 1) begin
        vmem[i] = 8'd65; // ASCII for space ' '
    end
    

    for (i = 31; i < 255 + 31; i = i + 1) begin
/* verilator lint_off WIDTH */
        vmem[i] = i; // ASCII for space ' '
/* verilator lint_on WIDTH */
    end


end

endmodule
