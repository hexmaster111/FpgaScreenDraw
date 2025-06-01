module Computer (
    input wire clk,
	output wire vga_v_sync, vga_h_sync,
	output reg  [5:0] vga_red, vga_green, vga_blue

);
    wire vc_write_enable;
    wire [7:0] vc_char_in;

    assign vc_write_enable = 0;
    assign vc_char_in = 0;

    video_controller vc(clk, vga_v_sync, vga_h_sync, vga_red, vga_green, vga_blue, vc_write_enable, vc_char_in);

endmodule