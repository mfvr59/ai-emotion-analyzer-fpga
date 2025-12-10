module block_output_mux (
    input  wire [2:0]  block_size,

    input  wire [15:0] f_out0,
    input  wire [15:0] f_out1,
    input  wire [15:0] f_out2,
    input  wire [15:0] f_out3,

    output wire [15:0] note0,
    output wire [15:0] note1,
    output wire [15:0] note2,
    output wire [15:0] note3
);

    localparam BLANK = 16'h0000;

    reg [15:0] note0_q;
    reg [15:0] note1_q;
    reg [15:0] note2_q;
    reg [15:0] note3_q;

    always @(*) begin
        // Defaults
        note0_q = BLANK;
        note1_q = BLANK;
        note2_q = BLANK;
        note3_q = BLANK;

        case (block_size)
            3'd1: begin note0_q = f_out0; end
            3'd2: begin note0_q = f_out0; note1_q = f_out1; end
            3'd3: begin note0_q = f_out0; note1_q = f_out1; note2_q = f_out2; end
            3'd4: begin note0_q = f_out0; note1_q = f_out1; note2_q = f_out2; note3_q = f_out3; end
            default: begin note0_q = BLANK; note1_q = BLANK; note2_q = BLANK; note3_q = BLANK; end
        endcase
    end

    assign note0 = note0_q;
    assign note1 = note1_q;
    assign note2 = note2_q;
    assign note3 = note3_q;

endmodule


