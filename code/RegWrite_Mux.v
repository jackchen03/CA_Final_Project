// `timescale 1 ns/10 ps
module RegWrite_Mux(rst_n, ctrl, pc, read_data, alu_result, regW_data, mul_ready, mul_out);
	input rst_n;
    input  [1:0]  ctrl;
    input  [31:0] pc;
    input  [31:0] read_data;
    input  [31:0] alu_result;

    input mul_ready;
    input [31:0] mul_out;
    output reg [31:0] regW_data;

    always @(*) begin
    	if (!rst_n) begin
            regW_data = 0;
        end

        else begin
            if (mul_ready) begin 
                regW_data = mul_out;
            end

            else begin 
                case (ctrl) 
                    2'b00: regW_data = alu_result;
                    2'b01: regW_data = read_data;
                    2'b10: regW_data = pc +4;
                    default: regW_data = 0;
                endcase // ctrl
            end
                
        end 
    end
endmodule