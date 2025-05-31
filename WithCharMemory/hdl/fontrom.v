module fontrom (
    input   wire [7:0]  addr,
    output  wire [71:0] charout
);
    
reg [71:0] char_rom [255:0]; // 255 32 (12x6 bitmap) bit values

assign charout = char_rom[addr];

initial begin
  $readmemb("spleen_6x12.txt",char_rom);
end

endmodule
