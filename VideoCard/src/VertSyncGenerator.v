module VertSyncGenerator (
    input wire [9:0] i_vCount,
    output wire o_vsync
);
    

parameter VPIXEL        = 480;
parameter V_FRONT_PORCH = 10;
parameter V_SYNC_PULSE  = 2;
parameter V_Polarity    = 0;

wire temp;
assign temp = ((i_vCount >= (VPIXEL + V_FRONT_PORCH)) && (i_vCount < (VPIXEL + V_FRONT_PORCH + V_SYNC_PULSE))); // active for 2 pix_clock see diagram


// 0-  low during Sync pulse
// 1-  high during Sync pulse
assign o_vsync = (V_Polarity == 0) ? ~temp : temp;


endmodule
