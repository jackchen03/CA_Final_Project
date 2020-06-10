module Control(rst_n, Con_in, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
	input rst_n;
	input [2:0] Con_in;
	output reg Branch;
	output reg MemRead;
	output reg MemtoReg;
	output reg MemWrite;
	output reg ALUSrc;
	output reg RegWrite;
	output reg [1:0] ALUOp;

	always @(*) begin
		if (!rst_n) begin
            Branch <= 0;
			MemRead <= 0;
			MemtoReg <= 0;
			MemWrite <= 0;
			ALUSrc <= 0;
			RegWrite <= 0;
			ALUOp <= 0;
        end

        else begin 
	    	ALUSrc = ~Con_in[2] & ~Con_in[0];
			MemtoReg = ~Con_in[1];
			RegWrite = Con_in[0] | ~Con_in[1];
			MemRead = ~Con_in[1];
			MemWrite = Con_in[1] & ~Con_in[0] & ~Con_in[2];
			Branch = Con_in[2];
			ALUOp = {Con_in[2], Con_in[0]};
		end 
    end

endmodule