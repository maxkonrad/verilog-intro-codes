// Author: Furkan Selek

module lab4(input Clk, input Send, input [7:0] PDin, output SCout, output SDout, output [7:0] PDout, output PDready);	
	transmitter transmitter_inst(Clk, Send, PDin, SCout, SDout);
	receiver receiver_inst(SCout, SDout, PDout, PDready);
endmodule

module transmitter(input Clk, input Send, input [7:0] PDin, output SCout, output SDout);
	reg [8:0] SR;
	
	assign SDout = SR[8];
	assign SCout = Clk;
	
	always @(posedge Clk)
	begin
		if (Send == 1'b1)
		begin
			SR[7:0] <= PDin[7:0];
			SR[8] <= 1'b1;
		end
		else
		begin 
			SR[8:1] <= SR[7:0];
			SR[0] <= 1'b0;
		end
	end
endmodule

module receiver(input SCin, input SDin, output [7:0] PDout, output PDready);
    reg [8:0] SR;
    
    assign PDout[7:0] = (SR[8]) ? SR[7:0] : 8'b0;
    assign PDready = SR[8];
    
    always @(posedge SCin)
		begin
			if (SR[8])
				SR[8:0] <= 9'b0;
			else if (~SR[8])
				begin 
					SR[8:1] <= SR[7:0];
					SR[0] <= SDin;
				end
			else
				SR[8:0] <= SR[8:0];
		end
endmodule
