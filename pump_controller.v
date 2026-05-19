module pump_controller (
    input enable,
    input water_level_ok,
    output pump_out
);
    assign pump_out = enable & water_level_ok;
endmodule
