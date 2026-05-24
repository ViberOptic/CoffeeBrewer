module seven_seg_controller (
    input clk,
    input rst,
    input water_level,
    input start,
    input [2:0] state,
    output reg [7:0] an,   
    output reg [6:0] seg   
);
    reg [19:0] refresh_counter;
    always @(posedge clk or posedge rst) begin
        if (rst)
            refresh_counter <= 20'd0;
        else
            refresh_counter <= refresh_counter + 20'd1;
    end
    
    wire [2:0] digit_select = refresh_counter[19:17];
    
    always @(*) begin
        case(digit_select)
            3'b000: an = 8'b11111110; 
            3'b001: an = 8'b11111101; 
            3'b010: an = 8'b11111011; 
            3'b011: an = 8'b11110111; 
            3'b100: an = 8'b11101111; 
            3'b101: an = 8'b11011111; 
            3'b110: an = 8'b10111111; 
            3'b111: an = 8'b01111111; 
            default: an = 8'b11111111;
        endcase
    end

    always @(*) begin
        case(digit_select)
            3'b111: seg = 7'b1100011; 
            3'b110: seg = water_level ? 7'b1111001 : 7'b1000000; 
            3'b101: seg = 7'b0010001; 
            3'b100: seg = start ? 7'b1111001 : 7'b1000000; 
            3'b011: seg = 7'b0010010; 
            3'b010: seg = 7'b0000111; 
            
            3'b001: begin
                case(state)
                    3'b000: seg = 7'b1111001; 
                    3'b001: seg = 7'b1000010; 
                    3'b010: seg = 7'b0000011; 
                    3'b011: seg = 7'b0100001; 
                    3'b100: seg = 7'b0100001; 
                    3'b101: seg = 7'b0110000; 
                    default: seg = 7'b1111111; 
                endcase
            end
            
            3'b000: begin
                case(state)
                    3'b000: seg = 7'b0100001; 
                    3'b001: seg = 7'b0101111; 
                    3'b010: seg = 7'b0101111; 
                    3'b011: seg = 7'b0101111; 
                    3'b100: seg = 7'b0101011; 
                    3'b101: seg = 7'b0101111; 
                    default: seg = 7'b1111111; 
                endcase
            end
            default: seg = 7'b1111111;
        endcase
    end
endmodule