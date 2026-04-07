module lab2 (
    input wire nReset,
    input wire Clock,
    input wire Enable,
    output wire [3:0] Co1,     // 1's place
    output wire [3:0] Co10,    // 10's place
    output wire [3:0] Co100    // 100's place
);

    wire en10, en100;

    bcd_counter U1 (
        .nRst(nReset),
        .Clk(Clock),
        .CntEn(Enable),
        .Cout(Co1),
        .NextEn(en10)
    );

    bcd_counter U2 (
        .nRst(nReset),
        .Clk(Clock),
        .CntEn(en10),
        .Cout(Co10),
        .NextEn(en100)
    );

    bcd_counter U3 (
        .nRst(nReset),
        .Clk(Clock),
        .CntEn(en100),
        .Cout(Co100),
        .NextEn() // Not used
    );
endmodule


module bcd_counter (
    input wire nRst,     // active-low reset
    input wire Clk,      // clock
    input wire CntEn,    // count enable
    output reg [3:0] Cout,
    output wire NextEn   // high when Cout is 9
);

    assign NextEn = (Cout == 4'd9);

    always @(posedge Clk or negedge nRst) begin
        if (!nRst)
            Cout <= 4'd0;
        else if (CntEn) begin
            if (Cout == 4'd9)
                Cout <= 4'd0;
            else
                Cout <= Cout + 1;
        end
    end
endmodule
