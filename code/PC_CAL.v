module PC_CAL(rst_n, pc_in, pc_out, jump, jump_addr);
	input rst_n;
    input         jump;
    input  [31:0] jump_addr;
    input  [31:0] pc_in;
    output reg [31:0] pc_out;

    always @(*) begin
    	if (!rst_n) begin
            pc_out <= 0;
        end

        else begin
        	pc_out = jump ? pc_in+jump_addr : pc_in+4;
        end 
    end
endmodule