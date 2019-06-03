module firstTerm(
	input [16:0] SW,
	output reg [0:6] HEX0, output reg [0:6] HEX1, 
	output reg [0:6] HEX4, output reg [0:6] HEX5, output reg [0:6] HEX6, output reg [0:6] HEX7,
	output reg [8:0] LEDG
	
);

	parameter Seg9 = 7'b000_1100; parameter Seg8 = 7'b000_0000; parameter Seg7 = 7'b000_1111;
	parameter Seg6 = 7'b010_0000; parameter Seg5 = 7'b010_0100;
	parameter Seg4 = 7'b100_1100; parameter Seg3 = 7'b000_0110; parameter Seg2 = 7'b001_0010;
	parameter Seg1 = 7'b100_1111; parameter Seg0 = 7'b000_0001;
	
	reg [8:0] num1, num2;								//registers to store inputs(two 2-digit BCD numbers)
	reg [8:0] num1Ten, num1One, num2Ten, num2One;		//registers to store each digits

initial
begin
	LEDG[8] = 1'b0;
end

always @(*)
begin
	num1Ten = 8*SW[15] + 4*SW[14] + 2*SW[13] + SW[12];	//ten digit value of first BCD input
	num1One = 8*SW[11] + 4*SW[10] + 2*SW[9] + SW[8];	//one digit value of first BCD input
	num1 = 10 * num1Ten + num1One;						//decimal value of first BCD input
	
	num2Ten = 8*SW[7] + 4*SW[6] + 2*SW[5] + SW[4];
	num2One = 8*SW[3] + 4*SW[2] + 2*SW[1] + SW[0];
	num2 = 10 * num2Ten + num2One;
end

always @(*)					//always statement to display input value in 7-segment display
begin
		case(num1Ten)
			9:HEX7=Seg9; 8:HEX7=Seg8; 7:HEX7=Seg7; 6:HEX7=Seg6;
			5:HEX7=Seg5; 4:HEX7=Seg4; 3:HEX7=Seg3; 2:HEX7=Seg2;
			1:HEX7=Seg1; 0:HEX7=Seg0; default: HEX7 = 7'b1111111;
		endcase
		
		case(num1One)
			9:HEX6=Seg9; 8:HEX6=Seg8; 7:HEX6=Seg7; 6:HEX6=Seg6;
			5:HEX6=Seg5; 4:HEX6=Seg4; 3:HEX6=Seg3; 2:HEX6=Seg2;
			1:HEX6=Seg1; 0:HEX6=Seg0; default: HEX6 = 7'b1111111;
		endcase
		
		case(num2Ten)
			9:HEX5=Seg9; 8:HEX5=Seg8; 7:HEX5=Seg7; 6:HEX5=Seg6;
			5:HEX5=Seg5; 4:HEX5=Seg4; 3:HEX5=Seg3; 2:HEX5=Seg2;
			1:HEX5=Seg1; 0:HEX5=Seg0; default: HEX5 = 7'b1111111;
		endcase
		
		case(num2One)
			9:HEX4=Seg9; 8:HEX4=Seg8; 7:HEX4=Seg7; 6:HEX4=Seg6;
			5:HEX4=Seg5; 4:HEX4=Seg4; 3:HEX4=Seg3; 2:HEX4=Seg2;
			1:HEX4=Seg1; 0:HEX4=Seg0; default: HEX4 = 7'b1111111;
		endcase
		
end

always @(*)
begin
		if(~SW[16])					//case for + operation
		begin
			if(num1 + num2 < 100)	//if overflow not detected, display added result
				begin
					LEDG[8] = 1'b0;
					case((num1 + num2) / 10)
						9:HEX1=Seg9; 8:HEX1=Seg8; 7:HEX1=Seg7; 6:HEX1=Seg6;
						5:HEX1=Seg5; 4:HEX1=Seg4; 3:HEX1=Seg3; 2:HEX1=Seg2;
						1:HEX1=Seg1; 0:HEX1=Seg0; default: HEX1 = 7'b1111111;
					endcase
					
					case((num1 + num2) % 10)
						9:HEX0=Seg9; 8:HEX0=Seg8; 7:HEX0=Seg7; 6:HEX0=Seg6;
						5:HEX0=Seg5; 4:HEX0=Seg4; 3:HEX0=Seg3; 2:HEX0=Seg2;
						1:HEX0=Seg1; 0:HEX0=Seg0; default: HEX0 = 7'b1111111;
					endcase
				end
				
			else if(num1 + num2 >= 100)	//overflow detected
				begin
					LEDG[8] = 1'b1;
					HEX1 = 7'b1111111;
					HEX0 = 7'b1111111;
				end
		end
		
		if(SW[16])				//case for - operation
		begin
			if(num1 >= num2)	//if overflow not detected, display subtracted result
				begin
					LEDG[8] = 1'b0;
					case((num1 - num2) / 10)
						9:HEX1=Seg9; 8:HEX1=Seg8; 7:HEX1=Seg7; 6:HEX1=Seg6;
						5:HEX1=Seg5; 4:HEX1=Seg4; 3:HEX1=Seg3; 2:HEX1=Seg2;
						1:HEX1=Seg1; 0:HEX1=Seg0; default: HEX1 = 7'b1111111;
					endcase
					
					case((num1 - num2) % 10)
						9:HEX0=Seg9; 8:HEX0=Seg8; 7:HEX0=Seg7; 6:HEX0=Seg6;
						5:HEX0=Seg5; 4:HEX0=Seg4; 3:HEX0=Seg3; 2:HEX0=Seg2;
						1:HEX0=Seg1; 0:HEX0=Seg0; default: HEX0 = 7'b1111111;
					endcase
				end
				
			if (num1 < num2)	//overflow detected
				begin
					LEDG[8] = 1'b1;
					HEX1 = 7'b1111111;
					HEX0 = 7'b1111111;
				end
		end
		
end


endmodule