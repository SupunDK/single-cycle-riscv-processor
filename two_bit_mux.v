
module two_bit_mux (input_0,
						input_1, 
						input_2, 
						mux_out,
						select);
						
	parameter N = 32;
	input [N-1:0] input_0;
	input [N-1:0] input_1;
	input [N-1:0] input_2;
	input [1:0] select;
	output [N-1:0] mux_out;
	assign mux_out = select[1] ? (select[0] ? 0 : input_2) : (select[0] ? input_1 : input_0);
endmodule