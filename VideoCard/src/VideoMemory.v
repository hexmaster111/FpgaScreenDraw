module VideoMemory (
    input   wire            i_clk, i_enable, i_write_enable,
    input   wire    [7:0]   i_data, 
    input   wire    [12:0]  i_address,
    output  reg     [7:0]   o_data
);
    

// not sure if i need this in my code... quartus will tell me
(* RAM_STYLE="BLOCK" *)
reg [7:0] vmem [0:(80*60)-1];

integer i;
initial begin
    for (i = 0; i < (80*60); i++) begin
        vmem[i] = 8'd32;
    end
end

always @(posedge i_clk) begin
    if(i_enable == 1) begin
        if(i_write_enable == 1) vmem[i_address] = i_data;
        o_data <= vmem[i_address];
    end
end


endmodule
