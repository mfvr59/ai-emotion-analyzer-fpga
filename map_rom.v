// This module maps a given note index to the addresses 
// of its ascii character representations in tcgrom.

module map_rom (
    input wire [5:0] note_idx,
    output reg [8:0] left_char,
    output reg [8:0] right_char
);  
    
    always @(note_idx)
        case (note_idx)
            // notes starting with 1
            6'd0   : {left_char, right_char} = {9'h090, 9'h090}; // 0: rest: R for ascii
            6'd1   : {left_char, right_char} = {9'h188, 9'h008}; // 1: 1A
            6'd2   : {left_char, right_char} = {9'h188, 9'h008}; // 2: 1A#Bb
            6'd3   : {left_char, right_char} = {9'h188, 9'h010}; // 3: 1B
            6'd4   : {left_char, right_char} = {9'h188, 9'h018}; // 4: 1C
            6'd5   : {left_char, right_char} = {9'h188, 9'h018}; // 5: 1C#Db
            6'd6   : {left_char, right_char} = {9'h188, 9'h020}; // 6: 1D
            6'd7   : {left_char, right_char} = {9'h188, 9'h020}; // 7: 1D#Eb
            6'd8   : {left_char, right_char} = {9'h188, 9'h028}; // 8: 1E
            6'd9   : {left_char, right_char} = {9'h188, 9'h030}; // 9: 1F
            6'd10  : {left_char, right_char} = {9'h188, 9'h030}; // 10: 1F#Gb
            6'd11  : {left_char, right_char} = {9'h188, 9'h038}; // 11: 1G
            6'd12  : {left_char, right_char} = {9'h188, 9'h038}; // 12: 1G#Ab
            
            // notes starting with 2
            6'd13  : {left_char, right_char} = {9'h190, 9'h008}; // 13: 2A
            6'd14  : {left_char, right_char} = {9'h190, 9'h008}; // 14: 2A#Bb
            6'd15  : {left_char, right_char} = {9'h190, 9'h010}; // 15: 2B
            6'd16  : {left_char, right_char} = {9'h190, 9'h018}; // 16: 2C
            6'd17  : {left_char, right_char} = {9'h190, 9'h018}; // 17: 2C#Db
            6'd18  : {left_char, right_char} = {9'h190, 9'h020}; // 18: 2D
            6'd19  : {left_char, right_char} = {9'h190, 9'h020}; // 19: 2D#Eb
            6'd20  : {left_char, right_char} = {9'h190, 9'h028}; // 20: 2E
            6'd21  : {left_char, right_char} = {9'h190, 9'h030}; // 21: 2F
            6'd22  : {left_char, right_char} = {9'h190, 9'h030}; // 22: 2F#Gb
            6'd23  : {left_char, right_char} = {9'h190, 9'h038}; // 23: 2G
            6'd24  : {left_char, right_char} = {9'h190, 9'h038}; // 24: 2G#Ab

            // notes starting with 3
            6'd25  : {left_char, right_char} = {9'h198, 9'h008}; // 25: 3A
            6'd26  : {left_char, right_char} = {9'h198, 9'h008}; // 26: 3A#Bb
            6'd27  : {left_char, right_char} = {9'h198, 9'h010}; // 27: 3B
            6'd28  : {left_char, right_char} = {9'h198, 9'h018}; // 28: 3C
            6'd29  : {left_char, right_char} = {9'h198, 9'h018}; // 29: 3C#Db
            6'd30  : {left_char, right_char} = {9'h198, 9'h020}; // 30: 3D
            6'd31  : {left_char, right_char} = {9'h198, 9'h020}; // 31: 3D#Eb
            6'd32  : {left_char, right_char} = {9'h198, 9'h028}; // 32: 3E
            6'd33  : {left_char, right_char} = {9'h198, 9'h030}; // 33: 3F
            6'd34  : {left_char, right_char} = {9'h198, 9'h030}; // 34: 3F#Gb
            6'd35  : {left_char, right_char} = {9'h198, 9'h038}; // 35: 3G
            6'd36  : {left_char, right_char} = {9'h198, 9'h038}; // 36: 3G#Ab 

            // notes starting with 4
            6'd37  : {left_char, right_char} = {9'h1a0, 9'h008}; // 37: 4A
            6'd38  : {left_char, right_char} = {9'h1a0, 9'h008}; // 38: 4A#Bb
            6'd39  : {left_char, right_char} = {9'h1a0, 9'h010}; // 39: 4B
            6'd40  : {left_char, right_char} = {9'h1a0, 9'h018}; // 40: 4C
            6'd41  : {left_char, right_char} = {9'h1a0, 9'h018}; // 41: 4C#Db
            6'd42  : {left_char, right_char} = {9'h1a0, 9'h020}; // 42: 4D
            6'd43  : {left_char, right_char} = {9'h1a0, 9'h020}; // 43: 4D#Eb
            6'd44  : {left_char, right_char} = {9'h1a0, 9'h028}; // 44: 4E
            6'd45  : {left_char, right_char} = {9'h1a0, 9'h030}; // 45: 4F
            6'd46  : {left_char, right_char} = {9'h1a0, 9'h030}; // 46: 4F#Gb
            6'd47  : {left_char, right_char} = {9'h1a0, 9'h038}; // 47: 4G
            6'd48  : {left_char, right_char} = {9'h1a0, 9'h038}; // 48: 4G#Ab

            // notes starting with 5
            6'd49  : {left_char, right_char} = {9'h1a8, 9'h008}; // 49: 5A
            6'd50  : {left_char, right_char} = {9'h1a8, 9'h008}; // 50: 5A#Bb
            6'd51  : {left_char, right_char} = {9'h1a8, 9'h010}; // 51: 5B
            6'd52  : {left_char, right_char} = {9'h1a8, 9'h018}; // 52: 5C
            6'd53  : {left_char, right_char} = {9'h1a8, 9'h018}; // 53: 5C#Db
            6'd54  : {left_char, right_char} = {9'h1a8, 9'h020}; // 54: 5D
            6'd55  : {left_char, right_char} = {9'h1a8, 9'h020}; // 55: 5D#Eb
            6'd56  : {left_char, right_char} = {9'h1a8, 9'h028}; // 56: 5E
            6'd57  : {left_char, right_char} = {9'h1a8, 9'h030}; // 57: 5F
            6'd58  : {left_char, right_char} = {9'h1a8, 9'h030}; // 58: 5F#Gb
            6'd59  : {left_char, right_char} = {9'h1a8, 9'h038}; // 59: 5G
            6'd60  : {left_char, right_char} = {9'h1a8, 9'h038}; // 60: 5G#Ab

            // notes starting with 6
            6'd61  : {left_char, right_char} = {9'h1b0, 9'h008}; // 61: 6A
            6'd62  : {left_char, right_char} = {9'h1b0, 9'h008}; // 62: 6A#Bb
            6'd63  : {left_char, right_char} = {9'h1b0, 9'h010}; // 63: 6B

            default: {left_char, right_char} = {9'h100, 9'h100}; // default: two blank spaces
        endcase

endmodule