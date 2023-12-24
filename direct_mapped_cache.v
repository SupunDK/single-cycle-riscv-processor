module direct_mapped_cache(
	input [31:0]addr,
	input [31:0]data_in_cpu,
	input [1:0]write_mode, // 0:disable, 1:write byte, 2:write half word, 3:write word
	input clk,
	input enable,
	input [127:0]data_in_memory,
	output reg [127:0]data_out_memory,
	output reg [31:0]data_out,
	output reg mem_access_flag,
	output reg wait_until_next_cycle
);

integer i;
integer j;

// cache
reg [127:0]cache[0:3];
reg [3:0]tag_store[0:3];
reg valid_bit_store[0:3]; // 0 - Not valid, 1 - Valid

initial
	begin
	for (i=0; i<4; i=i+1)
		begin
		valid_bit_store[i] = 0;
		wait_until_next_cycle = 0;
		mem_access_flag = 0;
		end
	end

// addr[9:4] -> block address, addr[5:4] -> cache line, addr[9:6] -> tag bits
always@(negedge clk)
	begin
	if (enable == 1)
		begin
		if (write_mode == 0)
		// reading from memory
			begin
			if (valid_bit_store[addr[5:4]] == 1 && tag_store[addr[5:4]] == addr[9:6])
				begin
				// needed read data is in the cache line
				data_out = cache[addr[5:4]][8*addr[3:0] +: 32]; //[31+8*addr[3:0]:8*addr[3:0]];
				wait_until_next_cycle = 0;
				end		
			else
				begin
				// needed read data is not in the cache line 
				mem_access_flag = 1;
				
				if (wait_until_next_cycle == 1)
					begin
					tag_store[addr[5:4]] = addr[9:6]; 
					valid_bit_store[addr[5:4]] = 1;
					cache[addr[5:4]] = data_in_memory;
					
					mem_access_flag = 0;
					wait_until_next_cycle = 0;
					
					data_out = cache[addr[5:4]][8*addr[3:0] +: 32]; //[31+8*addr[3:0]:8*addr[3:0]];
					end
				else
					wait_until_next_cycle = 1;
				
				end
			end
		else 
		// writing to memory
			begin
			if (valid_bit_store[addr[5:4]] == 1 && tag_store[addr[5:4]] == addr[9:6])
			// memory block is in the cache (write through policy)
				begin
				if (write_mode == 1)
					begin
					cache[addr[5:4]][8*addr[3:0] +: 8] = data_in_cpu[7:0]; //[(8*write_mode-1)+8*addr[3:0]:8*addr[3:0]]
					data_out_memory = cache[addr[5:4]];
					
					mem_access_flag = 1;
					
					if (wait_until_next_cycle == 1)
						begin
						mem_access_flag = 0;
						wait_until_next_cycle = 0;
						end
					else
						wait_until_next_cycle = 1;
					end
				else if (write_mode == 2)
					begin
					cache[addr[5:4]][8*addr[3:0] +: 16] = data_in_cpu[15:0];
					data_out_memory = cache[addr[5:4]];
					
					mem_access_flag = 1;
					
					if (wait_until_next_cycle == 1)
						begin
						mem_access_flag = 0;
						wait_until_next_cycle = 0;
						end
					else
						wait_until_next_cycle = 1;
					end
				else if (write_mode == 3)
					begin
					cache[addr[5:4]][8*addr[3:0] +: 32] = data_in_cpu; //[31+8*addr[3:0]:8*addr[3:0]]
					data_out_memory = cache[addr[5:4]];
					
					mem_access_flag = 1;
					
					if (wait_until_next_cycle == 1)
						begin
						mem_access_flag = 0;
						wait_until_next_cycle = 0;
						end
					else
						wait_until_next_cycle = 1;
					end
				end
			else
			// memory block is not in the cache
				begin
				if (write_mode == 1)
					begin
					data_out_memory[8*addr[3:0] +: 8] = data_in_cpu[8:0];
					mem_access_flag = 1;
					
					if (wait_until_next_cycle == 1)
						begin
						cache[addr[5:4]] = data_in_memory;
						tag_store[addr[5:4]] = addr[9:6];
						valid_bit_store[addr[5:4]] = 1;
						
						mem_access_flag = 0;
						wait_until_next_cycle = 0;
						end
					else
						wait_until_next_cycle = 1;
					end
				else if (write_mode == 2)
					begin
					data_out_memory[8*addr[3:0] +: 16] = data_in_cpu[15:0];
					mem_access_flag = 1;
					
					if (wait_until_next_cycle == 1)
						begin
						cache[addr[5:4]] = data_in_memory;
						tag_store[addr[5:4]] = addr[9:6];
						valid_bit_store[addr[5:4]] = 1;
						
						mem_access_flag = 0;
						wait_until_next_cycle = 0;
						end
					else
						wait_until_next_cycle = 1;
					end
				else if (write_mode == 3)
					begin
					data_out_memory[8*addr[3:0] +: 32] = data_in_cpu;
					mem_access_flag = 1;
					
					if (wait_until_next_cycle == 1)
						begin
						cache[addr[5:4]] = data_in_memory;
						tag_store[addr[5:4]] = addr[9:6];
						valid_bit_store[addr[5:4]] = 1;
						
						mem_access_flag = 0;
						wait_until_next_cycle = 0;
						end
					else
						wait_until_next_cycle = 1;
					end
				end
			end
		end
	end

endmodule 