module SingleCycleProcessor2(
	input clock, 
	//input [31:0] overwrite_pc,
	//input	[31:0] write_inst,
	//output [31:0]pc_out,
	//output [31:0]inst, 
	//output [31:0]alu_out,
	//output [31:0]WBSel_mux_out,
	output led
	);

//outputs of Control Signal Unit
wire [31:0]inst; 
wire[2:0] ImmSel;	//3
wire RegWEn;		//1
wire BrUn;			//1
wire PCSel; 		//1
wire Asel;			//1
wire BSel;			//1
wire[3:0] ALUSel;	//4
wire[1:0] MemRW;	//2
wire[2:0] SWSel;	//3
wire[1:0] WBSel;
wire data_mem_enable;
wire [1:0]data_mem_write_mode;

//outputs of PCSel mux
wire [31:0]pc_in;
//wire [31:0]normal_pc;
wire [31:0]pc_out;

//outputs of the PC Adder
wire [31:0]	next_pc;

//outputs of the register file
wire [31:0]sel_reg_1_out;
wire [31:0]sel_reg_2_out;

//outputs of the immediate generator
wire [31:0]proper_immediate;

//outputs of the branch compare
wire BrLT;
wire BrEq;

//outputs of the ASel mux
wire [31:0]alu_in_a;

//outputs of the BSel mux
wire [31:0]alu_in_b;

//outputs of the ALU
wire [31:0]alu_out;

//outputs of the WBSel mux 
wire [31:0]WBSel_mux_out;

//outputs of the Data Memory
wire [31:0]data_mem_out;
wire wait_until_next_cycle_flag;

//outputs of the Data Memory Loader
wire [31:0]proper_data_out;

//outputs of inst mem
wire [31:0]norm_inst;

//empty wire for compiler inst mux
wire [31:0]empty_inst;

//reg compil_signal;
//reg [31:0] overwrite_pc;

wire [6:0]clk_div_counter;
wire clk;

assign led = clk;

counter counter_1(
	.clock(clock),
	.q(clk_div_counter)
);

assign clk = clk_div_counter[6];

//sub modules
one_bit_mux PCSel_Mux(.in1(alu_out), 
							 .in0(next_pc), 
							 .select(PCSel),
							 .out(pc_in)
							 );
							 

increment_pc_by_4 PC_Adder(.inp_pc(pc_out),
									.out_pc(next_pc)
									);
									

program_counter PC(
						.clk(clk), 
						.pc_in(pc_in),
						.wait_until_next_cycle_flag(wait_until_next_cycle_flag),
						.pc_out(pc_out)//output
						);
	
instruction_memory Instruction_Mem(
											.program_counter(pc_out), 
											.instruction_out(inst) //output
											);									

	
									
RegisterFile Register_File(.input_register_1_select(inst[19:15]), 
									.input_register_2_select(inst[24:20]), 
									.output_register_select(inst[11:7]),
									.reg_write(RegWEn),
									.data(WBSel_mux_out),
									.register1(sel_reg_1_out),
									.register2(sel_reg_2_out)
									);
									
immediate_generator Imm_Generator(.instruction_part(inst[31:7]), 
											 .select(ImmSel), 
											 .immediate(proper_immediate)
											 );
											 
BranchCmp Branch_Compare_Unit(.DataA(sel_reg_1_out), 
										.DataB(sel_reg_2_out), 
										.BrUn(BrUn),
										.BrLT(BrLT),
										.BrEq(BrEq)
										);
										
one_bit_mux ASel_Mux(.in1(pc_out), 
							.in0(sel_reg_1_out), 
							.out(alu_in_a), 
							.select(Asel)
							);

one_bit_mux BSel_Mux(.in1(proper_immediate), 
							.in0(sel_reg_2_out), 
							.out(alu_in_b), 
							.select(BSel));

ALU_32bit ALU(.i1(alu_in_a), 
				  .i2(alu_in_b), 
				  .control(ALUSel), 
				  .o(alu_out)); // output

				  
data_memory_controller Data_Mem(
	.addr(alu_out),
	.data_in(sel_reg_2_out),
	.write_mode(data_mem_write_mode),
	.clk(clk),
	.enable(data_mem_enable),
	.data_out(data_mem_out),
	.wait_until_next_cycle(wait_until_next_cycle_flag)
);				  
				  
				  
data_mem_loader Data_Memory_Loader(
												.memory_cell(data_mem_out), 
												.select(SWSel), 
												.data(proper_data_out)
												);

two_bit_mux WBSel_Mux(.input_0(proper_data_out), 
							 .input_1(alu_out), 
							 .input_2(next_pc), 
							 .mux_out(WBSel_mux_out), //output
							 .select(WBSel)
							 );
							 
ControlSignal Control_Signal_Unit(.Inst(inst),
											 .BrLT(BrLT),
											 .BrEq(BrEq),
											 .ImmSel(ImmSel),
											 .RegWEn(RegWEn),
											 .BrUn(BrUn),
											 .PCSel(PCSel),
											 .Asel(Asel),
											 .BSel(BSel),
											 .ALUSel(ALUSel),
											 .MemRW(data_mem_write_mode),
											 .SWSel(SWSel),
											 .WBSel(WBSel),
											 .MemEna(data_mem_enable)
											 );							 


endmodule 