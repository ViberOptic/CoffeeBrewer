module coffee_brewer_top (
    input clk,
    input rst,
    input start,
    input water_level,
    output grinder,
    output heater,
    output pump,
    output drip_valve,
    output done,
    output [7:0] an,   // TAMBAHAN: Port fisik Anode Nexys A7
    output [6:0] seg   // TAMBAHAN: Port fisik Cathode Nexys A7
);
    wire tick;
    wire latch_en;
    wire water_level_latched;
    wire brew_en;
    wire fsm_active;
    wire [2:0] w_state; // TAMBAHAN: Kawat penghubung data state

    assign fsm_active = grinder | brew_en | drip_valve;

    clk_divider div_inst (
        .clk(clk),
        .rst(rst),
        .en(fsm_active),
        .tick(tick)
    );

    d_flipflop latch_inst (
        .clk(clk),
        .rst(rst),
        .en(latch_en),
        .d(water_level),
        .q(water_level_latched)
    );

    coffee_fsm fsm_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .tick(tick),
        .latch_en(latch_en),
        .grinder(grinder),
        .heater(heater),
        .brew_en(brew_en),
        .drip_valve(drip_valve),
        .done(done),
        .current_state(w_state) // Dihubungkan ke kawat internal
    );

    pump_controller pump_inst (
        .enable(brew_en),
        .water_level_ok(water_level_latched),
        .pump_out(pump)
    );

    // TAMBAHAN: Instansiasi pengendali Seven Segment
    seven_seg_controller seg_inst (
        .clk(clk),
        .rst(rst),
        .water_level(water_level),
        .start(start),
        .state(w_state),
        .an(an),
        .seg(seg)
    );

endmodule