module my_snake(
    input sys_clk,
    input sys_reset_n,    // Freshly brainwashed Lemmings walk left.
	input wire  [7: 0] 	po_data     ,

    output reg[23:0] snake_body//4*6 = 24//[23:6]
	);  
	
	wire [3: 0] sel;
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


    reg [4:0]state, next_state;

    always @(posedge sys_clk or posedge sys_reset_n) begin
        // State transition logic
		if(sys_reset_n)begin
			state <= LEFT;
		end
		else begin
			state <= next_state;
		end
    end
	wire [5:0] head_i3 ;
	assign head_i3 = snake_body[23:18]; 
	assign body_i2 = snake_body[17:12];
	assign body_i1 = snake_body[11:6];
	assign body_i0 = snake_body[5:0];

	always @(*) begin
		next_state = LEFT;
		case (state)
			ORIGIN:begin
				
			end
			UP:begin
				if(sel == 4'b0100)begin
					next_state = LEFT;
				end
				else if(sel == 4'b1000)begin
					next_state = RIGHT;
				end
				else next_state = UP;
			end 
			DOWN:begin
				if(sel == 4'b0100)begin
					next_state = LEFT;
				end
				else if(sel == 4'b1000)begin
					next_state = RIGHT;
				end
				else next_state = DOWN;
			end
			LEFT:begin
				if(sel == 4'b0100)begin
					next_state = DOWN;
				end
				else if(sel == 4'b1000)begin
					next_state = UP;
				end
				else next_state = LEFT;
			end
			RIGHT:begin
				if(sel == 4'b0100)begin
					next_state = UP;
				end
				else if(sel == 4'b1000)begin
					next_state = DOWN;
				end
				else next_state = RIGHT;
			end
			TURN_L:begin
			end	
			TURN_R:begin
				
			end
			DIE:begin
				
			end
			default:;
		endcase
	end

    always @(posedge sys_clk, posedge sys_reset_n) begin
        // State flip-flops with asynchronous reset
		if(sys_reset_n)begin
			snake_body = {6'd44,6'd45,6'd46,6'd47};
		end
		else begin
			case (next_state)
			UP:begin
				if(state == UP)begin//U
					if(head_i3 % 8 <7)snake_body 		<= {head_i3-8+56,snake_body[23:6]};
					else if(body_i2 % 8 <7)snake_body 	<= {head_i3-8,body_i2-8+56,snake_body[17:6]};
					else if(body_i1 % 8 <7)snake_body 	<= {head_i3-8,body_i2-8,body_i1-8+56,snake_body[11:6]};
					else if(body_i0 % 8 <7)snake_body 	<= {head_i3-8,body_i2-8,body_i1-8,body_i0-8+56};
					
					else snake_body = {head_i3-8,snake_body[23:6]};
				end
				else if(state == DOWN)begin//U
					if(head_i3 % 8 <7)snake_body 		<= {head_i3-8+56,snake_body[23:6]};
					else if(body_i2 % 8 <7)snake_body 	<= {head_i3-8,body_i2-8+56,snake_body[17:6]};
					else if(body_i1 % 8 <7)snake_body 	<= {head_i3-8,body_i2-8,body_i1-8+56,snake_body[11:6]};
					else if(body_i0 % 8 <7)snake_body 	<= {head_i3-8,body_i2-8,body_i1-8,body_i0-8+56};
					
					else snake_body = {head_i3-8,snake_body[23:6]};
				end
				else if(state == LEFT)begin//L
					if(head_i3 % 8 == 0)snake_body 		<= {head_i3-1+8,snake_body[23:6]};
					else if(body_i2 % 8 == 0)snake_body <= {head_i3-1,body_i2-1+8,snake_body[17:6]};
					else if(body_i1 % 8 == 0)snake_body <= {head_i3-1,body_i2-1,body_i1-1+8,snake_body[11:6]};
					else if(body_i0 % 8 == 0)snake_body <= {head_i3-1,body_i2-1,body_i1-1,body_i0-1+8};
					
					else snake_body <= {head_i3-1,snake_body[23:6]};
				end
				else if(state == RIGHT)begin//R
					if(head_i3 % 8 == 7)snake_body 		= {head_i3+1-8,snake_body[23:6]};
					else if(body_i2 % 8 == 7)snake_body = {head_i3+1,body_i2+1-8,snake_body[17:6]};
					else if(body_i1 % 8 == 7)snake_body = {head_i3+1,body_i2+1,body_i1+1-8,snake_body[11:6]};
					else if(body_i0 % 8 == 7)snake_body = {head_i3+1,body_i2+1,body_i1+1,body_i0+1-8};
					else snake_body = {head_i3+1,snake_body[23:6]};
				end
			end 
			DOWN:begin
				if(state == UP)begin//D
					if(head_i3 % 8 > 55)snake_body 		<= {head_i3+8-56,snake_body[23:6]};
					else if(body_i2 % 8 > 55)snake_body <= {head_i3+8,body_i2+8-56,snake_body[17:6]};
					else if(body_i1 % 8 > 55)snake_body <= {head_i3+8,body_i2+8,body_i1+8-56,snake_body[11:6]};
					else if(body_i0 % 8 > 55)snake_body <= {head_i3+8,body_i2+8,body_i1+8,body_i0+8-56};
					
					else snake_body = {head_i3+8,snake_body[23:6]};
				end
				else if(state == DOWN)begin//D
					if(head_i3 % 8 > 55)snake_body 		<= {head_i3+8-56,snake_body[23:6]};
					else if(body_i2 % 8 > 55)snake_body <= {head_i3+8,body_i2+8-56,snake_body[17:6]};
					else if(body_i1 % 8 > 55)snake_body <= {head_i3+8,body_i2+8,body_i1+8-56,snake_body[11:6]};
					else if(body_i0 % 8 > 55)snake_body <= {head_i3+8,body_i2+8,body_i1+8,body_i0+8-56};
					
					else snake_body = {head_i3+8,snake_body[23:6]};
				end
				else if(state == LEFT)begin//L
					if(head_i3 % 8 == 0)snake_body 		<= {head_i3-1+8,snake_body[23:6]};
					else if(body_i2 % 8 == 0)snake_body <= {head_i3-1,body_i2-1+8,snake_body[17:6]};
					else if(body_i1 % 8 == 0)snake_body <= {head_i3-1,body_i2-1,body_i1-1+8,snake_body[11:6]};
					else if(body_i0 % 8 == 0)snake_body <= {head_i3-1,body_i2-1,body_i1-1,body_i0-1+8};
					
					else snake_body <= {head_i3-1,snake_body[23:6]};
				end
				else if(state == RIGHT)begin//R
					if(head_i3 % 8 == 7)snake_body 		= {head_i3+1-8,snake_body[23:6]};
					else if(body_i2 % 8 == 7)snake_body = {head_i3+1,body_i2+1-8,snake_body[17:6]};
					else if(body_i1 % 8 == 7)snake_body = {head_i3+1,body_i2+1,body_i1+1-8,snake_body[11:6]};
					else if(body_i0 % 8 == 7)snake_body = {head_i3+1,body_i2+1,body_i1+1,body_i0+1-8};
					else snake_body = {head_i3+1,snake_body[23:6]};
				end
			end
			LEFT:begin
				if(state == UP)begin//L
					if(head_i3 % 8 == 0)snake_body 		<= {head_i3-1+8,snake_body[23:6]};
					else if(body_i2 % 8 == 0)snake_body <= {head_i3-1,body_i2-1+8,snake_body[17:6]};
					else if(body_i1 % 8 == 0)snake_body <= {head_i3-1,body_i2-1,body_i1-1+8,snake_body[11:6]};
					else if(body_i0 % 8 == 0)snake_body <= {head_i3-1,body_i2-1,body_i1-1,body_i0-1+8};
					
					else snake_body <= {head_i3-1,snake_body[23:6]};
				end
				else if(state == DOWN)begin//L
					if(head_i3 % 8 == 0)snake_body 		<= {head_i3-1+8,snake_body[23:6]};
					else if(body_i2 % 8 == 0)snake_body <= {head_i3-1,body_i2-1+8,snake_body[17:6]};
					else if(body_i1 % 8 == 0)snake_body <= {head_i3-1,body_i2-1,body_i1-1+8,snake_body[11:6]};
					else if(body_i0 % 8 == 0)snake_body <= {head_i3-1,body_i2-1,body_i1-1,body_i0-1+8};
					
					else snake_body <= {head_i3-1,snake_body[23:6]};
				end
				else if(state == LEFT)begin//D
					if(head_i3 % 8 > 55)snake_body 		<= {head_i3+8-56,snake_body[23:6]};
					else if(body_i2 % 8 > 55)snake_body <= {head_i3+8,body_i2+8-56,snake_body[17:6]};
					else if(body_i1 % 8 > 55)snake_body <= {head_i3+8,body_i2+8,body_i1+8-56,snake_body[11:6]};
					else if(body_i0 % 8 > 55)snake_body <= {head_i3+8,body_i2+8,body_i1+8,body_i0+8-56};
					
					else snake_body = {head_i3+8,snake_body[23:6]};
				end
				else if(state == RIGHT)begin//U
					if(head_i3 % 8 <7)snake_body 		<= {head_i3-8+56,snake_body[23:6]};
					else if(body_i2 % 8 <7)snake_body 	<= {head_i3-8,body_i2-8+56,snake_body[17:6]};
					else if(body_i1 % 8 <7)snake_body 	<= {head_i3-8,body_i2-8,body_i1-8+56,snake_body[11:6]};
					else if(body_i0 % 8 <7)snake_body 	<= {head_i3-8,body_i2-8,body_i1-8,body_i0-8+56};
					
					else snake_body = {head_i3-8,snake_body[23:6]};
				end
			end
			RIGHT:begin
				if(state == UP )begin//R
					if(head_i3 % 8 == 7)snake_body 		= {head_i3+1-8,snake_body[23:6]};
					else if(body_i2 % 8 == 7)snake_body = {head_i3+1,body_i2+1-8,snake_body[17:6]};
					else if(body_i1 % 8 == 7)snake_body = {head_i3+1,body_i2+1,body_i1+1-8,snake_body[11:6]};
					else if(body_i0 % 8 == 7)snake_body = {head_i3+1,body_i2+1,body_i1+1,body_i0+1-8};
					else snake_body = {head_i3+1,snake_body[23:6]};
				end
				else if(state == DOWN)begin//R
					if(head_i3 % 8 == 7)snake_body		= {head_i3+1-8,snake_body[23:6]};
					else if(body_i2 % 8 == 7)snake_body = {head_i3+1,body_i2+1-8,snake_body[17:6]};
					else if(body_i1 % 8 == 7)snake_body = {head_i3+1,body_i2+1,body_i1+1-8,snake_body[11:6]};
					else if(body_i0 % 8 == 7)snake_body = {head_i3+1,body_i2+1,body_i1+1,body_i0+1-8};
					else snake_body = {head_i3+1,snake_body[23:6]};
				end
				else if(state == LEFT)begin//U
					if(head_i3 % 8 <7)snake_body 		= {head_i3-8+56,snake_body[23:6]};
					else if(body_i2 % 8 <7)snake_body 	= {head_i3-8,body_i2-8+56,snake_body[17:6]};
					else if(body_i1 % 8 <7)snake_body 	= {head_i3-8,body_i2-8,body_i1-8+56,snake_body[11:6]};
					else if(body_i0 % 8 <7)snake_body 	= {head_i3-8,body_i2-8,body_i1-8,body_i0-8+56};	
					else snake_body = {head_i3-8,snake_body[23:6]};
				end
				else if(state == RIGHT)begin//D
					if(head_i3 % 8 >55)snake_body 		= {head_i3+8-56,snake_body[23:6]};
					else if(body_i2 % 8 >55)snake_body 	= {head_i3+8,body_i2+8-56,snake_body[17:6]};
					else if(body_i1 % 8 >55)snake_body	= {head_i3+8,body_i2+8,body_i1+8-56,snake_body[11:6]};
					else if(body_i0 % 8 >55)snake_body 	= {head_i3+8,body_i2+8,body_i1+8,body_i0+8-56};
					else snake_body = {head_i3+8,snake_body[23:6]};
				end
			end
				default:begin 
					snake_body <= snake_body;
				end
			endcase
		end
    end

endmodule