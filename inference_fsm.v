module inference_fsm (
    input clk,
    input reset,
    input buffer_full,
    input enable_cnn,
    input mlp_valid_out,
    output start_mlp,
    output note_ready
);
    wire [1:0] state;
    reg [1:0] next_state;
    
    dffre #(2) state_reg (.clk(clk), .r(reset), .en(1'b1), .d(next_state), .q(state));
    
    always @(*) begin
        case (state)
            2'd0: begin //idle
                if (buffer_full && enable_cnn)
                    next_state = 2'd1;
                else
                    next_state = 2'd0;
            end
            
            2'd1: begin //start
                next_state = 2'd2;
            end
            
            2'd2: begin //wait for mlp
                if (mlp_valid_out)
                    next_state = 2'd3;
                else
                    next_state = 2'd2;
            end
            
            2'd3: begin //ready
                if (!enable_cnn || !buffer_full)
                    next_state = 2'd0;
                else
                    next_state = 2'd1;
            end
            
            default: begin
                next_state = 2'd0;
            end
        endcase
    end
    
    assign start_mlp = (state == 2'd1);
    assign note_ready = (state == 2'd3);
endmodule
