module ClockHalfer (
   input wire i_clk, i_n_reset,
   output reg o_clk
);
    
parameter DIVISOR = 28'd2;
reg[27:0] counter = 28'd2;

always @(posedge i_clk) begin
    if(i_n_reset == 0) begin
        counter <= 28'd0;
    end else begin
        counter <= counter + 28'd1;
        if(counter>=(DIVISOR-1)) counter <= 28'd0;
        o_clk <= (counter<DIVISOR/2) ? 1'b1 : 1'b0;
    end 
end

endmodule
