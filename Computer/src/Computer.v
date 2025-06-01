module Computer (
    input wire clk,
	output wire vga_v_sync, vga_h_sync,
	output reg  [5:0] vga_red, vga_green, vga_blue

);

    
    
    video_controller vc(
		clk,  
        vga_v_sync, vga_h_sync,
		vga_red, vga_green, vga_blue
    );

endmodule