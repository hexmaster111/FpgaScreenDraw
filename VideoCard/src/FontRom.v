module FontRom (
    input wire i_clk, i_enable,
    input wire [7:0] i_address,
    output reg [71:0] o_data
);

(* RAM_STYLE="BLOCK" *) 
reg [71:0] fontrom [0:255];


initial $readmemb("video_font_spleen_6x12.txt", fontrom);

always @(posedge i_clk) begin
    if(i_enable == 1) o_data <= fontrom[i_address];
end


endmodule