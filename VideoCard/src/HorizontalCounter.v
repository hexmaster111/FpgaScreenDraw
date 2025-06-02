
module HorizontalCounter (
    input wire i_pixelClock, i_n_reset,
    output wire o_endOfLine,
    output reg [$clog2(LIMIT)-1:0] o_hCount
);

parameter LIMIT = 800-1;

assign o_endOfLine = (o_hCount == LIMIT);

always @(posedge i_pixelClock) begin
    if((i_n_reset == 0) || (o_hCount == LIMIT)) o_hCount <= 0;
    else o_hCount <= o_hCount + 1;
end

endmodule
