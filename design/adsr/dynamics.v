module adsr_envelope(
    input clk,
    input reset,
    input play_enable,
    input beat,
    input [7:0] attack,
    input [7:0] decay,
    input [7:0] sustain,
    input [7:0] released,
    output [15:0] envelope_out
);
    `define S_IDLE 3'b000
    `define S_ATTACK 3'b001
    `define S_DECAY 3'b010
    `define S_SUSTAIN 3'b011
    `define S_RELEASE 3'b100
    
    wire [2:0] state;
    wire [15:0] envelope;
    reg [2:0] next_state;
    reg [15:0] next_envelope;
    
    wire [15:0] sustain_level = {sustain, 8'd0};
    wire [15:0] attack_step = {attack, 8'd0};
    wire [15:0] decay_step = {decay, 8'd0};
    wire [15:0] release_step = {released, 8'd0};
    
    dffre #(.WIDTH(3)) state_reg(.clk(clk), .r(reset), .en(1'b1), .d(next_state), .q(state));
    dffre #(.WIDTH(16)) env_reg(.clk(clk), .r(reset), .en(1'b1), .d(next_envelope), .q(envelope));
    
    always @(*) begin
        next_state = state;
        next_envelope = envelope;
        
        case (state)
            `S_IDLE: begin
                next_envelope = 16'd0;
                if (play_enable) next_state = `S_ATTACK;
            end
            
            `S_ATTACK: begin
                if (beat) begin
                    if (envelope >= 16'hFFFF - attack_step) begin
                        next_envelope = 16'hFFFF;
                        next_state = `S_DECAY;
                    end else begin
                        next_envelope = envelope + attack_step;
                    end
                end
            end
            
            `S_DECAY: begin
                if (beat) begin
                    if (envelope <= sustain_level) begin
                        next_envelope = sustain_level;
                        next_state = `S_SUSTAIN;
                    end else if (envelope - decay_step <= sustain_level) begin
                        next_envelope = sustain_level;
                        next_state = `S_SUSTAIN;
                    end else begin
                        next_envelope = envelope - decay_step;
                    end
                end
            end
            
            `S_SUSTAIN: begin
                next_envelope = sustain_level;
                if (!play_enable) next_state = `S_RELEASE;
            end
            
            `S_RELEASE: begin
                if (beat) begin
                    if (envelope <= release_step) begin
                        next_envelope = 16'd0;
                        next_state = `S_IDLE;
                    end else begin
                        next_envelope = envelope - release_step;
                    end
                end
            end
            
            default: begin
                next_state = `S_IDLE;
                next_envelope = 16'd0;
            end
        endcase
    end
    
    assign envelope_out = envelope;
endmodule

