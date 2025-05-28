/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */
module WithCharMemory (  
		input  wire clk, // should be 25Mhz, we have 21.4 tho...
		output wire v_sync, h_sync,
		output reg  [5:0] red, green, blue,
		output wire [7:0] led,
		input  wire [7:0] dip
);


// video structure constants
parameter hpixels = 800; // horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 	// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480




// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;


reg  [7:0] char_out;
wire [31:0] char_gfx;
fontrom fr(char_out, char_gfx);

wire vid_mem_rw;
wire [7:0] vid_ch_out, vid_ch_in;

assign vid_mem_rw = 0;
assign vid_ch_in = 8'd0;

wire [5:0] vm_red, vm_green, vm_blue;

videomem2 vm2(
	px_h, px_v,
    vid_ch_in, vid_mem_rw, clk, // write to video memory... not so sure about this 
    vm_red, vm_green, vm_blue
);



wire clr;
assign clr = dip[7];

assign led = char_out;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge clk or posedge clr)
begin
	// v---33
	// A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
	// reset condition
	if (clr)
	begin
		hc <= 0;
		vc <= 0;
		timer <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1) 
				vc <= vc + 1;
			else begin
				vc <= 0;		
			end
		end
	end
end




// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign h_sync = (hc < hpulse) ? 0:1;
assign v_sync = (vc < vpulse) ? 0:1;


wire [9:0] px_v, px_h;

assign px_v =  vc - vbp; 
assign px_h =  hc - hbp;

always @(*) begin
	if (vc >= vbp && vc < vfp) begin
		red   = vm_red;
		green = vm_green;
		blue  = vm_blue;
	end else begin
		red   = 8'd0;
		green = 8'd0;
		blue  = 8'd0;
	end
end

endmodule
