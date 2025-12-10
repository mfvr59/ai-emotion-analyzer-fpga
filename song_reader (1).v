module song_reader_reverse(
    input clk,
    input reset,
    input play,
    input [1:0] song,
    input beat,
    input reverse_play,
    input fast_forward,
    output song_done,
    output [5:0] note,
    output [5:0] duration,
    output new_note
);
    wire [1:0] state;
    wire [8:0] addr;
    wire [5:0] wait_count;
    wire done;
    reg [1:0] next_state;
    reg [8:0] next_addr;
    reg [5:0] next_wait_count;
    reg next_done;
    reg new_note_reg;

    wire [8:0] song_base = (song == 2'd0) ? 9'd0 : (song == 2'd1) ? 9'd128 : (song == 2'd2) ? 9'd256 : 9'd384;
    
    wire [8:0] song_last_note = (song == 2'd0) ? 9'd29 : (song == 2'd1) ? 9'd156 : (song == 2'd2) ? 9'd284 : 9'd412;
    
    dffr #(.WIDTH(2)) state_ff(.clk(clk),.r(reset),.d(next_state),.q(state));
    dffr #(.WIDTH(9)) addr_ff(.clk(clk),.r(reset),.d(next_addr),.q(addr));
    dffr #(.WIDTH(6)) wait_ff(.clk(clk),.r(reset),.d(next_wait_count),.q(wait_count));
    dffr done_ff(.clk(clk),.r(reset),.d(next_done),.q(done));
    
    assign song_done = done;
    
    wire [15:0] rom_data;
    song_rom rom_inst(.clk(clk),.addr(addr),.dout(rom_data));
    
    wire is_wait = rom_data[15];
    wire [5:0] field = rom_data[14:9];
    wire [5:0] dur = rom_data[8:3];
    
    assign note = field;
    assign duration = dur;
    assign new_note = new_note_reg;
    
    always @(*) begin
        next_state = state;
        next_addr = addr;
        next_wait_count = wait_count;
        next_done = done;
        new_note_reg = 1'b0;
        
        case(state)
            2'b00: begin  //idle
                next_done = 1'b0;
                next_wait_count = 6'd0;
                next_addr = reverse_play ? song_last_note : song_base;
                if(play) next_state = 2'b01;
            end
            
            2'b01: begin  //play
                if(!play) begin
                end else if(!is_wait) begin 
                    new_note_reg = 1'b1;
                    if(reverse_play) begin
                        if(addr > song_base) 
                            next_addr = addr - 9'd1;
                        else begin
                            next_done = 1'b1;
                            next_state = 2'b11;
                        end
                    end else begin
                        next_addr = addr + 9'd1;
                    end
                    
                end else if(field == 6'd0) begin 
                    next_done = 1'b1;
                    next_state = 2'b11;
                    
                end else begin
                    if(fast_forward) 
                        next_wait_count = (field > 6'd1) ? (field >> 1) : 6'd1;
                    else 
                        next_wait_count = field;
                    
                    if(reverse_play) begin
                        if(addr > song_base) begin
                            next_addr = addr - 9'd1;
                            next_state = 2'b10;
                        end else begin
                            next_done = 1'b1;
                            next_state = 2'b11;
                        end
                    end else begin
                        next_addr = addr + 9'd1;
                        next_state = 2'b10;
                    end
                end
            end
            
            2'b10: begin  //wait
                if(!play) begin
                end else if(beat) begin
                    if(wait_count > 6'd1) 
                        next_wait_count = wait_count - 6'd1;
                    else begin
                        next_wait_count = 6'd0;
                        next_state = 2'b01;
                    end
                end
            end
            
            2'b11: begin  //done
            end
            
            default: begin
                next_state = 2'b00;
                next_addr = reverse_play ? song_last_note : song_base;
                next_wait_count = 6'd0;
                next_done = 1'b0;
                new_note_reg = 1'b0;
            end
        endcase
    end
endmodule
