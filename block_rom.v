//
// BLOCK ROM 
// format of dout:
//
//   [14:6] = start_addr (9 bits) 
//   [5:3]  = prev_block_size (3 bits)
//   [2:0]  = curr_block_size (3 bits)
//
//
module block_rom (
    input  wire       clk,
    input  wire [8:0] addr,
    output reg  [14:0] dout
);

    // allow space for future songs
    wire [14:0] memory [0:511];

    // synchronous read
    always @(posedge clk)
        dout <= memory[addr];

    // ----------------------------------------------------
    // Song 0 : blocks 0..15 (size = 4)
    // ----------------------------------------------------
    assign memory[  0] = {9'd0 , 3'd0, 3'd4};
    assign memory[  1] = {9'd4 , 3'd4, 3'd4};
    assign memory[  2] = {9'd8 , 3'd4, 3'd4};
    assign memory[  3] = {9'd12, 3'd4, 3'd4};
    assign memory[  4] = {9'd16, 3'd4, 3'd4};
    assign memory[  5] = {9'd20, 3'd4, 3'd4};
    assign memory[  6] = {9'd24, 3'd4, 3'd4};
    assign memory[  7] = {9'd28, 3'd4, 3'd4};
    assign memory[  8] = {9'd32, 3'd4, 3'd4};
    assign memory[  9] = {9'd36, 3'd4, 3'd4};
    assign memory[ 10] = {9'd40, 3'd4, 3'd4};
    assign memory[ 11] = {9'd44, 3'd4, 3'd4};
    assign memory[ 12] = {9'd48, 3'd4, 3'd4};
    assign memory[ 13] = {9'd52, 3'd4, 3'd4};
    assign memory[ 14] = {9'd56, 3'd4, 3'd4};
    assign memory[ 15] = {9'd60, 3'd4, 3'd4};

    // ----------------------------------------------------
    // Song 1 : blocks 16..47 (size = 2)
    // ----------------------------------------------------
    assign memory[ 16] = {9'd128, 3'd0, 3'd2};
    assign memory[ 17] = {9'd130, 3'd2, 3'd2};
    assign memory[ 18] = {9'd132, 3'd2, 3'd2};
    assign memory[ 19] = {9'd134, 3'd2, 3'd2};
    assign memory[ 20] = {9'd136, 3'd2, 3'd2};
    assign memory[ 21] = {9'd138, 3'd2, 3'd2};
    assign memory[ 22] = {9'd140, 3'd2, 3'd2};
    assign memory[ 23] = {9'd142, 3'd2, 3'd2};
    assign memory[ 24] = {9'd144, 3'd2, 3'd2};
    assign memory[ 25] = {9'd146, 3'd2, 3'd2};
    assign memory[ 26] = {9'd148, 3'd2, 3'd2};
    assign memory[ 27] = {9'd150, 3'd2, 3'd2};
    assign memory[ 28] = {9'd152, 3'd2, 3'd2};
    assign memory[ 29] = {9'd154, 3'd2, 3'd2};
    assign memory[ 30] = {9'd156, 3'd2, 3'd2};
    assign memory[ 31] = {9'd158, 3'd2, 3'd2};

    assign memory[ 32] = {9'd160, 3'd2, 3'd2};
    assign memory[ 33] = {9'd162, 3'd2, 3'd2};
    assign memory[ 34] = {9'd164, 3'd2, 3'd2};
    assign memory[ 35] = {9'd166, 3'd2, 3'd2};
    assign memory[ 36] = {9'd168, 3'd2, 3'd2};
    assign memory[ 37] = {9'd170, 3'd2, 3'd2};
    assign memory[ 38] = {9'd172, 3'd2, 3'd2};
    assign memory[ 39] = {9'd174, 3'd2, 3'd2};
    assign memory[ 40] = {9'd176, 3'd2, 3'd2};
    assign memory[ 41] = {9'd178, 3'd2, 3'd2};
    assign memory[ 42] = {9'd180, 3'd2, 3'd2};
    assign memory[ 43] = {9'd182, 3'd2, 3'd2};
    assign memory[ 44] = {9'd184, 3'd2, 3'd2};
    assign memory[ 45] = {9'd186, 3'd2, 3'd2};
    assign memory[ 46] = {9'd188, 3'd2, 3'd2};
    assign memory[ 47] = {9'd190, 3'd2, 3'd2};

    // ----------------------------------------------------
    // Song 2 : blocks 48..63 (size = 2)
    // ----------------------------------------------------
    assign memory[ 48] = {9'd256, 3'd0, 3'd2};
    assign memory[ 49] = {9'd258, 3'd2, 3'd2};
    assign memory[ 50] = {9'd260, 3'd2, 3'd2};
    assign memory[ 51] = {9'd262, 3'd2, 3'd2};
    assign memory[ 52] = {9'd264, 3'd2, 3'd2};
    assign memory[ 53] = {9'd266, 3'd2, 3'd2};
    assign memory[ 54] = {9'd268, 3'd2, 3'd2};
    assign memory[ 55] = {9'd270, 3'd2, 3'd2};
    assign memory[ 56] = {9'd272, 3'd2, 3'd2};
    assign memory[ 57] = {9'd274, 3'd2, 3'd2};
    assign memory[ 58] = {9'd276, 3'd2, 3'd2};
    assign memory[ 59] = {9'd278, 3'd2, 3'd2};
    assign memory[ 60] = {9'd280, 3'd2, 3'd2};
    assign memory[ 61] = {9'd282, 3'd2, 3'd2};
    assign memory[ 62] = {9'd284, 3'd2, 3'd2};
    assign memory[ 63] = {9'd286, 3'd2, 3'd2};

    // ----------------------------------------------------
    // Song 3 : blocks 64..95 (size = 2)
    // ----------------------------------------------------
    assign memory[ 64] = {9'd384, 3'd0, 3'd2};
    assign memory[ 65] = {9'd386, 3'd2, 3'd2};
    assign memory[ 66] = {9'd388, 3'd2, 3'd2};
    assign memory[ 67] = {9'd390, 3'd2, 3'd2};
    assign memory[ 68] = {9'd392, 3'd2, 3'd2};
    assign memory[ 69] = {9'd394, 3'd2, 3'd2};
    assign memory[ 70] = {9'd396, 3'd2, 3'd2};
    assign memory[ 71] = {9'd398, 3'd2, 3'd2};
    assign memory[ 72] = {9'd400, 3'd2, 3'd2};
    assign memory[ 73] = {9'd402, 3'd2, 3'd2};
    assign memory[ 74] = {9'd404, 3'd2, 3'd2};
    assign memory[ 75] = {9'd406, 3'd2, 3'd2};
    assign memory[ 76] = {9'd408, 3'd2, 3'd2};
    assign memory[ 77] = {9'd410, 3'd2, 3'd2};
    assign memory[ 78] = {9'd412, 3'd2, 3'd2};
    assign memory[ 79] = {9'd414, 3'd2, 3'd2};

    assign memory[ 80] = {9'd416, 3'd2, 3'd2};
    assign memory[ 81] = {9'd418, 3'd2, 3'd2};
    assign memory[ 82] = {9'd420, 3'd2, 3'd2};
    assign memory[ 83] = {9'd422, 3'd2, 3'd2};
    assign memory[ 84] = {9'd424, 3'd2, 3'd2};
    assign memory[ 85] = {9'd426, 3'd2, 3'd2};
    assign memory[ 86] = {9'd428, 3'd2, 3'd2};
    assign memory[ 87] = {9'd430, 3'd2, 3'd2};
    assign memory[ 88] = {9'd432, 3'd2, 3'd2};
    assign memory[ 89] = {9'd434, 3'd2, 3'd2};
    assign memory[ 90] = {9'd436, 3'd2, 3'd2};
    assign memory[ 91] = {9'd438, 3'd2, 3'd2};
    assign memory[ 92] = {9'd440, 3'd2, 3'd2};
    assign memory[ 93] = {9'd442, 3'd2, 3'd2};
    assign memory[ 94] = {9'd444, 3'd2, 3'd2};
    assign memory[ 95] = {9'd446, 3'd2, 3'd2};


endmodule
         