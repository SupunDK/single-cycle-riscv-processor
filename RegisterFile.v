module RegisterFile(
	input[4:0] input_register_1_select, 
	input[4:0] input_register_2_select, 
	input[4:0] output_register_select, 
	input reg_write, 
	input[31:0] data, 
	output reg[31:0] register1, 
	output reg[31:0] register2
	); 

	reg [31:0] register_list[0:15];

	always@* begin
		register1 <= register_list[input_register_1_select];
		register2 <= register_list[input_register_2_select];

		if (reg_write == 1 & output_register_select!=0) 
			register_list[output_register_select] <= data;
		
		
		register_list[0] <= 32'b00000000_00000000_00000000_00000000;

	end

endmodule