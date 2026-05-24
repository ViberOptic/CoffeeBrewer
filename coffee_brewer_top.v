module clk_divider (
    input clk,
    input rst,
    input en,
    output reg tick
);
    reg [31:0] counter;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 32'd0;
            tick <= 1'b0;
        end else if (en) begin
            if (counter == 32'd99999999) begin
                counter <= 32'd0;
                tick <= 1'b1;
            end else begin
                counter <= counter + 32'd1;
                tick <= 1'b0;
            end
        end else begin
            counter <= 32'd0;
            tick <= 1'b0;
        end
    end
endmodule
