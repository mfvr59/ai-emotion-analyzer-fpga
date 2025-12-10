module top_block_reader (
    input wire clk,
    input wire rst,
    input wire [8:0] block_idx_in,   // block index
    input wire [1:0] song_sel,

    output wire [15:0] note0,
    output wire [15:0] note1,
    output wire [15:0] note2,
    output wire [15:0] note3,

    output wire [2:0]  block_size,
    output wire [2:0]  prev_block_size  
);

    // inspector window outputs
    wire [15:0] f_out0, f_out1, f_out2, f_out3;

    // block inspector
    song_block_inspector inspect (
        .clk(clk),
        .rst(rst),
        .block_idx_in(block_idx_in),
        .song_sel(song_sel),

        .f_out0(f_out0),
        .f_out1(f_out1),
        .f_out2(f_out2),
        .f_out3(f_out3),

        .block_size(block_size),
        .prev_block_size(prev_block_size) 
    );

    // output mux: pads with BLANK depending on block_size
    block_output_mux mux (
        .block_size(block_size),

        .f_out0(f_out0),
        .f_out1(f_out1),
        .f_out2(f_out2),
        .f_out3(f_out3),

        .note0(note0),
        .note1(note1),
        .note2(note2),
        .note3(note3)
    );

endmodule
