module Imm_Gen(rst_n, I_in, imm_out, no_shift);
	input rst_n;
	input [31:0] I_in;
	output reg [31:0] imm_out;
	output reg no_shift;

	always @(*) begin
		if (!rst_n) begin
            imm_out = 0;
        end
			
		else begin 
			case (I_in[6:5])
				2'b00: begin
					imm_out = I_in[2] ? (I_in & {20'b1, 12'b0}) : { {20{I_in[31]}}, I_in[31:20]};  // 1: auipc, 0: load
				end
					
				2'b01: imm_out = { {20{I_in[31]}}, I_in[31:25], I_in[11:7]};
				2'b10: imm_out = { {20{I_in[31]}}, I_in[31], I_in[7], I_in[30:25], I_in[11:8]};
				2'b11: begin
					case (I_in[3:2]) 
						2'b00: imm_out = { {20{I_in[31]}}, I_in[31], I_in[7], I_in[30:25], I_in[11:8]};  	// bqe
						2'b01: imm_out = { {20{I_in[31]}}, I_in[31:20]};  									// jalr
						2'b11: imm_out = { {12{I_in[31]}}, I_in[31], I_in[19:12], I_in[20], I_in[30:21]};	// jal
					endcase
				end 
				default : imm_out = 0;
			endcase

			no_shift = (I_in[6:2] == 5'b00101) ? 1'b1 : 1'b0;  // auipc, no shift
		end
	end

 
endmodule