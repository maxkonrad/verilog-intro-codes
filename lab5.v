// Author: Furkan Selek

module lab5(input Clk, input Send, input [7:0] PDin, output SCout, output SDout, output [7:0] PDout, output PDready, output ParErr);	
	transmitter transmitter_inst(Clk, Send, PDin, SCout, SDout);
	receiver receiver_inst(SCout, SDout, PDout, PDready, ParErr);
endmodule

module transmitter(input Clk, input Send, input [7:0] PDin, output SCout, output SDout);
	reg [9:0] SR;
	
	assign SDout = SR[9];
	assign SCout = Clk;
	
	reg Cshift;
	reg Chold;
	
	always @(posedge Clk)
	begin
		if (Cshift == 1'b1)
		begin
			SR[9] <= 1'b1;
			SR[8:1] <= PDin[7:0];
			SR[0] <= PDin[7] + PDin[6] + PDin[5] + PDin[4] + PDin[3] + PDin[2] + PDin[1] + PDin[0];
		end
		else
		begin 
			SR[9:1] <= SR[8:0];
			SR[0] <= 1'b0;
		end
	Chold <= Cshift;
	end

	always @(posedge Send or posedge Chold)
		begin
			if (Chold)
				Cshift <= 1'b0;
			else
				Cshift <= 1'b1;
		end
endmodule

module receiver(input SCin, input SDin, output [7:0] PDout, output PDready, output reg ParErr);
	reg [9:0] SR;
	reg Chold;
	reg Par;
    
    always @(posedge SCin)
		Chold <= SDin;
		
		assign PDout[7:0] = (SR[9]) ? SR[8:1] : 8'b0;
		assign PDready = SR[9];
    
    always @(posedge SCin)
		begin
			if (SR[9])
			begin
				Par <= 1'b1;
				SR[9:0] <= 10'b0;
			end
			else
				begin
					SR[0] <= Chold;
					SR[9:1] <= SR[8:0];
				end
		end
always @(posedge PDready)
	begin
		ParErr <= PDout[0] + PDout[1] + PDout[2] + PDout[3] + PDout[4] + PDout[5] + PDout[6] + PDout[7] + Par;
	end
endmodule
