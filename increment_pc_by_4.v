module increment_pc_by_4 (inp_pc, out_pc);
	input [31:0] inp_pc;
	//input wait_until_next_cycle_flag;
	output [31:0] out_pc;

	assign out_pc = inp_pc + 4;
	
//	assign out_pc = (wait_until_next_cycle_flag == 0) ? out_pc+4 : out_pc; 
	
//	always@*
//		if (wait_until_next_cycle_flag == 0)
//			out_pc <= inp_pc + 4;

endmodule 