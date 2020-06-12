// Your code
`include "ALU_Control.v"
`include "ALU.v"
`include "Control.v"
`include "Imm_Gen.v"
`include "PC_CAL.v"

module CHIP(clk,
            rst_n,
            // For mem_D
            mem_wen_D,
            mem_addr_D,
            mem_wdata_D,
            mem_rdata_D,
            // For mem_I
            mem_addr_I,
            mem_rdata_I);

    input         clk, rst_n ;
    // For mem_D
    output        mem_wen_D  ;
    output [31:0] mem_addr_D ;
    output [31:0] mem_wdata_D;
    input  [31:0] mem_rdata_D;
    // For mem_I
    output [31:0] mem_addr_I ;
    input  [31:0] mem_rdata_I;
    
    //---------------------------------------//
    // Do not modify this part!!!            //
    // Exception: You may change wire to reg //
    reg    [31:0] PC          ;              //
    wire   [31:0] PC_nxt      ;              //
    wire          regWrite    ;              //
    wire   [ 4:0] rs1, rs2, rd;              //
    wire   [31:0] rs1_data    ;              //
    wire   [31:0] rs2_data    ;              //
    wire   [31:0] rd_data     ;              //
    //---------------------------------------//

    // Todo: other wire/reg
    // control signal
    wire branch, memRead, memWrite, aluSrc2_imm;  // for control,   memRead currently not used
    wire [1:0] aluOp; // check aluOp order, I[6] or I[4] first
    wire [1:0] regWrite_src;
    
    // jump signal and addr
    wire jal;  // jal_family
    wire jalr;  // jump_signal[1]
    wire jump;  // jump_signal[0]
    wire [31:0] jump_addr;
    wire [31:0] imm_addr; // generated immediate
    wire [31:0] auipc_rdata;

    // for allu
    wire alu_equal;  // decide to branch or not (output of ALU)
    wire [31:0] alu_in_2; // second input for alu
    wire [31:0] alu_out;
    wire [3:0] alu_ctrl_out; //output of ALU Control

    // for auipc
    wire imm_no_shift;

    //---------------------------------------//
    // Do not modify this part!!!            //
    reg_file reg0(                           //
        .clk(clk),                           //
        .rst_n(rst_n),                       //
        .wen(regWrite),                      //
        .a1(rs1),                            //
        .a2(rs2),                            //
        .aw(rd),                             //
        .d(rd_data),                         //
        .q1(rs1_data),                       //
        .q2(rs2_data));                      //
    //---------------------------------------//
    
    // Todo: any combinational/sequential circuit

    assign rs1 = mem_rdata_I[19:15];
    assign rs2 = mem_rdata_I[24:20];
    assign rd = mem_rdata_I[11:7];
    
    assign jump = (alu_equal & branch) | jal;
    assign jump_addr = imm_no_shift ? imm_addr : imm_addr << 1;

    assign alu_in_2 = aluSrc2_imm ? imm_addr : rs2_data;

    // output
    assign mem_wen_D = memWrite;
    assign mem_addr_I = PC;
    assign mem_addr_D = alu_out;
    assign mem_wdata_D = rs2_data;

    PC_CAL pc_cal(
        .rst_n(rst_n),
        .pc_in(PC), 
        .pc_out(PC_nxt), 
        .pc_out_adder(auipc_rdata),
        .jump_signal({jalr, jump}), 
        .jump_addr(jump_addr),
        .read_data(alu_out)
    );

    Control control(
        .rst_n(rst_n),
        .Con_in(mem_rdata_I[6:0]), 
        .Branch(branch), 
        .MemRead(memRead), 
        .RegWrite_src(regWrite_src), 
        .ALUOp(aluOp), 
        .MemWrite(memWrite), 
        .ALUSrc(aluSrc2_imm), 
        .RegWrite(regWrite),
        .Jal(jal),
        .Jalr(jalr)
    );

    Imm_Gen imm_gen(
        .rst_n(rst_n),
        .I_in(mem_rdata_I), 
        .imm_out(imm_addr),
        .no_shift(imm_no_shift)
    );

    ALU_Control alu_ctrl(
        .rst_n(rst_n),
        .I_in(mem_rdata_I), 
        .ALUOp(aluOp), 
        .alu_ctrl_out(alu_ctrl_out)
    );

    ALU alu(
        .rst_n(rst_n),
        .alu_in_1(rs1_data), 
        .alu_in_2(alu_in_2),
        .alu_ctrl(alu_ctrl_out),
        .alu_out(alu_out), 
        .zero(alu_equal)
    );

    RegWrite_Mux reg_mux(
        .rst_n(rst_n), 
        .ctrl(regWrite_src), 
        .pc(PC),
        .auipc_rdata(auipc_rdata), 
        .read_data(mem_rdata_D), 
        .alu_result(alu_out), 
        .regW_data(rd_data)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PC <= 32'h00010000; // Do not modify this value!!!
            
        end
        else begin
            PC <= PC_nxt;
            
        end
    end
endmodule

module reg_file(clk, rst_n, wen, a1, a2, aw, d, q1, q2);
   
    parameter BITS = 32;
    parameter word_depth = 32;
    parameter addr_width = 5; // 2^addr_width >= word_depth
    
    input clk, rst_n, wen; // wen: 0:read | 1:write
    input [BITS-1:0] d;
    input [addr_width-1:0] a1, a2, aw;

    output [BITS-1:0] q1, q2;

    reg [BITS-1:0] mem [0:word_depth-1];
    reg [BITS-1:0] mem_nxt [0:word_depth-1];

    integer i;

    assign q1 = mem[a1];
    assign q2 = mem[a2];

    always @(*) begin
        for (i=0; i<word_depth; i=i+1)
            mem_nxt[i] = (wen && (aw == i)) ? d : mem[i];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem[0] <= 0;
            for (i=1; i<word_depth; i=i+1) begin
                case(i)
                    32'd2: mem[i] <= 32'hbffffff0;
                    32'd3: mem[i] <= 32'h10008000;
                    default: mem[i] <= 32'h0;
                endcase
            end
        end
        else begin
            mem[0] <= 0;
            for (i=1; i<word_depth; i=i+1)
                mem[i] <= mem_nxt[i];
        end       
    end
endmodule

// module multDiv(clk, rst_n, valid, ready, mode, in_A, in_B, out);
//     // Todo: your HW3

// endmodule