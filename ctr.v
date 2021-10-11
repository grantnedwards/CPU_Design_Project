module ctr(Clk, Rst, Zflag, opcode, muxPC, muxMAR, muxACC, loadMAR, loadPC, loadACC, loadMDR, loadIR, opALU, MemRW);

input Clk;
input Rst;
input Zflag;
input [7:0]opcode;

output reg muxPC;
output reg muxMAR;
output reg muxACC;
output reg loadMAR;
output reg loadPC;
output reg loadACC;
output reg loadMDR;
output reg loadIR;
output reg [1:0]opALU;
output reg MemRW;


reg [3:0] cur_state;
reg [3:0] next_state;

parameter op_add=8'b001;
parameter op_or= 8'b010;
parameter op_jump=8'b011;
parameter op_jumpz=8'b100;
parameter op_load=8'b101;
parameter op_store=8'b110;
parameter op_mull=8'b1001;
parameter op_neg=8'b1010;


always @(posedge Clk)
begin
	if(Rst)
		begin
		cur_state = 4'b0000;
		end
	else
		begin
		cur_state = next_state;
		end
end





always@(*) //change if errors persist
begin
	case(cur_state)
	4'b0000:			//Fetch 1
		next_state = 4'b0001;
	4'b0001:			//Fetch 2
		next_state = 4'b0010;
	4'b0010:			//Fetch 3
		next_state = 4'b0011;
	4'b0011:			//Decode
		begin
		case(opcode)
		op_add:
			next_state = 4'b0100;
		op_or:
			next_state = 4'b0110;
		op_jump:
			next_state = 4'b1111;
		op_jumpz:
			begin
			if(Zflag)
				begin
				next_state = 4'b1111;
				end
			else
				begin
				next_state = 4'b0001;
				end
			end
		op_load:
			next_state = 4'b1100;
		op_store:
			next_state = 4'b1110;
		op_mull:
			next_state = 4'b1000;
		op_neg:
			next_state = 4'b1010;
		endcase
		end
		
	4'b0100:			//ExecADD 1
		next_state = 4'b0101;
	4'b0101:			//ExecADD 2
		next_state = 4'b0000;
	4'b0110:			//ExecOR 1
		next_state = 4'b0111;
	4'b0111:			//ExecOR 2
		next_state = 4'b0000;
	4'b1000:			//ExecMULL 1
		next_state = 4'b1001;
	4'b1001:			//ExecMULL 2
		next_state = 4'b0000;
	4'b1010:			//ExecNEG 1
		next_state = 4'b1011;
	4'b1011:			//ExecNEG 2
		next_state = 4'b0000;
	4'b1100:			//ExecLoad 1
		next_state = 4'b1101;
	4'b1101:			//ExecLoad 2
		next_state = 4'b0000;
	4'b1110:			//ExecStore
		next_state = 4'b0000;
	4'b1111:			//ExecJump
		next_state = 4'b0000;
	endcase
end


always@(cur_state)
begin

muxPC = 0; 
muxMAR = 0; 
muxACC = 0; 
loadMAR = 0; 
loadPC = 0; 
loadACC = 0; 
loadMDR = 0; 
loadIR = 0; 
opALU = 0; 
MemRW = 0; 

case(cur_state)
	4'b0000:		//Fetch 1
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 1; 
		loadPC = 1; 
		loadACC = 0; 
		loadMDR = 0; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b0001:		//Fetch 2
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 0; 
		loadMDR = 1; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b0010:		//Fetch 3
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 0; 
		loadMDR = 0; 
		loadIR = 1; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b0011:		//Decode
		begin
		muxPC = 0; 
		muxMAR = 1; 
		muxACC = 0; 
		loadMAR = 1; 
		loadPC = 0; 
		loadACC = 0; 
		loadMDR = 0; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b0100:		//ExecADD 1
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 0; 
		loadMDR = 1; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b0101:		//ExecADD 2
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 1; 
		loadMDR = 0; 
		loadIR = 0; 
		opALU = 1; 
		MemRW = 0; 
		end
	4'b0110:		//ExecOR 1
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 0; 
		loadMDR = 1; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b0111:		//ExecOR 2
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 1; 
		loadMDR = 0; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b1000:		//ExecMULL 1
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 0; 
		loadMDR = 1; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b1001:		//ExecMULL 2
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 1; 
		loadMDR = 0; 
		loadIR = 0; 
		opALU = 2; 
		MemRW = 0; 
		end
	4'b1010:		//ExecNEG 1
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 0; 
		loadMDR = 1; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b1011:		//ExecNEG 2
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 1; 
		loadMDR = 0; 
		loadIR = 0; 
		opALU = 3; 
		MemRW = 0; 
		end
	4'b1100:		//ExecLoad 1
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 0; 
		loadMDR = 1; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b1101:		//ExecLoad 2
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 1; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 1; 
		loadMDR = 0; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	4'b1110:		//ExecStore
		begin
		muxPC = 0; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 0; 
		loadACC = 0; 
		loadMDR = 0; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 1; 
		end
	4'b1111:		//ExecJump
		begin
		muxPC = 1; 
		muxMAR = 0; 
		muxACC = 0; 
		loadMAR = 0; 
		loadPC = 1; 
		loadACC = 0; 
		loadMDR = 0; 
		loadIR = 0; 
		opALU = 0; 
		MemRW = 0; 
		end
	endcase
end
endmodule

