`timescale 1 ns/10 ps
module multDiv(
    clk,
    rst_n,
    valid,
    ready,
    mode,
    in_A,
    in_B,
    out
);

    // Definition of ports
    input         clk, rst_n;
    input         valid, mode; // mode: 0: multu, 1: divu
    input  [31:0] in_A, in_B;
    output [63:0] out;
    output ready;

    // Definition of states
    parameter IDLE = 2'b00;
    parameter MULT = 2'b01;
    parameter DIV  = 2'b10;
    parameter OUT  = 2'b11;

    // Todo: Wire and reg
    reg  [ 1:0] state, state_nxt;
    reg  [ 4:0] counter, counter_nxt;
    reg  [63:0] shreg, shreg_nxt;
    reg  [31:0] alu_in, alu_in_nxt;
    reg  [32:0] alu_out;
    reg ready_c, ready_nxt;


    // Todo 5: wire assignments
    assign out = shreg;
    assign ready = ready_c;
    
    // Combinational always block
    // Todo 1: State machine
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid == 0)
                    state_nxt = IDLE;
                else 
                    if (mode == 0)
                        state_nxt = MULT;
                    else
                        state_nxt = DIV;
            end
            MULT: begin 
                if (counter == 5'd31)
                    state_nxt = OUT;
                else 
                    state_nxt = MULT;
            end

            DIV : begin 
                if (counter == 5'd31)
                    state_nxt = OUT;
                else 
                    state_nxt = DIV;
            end

            OUT : state_nxt = IDLE;
        endcase
    end

    always @(*) begin
        case(state)
            MULT: begin 
                if (counter == 5'd31)
                    ready_nxt = 1;
                else 
                    ready_nxt = 0;
            end

            DIV : begin 
                if (counter == 5'd31)
                    ready_nxt = 1;
                else 
                    ready_nxt = 0;
            end

            default : ready_nxt = 0;
        endcase
    end

    // Todo 2: Counter
    always @(*) begin
        if (state == MULT || state == DIV)
            counter_nxt = counter + 1;
        else
            counter_nxt = 0;
    end
    
    // ALU input
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid) alu_in_nxt = in_B;
                else       alu_in_nxt = 0;
            end
            OUT : alu_in_nxt = 0;
            default: alu_in_nxt = alu_in;
        endcase
    end

    // Todo 3: ALU output
    always @(*) begin
        case(state)
            MULT: begin
                if (shreg[0] == 1)
                    alu_out = alu_in + shreg[63:32];
                else 
                    alu_out = shreg[63:32];
            end
            DIV: begin
                if (shreg[62:31] < alu_in) // <0, do nothing
                    alu_out = {shreg[62:31], 1'b0};
                else
                    alu_out = {shreg[62:31] - alu_in, 1'b1};
            end
            default: alu_out = 33'b0;
        endcase
    end
    
    
    // Todo 4: Shift register
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid) shreg_nxt = {33'b0, in_A};
                else       shreg_nxt = 0;
            end
            MULT: begin
                shreg_nxt[63:31] = alu_out;
                shreg_nxt[30:0] = shreg[31:1];
            end
            DIV: begin
                shreg_nxt[63:32] = alu_out[32:1];
                shreg_nxt[31:1] = shreg[30:0];
                shreg_nxt[0] = alu_out[0];
            end
            default: shreg_nxt = shreg;
        endcase
    end

    // Todo: Sequential always block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= IDLE;
            counter <= 0;
            shreg   <= 0;
            alu_in  <= 0;
            ready_c <= 0;
        end
        else begin
            state   <= state_nxt;
            counter <= counter_nxt;
            shreg   <= shreg_nxt;
            alu_in  <= alu_in_nxt;
            ready_c <= ready_nxt;
        end
    end

endmodule