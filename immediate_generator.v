module immediate_generator (instruction_part, select, immediate);
	input [24:0] instruction_part;
	input [2:0] select;
	output reg [31:0] immediate;
	
	always @*
	begin
		case(select)
			// imm_r
			3'b000 : immediate <= 0;
			
			// imm_i
			3'b001 : 
				begin
					immediate[11:0] <= instruction_part[24:13];
					immediate[31:12] <= instruction_part[24]?20'b1111_1111_1111_1111_1111:20'b0;
				end
			
			// imm_s
			3'b010 :
				begin
					immediate[4:0] <= instruction_part[4:0];
					immediate[11:5] <= instruction_part[24:18];
					immediate[31:12] <= instruction_part[24]?20'b1111_1111_1111_1111_1111:20'b0;
				end
			
			// imm_b
			3'b011 :
				begin
					immediate[0] <= 0;
					immediate[4:1] <= instruction_part[4:1];
					immediate[10:5] <= instruction_part[23:18];
					immediate[11] <= instruction_part[0];
					immediate[31:12] <= instruction_part[24]?20'b1111_1111_1111_1111_1111:20'b0;
				end
			
			// imm_u
			3'b100 :
				begin
					immediate[11:0] <= 0;
					immediate[31:12] <= instruction_part[24:5];
				end
				
			
			// imm_j
			3'b101 :
				begin
					immediate[0] <= 0;
					immediate[10:1] <= instruction_part[23:14];
					immediate[11] <= instruction_part[13];
					immediate[19:12] <= instruction_part[12:5];
					immediate[31:20] <= instruction_part[24]?12'b1111_1111_1111:12'b0;
				end
			
			// shamt
			3'b110 :
				begin
					immediate[4:0] <= instruction_part[17:13];
					immediate[31:5] <= 0;
				end
			
			default: immediate <= 0;
			
		endcase
	end
endmodule