module emotion_decoder (
    input signed [15:0] y0,
    input signed [15:0] y1,
    input signed [15:0] y2,
    output [1:0] emotion_code,
    output [7:0] emotion_confidence
);
    wire y0_wins = (y0 >= y1) && (y0 >= y2);
    wire y1_wins = (y1 > y0) && (y1 >= y2);   
    wire [1:0] code = y0_wins ? 2'b01 : y1_wins ? 2'b10 : 2'b11;
    wire [15:0] max_val = y0_wins ? y0 : y1_wins ? y1 : y2;
    wire [15:0] abs_max = max_val[15] ? (~max_val + 1'b1) : max_val;
    
    assign emotion_code = code;
    assign emotion_confidence = abs_max[15:8];
endmodule
