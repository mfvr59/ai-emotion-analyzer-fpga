module wave_display (
    input clk,
    input reset,
    input [10:0] x,  // [0..1279]
    input [9:0]  y,  // [0..1023]
    input valid,
    input [7:0] read_value,
    input read_index,
    output wire [8:0] read_address,
    output wire valid_pixel,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);

wire [8:0] prev_address;
wire [7:0] read_adjusted;
wire [7:0] prev;
wire update;
wire region_ok;
wire [7:0] yval;
wire y_ok;

//calculate ram address from x coordinate (droppping LSB)
assign read_address = {read_index, x[9], x[7:1]};

//store previous address
dffr #(.WIDTH(9)) address_ff (.clk(clk), .r(reset), .d(read_address), .q(prev_address));
assign read_adjusted = (read_value >> 1) + 8'd32; //adjust read value for display following formula

//update only when address changes
assign update = (read_address != prev_address);
dffre #(.WIDTH(8)) value_ff (.clk(clk), .r(reset), .d(read_adjusted), .q(prev), .en(update));

//check if the pixel should be drawn
assign region_ok = ((x[10:8] == 3'b001) || (x[10:8] == 3'b010)) && (y[9] == 1'b0);

//check if y values fall in between prev and curr values
assign yval = y[8:1];
assign y_ok = ((yval >= prev && yval <= read_adjusted) || (yval >= read_adjusted && yval <= prev)) && (read_address[7:0] > 8'd0);

//define if the pixel is valid by checking if the input valid is 1, if it's within the valid region
//and in the correct y range, and if it's not x=0 to avoid vertical lines on the ends
assign valid_pixel = valid && region_ok && y_ok && (read_address[7:0] < 8'd255);

//output color
// map notes to colors
wire [23:0] note_color;
assign note_color =
        (read_value == 8'd1)  ? 24'hFF0000 :
        (read_value == 8'd3)  ? 24'h00FF00 :
        (read_value == 8'd4)  ? 24'h0000FF :
        (read_value == 8'd6)  ? 24'hFFFF00 :
        (read_value == 8'd8)  ? 24'h00FFFF :
        (read_value == 8'd9)  ? 24'hFFA500 :
        (read_value == 8'd10) ? 24'h800080 :
        (read_value == 8'd11) ? 24'h008000 :
        (read_value == 8'd13) ? 24'h808000 :
        (read_value == 8'd14) ? 24'h800000 :
        (read_value == 8'd15) ? 24'h008080 :
        (read_value == 8'd16) ? 24'hC0C0C0 :
        (read_value == 8'd17) ? 24'hA52A2A :
        (read_value == 8'd18) ? 24'h000080 :
        (read_value == 8'd20) ? 24'hFF1493 :
        (read_value == 8'd21) ? 24'h00CED1 :
        (read_value == 8'd23) ? 24'hFFD700 :
        (read_value == 8'd24) ? 24'hADFF2F :
        (read_value == 8'd25) ? 24'hDC143C :
        (read_value == 8'd27) ? 24'h00BFFF :
        (read_value == 8'd28) ? 24'h8B0000 :
        (read_value == 8'd30) ? 24'hB8860B :
        (read_value == 8'd32) ? 24'h006400 :
        (read_value == 8'd33) ? 24'h8B008B :
        (read_value == 8'd34) ? 24'h4682B4 :
        (read_value == 8'd35) ? 24'h2E8B57 :
        (read_value == 8'd37) ? 24'hFF6347 :
        (read_value == 8'd38) ? 24'h40E0D0 :
        (read_value == 8'd39) ? 24'hDAA520 :
        (read_value == 8'd40) ? 24'h7FFF00 :
        (read_value == 8'd41) ? 24'hD2691E :
        (read_value == 8'd42) ? 24'h6495ED :
        (read_value == 8'd43) ? 24'hFF4500 :
        (read_value == 8'd44) ? 24'h00FA9A :
        (read_value == 8'd45) ? 24'h1E90FF :
        (read_value == 8'd46) ? 24'hB22222 :
        (read_value == 8'd47) ? 24'h228B22 :
        (read_value == 8'd49) ? 24'hFF69B4 :
        (read_value == 8'd50) ? 24'hCD5C5C :
        (read_value == 8'd51) ? 24'h4B0082 :
        (read_value == 8'd52) ? 24'hF08080 :
        (read_value == 8'd54) ? 24'h20B2AA :
        (read_value == 8'd56) ? 24'h87CEFA :
        (read_value == 8'd57) ? 24'h778899 :
        (read_value == 8'd59) ? 24'hB0C4DE :
        24'hFF00AA;

assign {r,g,b} = valid_pixel ? note_color : 24'h000000;
    
endmodule
