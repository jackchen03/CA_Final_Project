module Control(rst_n, Con_in, Branch, MemRead, ALUOp, MemWrite, ALUSrc, RegWrite, RegWrite_src, Jal, Jalr);
	input rst_n;
	input [6:0] Con_in;
	output reg Branch;
	output reg MemRead;
	output reg MemWrite;
	output reg ALUSrc;
	output reg RegWrite;
	output reg Jal;
	output reg Jalr;
	output reg [1:0] ALUOp;
	output reg [1:0] RegWrite_src;

	always @(*) begin
		if (!rst_n) begin
            Branch <= 0;
			MemRead <= 0;
			RegWrite_src <= 0;
			MemWrite <= 0;
			ALUSrc <= 0;
			RegWrite <= 0;
			ALUOp <= 0;
			Jal <= 0;
			Jalr <= 0;
        end

        else begin 
	    	ALUSrc = (~Con_in[6] & (~Con_in[4] | ~Con_in[5])) | Con_in[2];
			RegWrite_src[0] = (~Con_in[5] & ~Con_in[4]) | (Con_in[2] & ~Con_in[5]);  // original MemtoReg + auipc
			RegWrite_src[1] = Con_in[2];    // jalr or jal or auipc  (auipc: 11)
			RegWrite = Con_in[4] | ~Con_in[5] | Con_in[2];
			MemRead = ~Con_in[5] ;
			MemWrite = Con_in[5] & ~Con_in[4] & ~Con_in[6];
			Branch = Con_in[6] & ~Con_in[2];
			ALUOp[1] =  Con_in[4] | Con_in[2];
			ALUOp[0] = Con_in[6];
			Jal = Con_in[2] & Con_in[3];
			Jalr = ~Con_in[4] & ~Con_in[3] & Con_in[2];
		end 
    end

endmodule