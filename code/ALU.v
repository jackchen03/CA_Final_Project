module ALU(rst_n, alu_in_1, alu_in_2, alu_ctrl, alu_out, zero);
    input rst_n;
    input[31:0] alu_in_1;
    input[31:0] alu_in_2;
    output [31:0] alu_out;
    reg [31:0] alu_out_r;

    input[3:0] alu_ctrl;
    output reg zero;

    assign alu_out = alu_out_r;

    always @(*) begin
        
        if (!rst_n) begin
            zero = 0;
            alu_out_r = 0;
        end
        else begin 
            zero = alu_ctrl[2] & (alu_out_r == 32'b0);
            case(alu_ctrl)
                4'b0000: alu_out_r = alu_in_1 & alu_in_2;
                4'b0001: alu_out_r = alu_in_1 | alu_in_2;
                4'b0010: alu_out_r = alu_in_1 + alu_in_2;
                4'b0110: alu_out_r = alu_in_1 - alu_in_2;

                default: alu_out_r = 0;
            endcase
        end
        
    end    

endmodule