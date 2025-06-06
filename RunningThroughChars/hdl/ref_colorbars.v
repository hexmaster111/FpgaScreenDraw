
// THIS IS NOT DONE YET

module colorbars () 

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin

	// first check if we're within vertical active video range
	if (vc >= vbp && vc < vfp)
	begin
		// now display different colors every 80 pixels
		// while we're within the active horizontal range
		// -----------------
		// display white bar
		if (hc >= hbp && hc < (hbp+80))
		begin
			red = 5'b11111;
			green = 5'b11111;
			blue = 5'b11111;
		end
		// display yellow bar
		else if (hc >= (hbp+80) && hc < (hbp+160))
		begin
			red = 5'b11111;
			green = 5'b11111;
			blue = 5'b00000;
		end
		// display cyan bar
		else if (hc >= (hbp+160) && hc < (hbp+240))
		begin
			red =   5'b00000;
			green = 5'b11111;
			blue =  5'b11111;
		end
		// display green bar
		else if (hc >= (hbp+240) && hc < (hbp+320))
		begin
			red =   5'b00000;
			green = 5'b11111;
			blue =  5'b00000;
		end
		// display magenta bar
		else if (hc >= (hbp+320) && hc < (hbp+400))
		begin
			red =   5'b11111;
			green = 5'b00000;
			blue =  5'b11111;
		end
		// display red bar
		else if (hc >= (hbp+400) && hc < (hbp+480))
		begin
			red =   5'b11111;
			green = 5'b00000;
			blue =  5'b00000;
		end
		// display blue bar
		else if (hc >= (hbp+480) && hc < (hbp+560))
		begin
			red =   5'b00000;
			green = 5'b00000;
			blue =  5'b11111;
		end
		// display black bar
		else if (hc >= (hbp+560) && hc < (hbp+640))
		begin
			red =   5'b00000;
			green = 5'b00000;
			blue =  5'b00000;
		end
		// we're outside active horizontal range so display black
		else
		begin
			red =   5'b00000;
			green = 5'b00000;
			blue =  5'b00000;
		end
	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end


endmodule