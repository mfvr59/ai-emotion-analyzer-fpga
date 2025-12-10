module sine_reader(
    input clk,
    input reset,
    input [19:0] step_size,
    input generate_next,
    output sample_ready,
    output wire [15:0] sample
);
    wire [9:0] raw_addr;
    wire [9:0] rom_addr;    
    wire [21:0] next_addr;
    wire [21:0] current_addr;
    wire [1:0] quadrant;
    wire [15:0] rom_sample;
    
    assign next_addr = generate_next ? (current_addr + {2'b00, step_size}) : current_addr;
    dffre #(22) sine_addr (.clk(clk), .r(reset), .en(generate_next), .d(next_addr), .q(current_addr));  
    assign quadrant = current_addr[21:20];
    assign raw_addr = current_addr[19:10];
    assign rom_addr = ((quadrant == 2'b01) || (quadrant == 2'b11)) ? ~raw_addr : raw_addr;
    sine_rom sin (.clk(clk), .addr(rom_addr), .dout(rom_sample)); 
    
    wire signed [15:0] rom_signed = rom_sample;
    wire signed [15:0] modified_sample = (quadrant[1]) ? -rom_signed : rom_signed;
    
    assign sample = modified_sample;
    
    wire first_cycle;
    dffr #(1) cycle_one (.clk(clk), .r(reset), .d(generate_next), .q(first_cycle));  
    dffr #(1) cycle_two (.clk(clk), .r(reset), .d(first_cycle), .q(sample_ready));  
   
endmodule
