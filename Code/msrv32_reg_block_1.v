module msrv32_reg_block_1 (
    input wire ms_riscv32_mp_clk_in,
    input wire ms_riscv32_mp_rst_in,
    input wire [31:0] pc_mux_in,
    output reg [31:0] pc_out
);

    always @(posedge ms_riscv32_mp_clk_in or posedge ms_riscv32_mp_rst_in) begin
        if (ms_riscv32_mp_rst_in) begin
            pc_out <= 32'b0;
        end else begin
            pc_out <= pc_mux_in;
        end
    end

endmodule
