module lab3 (
    input wire clk1ms,
    input wire sw_in,
    output wire sw_out_db1,
    output wire sw_out_db2
);

    debouncer1 db1 (
        .clk1ms(clk1ms),
        .sw_in(sw_in),
        .sw_out_db(sw_out_db1)
    );

    debouncer2 db2 (
        .clk1ms(clk1ms),
        .sw_in(sw_in),
        .sw_out_db(sw_out_db2)
    );

endmodule

module debouncer1 (
    input wire clk1ms,
    input wire sw_in,
    output reg sw_out_db
);

    reg [2:0] shift_reg;

    always @(posedge clk1ms) begin
        shift_reg <= {shift_reg[1:0], sw_in};

        if (&shift_reg)
            sw_out_db <= 1;
        else if (~|shift_reg)
            sw_out_db <= 0;
    end
endmodule

module debouncer2 (
    input wire clk1ms,
    input wire sw_in,
    output reg sw_out_db
);

    reg [2:0] state;
    reg [2:0] counter;
    reg lock;

    always @(posedge clk1ms) 
    begin
        if (!lock && (sw_in != sw_out_db)) begin
            sw_out_db <= sw_in;
            lock <= 1;
            counter <= 0;
        end else if (lock) begin
            counter <= counter + 1;
            if (counter == 3'd4)
                lock <= 0;
        end
    end
endmodule
