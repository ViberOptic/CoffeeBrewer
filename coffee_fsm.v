module coffee_fsm (
    input clk,
    input rst,
    input start,
    input tick,
    output reg latch_en,
    output reg grinder,
    output reg heater,
    output reg brew_en,
    output reg drip_valve,
    output reg done,
    output [2:0] current_state // TAMBAHAN: Output untuk membaca state
);
    parameter IDLE  = 3'b000;
    parameter GRIND = 3'b001;
    parameter BREW  = 3'b010;
    parameter DRIP  = 3'b011;
    parameter DONE  = 3'b100;

    reg [2:0] state, next_state;

    // Menghubungkan register internal state ke output luar
    assign current_state = state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start)
                    next_state = GRIND;
            end
            GRIND: begin
                if (tick)
                    next_state = BREW;
            end
            BREW: begin
                if (tick)
                    next_state = DRIP;
            end
            DRIP: begin
                if (tick)
                    next_state = DONE;
            end
            DONE: begin
                if (!start)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        latch_en   = 1'b0;
        grinder    = 1'b0;
        heater     = 1'b0;
        brew_en    = 1'b0;
        drip_valve = 1'b0;
        done       = 1'b0;
        case (state)
            IDLE: begin
                latch_en = 1'b1;
            end
            GRIND: begin
                grinder = 1'b1;
            end
            BREW: begin
                heater = 1'b1;
                brew_en = 1'b1;
            end
            DRIP: begin
                drip_valve = 1'b1;
            end
            DONE: begin
                done = 1'b1;
            end
        endcase
    end
endmodule