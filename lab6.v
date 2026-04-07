// Author: Furkan Selek

module lab6(Clk, D1, D2, Counter);
parameter St0=4'b0000, St1=4'b0001, St2=4'b0010, St3=4'b0011, St4=4'b0100, St5=4'b0101, St6=4'b0110, St7=4'b0111;
input D1, D2, Clk; 
reg [3:0] FSM; 
output reg [2:0] Counter;

always@(posedge Clk)
begin
	case(FSM[3:0])
		St0:
			begin
				if((D1==1)&(D2===0))
					FSM[3:0]<=St1;
				else if((D1==0)&(D2===1))
					FSM[3:0]<=St5;
				else 
					FSM[3:0]<=FSM[3:0];
			end
			
		St1:
			begin
				if((D1==1)&(D2===1))
					FSM[3:0]<=St2;
				else if((D1==0)&(D2===0))
					FSM[3:0]<=St0;
				else
					FSM[3:0]<=FSM[3:0];
			end	
			
		St2:
			begin
				if((D1==0)&(D2===1))
					FSM[3:0]<=St3;
				else if((D1==1)&(D2===0))
					FSM[3:0]<=St1;
				else
					FSM[3:0]<=FSM[3:0];
			end
			
		St3:
			begin
				if((D1==0)&(D2===0))
				begin
					FSM[3:0]<=St0;
					Counter <= Counter + 3'b001;
				end
				else if((D1==1)&(D2===1))
					FSM[3:0]<=St2;
				else
					FSM[3:0]<=FSM[3:0];
			end
			
		St5:
			begin
				if((D1==1)&(D2===1))
					FSM[3:0]<=St6;
				else if((D1==0)&(D2===0))
					FSM[3:0]<=St0;
				else
					FSM[3:0]<=FSM[3:0];
			end
			
		St6:
			begin
				if((D1==1)&(D2===0))
					FSM[3:0]<=St7;
				else if((D1==0)&(D2===1))
					FSM[3:0]<=St5;
				else
					FSM[3:0]<=FSM[3:0];
			end	
		St7:
			begin
				if((D1==0)&(D2===0))
				begin
					FSM[3:0]<=St0;
					Counter <= Counter - 3'b001;
				end
				else if((D1==1)&(D2===1))
					FSM[3:0]<=St6;
				else
					FSM[3:0]<=FSM[3:0];
			end	

			
		default:
				FSM[3:0]<=St0;
	endcase
end


endmodule
