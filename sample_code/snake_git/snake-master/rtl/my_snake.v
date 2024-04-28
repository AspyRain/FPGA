module my_snake(
    input sys_clk,
    input sys_rst_n,    // Freshly brainwashed Lemmings walk left.
	input wire  [7: 0] 	po_data     ,
	output wire [3: 0] sel,
	output wire move,
    output reg  [23:0] snake_body,//4*6 = 24//[23:6]
	output reg snake_clk	,
	output reg [23:0]count,
	output reg snake_clk1,
	output reg [4:0]	state,
	output reg [4:0] next_state
	);  
	
	
	assign sel = po_data[3: 0];



    // parameter LEFT=0, RIGHT=1, ...
	parameter [4:0] 
					UP		=5'd1,
					DOWN	=5'd2,
					LEFT	=5'd3,
					RIGHT	=5'd4,
					TURN_L	=5'd5, 

					ORIGIN	=5'd6,
					DIE		=5'd7,
					TURN_R  =5'd8;

	



	parameter CNT_500MS = 24'd10000000;
	wire end_cnt500ms;
	wire en_cnt500ms;
	


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
	assign end_cnt500ms = en_cnt500ms && (count == CNT_500MS);


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
			state <= LEFT;
		end
		else begin
			state <= next_state;
		end
    end
	wire [5:0] head_i3 ;
	wire [5:0] body_i2 ;
	wire [5:0] body_i1 ;
	wire [5:0] body_i0 ;
	assign head_i3 = snake_body[23:18]; 
	assign body_i2 = snake_body[17:12];
	assign body_i1 = snake_body[11:6];
	assign body_i0 = snake_body[5:0];

	always @(*) begin
		next_state = LEFT;
		if(sel == 4'b0001)begin
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
			ORIGIN:begin
				
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
			TURN_L:begin
			end	
			TURN_R:begin
				
			end
			DIE:begin
				
			end
			default:next_state = LEFT;
		endcase

		end
	end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        // State flip-flops with asynchronous reset
		if(!sys_rst_n)begin
			snake_body <= {6'd44,6'd45,6'd46,6'd47};
		end
		else if(move) begin
			case (next_state)
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
			default:begin 
				snake_body <= snake_body;
			end
			endcase
		end
		else snake_body <= snake_body;
    end

endmodule