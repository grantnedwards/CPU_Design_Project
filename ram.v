module ram(input We, input [15:0]D, output reg [15:0]Q, input [7:0]Addr);
reg [15:0] memory[0:255];

always@(Addr or We or D)
begin
if(We)
	begin
	memory[Addr] <= D;
	end  
else
	begin
  	Q <= memory[Addr];
	end
end
endmodule
