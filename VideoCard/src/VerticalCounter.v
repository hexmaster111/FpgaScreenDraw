
module VerticalCounter (
    input wire i_pixelClock, i_n_reset, i_enable,
    output reg [$clog2(LIMIT)-1:0] o_vCount
);

parameter LIMIT = 525-1;

always @(posedge i_pixelClock) begin
    if(i_n_reset == 0) o_vCount <= 0;
    else if(i_enable) begin 
        if(o_vCount == LIMIT) o_vCount <= 0;
        else o_vCount <= o_vCount + 1;
    end
end

endmodule
