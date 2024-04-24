module i2c_ctrl (
    input        wire   sys_clk,
    input        wire   sys_rst_n,
    output       wire    scl,
    inout        wire    sda
);
parameter I2C_DIV_FRQ = 5'd25;
parameter   IDLE = 2'd0,
            START = 2'd1,
            SLAVE_ID = 2'd2,
            STOP = 2'd3;
parameter   MAX = 1_000;
parameter   SLAVE = 7'h73;

reg         [1:0]         state_c     ;
reg         [1:0]         state_n     ;


reg         [5-1:0]     cnt_i2c    ; //计数器
wire                    add_cnt_i2c; //开始计数
wire                    end_cnt_i2c; //计数器最大值
reg                     i2c_clk ;//i2c时钟
reg          [2:0]      skip_en_1;//唤醒操作跳转时能
reg          [1:0]      cnt_i2c_clk;
reg          [9:0]      cnt_wait;
reg          [2:0]      cnt_bit;
reg                     i2c_end; // i2c结束寄存器
reg          [2:0]      step;//步骤计数寄存器
reg                     i2c_scl;//i2c驱动时钟
reg                     i2c_sda;//i2c数据寄存器
reg          [7:0]      slave_addr;//从机地址寄存器
wire                    sda_in;//从机输入信号
wire                    sda_en;//三态门开关

assign scl = i2c_scl;//i2c 驱动时钟输出

//三态门
assign sda_en = 1'b1;
assign sda_in = sda;
assign sda = (sda_en == 1'b1) ? i2c_sda : 1'bz;

always @(*) begin
    case (step)
        3'd0:slave_addr = {SLAVE,1'b0};//ID + 写 
        default: slave_addr =8'h00;
    endcase
end
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
         cnt_i2c <= 5'b0;
    end
    else if (add_cnt_i2c)begin
        if (end_cnt_i2c)begin
            cnt_i2c<=5'b0;
        end
        else begin
            cnt_i2c <= cnt_i2c +1'd1;
        end
    end
    else begin
        cnt_i2c <= cnt_i2c;
    end
end

assign add_cnt_i2c = 1'b1; 
assign end_cnt_i2c = add_cnt_i2c && (cnt_i2c == I2C_DIV_FRQ - 1'd1);

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        i2c_clk<=1'b0;
    end
    else if (end_cnt_i2c)begin
        i2c_clk <= ~i2c_clk;
    end
    else begin
        i2c_clk <= i2c_clk;
    end
end

//三段式状态机,第一段,时序逻辑
always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        state_c <= IDLE;
    end
    else begin
        state_c <= state_n;
    end
end

//第二段,组合逻辑
always @(*) begin
    case (state_c)
        IDLE: begin
            if (skip_en_1 == 1'b1)begin
                state_n = START ;
            end
            else begin
                state_n = IDLE ;
            end
        end 
        START: begin
            if (skip_en_1 == 1'b1)begin
                state_n = SLAVE_ID ;
            end
            else begin
                state_n = START ;
            end
        end
        SLAVE_ID: begin
            if (skip_en_1 == 1'b1)begin
                state_n = STOP ;
            end
            else begin
                state_n = SLAVE_ID ;
            end
        end
        STOP: begin
            if (skip_en_1 == 1'b1)begin
                state_n = START ;
            end
            else begin
                state_n = STOP ;
            end
        end
        default: state_n = IDLE ;
    endcase
end

//第三段 描述动作
always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        cnt_wait     <= 10'd0;
        skip_en_1    <= 1'b0;
        cnt_i2c_clk  <= 2'd0;
        cnt_bit      <= 3'd0;
        i2c_end      <= 1'b0;
        step         <= 3'd0;
    end
    else begin
        case (state_c)
            IDLE:    begin
                if (cnt_wait == MAX - 1'd1)begin
                    cnt_wait <= 10'd0;
                end
                else begin
                    cnt_wait <= cnt_wait + 1'd1;
                end
                if (cnt_wait == MAX - 2'd2)begin
                    skip_en_1 = 1'd1 ;
                end
                else begin
                    skip_en_1 = 1'd0 ;
                end
            end
            START:   begin
                cnt_i2c_clk <= cnt_i2c_clk + 1'd1;
                if (cnt_i2c_clk == 2'd2)begin
                    skip_en_1 = 1'd1 ;
                end
                else begin
                    skip_en_1 = 1'd0 ;
                end
            end
            SLAVE_ID:begin
                cnt_i2c_clk <= cnt_i2c_clk + 1'd1;

                if (cnt_i2c_clk == 2'd3)begin
                    cnt_bit <= cnt_bit + 1'd1;
                end
                else begin
                    cnt_bit <= cnt_bit;
                end

                if (cnt_bit == 3'd7 && cnt_i2c_clk == 2'd2)begin
                    skip_en_1 <= 1'd1;
                end
                else begin
                    skip_en_1 <= 1'd0;
                end
            end
            STOP:   begin
                cnt_i2c_clk <= cnt_i2c_clk + 1'd1;

                if (cnt_i2c_clk == 2'd2)begin
                    skip_en_1 <= 1'd1;
                    i2c_end <= 1'b1;
                end
                else begin
                    skip_en_1 <= 1'd0;
                    i2c_end <= 1'b0;
                end
                if (i2c_end == 1'b1)begin
                    step <= step + 1'b0;
                end
                else begin
                    step <= step ;
                end
            end
            default: begin
                cnt_wait     <= 10'd0;
                skip_en_1    <= 1'b0;
                cnt_i2c_clk  <= 2'd0;
                cnt_bit      <= 3'd0;
                i2c_end      <= 1'b0;
                step         <= step;
            end
        endcase
    end
end

//i2c_scl信号约束
always @(*) begin
    case (state_c)
        IDLE:begin
            i2c_scl = 1'b1;
        end  
        START:begin
            i2c_scl=cnt_i2c_clk < 2'd3;
        end
        SLAVE_ID:begin
            i2c_scl=(cnt_i2c_clk == 2'd3 || cnt_i2c_clk == 2'd0)? 1'd0:1'd1;
        end
        STOP:begin
            i2c_scl=cnt_i2c_clk > 2'd0;
        end
        default:    i2c_scl = 1'b1;
    endcase
end

//i2c_sda信号约束
always @(*) begin
    case (state_c)   
        IDLE:           i2c_sda = 1'b1;
        START:          i2c_sda = cnt_i2c_clk < 2'd2;
        SLAVE_ID:       i2c_sda = slave_addr[7-cnt_bit];
        default: i2c_sda=1'b1;
    endcase
end



endmodule