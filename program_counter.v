// 32 bit register
// written at the end of every clock cycle

module program_counter (clk, pc_in, wait_until_next_cycle_flag, pc_out);
	parameter N = 32;
	input clk;
	input [N-1:0] pc_in;
	input wait_until_next_cycle_flag;
	output [N-1:0] pc_out;
	reg [N-1:0] pc_out;
	
	initial 
		begin
			pc_out <= 0;
		end
	
	always @ (posedge clk)
	begin
		if (wait_until_next_cycle_flag == 0)
			pc_out<=pc_in;
	end
	
	
endmodule