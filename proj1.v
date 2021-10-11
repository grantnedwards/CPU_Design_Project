module proj1(Clk, Rst, MemRW_IO, MemAddr_IO,  MemD_IO);
input Clk;
input Rst;
output MemRW_IO;
output [7:0]MemAddr_IO;
output [15:0]MemD_IO;
wire [7:0]opcode;
wire [7:0]MemAddr;
wire [15:0]MemD;
wire [15:0]MemQ;
wire Zflag, muxPC, muxMAR, muxACC, loadMAR, loadPC, loadACC, loadMDR, loadIR, MemRW;
wire [1:0]opALU;

ctr cont1(Clk, Rst, Zflag, opcode, muxPC, muxMAR, muxACC, loadMAR, loadPC, loadACC, loadMDR, loadIR, opALU, MemRW);
datapath data1(Clk, Rst, muxPC, muxMAR, muxACC, loadMAR, loadPC, loadACC, loadMDR, loadIR, opALU, Zflag, opcode, MemAddr, MemD, MemQ);
ram ram_ins(MemRW, MemD, MemQ, MemAddr);


assign MemAddr_IO = MemAddr;
assign MemD_IO = MemD;
assign MemRW_IO = MemRW;
endmodule


module proj1_tb;
reg Clk; 
reg Rst; 
wire MemRW_IO;
wire [7:0]MemAddr_IO; 
wire [15:0]MemD_IO;

proj1 dut(Clk, Rst, MemRW_IO, MemAddr_IO, MemD_IO);
always 
      #5  Clk =  !Clk; 
		
initial begin
Clk=1'b0;
Rst=1'b1;
$readmemh("memory.list", proj1_tb.dut.ram_ins.memory);
#20 Rst=1'b0;
#435 
$display("Final value\n");
$display("0x000e %d\n",proj1_tb.dut.ram_ins.memory[16'h000e]);
$finish;
end
endmodule