module phrase_buffer (
    input clk,
    input reset,
    input [5:0] note_played,
    input load_new_note,
    output [5:0] n0,
    output [5:0] n1,
    output [5:0] n2,
    output [5:0] n3,
    output [5:0] n4,
    output [5:0] n5,
    output [5:0] n6,
    output [5:0] n7,
    output [5:0] n8,
    output [5:0] n9,
    output [5:0] n10,
    output [5:0] n11,
    output [5:0] n12,
    output [5:0] n13,
    output [5:0] n14,
    output [5:0] n15,
    output buffer_full
);
    wire [4:0] count;
    wire [4:0] next_count = (count < 5'd16) ? (count + 5'd1) : count;
    dffre #(5) cnt (.clk(clk), .r(reset), .en(load_new_note), .d(next_count), .q(count));
    assign buffer_full = (count >= 5'd16);
    wire shift_enable = load_new_note && (count < 5'd16);
    
    dffre #(6) r0 (.clk(clk), .r(reset), .en(shift_enable), .d(note_played), .q(n0));
    dffre #(6) r1 (.clk(clk), .r(reset), .en(shift_enable), .d(n0), .q(n1));
    dffre #(6) r2 (.clk(clk), .r(reset), .en(shift_enable), .d(n1), .q(n2));
    dffre #(6) r3 (.clk(clk), .r(reset), .en(shift_enable), .d(n2), .q(n3));
    dffre #(6) r4 (.clk(clk), .r(reset), .en(shift_enable), .d(n3), .q(n4));
    dffre #(6) r5 (.clk(clk), .r(reset), .en(shift_enable), .d(n4), .q(n5));
    dffre #(6) r6 (.clk(clk), .r(reset), .en(shift_enable), .d(n5), .q(n6));
    dffre #(6) r7 (.clk(clk), .r(reset), .en(shift_enable), .d(n6), .q(n7));
    dffre #(6) r8 (.clk(clk), .r(reset), .en(shift_enable), .d(n7), .q(n8));
    dffre #(6) r9 (.clk(clk), .r(reset), .en(shift_enable), .d(n8), .q(n9));
    dffre #(6) r10 (.clk(clk), .r(reset), .en(shift_enable), .d(n9), .q(n10));
    dffre #(6) r11 (.clk(clk), .r(reset), .en(shift_enable), .d(n10), .q(n11));
    dffre #(6) r12 (.clk(clk), .r(reset), .en(shift_enable), .d(n11), .q(n12));
    dffre #(6) r13 (.clk(clk), .r(reset), .en(shift_enable), .d(n12), .q(n13));
    dffre #(6) r14 (.clk(clk), .r(reset), .en(shift_enable), .d(n13), .q(n14));
    dffre #(6) r15 (.clk(clk), .r(reset), .en(shift_enable), .d(n14), .q(n15));
endmodule
