module RegWrite_Mux(rst_n, ctrl, pc, auipc_rdata, read_data, alu_result, regW_data);
	input rst_n;
    input  [1:0]  ctrl;
    input  [31:0] pc;
    input  [31:0] auipc_rdata;
    input  [31:0] read_data;
    input  [31:0] alu_result;
    output reg [31:0] regW_data;

    always @(*) begin
    	if (!rst_n) begin
            regW_data <= 0;
        end

        else begin
            case (ctrl) 
                2'b00: regW_data = alu_result;
                2'b01: regW_data = read_data;
                2'b10: regW_data = pc +4;
                2'b11: regW_data = auipc_rdata;
                default: regW_data = 0;
            endcase // ctrl
        end 
    end
endmodule