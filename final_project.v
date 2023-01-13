module final_project( CLK, RST, enter, test, keyin, key_choose, COMM, COM_led, seg, life, DATA_R, DATA_G, DATA_B, beep);

input CLK;
input RST;
input enter;
input test;
input [3:0] key_choose;
input reg [3:0] keyin;
output reg beep;
output reg [2:0] COMM;
output reg [7:0] DATA_R, DATA_G, DATA_B;
output reg [3:0] COM_led;
output reg [6:0] seg;
output reg [15:0] life;

reg  [3:0] in_0;
reg  [3:0] in_1;
reg  [3:0] in_2;
reg  [3:0] in_3;
reg  [3:0] key_index;
reg  [7:0] matrix [7:0];
reg  [7:0] led_in_0;
reg  [7:0] led_in_1;
reg  [7:0] led_in_2;
reg  [7:0] led_in_3;

reg over;
reg CLK_div;
reg CLK2_div;

integer  cnt;
integer  num_ran_0;
integer  num_ran_1;
integer  num_ran_2;
integer  num_ran_3;
integer  target_num_0;
integer  target_num_1;
integer  target_num_2;
integer  target_num_3;
integer  RGB_flag;
integer  flag;

assign  key_index = key_choose;

divfreq F0(CLK, CLK_div);
divfreq2 F1(CLK, CLK2_div);

initial
begin
	DATA_R = 8'b11111111;
	DATA_G = 8'b11111111;
	DATA_B = 8'b11111111;
	COMM = 4'b1000;
	target_num_3=6;
end

initial
begin
	seg = 7'b0000000;
	COM_led = 4'b1110;
	RGB_flag = 1;
	life = 16'b1111111111111111;
end

always @ (posedge CLK)
begin
	if(num_ran_0==10)
		num_ran_0 <= 0;
	else num_ran_0 <= num_ran_0+1;
	
	if(num_ran_1==10)
		num_ran_1 <= 0;
	else num_ran_1 <= num_ran_1+1;
	
	if(num_ran_2==10)
		num_ran_2 <= 0;
	else num_ran_2 <= num_ran_2+1;
	
	if(num_ran_3==10)
		num_ran_3 <= 0;
	else num_ran_3 <= num_ran_3+1;
	
	if (flag!=1)
		beep<=1'b0;
	else if (flag==1)
		beep<=~beep;	
end

always @ (posedge CLK2_div)
begin
	if (cnt >= 7) 
		cnt <= 0;
	else 
		cnt <= cnt+1;	
	COMM = cnt;
	DATA_R = matrix[cnt];	
		
	case(COM_led)
		4'b1110:   
			begin
				COM_led <= 4'b1101;
				seg = led_in_1;
			end
		4'b1101:   
			begin
				COM_led <= 4'b1011;
				seg = led_in_2;
			end
		4'b1011:      
			begin
				COM_led <= 4'b0111;
				seg = led_in_3;
			end
		4'b0111:	   
			begin
				COM_led <= 4'b1110;
				seg <= led_in_0;
			end 
	endcase
end

