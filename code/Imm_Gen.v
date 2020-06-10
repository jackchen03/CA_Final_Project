module Imm_Gen(rst_n, I_in, imm_out);
	input rst_n;
	input [31:0] I_in;
	output reg [31:0] imm_out;

	always @(*) begin
		if (!rst_n) begin
            imm_out = 0;
        end
			
		else begin 
			case (I_in[6:5])
				2'b00: imm_out = { {20{I_in[31]}}, I_in[31:20]};
				2'b01: imm_out = { {20{I_in[31]}}, I_in[31:25], I_in[11:7]};
				2'b10, 2'b11: imm_out = { {20{I_in[31]}}, I_in[31], I_in[7], I_in[30:25], I_in[11:8]};

				default : imm_out = 0;
			endcase
		end
	end

endmodule