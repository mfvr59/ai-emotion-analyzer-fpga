module song_rom(
    input clk,
    input [8:0] addr,
    output reg [15:0] dout
);
    always @(*) begin
        case(addr)
            // Block 0: F# minor chord (F#, A, C#)
            9'd0:  dout = {1'b0,6'd30,6'd8,3'd0};    // F#2
            9'd1:  dout = {1'b0,6'd33,6'd8,3'd0};    // A2
            9'd2:  dout = {1'b0,6'd37,6'd8,3'd0};    // C#3
            9'd3:  dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 1: G# minor chord (G#, B, D#)
            9'd4:  dout = {1'b0,6'd32,6'd8,3'd0};    // G#2
            9'd5:  dout = {1'b0,6'd35,6'd8,3'd0};    // B2
            9'd6:  dout = {1'b0,6'd39,6'd8,3'd0};    // D#3
            9'd7:  dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 2: A# minor chord (A#, C#, F)
            9'd8:  dout = {1'b0,6'd34,6'd8,3'd0};    // A#2
            9'd9:  dout = {1'b0,6'd37,6'd8,3'd0};    // C#3
            9'd10: dout = {1'b0,6'd41,6'd8,3'd0};    // F3
            9'd11: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 3: B Major chord (B, D#, F#)
            9'd12: dout = {1'b0,6'd35,6'd8,3'd0};    // B2
            9'd13: dout = {1'b0,6'd39,6'd8,3'd0};    // D#3
            9'd14: dout = {1'b0,6'd42,6'd8,3'd0};    // F#3
            9'd15: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 4: C# Major chord (C#, F, G#)
            9'd16: dout = {1'b0,6'd37,6'd8,3'd0};    // C#3
            9'd17: dout = {1'b0,6'd41,6'd8,3'd0};    // F3
            9'd18: dout = {1'b0,6'd44,6'd8,3'd0};    // G#3
            9'd19: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 5: D# minor chord (D#, F#, A#)
            9'd20: dout = {1'b0,6'd39,6'd8,3'd0};    // D#3
            9'd21: dout = {1'b0,6'd42,6'd8,3'd0};    // F#3
            9'd22: dout = {1'b0,6'd46,6'd8,3'd0};    // A#3
            9'd23: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 6: F Major chord (F, A, C)
            9'd24: dout = {1'b0,6'd41,6'd8,3'd0};    // F3
            9'd25: dout = {1'b0,6'd45,6'd8,3'd0};    // A3
            9'd26: dout = {1'b0,6'd48,6'd8,3'd0};    // C4
            9'd27: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 7: F# Major chord (F#, A#, C#)
            9'd28: dout = {1'b0,6'd42,6'd8,3'd0};    // F#3
            9'd29: dout = {1'b0,6'd46,6'd8,3'd0};    // A#3
            9'd30: dout = {1'b0,6'd49,6'd8,3'd0};    // C#4
            9'd31: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 8: G# Major chord (G#, C, D#) - Higher octave
            9'd32: dout = {1'b0,6'd44,6'd8,3'd0};    // G#3
            9'd33: dout = {1'b0,6'd48,6'd8,3'd0};    // C4
            9'd34: dout = {1'b0,6'd51,6'd8,3'd0};    // D#4
            9'd35: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 9: A# Major chord (A#, D, F)
            9'd36: dout = {1'b0,6'd46,6'd8,3'd0};    // A#3
            9'd37: dout = {1'b0,6'd50,6'd8,3'd0};    // D4
            9'd38: dout = {1'b0,6'd53,6'd8,3'd0};    // F4
            9'd39: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 10: C Major chord (C, E, G)
            9'd40: dout = {1'b0,6'd48,6'd8,3'd0};    // C4
            9'd41: dout = {1'b0,6'd52,6'd8,3'd0};    // E4
            9'd42: dout = {1'b0,6'd55,6'd8,3'd0};    // G4
            9'd43: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 11: D Major chord (D, F#, A)
            9'd44: dout = {1'b0,6'd50,6'd8,3'd0};    // D4
            9'd45: dout = {1'b0,6'd54,6'd8,3'd0};    // F#4
            9'd46: dout = {1'b0,6'd57,6'd8,3'd0};    // A4
            9'd47: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 12: E Major chord (E, G#, B)
            9'd48: dout = {1'b0,6'd52,6'd8,3'd0};    // E4
            9'd49: dout = {1'b0,6'd56,6'd8,3'd0};    // G#4
            9'd50: dout = {1'b0,6'd59,6'd8,3'd0};    // B4
            9'd51: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 13: F# Major chord (F#, A#, C#)
            9'd52: dout = {1'b0,6'd54,6'd8,3'd0};    // F#4
            9'd53: dout = {1'b0,6'd58,6'd8,3'd0};    // A#4
            9'd54: dout = {1'b0,6'd61,6'd8,3'd0};    // C#5
            9'd55: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 14: G Major chord (G, B, D)
            9'd56: dout = {1'b0,6'd55,6'd8,3'd0};    // G4
            9'd57: dout = {1'b0,6'd59,6'd8,3'd0};    // B4
            9'd58: dout = {1'b0,6'd62,6'd8,3'd0};    // D5
            9'd59: dout = {1'b1,6'd4,9'd0};          // Rest
            
            // Block 15: C Major chord (C, E, G) - Final cadence, longer
            9'd60: dout = {1'b0,6'd48,6'd16,3'd0};   // C4 (longer duration)
            9'd61: dout = {1'b0,6'd52,6'd16,3'd0};   // E4
            9'd62: dout = {1'b0,6'd55,6'd16,3'd0};   // G4
            9'd63: dout = {1'b1,6'd0,9'd0};          // Final rest

            //song1
            9'd128: dout = {1'b0,6'd59,6'd12,3'd0};  // B4
            9'd129: dout = {1'b1,6'd3,9'd0};
            9'd130: dout = {1'b0,6'd57,6'd12,3'd0};  // A4
            9'd131: dout = {1'b1,6'd3,9'd0};
            9'd132: dout = {1'b0,6'd56,6'd12,3'd0};  // G#4
            9'd133: dout = {1'b1,6'd3,9'd0};
            9'd134: dout = {1'b0,6'd54,6'd12,3'd0};  // F#4
            9'd135: dout = {1'b1,6'd3,9'd0};
            9'd136: dout = {1'b0,6'd52,6'd12,3'd0};  // E4
            9'd137: dout = {1'b1,6'd3,9'd0};
            9'd138: dout = {1'b0,6'd51,6'd12,3'd0};  // D#4
            9'd139: dout = {1'b1,6'd3,9'd0};
            9'd140: dout = {1'b0,6'd49,6'd12,3'd0};  // C#4
            9'd141: dout = {1'b1,6'd3,9'd0};
            9'd142: dout = {1'b0,6'd47,6'd12,3'd0};  // B3
            9'd143: dout = {1'b1,6'd3,9'd0};
            
            9'd144: dout = {1'b0,6'd59,6'd12,3'd0};
            9'd145: dout = {1'b1,6'd3,9'd0};
            9'd146: dout = {1'b0,6'd57,6'd12,3'd0};
            9'd147: dout = {1'b1,6'd3,9'd0};
            9'd148: dout = {1'b0,6'd56,6'd12,3'd0};
            9'd149: dout = {1'b1,6'd3,9'd0};
            9'd150: dout = {1'b0,6'd54,6'd12,3'd0};
            9'd151: dout = {1'b1,6'd3,9'd0};
            9'd152: dout = {1'b0,6'd52,6'd12,3'd0};
            9'd153: dout = {1'b1,6'd3,9'd0};
            9'd154: dout = {1'b0,6'd51,6'd12,3'd0};
            9'd155: dout = {1'b1,6'd3,9'd0};
            9'd156: dout = {1'b0,6'd49,6'd12,3'd0};
            9'd157: dout = {1'b1,6'd3,9'd0};
            9'd158: dout = {1'b0,6'd47,6'd12,3'd0};
            9'd159: dout = {1'b1,6'd3,9'd0};
            
            9'd160: dout = {1'b0,6'd47,6'd12,3'd0};  // Lower octave
            9'd161: dout = {1'b1,6'd3,9'd0};
            9'd162: dout = {1'b0,6'd45,6'd12,3'd0};
            9'd163: dout = {1'b1,6'd3,9'd0};
            9'd164: dout = {1'b0,6'd44,6'd12,3'd0};
            9'd165: dout = {1'b1,6'd3,9'd0};
            9'd166: dout = {1'b0,6'd42,6'd12,3'd0};
            9'd167: dout = {1'b1,6'd3,9'd0};
            9'd168: dout = {1'b0,6'd40,6'd12,3'd0};
            9'd169: dout = {1'b1,6'd3,9'd0};
            9'd170: dout = {1'b0,6'd39,6'd12,3'd0};
            9'd171: dout = {1'b1,6'd3,9'd0};
            9'd172: dout = {1'b0,6'd37,6'd12,3'd0};
            9'd173: dout = {1'b1,6'd3,9'd0};
            9'd174: dout = {1'b0,6'd35,6'd12,3'd0};
            9'd175: dout = {1'b1,6'd3,9'd0};
            
            9'd176: dout = {1'b0,6'd47,6'd12,3'd0};
            9'd177: dout = {1'b1,6'd3,9'd0};
            9'd178: dout = {1'b0,6'd45,6'd12,3'd0};
            9'd179: dout = {1'b1,6'd3,9'd0};
            9'd180: dout = {1'b0,6'd44,6'd12,3'd0};
            9'd181: dout = {1'b1,6'd3,9'd0};
            9'd182: dout = {1'b0,6'd42,6'd12,3'd0};
            9'd183: dout = {1'b1,6'd3,9'd0};
            9'd184: dout = {1'b0,6'd40,6'd12,3'd0};
            9'd185: dout = {1'b1,6'd3,9'd0};
            9'd186: dout = {1'b0,6'd39,6'd12,3'd0};
            9'd187: dout = {1'b1,6'd3,9'd0};
            9'd188: dout = {1'b0,6'd37,6'd12,3'd0};
            9'd189: dout = {1'b1,6'd3,9'd0};
            9'd190: dout = {1'b0,6'd35,6'd24,3'd0};  // Long ending
            9'd191: dout = {1'b1,6'd0,9'd0};

            //song2
            9'd256: dout = {1'b0,6'd59,6'd32,3'd0};  // B4 - long duration
            9'd257: dout = {1'b1,6'd8,9'd0};         // Longer rest
            9'd258: dout = {1'b0,6'd58,6'd32,3'd0};  // A#4
            9'd259: dout = {1'b1,6'd8,9'd0};
            9'd260: dout = {1'b0,6'd57,6'd32,3'd0};  // A4
            9'd261: dout = {1'b1,6'd8,9'd0};
            9'd262: dout = {1'b0,6'd56,6'd32,3'd0};  // G#4
            9'd263: dout = {1'b1,6'd8,9'd0};
            9'd264: dout = {1'b0,6'd55,6'd32,3'd0};  // G4
            9'd265: dout = {1'b1,6'd8,9'd0};
            9'd266: dout = {1'b0,6'd54,6'd32,3'd0};  // F#4
            9'd267: dout = {1'b1,6'd8,9'd0};
            9'd268: dout = {1'b0,6'd53,6'd32,3'd0};  // F4
            9'd269: dout = {1'b1,6'd8,9'd0};
            9'd270: dout = {1'b0,6'd52,6'd32,3'd0};  // E4
            9'd271: dout = {1'b1,6'd8,9'd0};
            
            9'd272: dout = {1'b0,6'd51,6'd32,3'd0};  // D#4
            9'd273: dout = {1'b1,6'd8,9'd0};
            9'd274: dout = {1'b0,6'd50,6'd32,3'd0};  // D4
            9'd275: dout = {1'b1,6'd8,9'd0};
            9'd276: dout = {1'b0,6'd49,6'd32,3'd0};  // C#4
            9'd277: dout = {1'b1,6'd8,9'd0};
            9'd278: dout = {1'b0,6'd48,6'd32,3'd0};  // C4
            9'd279: dout = {1'b1,6'd8,9'd0};
            9'd280: dout = {1'b0,6'd47,6'd32,3'd0};  // B3
            9'd281: dout = {1'b1,6'd8,9'd0};
            9'd282: dout = {1'b0,6'd46,6'd32,3'd0};  // A#3
            9'd283: dout = {1'b1,6'd8,9'd0};
            9'd284: dout = {1'b0,6'd45,6'd32,3'd0};  // A3
            9'd285: dout = {1'b1,6'd8,9'd0};
            9'd286: dout = {1'b0,6'd44,6'd48,3'd0};  // G#3 - extra long ending
            9'd287: dout = {1'b1,6'd0,9'd0};
            
            //song3
            // First pass: C, Am, F, G  (triad arpeggios)
            9'd384: dout = {1'b0,6'd48,6'd16,3'd0};  // C4
            9'd385: dout = {1'b1,6'd4,9'd0};
            9'd386: dout = {1'b0,6'd52,6'd16,3'd0};  // E4
            9'd387: dout = {1'b1,6'd4,9'd0};
            9'd388: dout = {1'b0,6'd55,6'd16,3'd0};  // G4
            9'd389: dout = {1'b1,6'd4,9'd0};

            9'd390: dout = {1'b0,6'd45,6'd16,3'd0};  // A3
            9'd391: dout = {1'b1,6'd4,9'd0};
            9'd392: dout = {1'b0,6'd48,6'd16,3'd0};  // C4
            9'd393: dout = {1'b1,6'd4,9'd0};
            9'd394: dout = {1'b0,6'd52,6'd16,3'd0};  // E4
            9'd395: dout = {1'b1,6'd4,9'd0};

            9'd396: dout = {1'b0,6'd41,6'd16,3'd0};  // F3
            9'd397: dout = {1'b1,6'd4,9'd0};
            9'd398: dout = {1'b0,6'd45,6'd16,3'd0};  // A3
            9'd399: dout = {1'b1,6'd4,9'd0};
            9'd400: dout = {1'b0,6'd48,6'd16,3'd0};  // C4
            9'd401: dout = {1'b1,6'd4,9'd0};

            9'd402: dout = {1'b0,6'd43,6'd16,3'd0};  // G3
            9'd403: dout = {1'b1,6'd4,9'd0};
            9'd404: dout = {1'b0,6'd47,6'd16,3'd0};  // B3
            9'd405: dout = {1'b1,6'd4,9'd0};
            9'd406: dout = {1'b0,6'd50,6'd16,3'd0};  // D4
            9'd407: dout = {1'b1,6'd4,9'd0};

            // Second pass: C, Am, F, G again (same voicings)
            9'd408: dout = {1'b0,6'd48,6'd16,3'd0};  // C4
            9'd409: dout = {1'b1,6'd4,9'd0};
            9'd410: dout = {1'b0,6'd52,6'd16,3'd0};  // E4
            9'd411: dout = {1'b1,6'd4,9'd0};
            9'd412: dout = {1'b0,6'd55,6'd16,3'd0};  // G4
            9'd413: dout = {1'b1,6'd4,9'd0};

            9'd414: dout = {1'b0,6'd45,6'd16,3'd0};  // A3
            9'd415: dout = {1'b1,6'd4,9'd0};
            9'd416: dout = {1'b0,6'd48,6'd16,3'd0};  // C4
            9'd417: dout = {1'b1,6'd4,9'd0};
            9'd418: dout = {1'b0,6'd52,6'd16,3'd0};  // E4
            9'd419: dout = {1'b1,6'd4,9'd0};

            9'd420: dout = {1'b0,6'd41,6'd16,3'd0};  // F3
            9'd421: dout = {1'b1,6'd4,9'd0};
            9'd422: dout = {1'b0,6'd45,6'd16,3'd0};  // A3
            9'd423: dout = {1'b1,6'd4,9'd0};
            9'd424: dout = {1'b0,6'd48,6'd16,3'd0};  // C4
            9'd425: dout = {1'b1,6'd4,9'd0};

            9'd426: dout = {1'b0,6'd43,6'd16,3'd0};  // G3
            9'd427: dout = {1'b1,6'd4,9'd0};
            9'd428: dout = {1'b0,6'd47,6'd16,3'd0};  // B3
            9'd429: dout = {1'b1,6'd4,9'd0};
            9'd430: dout = {1'b0,6'd50,6'd16,3'd0};  // D4
            9'd431: dout = {1'b1,6'd4,9'd0};

            // Cadence: walk around and land hard on C
            9'd432: dout = {1'b0,6'd48,6'd16,3'd0};  // C4
            9'd433: dout = {1'b1,6'd4,9'd0};
            9'd434: dout = {1'b0,6'd43,6'd16,3'd0};  // G3
            9'd435: dout = {1'b1,6'd4,9'd0};
            9'd436: dout = {1'b0,6'd45,6'd16,3'd0};  // A3
            9'd437: dout = {1'b1,6'd4,9'd0};
            9'd438: dout = {1'b0,6'd41,6'd16,3'd0};  // F3
            9'd439: dout = {1'b1,6'd4,9'd0};
            9'd440: dout = {1'b0,6'd50,6'd16,3'd0};  // D4
            9'd441: dout = {1'b1,6'd4,9'd0};
            9'd442: dout = {1'b0,6'd43,6'd16,3'd0};  // G3
            9'd443: dout = {1'b1,6'd4,9'd0};
            9'd444: dout = {1'b0,6'd48,6'd16,3'd0};  // C4
            9'd445: dout = {1'b1,6'd4,9'd0};
            9'd446: dout = {1'b0,6'd48,6'd32,3'd0};  // Final C4 - long
            9'd447: dout = {1'b1,6'd0,9'd0};

            default: dout = 16'd0;
        endcase
    end
endmodule
