module BranchCmp(

	input[31:0] DataA, 
	input[31:0] DataB, 
 	input BrUn,			//1
	
	output reg BrLT,			//1
	output reg BrEq		//1

	); 						
	

	always@* begin
	
		BrEq = (DataA==DataB);
		case(BrUn)
			1'b1 : BrLT = (DataA < DataB) ? 1 : 0;
			
			1'b0 :
				begin
					  if (DataA[31] == 0 && DataB[31] == 0)
							BrLT = (DataA < DataB) ? 1: 0;
					  else if ( DataA[31] == 1 && DataB[31] == 1)
							BrLT = (DataA > DataB) ? 1: 0;
					  else if ( DataA[31] == 1 && DataB[31] == 0)
							BrLT = 1;
					  else
							BrLT = 0;
				 end   
		endcase	
	end

endmodule