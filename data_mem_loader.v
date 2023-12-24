module data_mem_loader(memory_cell, select, data);
	input [31:0] memory_cell;
	input [2:0] select;
	output reg [31:0] data;
	
	always @*
	begin
	
		case(select)
			// 8 bit unsigned
			3'b000 :
				begin
					data[7:0] <= memory_cell[31:24];
					data[31:8] <= 0;
				end
			
			// 16 bit unsigned
			3'b001 :
				begin
					data[15:0] <= memory_cell[31:16];
					data[31:16] <= 0;
				end
			
			// 32 bit unsigned
			3'b010 : data <= memory_cell;
			
			// 8 bit signed
			3'b011 :
				begin
					data[7:0] <= memory_cell[31:24];
					data[31:8] <= memory_cell[31]?24'b1111_1111_1111_1111_1111_1111:24'b0;
				end
			
			// 16 bit signed
			3'b100 :
				begin
					data[15:0] <= memory_cell[31:16];
					data[31:16] <= memory_cell[31]?16'b1111_1111_1111_1111:16'b0;
				end
			
			default : data <= 0;
			
		endcase
	end

endmodule

