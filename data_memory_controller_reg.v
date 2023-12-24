module data_memory_controller(
	input clk,
	input [31:0] addr, 
	input [31:0] data_in, 
	input mem_read,
	input [1:0]write_mode, // 0:disable, 1:write byte, 2:write half word, 3:write word 
	output reg [31:0] data_out
);

//parameters: data memory
parameter mem_unit_size = 8;
parameter num_units = 16;
parameter num_cache_lines = 4;

reg [mem_unit_size-1:0] data_memory[0:num_units];
wire mem_write;
assign mem_write = write_mode[1] | write_mode[0];

//initiate actions of this block if there are any changes in addr, data_in, mem_read or mem_write
//always@(addr or data_in or mem_read or mem_write or write_mode) 
always@(negedge clk) 
begin
	if (mem_read == 1 && mem_write == 0) 
	//goes into the memory read mode
	begin
		//getting data corresponding to the Little Endian format
		data_out = {data_memory[addr], data_memory[addr+1], data_memory[addr+2], data_memory[addr+3]};
	end
	else if (mem_read == 0 && mem_write == 1)
	//goes into the memory write mode
	begin
		//saving data in the Litte Endian format
		case(write_mode)
			2'b11: begin
						data_memory[addr] = data_in[31:31-7];
						data_memory[addr+1] = data_in[31-8:31-15];
						data_memory[addr+2] = data_in[31-16:31-23];
						data_memory[addr+3] = data_in[31-24:31-31];
					end
			2'b10: begin
						data_memory[addr] = data_in[15:8];
						data_memory[addr+1] = data_in[7:0];
					end
			2'b01: begin
						data_memory[addr] = data_in[7:0];
					end
		endcase
	end
end


endmodule 