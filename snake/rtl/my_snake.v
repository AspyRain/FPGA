module my_snake(
    input sys_clk,
    input sys_rst_n,    // Freshly brainwashed Lemmings walk left.
	input 	wire	[7: 0]	po_data  		,
	input 	wire			snake_en		,
	output 	wire 	[3: 0] 	sel				,
	output 	wire 			move			,
    output 	reg  	[23:0] 	snake_body		,//4*6 = 24//[23:6]
	output 	reg 			snake_clk		,
	output 	reg 	[23:0]	count			,
	output 	reg 			snake_clk1		,
	output 	reg 	[4:0]	state			,
	output 	reg 	[4:0] 	next_state		,
	output 	reg 	[5:0] 	score_position	,
	output	reg		[2:0]	score			,
	output 	reg		 		flag_add		,
	output 			 		en_random  		,
	output	reg 	[31:0] 	lfsr_state		,
	output	reg 	[2:0]	snake_len			

	);  
	
	assign sel = po_data[3: 0];



    // parameter LEFT=0, RIGHT=1, ...
	parameter [4:0] 
					UP		=5'd1,
					DOWN	=5'd2,
					LEFT	=5'd3,
					RIGHT	=5'd4,
					START   =5'd5,
					WIN 	=5'd6;

	



	parameter CNT_500MS = 24'd10_000_000;//0.25ms设置为12_499_999就不行了
	wire end_cnt500ms;
	wire en_cnt500ms;

	wire [5:0] head_i3 ;
	wire [5:0] body_i2 ;
	wire [5:0] body_i1 ;
	wire [5:0] body_i0 ;
	assign head_i3 = snake_body[23:18]; 
	assign body_i2 = snake_body[17:12];
	assign body_i1 = snake_body[11:6];
	assign body_i0 = snake_body[5:0];
	//CNT_500MS - score * 2_000_000;
 	

	//伪随机数，随机生成分数红点的位置
	always @(posedge sys_clk or negedge sys_rst_n) begin
		if (!sys_rst_n)
		begin
			lfsr_state <= 32'h8a59467d; // 设置初始值为 32'h12345678
			score_position <= 6'd0;
			flag_add <= 0;
		end
		else if(move)begin
			flag_add <= 0;
		end
		else if(en_random)begin
			lfsr_state <= {lfsr_state[30:0], lfsr_state[0] ^ lfsr_state[1]};
			//lfsr_state <= {lfsr_state[0],lfsr_state[31:1]};

		// 输出随机数范围为 0 到 63
			score_position <= lfsr_state[5:0]; // 取 lfsr_state 的低 5 位作为随机数

			flag_add <= 1;
		end
		else begin
			score_position <= score_position;
			flag_add <= flag_add;
		end
	end
	//检测是否撞到得分红点
	assign en_random  = (
		score_position == head_i3 ||
	 	score_position == body_i2 || 
		score_position == body_i1 || 
		score_position == body_i0
		)?  1 : 0;
	

	always @(posedge sys_clk or negedge sys_rst_n)begin//组合不可以，时序可以？
		if(!sys_rst_n) score <= 0;
		else if(en_random)begin
			score <= score + 1;
		end
		else begin
			score <= score;
		end
	end
	always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		count <= 0;
		snake_clk <= 0;
	end
	else begin
		if (en_cnt500ms) begin
		if (end_cnt500ms) begin
			count <= 0;
			snake_clk <= ~snake_clk;
		end 
		else begin
			count <= count + 1;
		end
		end
	end
	end
	assign en_cnt500ms = 1;
	assign end_cnt500ms = en_cnt500ms && (count == CNT_500MS - (score * 2_000_000));


	always @(posedge sys_clk or negedge sys_rst_n)begin
		if(!sys_rst_n)begin
			snake_clk1 <= 0;
		end
		else begin
			snake_clk1 <= snake_clk; 
		end
	end
	assign move = snake_clk && ~snake_clk1;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        // State transition logic
		if(!sys_rst_n)begin
			state <= START;
		end
		else begin
			state <= next_state;
		end
    end


	always @(*) begin
		if(snake_en == 1'b1) begin
		if(score == 3'd5)begin
			next_state = WIN;
		end 
		else if(sel == 4'b0001)begin
		next_state = UP;
		end
		else if(sel == 4'b0010)begin
		next_state = DOWN;
		end
		else if(sel == 4'b0100)begin
		next_state = LEFT;
		end
		else if(sel == 4'b1000)begin
		next_state = RIGHT;
		end
		else begin
			case (state)
			START:begin
				if(snake_en== 1'b1)next_state = LEFT;
				else  next_state = START;
			end
			UP:begin

				next_state = UP;
			end 
			DOWN:begin
				next_state = DOWN;
			end
			LEFT:begin
				next_state = LEFT;
			end
			RIGHT:begin
				next_state = RIGHT;
			end
			WIN:begin
				next_state = WIN;
			end
			default:next_state = LEFT;
		endcase
		end
		end
		else begin
			next_state = START;
		end

	end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        // State flip-flops with asynchronous reset
		if(!sys_rst_n)begin
			snake_body <= {6'd15,6'd15,6'd15,6'd15};
			snake_len <= 3'd1;
		end
		else if(move ) begin
			if(flag_add && snake_len < 4)begin//最长为4，可以加长1222
				snake_len <= 3'd1 + snake_len;
			end
			else begin
			case (next_state)
			START:begin 
			end
			UP:begin

					if(head_i3		<7)snake_body 	<= {head_i3+64-8,snake_body[23:6]};
					else if(body_i2 <7)snake_body 	<= {head_i3-8,head_i3,snake_body[17:6]};///1076
					else if(body_i1 <7)snake_body 	<= {head_i3-8,head_i3,body_i2,snake_body[11:6]};//2107
					else if(body_i0 <7)snake_body 	<= {head_i3-8,head_i3,body_i2,body_i1};
					
					else snake_body <= {head_i3-8,snake_body[23:6]};
			end
			DOWN:begin
					if(head_i3 		 > 55)snake_body <= {head_i3+8-64,snake_body[23:6]};
					else if(body_i2  > 55)snake_body <= {head_i3+8,head_i3,snake_body[17:6]};///1076
					else if(body_i1  > 55)snake_body <= {head_i3+8,head_i3,body_i2,snake_body[11:6]};//2107
					else if(body_i0  > 55)snake_body <= {head_i3+8,head_i3,body_i2,body_i1};
					
					else snake_body <= {head_i3+8,snake_body[23:6]};

			end
			LEFT:begin
					if(head_i3 % 8 == 0)snake_body 		<= {head_i3-1+8,snake_body[23:6]};
					else if(body_i2 % 8 == 0)snake_body <= {head_i3-1,head_i3,snake_body[17:6]};///1076
					else if(body_i1 % 8 == 0)snake_body <= {head_i3-1,head_i3,body_i2,snake_body[11:6]};//2107
					else if(body_i0 % 8 == 0)snake_body <= {head_i3-1,head_i3,body_i2,body_i1};
					else snake_body <= {head_i3-1,snake_body[23:6]};
			end
			RIGHT:begin
					if(head_i3 		% 8 == 7)snake_body	<= {head_i3+1-8,snake_body[23:6]};//0765
					else if(body_i2 % 8 == 7)snake_body <= {head_i3+1,head_i3,snake_body[17:6]};///1076
					else if(body_i1 % 8 == 7)snake_body <= {head_i3+1,head_i3,body_i2,snake_body[11:6]};//2107
					else if(body_i0 % 8 == 7)snake_body <= {head_i3+1,head_i3,body_i2,body_i1};
					else snake_body <= {head_i3+1,snake_body[23:6]};
			end
			WIN:begin
			end
			default:begin 
				snake_body <= snake_body;
			end
			endcase
		end
		end
		else snake_body <= snake_body;
    end

endmodule