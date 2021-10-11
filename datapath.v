module datapath(Clk, Rst, muxPC, muxMAR, muxACC, loadMAR, loadPC, loadACC, loadMDR, loadIR, opALU, Zflag, opcode, MemAddr, MemD, MemQ);
input Clk;
input  Rst;
input  muxPC;
input  muxMAR;
input  muxACC;
input  loadMAR;
input  loadPC;
input  loadACC;
input  loadMDR;
input  loadIR;
input [1:0]opALU; 

output reg Zflag;
output reg[7:0]opcode;
output reg[7:0]MemAddr;
output reg[15:0]MemD;
input	[15:0]MemQ;

reg  [7:0]PC_next;
reg  [15:0]IR_next;  
reg  [15:0]ACC_next;  
reg  [15:0]MDR_next;  
reg  [7:0]MAR_next;  
reg Zflag_next;

wire  [7:0]PC_reg;
wire  [15:0]IR_reg;  
wire  [15:0]ACC_reg;  
wire  [15:0]MDR_reg;  
wire  [7:0]MAR_reg;  
wire Zflag_reg;

wire  [15:0]ALU_out;  

registers m1(Clk, Rst, PC_reg, PC_next, IR_reg, IR_next, ACC_reg, ACC_next, MDR_reg, MDR_next, MAR_reg, MAR_next, Zflag_reg, Zflag_next);
alu m2(ACC_reg, MDR_reg, opALU, ALU_out, Clk, Rst);


always @(*)
begin
//==============================================================
if(loadPC)
	begin
	PC_next = muxPC ? IR_reg[15:8] : (1 + PC_reg);
	end
else
	begin
	PC_next = PC_reg;
	end
//==============================================================
if(loadIR)
	begin
	IR_next = MDR_reg;
	end
else
	begin
	IR_next = IR_reg;
	end
//==============================================================
if(loadACC)
	begin
	ACC_next = muxACC ? MDR_reg : ALU_out; 
	end
else
	begin
	ACC_next = ACC_reg;
	end
//==============================================================
if(loadMDR)
	begin
	MDR_next = MemQ;
	end
else
	begin
	MDR_next = MDR_reg;
	end
//==============================================================
if(loadMAR)
	begin
	MAR_next = muxMAR ? PC_reg : IR_reg[15:8];		// Possibly switch PC_reg and IR_reg later?
	end
else
	begin
	MAR_next = MAR_reg;
	end
//==============================================================
if(ACC_reg == 0)						// Possible errors in this logic
	begin
	Zflag_next <= 0;
	end
else
	begin
	Zflag_next <= 1;
	end
//==============================================================


Zflag = (ACC_reg == 0);
opcode=IR_reg[7:0];
MemAddr = MAR_reg;
MemD = ACC_reg;

end
endmodule