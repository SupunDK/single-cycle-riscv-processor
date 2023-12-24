//module instruction_memory (program_counter, instruction_out, instruction_in, write_flag);
//	parameter N = 32;
//	parameter H = 16;
//	input [N-1:0] instruction_in;
//	input [N-1:0] program_counter;
//	input write_flag;  //  1- write
//	output reg [31:0] instruction_out;
//	
//	reg [31:0] memory [0:H-1];
//	
//	always @*
//	begin
//		if (write_flag)
//			memory[program_counter] = instruction_in;
//			
//		instruction_out = memory[program_counter];
//	end
//	
//
//endmodule


module instruction_memory (program_counter, instruction_out);//, instruction_in);//, write_flag);
	parameter N = 32;
	parameter H = 16;
//	input [N-1:0] instruction_in;
	input [N-1:0] program_counter;
//	input write_flag;  //  1- write
	output reg [31:0] instruction_out;
	
	reg [31:0] memory [0:H-1];
	
	initial
		begin//             f7     rs2  rs1   f3   rd   opcode
 		memory[0] = 32'b 0000000_00001_00000_110_00001_0010011;//0 - ori
		memory[1] = 32'b 0000000_00011_00000_110_00010_0010011;//1 - ori
		memory[2] = 32'b 0000000_00010_00001_000_00011_0110011;//2	- add
		memory[3] = 32'b 1111111_11101_00000_110_00100_0010011;//3 - ori
		memory[4] = 32'b 0000000_01010_00000_110_00101_0010011;//4	- ori
		memory[5] = 32'b 0100000_00010_00001_000_00110_0110011;//5	- sub
		memory[6] = 32'b 0000000_00000_00000_000_00000_0001111;//5	- fence
		memory[7] = 32'b 0000000_00110_00000_010_00100_0100011;//6 - sw
		memory[8] = 32'b 0000000_00100_00000_001_01000_0100011;//7	- sh
		memory[9] = 32'b 0000000_01000_00000_010_00111_0000011;//8	- lw
		memory[10] = 32'b 0000000_00001_00011_000_00100_0110011;//9 - add
		memory[11] = 32'b 0000000_00100_00000_000_00011_0110011;//10 - add
		memory[12] = 32'b 1111111_00101_00011_100_10001_1100011;//11 - blt
		memory[13] = 32'b 0000000_01000_00000_001_00011_0000011;//12 -	lh
		memory[14] = 32'h 6f;//0 - ori
		
		end
	
	
	always @*
	begin
//		if (write_flag)
//			//memory[program_counter] = instruction_in;
//			memory[program_counter[31:2]][8*program_counter[1:0] +: 32] = instruction_in;
			
		//instruction_out = memory[program_counter];
		instruction_out = memory[program_counter[31:2]][8*program_counter[1:0] +: 32];
	end
	

endmodule