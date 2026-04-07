module lab7(Clock, Sel1, RnW1, Sel2, RnW2, Sel3, RnW3, En, EnAcc, DioExt, Dbus);
	input Clock;  
	input Sel1, Sel2, Sel3, En;
	input RnW1, RnW2, RnW3, EnAcc;
	inout [7:0] DioExt;
	output [7:0] Dbus;
	tri  [7:0] DBus;
	assign Dbus = DBus;
	
	Reg8bit R1(Clock, Sel1, RnW1, DBus);
	Reg8bit R2(Clock, Sel2, RnW2, DBus); 
	Reg8bit R3(Clock, Sel3, RnW3, DBus);
	Accumulator Acc(Clock, En, EnAcc, DBus);
	
	wire in;
	assign in = ((RnW1|RnW2|RnW3) & (~En) & ~(Sel1&Sel2) & ~(Sel1&Sel3) & ~(Sel2&Sel3)) | (~(Sel1|Sel2|Sel3) & En);
	wire out;
	assign out = ~in;
	
	assign DBus[7:0]   = (in) ?  DioExt[7:0] : 8'bZ; 
	assign DioExt[7:0] = (out) ?  DBus[7:0]  : 8'bZ;
endmodule 

module Reg8bit(Clk, Sel, RnW, Dio); 
	input Clk;
	input Sel;
	input RnW;
	inout [7:0]Dio;
	reg   [7:0]FFstore;

	always @(posedge Clk) 
	  if (RnW == 1'b1 && Sel == 1'b1) 
	    FFstore[7:0] <= Dio[7:0]; 
	  else 
	    FFstore[7:0] <= FFstore[7:0]; 
	
	assign Dio[7:0] = (Sel == 1'b1 && RnW == 1'b0) ? FFstore[7:0] : 8'bZ; 
endmodule

module Accumulator(Clk, Sel, RnW, Dio); 
	input Clk;
	input Sel;
	input RnW;
	inout [7:0]Dio;
	reg   [7:0]FFstore;
	wire Reset;
	assign Reset = Sel & RnW; 
	
	always @(posedge Clk) 
		if (RnW == 1'b0 && Sel == 1'b1) 
		    FFstore[7:0] <= FFstore[7:0] + Dio[7:0]; 
		else if (Reset)
		    FFstore[7:0] <= 8'b0;
		else
		    FFstore[7:0] <= FFstore[7:0];
		
	assign Dio[7:0] = (Sel == 1'b1 && RnW == 1'b1) ? FFstore[7:0] : 8'bZ; 
endmodule