always @ (posedge CLK_div)
begin	
	if((over==0)&&(enter==1))
	begin
		case(key_index)
			4'b0001:   
				begin
					if(keyin<10)
					begin
						in_0 <= keyin;
						RGB_flag <= 5;
					end
					else
						RGB_flag <= 0;
				end
			4'b0010:   
				begin
					if(keyin<10)
					begin
						in_1 <= keyin;
						RGB_flag <= 6;
					end
					else
						RGB_flag <= 0;
				end
			4'b0100:   
				begin
					if(keyin<10)
					begin
						in_2 <= keyin;
						RGB_flag <= 7;
					end
					else
						RGB_flag <= 0;
				end
			4'b1000:	  
				begin
					if(keyin<10)
					begin
						in_3 <= keyin;
						RGB_flag <= 8;
					end
					else
						RGB_flag <= 0;
				end
			default:   RGB_flag <= 0;  
		endcase
	end
	
	if(RST)
	begin
		matrix[0]<=8'b00000000;
		matrix[1]<=8'b00000000;
		matrix[2]<=8'b00000000;
		matrix[3]<=8'b00000000;
		matrix[4]<=8'b00000000;
		matrix[5]<=8'b00000000;
		matrix[6]<=8'b00000000;
		matrix[7]<=8'b00000000;
		over<=0;
		target_num_0 <= 6;
		target_num_1 <= 3;
		target_num_2 <= 8;
		target_num_3 <= 1;
		in_0 <= 4'b0;
		in_1 <= 4'b0;
		in_2 <= 4'b0;
		in_3 <= 4'b0;
		RGB_flag <= 1;
		life <= 16'b1111111111111111;
		flag<=0;
	end
	
	if(target_num_0==in_0)
	begin
		if(target_num_1==in_1)
		begin
			if(target_num_2==in_2)
			begin
				if(target_num_3==in_3)
				begin
					flag<=1;
					over<=1;
				end
				else if(in_3<target_num_3)
					flag<=2;
				else if(in_3>target_num_3)
					flag<=3;
			end
			else if(in_2<target_num_2)
				flag<=2;
			else if(in_2>target_num_2)
				flag<=3;
		end
		else if(in_1<target_num_1)
				flag<=2;
		else if(in_1>target_num_1)
				flag<=3;	
	end
	else if(in_0<target_num_0)
		flag<=2;
	else if(in_0>target_num_0)
		flag<=3;
		
	if(over==0)
	begin
		if(test)
		begin
			if(flag==1)
			begin
				RGB_flag <= 2;
				over <= 1;
			end
			else if(flag==2)
			begin
				RGB_flag <= 3;
				life <= life << 1;
			end
			else if(flag==3)
			begin
				RGB_flag <= 4;
				life <= life << 1;
			end
		end
	end
	
	case(RGB_flag)
		0:   
			begin
				matrix <= '{ 8'b10111101,
								 8'b11011011,
								 8'b11100111,
								 8'b11011011,
								 8'b10111101,
								 8'b11111111,
								 8'b11111111,
								 8'b11111111};
			end
		1:   
			begin
				matrix <= '{  8'b01110101,
                       8'b11000111,
                       8'b01111110,
                       8'b10100101,
                       8'b01011010,
                       8'b01100110,
                       8'b11011011,
                       8'b10111101};
			end
		2:   
			begin
				matrix <= '{ 8'b01010101,
								 8'b01010101,
								 8'b01010101,
								 8'b01010101,
								 8'b01010101,
								 8'b01010101,
								 8'b01010101,
								 8'b01010101};
			end
		3:      
			begin
				matrix <= '{ 8'b11111111,
								 8'b11111111,
								 8'b11100111,
								 8'b11011011,
								 8'b10111101,
								 8'b01111110,
								 8'b11111111,
								 8'b11111111};
			end
		4:	   
			begin
				matrix <= '{  8'b11111111,
                       8'b11111111,
                       8'b01111110,
                       8'b10111101,
                       8'b11011011,
                       8'b11100111,
                       8'b11111111,
                       8'b11111111};
			end 
		8:   
			begin
				matrix<='{8'b11111111,
                        8'b11111111,
                                  8'b11111111,
                        8'b10111011,
                                  8'b10000001,
                        8'b10111111,
                                  8'b11111111,
											 8'b11111111};
			end
		7:   
			begin
				matrix<='{8'b11111111,
                                   8'b11111111,
                         8'b10000001,
                                   8'b11111111,
                         8'b10000001,
                         8'b10111101,
                                   8'b10000001,
                         8'b11111111};
			end
		6:      
			begin
				matrix<='{8'b10000001,
                          8'b11111111,
                                    8'b10000001,
                          8'b10111101,
                                    8'b10000001,
                          8'b10000001,
                                    8'b10111101,
                          8'b10000001};
			end
		5:	   
			begin
				matrix<='{8'b01101110,
                                8'b10101101,
                                        8'b11000011,
                              8'b00000000,
                                        8'b11000111,
                              8'b11000111,
                                        8'b10110101,
                            8'b01110110};
			end 
	endcase
	
	case(in_0)
		0:   
			begin
				led_in_0 <= 7'b1000000;
			end
		1:   
			begin
				led_in_0 <= 7'b1111001;
			end
		2:   
			begin
				led_in_0 <= 7'b0100100;
			end
		3:      
			begin
				led_in_0 <= 7'b0110000;
			end
		4:	   
			begin
				led_in_0 <= 7'b0011001;
			end 
		5:   
			begin
				led_in_0 <= 7'b0010010;
			end
		6:   
			begin
				led_in_0 <= 7'b0000010;
			end
		7:      
			begin
				led_in_0 <= 7'b1111000;
			end
		8:	   
			begin
				led_in_0 <= 7'b0000000;
			end 
		9:	   
			begin
				led_in_0 <= 7'b0010000;
			end 			
	endcase

	case(in_1)
		0:   
			begin
				led_in_1 <= 7'b1000000;
			end
		1:   
			begin
				led_in_1 <= 7'b1111001;
			end
		2:   
			begin
				led_in_1 <= 7'b0100100;
			end
		3:      
			begin
				led_in_1 <= 7'b0110000;
			end
		4:	   
			begin
				led_in_1 <= 7'b0011001;
			end 
		5:   
			begin
				led_in_1 <= 7'b0010010;
			end
		6:   
			begin
				led_in_1 <= 7'b0000010;
			end
		7:      
			begin
				led_in_1 <= 7'b1111000;
			end
		8:	   
			begin
				led_in_1 <= 7'b0000000;
			end 
		9:	   
			begin
				led_in_1 <= 7'b0010000;
			end 			
	endcase
	
	case(in_2)
		0:   
			begin
				led_in_2 <= 7'b1000000;
			end
		1:   
			begin
				led_in_2 <= 7'b1111001;
			end
		2:   
			begin
				led_in_2 <= 7'b0100100;
			end
		3:      
			begin
				led_in_2 <= 7'b0110000;
			end
		4:	   
			begin
				led_in_2 <= 7'b0011001;
			end 
		5:   
			begin
				led_in_2 <= 7'b0010010;
			end
		6:   
			begin
				led_in_2 <= 7'b0000010;
			end
		7:      
			begin
				led_in_2 <= 7'b1111000;
			end
		8:	   
			begin
				led_in_2 <= 7'b0000000;
			end 
		9:	   
			begin
				led_in_2 <= 7'b0010000;
			end 			
	endcase
	
	case(in_3)
		0:   
			begin
				led_in_3 <= 7'b1000000;
			end
		1:   
			begin
				led_in_3 <= 7'b1111001;
			end
		2:   
			begin
				led_in_3 <= 7'b0100100;
			end
		3:      
			begin
				led_in_3 <= 7'b0110000;
			end
		4:	   
			begin
				led_in_3 <= 7'b0011001;
			end 
		5:   
			begin
				led_in_3 <= 7'b0010010;
			end
		6:   
			begin
				led_in_3 <= 7'b0000010;
			end
		7:      
			begin
				led_in_3 <= 7'b1111000;
			end
		8:	   
			begin
				led_in_3 <= 7'b0000000;
			end 
		9:	   
			begin
				led_in_3 <= 7'b0010000;
			end 			
	endcase
end

endmodule

module divfreq(input CLK, output reg CLK_div);
reg [24:0] Count;
always @(posedge CLK)
begin
if(Count > 25000000)
begin
Count <= 25'b0;
CLK_div <= ~CLK_div;
end

else
Count <= Count + 1'b1;
end
endmodule

module divfreq2(input CLK, output reg CLK2_div);
reg [24:0] Count;
always @(posedge CLK)
begin
if(Count > 25000)
begin
Count <= 25'b0;
CLK2_div <= ~CLK2_div;
end

else
Count <= Count + 1'b1;
end
endmodule