
module ControlSignal(
	input[31:0] Inst, 
	input BrLT, 
	input BrEq, 

	
	output reg[2:0] ImmSel,	//3
	output reg RegWEn,		//1
	output reg BrUn,			//1
	output reg PCSel, 		//1
	output reg Asel,			//1
	output reg BSel,			//1
	output reg[3:0] ALUSel,	//4
	output reg[1:0] MemRW,	//2
	output reg[2:0] SWSel,	//3
	output reg[1:0] WBSel,	//2
	output reg MemEna			//1
	); 							//20
	reg [19:0] ROM0 [0:1];
	reg [19:0] ROM1 [0:7];
	reg [19:0] ROM2 [0:15];
	reg [19:0] ROM3 [0:7];
	reg [19:0] ROM4 [0:3];
	reg [19:0] ROM5 [0:3];
	reg [19:0] ROM6 [0:7];
	reg [19:0] temp;
	
	initial begin 
					//	       IMM_R_B_P_A_B_ALUS_ME_SWS_WB_MR
		ROM0[1'b 0] = 20'b 110_1_0_0_0_1_0110_00_000_01_0;	//SRLI	
		ROM0[1'b 1] = 20'b 110_1_0_0_0_1_0111_00_000_01_0;	//SRAI
		
						//	       IMM_R_B_P_A_B_ALUS_ME_SWS_WB_MR
		ROM1[3'b 000] = 20'b 001_1_0_0_0_1_0000_00_000_01_0; 	//ADDI
		ROM1[3'b 010] = 20'b 001_1_0_0_0_1_1000_00_000_01_0;	//SLTI			
		ROM1[3'b 011] = 20'b 001_1_0_0_0_1_1001_00_000_01_0;	//SLTU	
		ROM1[3'b 100] = 20'b 001_1_0_0_0_1_0100_00_000_01_0;	//XORI	
		ROM1[3'b 110] = 20'b 001_1_0_0_0_1_0010_00_000_01_0;	//ORI	
		ROM1[3'b 111] = 20'b 001_1_0_0_0_1_0011_00_000_01_0;	//ANDI	
		ROM1[3'b 001] = 20'b 110_1_0_0_0_1_0101_00_000_01_0;	//SLLI	
	

						//	       IMM_R_B_P_A_B_ALUS_ME_SWS_WB_MR
		ROM2[4'b 0000] = 20'b 000_1_0_0_0_0_0000_00_000_01_0; 	//ADD
		ROM2[4'b 0001] = 20'b 000_1_0_0_0_0_0001_00_000_01_0;	//Sub			
		ROM2[4'b 0010] = 20'b 000_1_0_0_0_0_0101_00_000_01_0;	//SLL	
		ROM2[4'b 0100] = 20'b 000_1_0_0_0_0_1000_00_000_01_0;	//SLT	
		ROM2[4'b 0110] = 20'b 000_1_0_0_0_0_1001_00_000_01_0;	//SLTU	
		ROM2[4'b 1000] = 20'b 000_1_0_0_0_0_0100_00_000_01_0;	//XOR	
		ROM2[4'b 1010] = 20'b 000_1_0_0_0_0_0110_00_000_01_0;	//SRL	
		ROM2[4'b 1011] = 20'b 000_1_0_0_0_0_0111_00_000_01_0;	//SRA	
		ROM2[4'b 1100] = 20'b 000_1_0_0_0_0_0010_00_000_01_0;	//OR	
		ROM2[4'b 1110] = 20'b 000_1_0_0_0_0_0011_00_000_01_0;	//AND	

						//	      IMM_R_B_P_A_B_ALUS_ME_SWS_WB_MR
		ROM3[3'b 000] = 20'b 001_1_0_0_0_1_0000_00_011_00_1; //LB
		ROM3[3'b 001] = 20'b 001_1_0_0_0_1_0000_00_100_00_1;	//LH			
		ROM3[3'b 010] = 20'b 001_1_0_0_0_1_0000_00_010_00_1;	//LW	
		ROM3[3'b 100] = 20'b 001_1_0_0_0_1_0000_00_000_00_1;	//LBU	
		ROM3[3'b 101] = 20'b 001_1_0_0_0_1_0000_00_001_00_1;	//LHU	
		
					//	        IMM_R_B_P_A_B_ALUS_ME_SWS_WB_MR
		ROM4[2'b 00] = 20'b 010_0_0_0_0_1_0000_01_000_00_1; //SB
		ROM4[2'b 01] = 20'b 010_0_0_0_0_1_0000_10_000_00_1;	//SH			
		ROM4[2'b 10] = 20'b 010_0_0_0_0_1_0000_11_000_00_1;	//SW	

						//	     IMM_R_B_P_A_B_ALUS_ME_SWS_WB_MR
		ROM5[2'b 01] = 20'b 011_0_0_1_1_1_0000_00_000_00_0; 	//BEQ
		ROM5[2'b 00] = 20'b 011_0_0_0_0_0_0000_00_000_00_0;	//BEQ		
		ROM5[2'b 11] = 20'b 011_0_0_0_0_0_0000_00_000_00_0;	//BNE
		ROM5[2'b 10] = 20'b 011_0_0_1_1_1_0000_00_000_00_0;	//BNE	

						//	      IMM_R_B_P_A_B_ALUS_ME_SWS_WB_MR
		ROM6[3'b 001] = 20'b 011_0_0_1_1_1_0000_00_000_00_0; //BLT
		ROM6[3'b 000] = 20'b 011_0_0_0_0_0_0000_00_000_00_0;	//BLT			
		ROM6[3'b 011] = 20'b 011_0_0_0_0_0_0000_00_000_00_0;	//BGE	
		ROM6[3'b 010] = 20'b 011_0_0_1_1_1_0000_00_000_00_0;	//BGE	
		ROM6[3'b 101] = 20'b 011_0_1_1_1_1_0000_00_000_00_0;	//BLTU	
		ROM6[3'b 100] = 20'b 011_0_1_0_0_0_0000_00_000_00_0;	//BLTU	
		ROM6[3'b 111] = 20'b 011_0_1_0_0_0_0000_00_000_00_0;	//BGEU
		ROM6[3'b 110] = 20'b 011_0_1_1_1_1_0000_00_000_00_0;	//BGEU
		
	end	

	always@* begin
		case(Inst[6:2])
			5'b00100 : 
                begin
							case(Inst[14:12])
								3'b 101 : temp <= ROM0[Inst[30]];//yellow
								default : temp <= ROM1[Inst[14:12]];//yellow   
							endcase
                end
			5'b01100 : temp <= ROM2[{Inst[14:12],Inst[30]}];//blue
			            //	         IMM_R_B_P_A_B_ALUS_ME_SWS_WB
			5'b11001 : temp <= 20'b 001_1_0_1_0_1_1011_00_000_01_0; 	//JALR
			5'b00000 : temp <= ROM3[Inst[14:12]]; //RED
			5'b01000 : temp <= ROM4[Inst[13:12]]; //GREEN
			5'b11000 : //LRED
                begin
							case(Inst[14])
								1'b0 : temp <= ROM5[{Inst[12],BrEq}];//Lyellow
								1'b1 : temp <= ROM6[{Inst[13:12],BrLT}];//Lgreen    
							endcase
                end
			            //	         IMM_R_B_P_A_B_ALUS_ME_SWS_WB
			5'b01101 : temp <= 20'b 100_1_0_0_0_1_1010_00_000_01_0; 	//LUP
			            //	         IMM_R_B_P_A_B_ALUS_ME_SWS_WB
			5'b00101 : temp <= 20'b 100_1_0_0_1_1_0000_00_000_01_0; 	//AUIPC	
			            //	         IMM_R_B_P_A_B_ALUS_ME_SWS_WB
			5'b11011 : temp <= 20'b 101_1_0_1_1_1_0000_00_000_10_0; 	//JAL
			
			5'b00011 : temp <= 20'b 000_0_0_0_0_0_0000_00_000_00_0; 	//FENCE
		endcase                  //987_6 5 4 3 2 1098_76_543_21_0
		
		
		ImmSel <= temp[19:17];	//3
		RegWEn <= temp[16];	//1
		BrUn <= temp[15];	//1
		PCSel <= temp[14]; 	//1
		Asel <= temp[13];	//1
		BSel <= temp[12];	//1
		ALUSel <= temp[11:8];	//4
		MemRW <= temp[7:6];	//2
		SWSel <= temp[5:3];	//3
		WBSel <= temp[2:1];	//2
		MemEna <= temp[0];
	end

endmodule