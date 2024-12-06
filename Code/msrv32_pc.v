module msrv32_pc (
    input wire rst_in,
    input wire [1:0] pc_src_in,
    input wire [31:0] epc_in,
    input wire [31:0] trap_address_in,
    input wire branch_taken_in,
    input wire ahb_ready_in,
    input wire [30:0] iaddr_in,
    input wire [31:0] pc_in,
    output wire [31:0] iaddr_out,
    output wire [31:0] pc_plus_4_out,
    output wire misaligned_instr_logic_out,
    output wire [31:0] pc_mux_out
);

    parameter BOOT_ADDRESS = 32'h00000000; 

    wire [31:0] pc_plus_4;
    wire [31:0] next_pc;
    wire [31:0] branch_target;
    reg [31:0] pc_next;
    
    assign pc_plus_4 = pc_in + 32'h00000004;
    assign branch_target = {iaddr_in, 1'b0};    
    assign next_pc = branch_taken_in ? branch_target : pc_plus_4;

    always @(*) begin
        case(pc_src_in)
            2'b00: pc_next = BOOT_ADDRESS;
            2'b01: pc_next = epc_in;
            2'b10: pc_next = trap_address_in;
            2'b11: pc_next = next_pc;
            default: pc_next = next_pc;
        endcase
    end

    assign iaddr_out = (ahb_ready_in) ? pc_next : 32'b0;
    assign pc_plus_4_out = pc_plus_4;
    assign pc_mux_out = pc_next;
    assign misaligned_instr_logic_out = (branch_taken_in && (next_pc[1:0] != 2'b00));

endmodule

