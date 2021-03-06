module ALU_Control(rst_n, I_in, ALUOp, alu_ctrl_out);
    input rst_n;
    input [31:0] I_in;
    input [1:0] ALUOp;
    output reg [3:0] alu_ctrl_out;

    always @(*) begin
        if (!rst_n) begin
            alu_ctrl_out = 0;
        end
        else begin 
            case(ALUOp)
                2'b00: alu_ctrl_out = 4'b0010;
                2'b01: alu_ctrl_out = 4'b0110;
                2'b10: begin 
                    case(I_in[14:12])
                        3'b000: alu_ctrl_out = (I_in[30] & I_in[5]) ? 4'b0110 : 4'b0010;
                        3'b111: alu_ctrl_out = 4'b0000;
                        3'b110: alu_ctrl_out = 4'b0001;
                        3'b010: alu_ctrl_out = 4'b1000; // slti
                        3'b001: alu_ctrl_out = 4'b1001; // slli
                        3'b101: alu_ctrl_out = 4'b1010; // srai
                        default: alu_ctrl_out = 0;
                    endcase
                    
                end                   

                2'b11: alu_ctrl_out = 4'b0010;
                default: alu_ctrl_out = 0;
            endcase
        end
    end

endmodule