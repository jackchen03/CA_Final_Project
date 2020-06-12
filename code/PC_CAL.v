module PC_CAL(rst_n, pc_in, pc_out, pc_out_adder, jump_signal, jump_addr, read_data);
	input rst_n;
    input  [1:0]  jump_signal;
    input  [31:0] jump_addr;
    input  [31:0] pc_in;
    input  [31:0] read_data;
    output reg [31:0] pc_out;
    output reg [31:0] pc_out_adder;

    always @(*) begin
    	if (!rst_n) begin
            pc_out <= 0;
        end

        else begin
            pc_out_adder = pc_in + jump_addr;
            case (jump_signal) 
                2'b00: pc_out = pc_in+4;
                2'b01: pc_out = pc_in+jump_addr;
                2'b10: pc_out = read_data;
                default: pc_out = 0;
            endcase // jump_signal
        end 
    end
endmodule