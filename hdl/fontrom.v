module fontrom (
    input   wire [7:0]  addr,
    output  wire [31:0] charout
);
    
reg [31:0] char_rom [255:0]; // 255 32 (8x4 bitmap) bit values

assign charout = char_rom[addr];

initial begin
  $readmemb("chars.txt",char_rom);
end

endmodule
