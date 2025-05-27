


/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */
module FPGAScreenDraw (  
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


wire clr;
assign clr = dip[7];

reg [10:0] timer; //  2047

//assign led = dip;
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
				timer <= timer + 1;
				// timer expired, inc char
				if(7 <= timer) begin
					char_out <= char_out + 1;
					timer <= 0;

					if(127 <= char_out) begin
						char_out <= 0;
					end
				end
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

// hc is 0 -> 800, should be 0 -> 640,
assign px_h =  hc - hbp;

always @(*) begin
	if (vc >= vbp && vc < vfp) begin
		// if ( px_h >= 0 && px_h < 4 && px_v >= 0 && px_v < 8 ) begin	
		// 	red =   6'b111111;
		// 	green = 6'b111111;
		// 	blue =  6'b111111;
		// end 

		if ( px_h == 0 && px_v == 0) begin	
			red = char_gfx[0] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[0] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[0] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 1 && px_v == 0) begin	
			red = char_gfx[1] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[1] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[1] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 2 && px_v == 0) begin	
			red = char_gfx[2] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[2] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[2] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 3 && px_v == 0) begin	
			red = char_gfx[3] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[3] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[3] == 1 ? 6'b111111 : 6'b000000; 
		
		end else if ( px_h == 0 && px_v == 1) begin	
			red = char_gfx[4] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[4] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[4] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 1 && px_v == 1) begin	
			red = char_gfx[5] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[5] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[5] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 2 && px_v == 1) begin	
			red = char_gfx[6] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[6] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[6] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 3 && px_v == 1) begin	
			red = char_gfx[7] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[7] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[7] == 1 ? 6'b111111 : 6'b000000; 
		end 
		
		 else if ( px_h == 0 && px_v == 2) begin	
			red = char_gfx[8] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[8] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[8] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 1 && px_v == 2) begin	
			red = char_gfx[9] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[9] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[9] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 2 && px_v == 2) begin	
			red = char_gfx[10] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[10] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[10] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 3 && px_v == 2) begin	
			red = char_gfx[11] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[11] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[11] == 1 ? 6'b111111 : 6'b000000; 
		end 



		 else if ( px_h == 0 && px_v == 3) begin	
			red = char_gfx[12] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[12] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[12] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 1 && px_v == 3) begin	
			red = char_gfx[13] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[13] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[13] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 2 && px_v == 3) begin	
			red = char_gfx[14] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[14] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[14] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 3 && px_v == 3) begin	
			red = char_gfx[15] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[15] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx[15] == 1 ? 6'b111111 : 6'b000000; 
		end 





		 else if ( px_h == 0 && px_v == 4) begin	
			red = char_gfx  [16] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[16] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [16] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 1 && px_v == 4) begin	
			red = char_gfx   [17] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx [17] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx  [17] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 2 && px_v == 4) begin	
			red = char_gfx  [18] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[18] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [18] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 3 && px_v == 4) begin	
			red = char_gfx  [19] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[19] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [19] == 1 ? 6'b111111 : 6'b000000; 
		end 


		 else if ( px_h == 0 && px_v == 5) begin	
			red = char_gfx  [20] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[20] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [20] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 1 && px_v == 5) begin	
			red = char_gfx   [21] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx [21] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx  [21] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 2 && px_v == 5) begin	
			red = char_gfx  [22] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[22] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [22] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 3 && px_v == 5) begin	
			red = char_gfx  [23] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[23] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [23] == 1 ? 6'b111111 : 6'b000000; 
		end 



		 else if ( px_h == 0 && px_v == 6) begin	
			red = char_gfx  [24] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[24] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [24] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 1 && px_v == 6) begin	
			red = char_gfx   [25] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx [25] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx  [25] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 2 && px_v == 6) begin	
			red = char_gfx  [26] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[26] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [26] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 3 && px_v == 6) begin	
			red = char_gfx  [27] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[27] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [27] == 1 ? 6'b111111 : 6'b000000; 
		end 


		
		 else if ( px_h == 0 && px_v == 7) begin	
			red = char_gfx  [28] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[28] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [28] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 1 && px_v == 7) begin	
			red = char_gfx   [29] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx [29] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx  [29] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 2 && px_v == 7) begin	
			red = char_gfx  [30] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[30] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [30] == 1 ? 6'b111111 : 6'b000000; 
		end 
		else if ( px_h == 3 && px_v == 7) begin	
			red = char_gfx  [31] == 1 ? 6'b111111 : 6'b000000; 
			green = char_gfx[31] == 1 ? 6'b111111 : 6'b000000; 
			blue = char_gfx [31] == 1 ? 6'b111111 : 6'b000000; 
		end 

		else begin
			red =   6'b000000;
			green = 6'b000000;
			blue =  6'b000000;
		end 


		// if ( hc >= hbp + 10 && hc < (hbp+20) && vc >= vbp + 10 && vc < (vbp+20) ) begin	
		// 	red =   5'b11111;
		// 	green = 5'b00000;
		// 	blue =  5'b00000;
		// end else begin
		// 	red =   5'b00000;
		// 	green = 5'b00000;
		// 	blue =  5'b00000;
		// end 

	end else begin
		red =   6'b000000;
		green = 6'b000000;
		blue =  6'b000000;
	end
end


endmodule
