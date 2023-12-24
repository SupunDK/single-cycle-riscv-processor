// 2 to 1 mux
// n bit mux (mostly n = 32)
// select is 1 bit
// if select = 1 -> in1
// if select = 0 -> in0

module one_bit_mux (in1, in0, out, select);
	parameter N = 32;
	input [N-1:0] in1, in0;
	input select;
	output [N-1:0] out;
	assign	out = select?in1:in0;
	
endmodule