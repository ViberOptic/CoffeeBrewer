module pump_controller (
    input clk,
    input rst,
    input brew_en,
    output reg pump
);
    // Register the pump output for clean, glitch-free LED drive.
    // pump follows brew_en with one clock cycle latency (10 ns),
    // which is imperceptible but ensures a clean signal.
    always @(posedge clk or posedge rst) begin
        if (rst)
            pump <= 1'b0;
        else
            pump <= brew_en;
    end
endmodule