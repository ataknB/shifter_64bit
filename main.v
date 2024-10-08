module shifter_64bit(

	input [31:0]in,
	input sra,	
	input sll,
	input [5:0]size,
	
	output [63:0]out
    );
    
	genvar i;
	
	wire [63:0]wire_in = {32'd0 , in};
	wire wire_MSB = (sra) ? wire_in[63] : 1'b0;
	
	 
	generate 
		for(i = 0 ; i < 5 ; i = i+1)
		begin: stage
			wire[63:0]wire_con;
		end
		
		for(i = 0 ; i < 2 ; i = i+1)
		begin: SLStage
			wire [63:0]wire_con;
		end
		
		for(i=0 ; i<64 ; i=i+1)begin 
			assign SLStage[0].wire_con[63-i] = (sll) ? wire_in[i] : wire_in[63-i];
		end
		
		//stage 0
		for(i=0 ; i<32 ; i=i+1)begin 
			assign stage[0].wire_con[63-i] = (size[5]) ? wire_MSB : SLStage[0].wire_con[63-i];
		end 
		
		for(i=0 ; i<32 ; i=i+1)begin	
			assign stage[0].wire_con[31-i] = (size[5]) ? SLStage[0].wire_con[63-i] : SLStage[0].wire_con[31-i];
		end
		
		//stage 1
		for(i=0 ; i<16 ; i=i+1)begin 
			assign stage[1].wire_con[63-i] = (size[4]) ? wire_MSB : stage[0].wire_con[63-i];
		end
		
		for(i=0 ; i<48 ; i=i+1)begin
			assign stage[1].wire_con[47-i] = (size[4]) ? stage[0].wire_con[63-i] : stage[0].wire_con[47-i];
		end
		
		//stage 2
		for(i=0 ; i<8 ; i=i+1)begin
			assign stage[2].wire_con[63-i] = (size[3]) ? wire_MSB : stage[1].wire_con[63-i];
		end
		
		for(i=0 ; i<56 ; i=i+1)begin
			assign stage[2].wire_con[55-i] = (size[3]) ? stage[1].wire_con[63-i] : stage[1].wire_con[55-i];
		end	
		
		//stage 3
		for(i=0 ; i<4 ; i=i+1)begin 
			assign stage[3].wire_con[63-i] = (size[2]) ? wire_MSB : stage[2].wire_con[63-i];
		end
		
		for(i=0 ; i<60 ; i=i+1)begin 
			assign stage[3].wire_con[59-i] = (size[2]) ? stage[2].wire_con[63-i] : stage[2].wire_con[59-i];
		end
		
		//stage 4
		for(i=0 ; i<2 ; i=i+1)begin 
			assign stage[4].wire_con[63-i] = (size[1]) ? wire_MSB : stage[3].wire_con[63-i];
		end
		
		for(i=0 ; i<62 ; i=i+1)begin 
			assign stage[4].wire_con[61-i] = (size[1]) ? stage[3].wire_con[63-i] : stage[3].wire_con[61-i];
		end
		
		//stage 5
		
		assign SLStage[1].wire_con[63] = (size[0]) ? wire_MSB : stage[4].wire_con[63];
			
		for(i=0 ; i<63 ; i=i+1)begin 
			assign SLStage[1].wire_con[62-i] = (size[0]) ? stage[4].wire_con[63-i] : stage[4].wire_con[62-i];
		end
		
		//result
		
		for(i=0 ; i<64 ; i=i+1)begin
			assign out[63-i] = (sll) ? SLStage[1].wire_con[i] : SLStage[1].wire_con[63-i];
		end
		
	endgenerate
	
	
endmodule

