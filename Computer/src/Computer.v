module Computer (
    input wire clk,
	output wire vga_v_sync, vga_h_sync,
	output wire  [5:0] vga_red, vga_green, vga_blue

);
    wire vc_write_enable;
    wire [7:0] vc_char_in;
    wire[12:0]  vid_ch_addr;

    assign vc_write_enable = 0;
    assign vc_char_in = 0;
    assign vid_ch_addr = 0;

    video_controller vc(clk, vga_v_sync, vga_h_sync, vga_red, vga_green, vga_blue, vc_write_enable, vc_char_in, vid_ch_addr);

endmodule