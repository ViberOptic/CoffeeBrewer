module coffee_brewer_top (
    input clk,
    input rst,
    input start,
    input water_level,
    input coffee_level,
    output grinder,
    output heater,
    output pump,
    output drip_valve,
    output done,
    output error,
    output [7:0] an,
    output [6:0] seg
);

    // Internal wires
    wire tick;
    wire latch_en;
    wire brew_en;
    wire start_latched;
    wire [2:0] current_state;

    // Clock Divider: 100 MHz -> 1 Hz tick
    clk_divider u_clk_div (
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .tick(tick)
    );

    // D Flip-Flop: Latch start input during IDLE
    d_flipflop u_dff (
        .clk(clk),
        .rst(rst),
        .en(latch_en),
        .d(start),
        .q(start_latched)
    );

    // Coffee FSM: Core state machine
    coffee_fsm u_fsm (
        .clk(clk),
        .rst(rst),
        .start(start_latched),
        .tick(tick),
        .water_level(water_level),
        .coffee_level(coffee_level),
        .latch_en(latch_en),
        .grinder(grinder),
        .heater(heater),
        .brew_en(brew_en),
        .drip_valve(drip_valve),
        .done(done),
        .error(error),
        .current_state(current_state)
    );

    // Pump Controller: Drive pump output from brew_en
    pump_controller u_pump (
        .clk(clk),
        .rst(rst),
        .brew_en(brew_en),
        .pump(pump)
    );

    // Seven Segment Controller: Display status
    seven_seg_controller u_seg (
        .clk(clk),
        .rst(rst),
        .water_level(water_level),
        .start(start),
        .state(current_state),
        .an(an),
        .seg(seg)
    );

endmodule
