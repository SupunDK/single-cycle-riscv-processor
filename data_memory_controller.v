module data_memory_controller(
	input [31:0] addr, 
	input [31:0] data_in, 
	input [1:0]write_mode, // 0:disable, 1:write byte, 2:write half word, 3:write word 
	input clk,
	input enable,
	output [31:0] data_out,
	output wait_until_next_cycle
);

integer i;

wire mem_access_flag;

wire mem_write;
assign mem_write = ( write_mode[1] | write_mode[0] ) && mem_access_flag;

reg [15:0]byteena;
wire [127:0]memory_data_out;
wire [127:0]memory_data_in;

// cache 
direct_mapped_cache_with_victim cache(
	.addr(addr),
	.data_in_cpu(data_in),
	.write_mode(write_mode),
	.clk(clk),
	.enable(enable),
	.data_in_memory(memory_data_out),
	.data_out_memory(memory_data_in),
	.data_out(data_out),
	.mem_access_flag(mem_access_flag),
	.wait_until_next_cycle(wait_until_next_cycle)
);

// memory
data_memory Data_Memory(
	.address(addr[9:4]),
	.byteena(byteena),
	.clock(clk),
	.data(memory_data_in),
	.wren(mem_write),
	.q(memory_data_out)
);

initial 
begin
	byteena <= 0;
end

always@(negedge clk) begin
	for (i=0; i<2**4; i=i+1) begin 
		if (write_mode == 0)
			byteena <= 16'hffff;
		else if (write_mode == 1) 
		begin
			if (i==addr[3:0])
				byteena[i] <= 1;
			else
				byteena[i] <= 0;
		end
		else if (write_mode == 2)
		begin
			if (i==addr[3:0] || i==addr[3:0]+1)
				byteena[i] <= 1;
			else
				byteena[i] <= 0;
		end
		else if (write_mode == 3)
		begin
			if (i==addr[3:0] || i==addr[3:0]+1 || i==addr[3:0]+2 || i==addr[3:0]+3)
				byteena[i] <= 1;
			else
				byteena[i] <= 0;
		end
		else
			byteena <= 0;
	end
end	

endmodule 