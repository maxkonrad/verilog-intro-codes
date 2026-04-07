module lab1(input clk_in, input rst_in, input sel, output out);
	three_bit_counter counter_inst(.clk_in(clk_in), .rst_in(rst_in), .bit_0(bit_0), .bit_1(bit_1), .bit_2(bit_2));
	and_or_xor_func func_inst(.op1(bit_0), .op2(bit_2), .sel(sel), .out(out));
endmodule

module and_or_xor_func(input op1, input op2, input sel, output out);
	assign out = (sel == 1'b0) ? op1 & op2 : op1 ^ op2;
endmodule
	
module three_bit_counter(input clk_in, input rst_in, output bit_0, output bit_1, output bit_2);
	reg [2:0] counter;
	
	always @(posedge clk_in or negedge rst_in)
	begin
		if (rst_in == 1'b0)
			counter <= 3'b0;
		else
			counter <= counter + 1;
	end 
	
	assign bit_0 = counter[0];
	assign bit_1 = counter[1];
	assign bit_2 = counter[2];
endmodule
