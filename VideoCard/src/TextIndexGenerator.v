
/*
 This module handles taking in a px and py, and converting it to a sprite offset,
 and a char index on screen
*/
module TextIndexGenerator (
    input   wire   [9:0]    i_xPixel, i_yPixel,
    output  wire   [12:0]   o_char_index, // screen location of pixel
    output  wire   [7:0]   o_char_pixel_idx // pixel we are on
);

// Parameters for character cell size and screen dimensions
localparam CHAR_WIDTH = 8;
localparam CHAR_HEIGHT = 16;
localparam SCREEN_COLS = 80;
localparam SCREEN_ROWS = 30;

// Calculate character column and row
wire [6:0] char_col = i_xPixel / CHAR_WIDTH;   // 80 columns max (7 bits)
wire [4:0] char_row = i_yPixel / CHAR_HEIGHT;  // 30 rows max (5 bits)

// Calculate character index (row-major order)
assign o_char_index = char_row * SCREEN_COLS + char_col;

// Calculate pixel index within the character cell (0..127)
assign o_char_pixel_idx = ((i_yPixel & (CHAR_HEIGHT-1)) << 3) | (i_xPixel & (CHAR_WIDTH-1));

endmodule
