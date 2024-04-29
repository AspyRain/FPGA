module start_roll(
    input sys_clk,      // 系统时钟
    input sys_rst_n,    // 系统复位信号（低有效）
    input [5:0] water_index, // 水位索引
    input roll_cnt,     // 滚动计数信号
    input  wire [(8*6)-1:0] snake_body,
    input  wire [4:0]  state,


    output wire [287:0] snake_index, // 蛇索引
    output wire snake_en, // 蛇使能信号
    output reg en_1, //开始计数器信号  
    output reg  en_2
);
parameter       	START   =5'd5,
					WIN	=5'd6;
reg [(8*6)-1:0] snake_roll_index;



always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        snake_roll_index <= {6'd0,6'd0,6'd0,6'd0,6'd0,6'd0,6'd0,6'd0};
    end
    else if (roll_cnt == 1'b1)begin
        if (en_1 == 1'b1)begin
            snake_roll_index <= {water_index,snake_roll_index[47:6]};
        end
    end
end


always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        en_1 <= 1'b0;
        en_2    <= 1'b0;
    end
    else begin
        case (state)
        START:begin
            en_1 <= 1'b1;
        end 
        WIN:begin
            en_2 <= 1'b1;
        end
        default: begin
            en_1 <= 1'b0;
            en_2 <= 1'b0;
        end
    endcase
    end
end



assign snake_en = (water_index == 63)?1'b1:1'b0;
assign snake_index = (snake_en == 1'b1)?(snake_body):(snake_roll_index);
endmodule