module HorSyncGenerator (
    input  wire [9:0] i_hCount,
    output wire       o_hsync
);

    
parameter HPIXEL        = 640; 
parameter H_FRONT_PORCH = 16; 
parameter H_SYNC_PULSE  = 96;
parameter H_Polarity    = 0;


wire temp;
assign temp = ((i_hCount >= (HPIXEL + H_FRONT_PORCH)) && (i_hCount < (HPIXEL + H_FRONT_PORCH + H_SYNC_PULSE)));   // active for 96 pix_clock see diagram


// 0-  low during Sync pulse
// 1-  high during Sync pulse
assign o_hsync = (H_Polarity == 0) ? ~temp : temp;

endmodule


