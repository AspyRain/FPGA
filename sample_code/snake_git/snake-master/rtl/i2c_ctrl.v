module i2c_ctrl(
    input   wire         sys_clk     ,
    input   wire         sys_rst_n   ,
    input   wire         i2c_start   ,
    input   wire [5: 0]  cfg_num     ,
    input   wire [15: 0] cfg_data    ,

    output  reg          cfg_start   ,
    output  reg  [2: 0]  step        ,
    output  reg          i2c_clk     ,
    output  wire         scl         ,
    inout   wire         sda         ,
    output  reg  [7: 0]  po_data    


);
parameter I2C_CLK_DIV = 5'd24,
          MAX = 10'd1000,
          SLAVE_ID = 7'h73;
//状态机参数定义
parameter IDLE          = 4'd0,
          START         = 4'd1,
          SLAVE_ADDR    = 4'd2,
          ACK_1         = 4'd3,
          ACK_2         = 4'd4,
          ACK_3         = 4'd5,
          DEVICE_ADDR   = 4'd6,
          DATA          = 4'd7,
          WAIT          = 4'd8,
          NACK          = 4'd9, 
          STOP          = 4'd10;
reg [3: 0] state_c;
reg [3: 0] state_n;
////

//i2c时钟计数器
reg [4: 0] cnt_clk;
/////

//中间信号定义
reg [9: 0]  cnt_wait    ;//1000us
reg         skip_en_1   ;//步骤1跳转信号,唤醒
reg         skip_en_2   ;//步骤2跳转信号,激活bank0
reg         skip_en_3   ;//步骤3跳转信号,配置0x00
reg         skip_en_4   ;//步骤4跳转信号,读取0x20
reg         skip_en_5   ;//步骤5跳转信号,配置51寄存器
reg         skip_en_6   ;//步骤6跳转信号,配置0x43
reg         skip_en_7   ;//步骤7跳转信号,读取0x43
reg [1: 0]  cnt_i2c_clk ;//i2c计数器
reg [2: 0]  cnt_bit     ;//bit计数器
reg         i2c_end     ;//i2c结束信号
wire        sda_en      ;
wire        sda_in      ;
reg         i2c_sda     ;
reg         i2c_scl     ;
reg [7: 0]  slave_addr  ;
reg [7: 0]  device_addr ;
reg [7: 0]  wr_data     ;
reg [7: 0]  recv_data   ;//接受0x20寄存器
reg         ack         ;//接受信号
reg         err_en      ;//接受到0x20有误
//三态门
assign sda_en  = ((state_c == ACK_1) || (state_c == ACK_2) || (state_c == ACK_3) || (state_c == DATA && (step == 3'd3 || step == 3'd6))) ? 1'b0: 1'b1;//发送主机控制从机，接受主机释放
assign sda_in  = sda;
assign sda     = (sda_en == 1'b1)? i2c_sda : 1'bz;
//cfg_start
always @(posedge i2c_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        cfg_start <= 1'b0;
    end 
    else begin
        cfg_start <= i2c_end;//延迟一个时钟输出
    end 
end 
//i2c驱动时钟设计
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        cnt_clk <= 5'd0;
    end 
    else if(cnt_clk == I2C_CLK_DIV)begin
        cnt_clk <= 5'd0;
    end 
    else begin
        cnt_clk <= cnt_clk + 1;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        i2c_clk <= 1'b1;
    end 
    else if(cnt_clk == I2C_CLK_DIV)begin
        i2c_clk <= ~i2c_clk;
    end
    else begin
        i2c_clk <= i2c_clk;
    end 
end
/////////
//状态机，第一段
always @(posedge i2c_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        state_c <= IDLE;
    end 
    else begin
        state_c <= state_n;
    end
end
//状态机第二段
always @(*)begin
    case(state_c)
        IDLE:       if((skip_en_1 == 1'b1) || (skip_en_2 == 1'b1) || (skip_en_3 == 1'b1) || (skip_en_4 == 1'b1) || (skip_en_5 == 1'b1) || (skip_en_6 == 1'b1) || (skip_en_7 == 1'b1))begin
                        state_n = START;
                    end
                    else begin
                        state_n = IDLE;
                    end 
        START:      if((skip_en_1 == 1'b1) || (skip_en_2 == 1'b1) || (skip_en_3 == 1'b1) || (skip_en_4 == 1'b1) || (skip_en_5 == 1'b1) || (skip_en_6 == 1'b1) || (skip_en_7 == 1'b1))begin
                        state_n = SLAVE_ADDR;
                    end 
                    else begin
                        state_n = START;
                    end
        SLAVE_ADDR: if(skip_en_1 == 1'b1)begin
                        state_n = WAIT;
                    end 
                    else if((skip_en_2 == 1'b1) || (skip_en_3 == 1'b1) || (skip_en_4 == 1'b1) || (skip_en_5 == 1'b1) || (skip_en_6 == 1'b1) || (skip_en_7 == 1'b1))begin
                        state_n = ACK_1;
                    end 
                    else begin
                        state_n = SLAVE_ADDR;
                    end 
        ACK_1:      if((skip_en_2 == 1'b1) || (skip_en_3 == 1'b1) || (skip_en_5 == 1'b1) || (skip_en_6 == 1'b1))begin
                        state_n = DEVICE_ADDR;
                    end 
                    else if((skip_en_4 == 1'b1) || (skip_en_7 == 1'b1))begin
                        state_n = DATA;
                    end 
                    else begin
                        state_n = ACK_1;
                    end 
        DEVICE_ADDR:if((skip_en_2 == 1'b1) || (skip_en_3 == 1'b1) || (skip_en_5 == 1'b1) || (skip_en_6 == 1'b1))begin
                        state_n = ACK_2;
                    end 
                    else begin
                        state_n = DEVICE_ADDR;
                    end 
        ACK_2:      if((skip_en_2 == 1'b1) || (skip_en_5 == 1'b1))begin
                        state_n = DATA;
                    end 
                    else if((skip_en_3 == 1'b1) || (skip_en_6 == 1'b1))begin
                        state_n = STOP;
                    end 
                    else begin
                        state_n = ACK_2;
                    end 
        DATA:       if((skip_en_2 == 1'b1) || (skip_en_5 == 1'b1))begin
                        state_n = ACK_3;
                    end  
                    else if((skip_en_4 == 1'b1) || (skip_en_7 == 1'b1))begin
                        state_n = NACK;
                    end 
                    else if(err_en == 1'b1)begin
                        state_n = IDLE;
                    end 
                    else begin
                        state_n = DATA;
                    end 
        NACK:       if((skip_en_4 == 1'b1) || (skip_en_7 == 1'b1))begin
                        state_n = STOP;
                    end 
                    else begin
                        state_n = NACK;
                    end 
        ACK_3:      if((skip_en_2 == 1'b1) || (skip_en_5 == 1'b1))begin
                        state_n = STOP;
                    end 
                    else begin
                        state_n = ACK_3;
                    end 
        WAIT:       if(skip_en_1 == 1'b1)begin
                        state_n = STOP;
                    end 
                    else begin
                        state_n = WAIT;
                    end 
        STOP:       if((skip_en_1 == 1'b1) || (skip_en_2 == 1'b1) || (skip_en_3 == 1'b1) || (skip_en_4 == 1'b1) || (skip_en_5 == 1'b1) || (skip_en_6 == 1'b1) || (skip_en_7 == 1'b1))begin
                        state_n = IDLE;
                    end 
                    else begin
                        state_n = STOP;
                    end 
        default:    begin
                        state_n = IDLE;
                    end
    endcase
end 
//状态机第三段
always @(posedge i2c_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        cnt_wait    <= 10'd0;
        skip_en_1   <= 1'b0;//步骤1跳转信号
        skip_en_2   <= 1'b0;//步骤2跳转信号
        skip_en_3   <= 1'b0;//步骤3跳转信号
        skip_en_4   <= 1'b0;//步骤4跳转信号
        skip_en_5   <= 1'b0;//步骤5跳转信号
        skip_en_6   <= 1'b0;//步骤6跳转信号
        skip_en_7   <= 1'b0;//步骤7跳转信号
        step        <= 3'd0;
        err_en      <= 1'b0;
        cnt_i2c_clk <= 2'd0;
        cnt_bit     <= 3'd0;
        i2c_end     <= 1'b0;
    end 
    else begin
        case(state_c)
            IDLE:       begin
                            if(cnt_wait == MAX - 1)begin
                                cnt_wait <= 10'd0;
                            end
                            else begin
                                cnt_wait <= cnt_wait + 1;
                            end 
                            if((cnt_wait == MAX - 2'd2) && (step == 3'd0))begin
                                skip_en_1 <= 1'b1;
                            end 
                            else begin
                                skip_en_1 <= 1'b0;
                            end 
                            if((cnt_wait == MAX - 2'd2) && (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end 
                            if((cnt_wait == MAX - 2'd2) && (step == 3'd2))begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end 
                            if((cnt_wait == MAX - 2'd2) && (step == 3'd3))begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end 
                            if((cnt_wait == MAX - 2'd2) && (step == 3'd4))begin
                                skip_en_5 <= 1'b1;
                            end 
                            else begin
                                skip_en_5 <= 1'b0;
                            end
                            if((cnt_wait == MAX - 2'd2) && (step == 3'd5))begin
                                skip_en_6 <= 1'b1;
                            end 
                            else begin
                                skip_en_6 <= 1'b0;
                            end  
                            if((cnt_wait == MAX - 2'd2) && (step == 3'd6))begin
                                skip_en_7 <= 1'b1;
                            end 
                            else begin
                                skip_en_7 <= 1'b0;
                            end  
                        end 
            START:      begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd0))begin
                                skip_en_1 <= 1'b1;
                            end 
                            else begin
                                skip_en_1 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd2))begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd3))begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd4))begin
                                skip_en_5 <= 1'b1;
                            end 
                            else begin
                                skip_en_5 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd5))begin
                                skip_en_6 <= 1'b1;
                            end 
                            else begin
                                skip_en_6 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd6))begin
                                skip_en_7 <= 1'b1;
                            end 
                            else begin
                                skip_en_7 <= 1'b0;
                            end 
                        end
            SLAVE_ADDR: begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;
                            if((cnt_i2c_clk == 2'd2)  && (step == 3'd0) && (cnt_bit == 3'd7))begin
                                skip_en_1 <= 1'b1;
                            end 
                            else begin
                                skip_en_1 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd1) && (cnt_bit == 3'd7))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd2) && (cnt_bit == 3'd7))begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd3) && (cnt_bit == 3'd7))begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd4) && (cnt_bit == 3'd7))begin
                                skip_en_5 <= 1'b1;
                            end 
                            else begin
                                skip_en_5 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd5) && (cnt_bit == 3'd7))begin
                                skip_en_6 <= 1'b1;
                            end 
                            else begin
                                skip_en_6 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd6) && (cnt_bit == 3'd7))begin
                                skip_en_7 <= 1'b1;
                            end 
                            else begin
                                skip_en_7 <= 1'b0;
                            end 
                            if((cnt_bit == 3'd7) && (cnt_i2c_clk == 2'd3))begin
                                cnt_bit <= 3'd0;
                            end 
                            else if(cnt_i2c_clk == 2'd3)begin
                                cnt_bit <= cnt_bit + 1'd1;
                            end
                            else begin
                                cnt_bit <= cnt_bit;
                            end 
                        end
            ACK_1:      begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end 
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd2))begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end 
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd3))begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end 
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd4))begin
                                skip_en_5 <= 1'b1;
                            end 
                            else begin
                                skip_en_5 <= 1'b0;
                            end 
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd5))begin
                                skip_en_6 <= 1'b1;
                            end 
                            else begin
                                skip_en_6 <= 1'b0;
                            end 
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd6))begin
                                skip_en_7 <= 1'b1;
                            end 
                            else begin
                                skip_en_7 <= 1'b0;
                            end 
                        end 
            DEVICE_ADDR:begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'b1;
                            if((cnt_i2c_clk == 2'd3) && (cnt_bit == 3'd7))begin
                                cnt_bit <= 3'd0;
                            end 
                            else if(cnt_i2c_clk == 2'd3)begin
                                cnt_bit <= cnt_bit + 1'b1;
                            end
                            else begin
                                cnt_bit <= cnt_bit;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) && (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) && (step == 3'd2))begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) && (step == 3'd4))begin
                                skip_en_5 <= 1'b1;
                            end 
                            else begin
                                skip_en_5 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) && (step == 3'd5))begin
                                skip_en_6 <= 1'b1;
                            end 
                            else begin
                                skip_en_6 <= 1'b0;
                            end 
                        end 
            ACK_2:      begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1;
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end 
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd2))begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end 
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd4))begin
                                skip_en_5 <= 1'b1;
                            end 
                            else begin
                                skip_en_5 <= 1'b0;
                            end 
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd5))begin
                                skip_en_6 <= 1'b1;
                            end 
                            else begin
                                skip_en_6 <= 1'b0;
                            end 
                        end 
            DATA:       begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'b1;
                            if((cnt_i2c_clk == 2'd3) && (cnt_bit == 3'd7))begin
                                cnt_bit <= 3'd0;
                            end 
                            else if(cnt_i2c_clk == 2'd3)begin
                                cnt_bit <= cnt_bit + 1'b1;
                            end 
                            else begin
                                cnt_bit <= cnt_bit;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) && (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end  
                            else begin
                                skip_en_2 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) && (step == 3'd3) && (recv_data == 8'h20))begin
                                skip_en_4 <= 1'b1;
                            end  
                            else begin
                                skip_en_4 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) && (step == 3'd4))begin
                                skip_en_5 <= 1'b1;
                            end  
                            else begin
                                skip_en_5 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) && (step == 3'd6))begin
                                skip_en_7 <= 1'b1;
                            end  
                            else begin
                                skip_en_7 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) && (step == 3'd3) && (recv_data != 8'h20))begin
                                begin
                                    err_en <= 1'b1;
                                    step <= 3'd0;
                                end 
                            end 
                            else begin
                                begin
                                    err_en <= 1'b0;
                                    step <= step;
                                end 
                            end 
                        end 
            NACK:       begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1;
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd3))begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end 
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd6))begin
                                skip_en_7 <= 1'b1;
                            end 
                            else begin
                                skip_en_7 <= 1'b0;
                            end 
                        end 
            ACK_3:      begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1;
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end 
                            if((ack == 1'b1) && (cnt_i2c_clk == 2'd2) && (step == 3'd4))begin
                                skip_en_5 <= 1'b1;
                            end 
                            else begin
                                skip_en_5 <= 1'b0;
                            end 
                        end 
            WAIT:       begin
                            if(cnt_wait == MAX - 1'd1)begin
								cnt_wait <= 10'd0;
                            end 
                            else begin
                                cnt_wait <= cnt_wait + 1'd1;
                            end 
                            if((cnt_wait == MAX - 2'd2) && (step == 3'd0))begin
                                skip_en_1 <= 1'b1;
                            end 
                            else begin
                                skip_en_1 <= 1'b0;
                            end
                        end
            STOP:       begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd0))begin
                                skip_en_1 <= 1'b1;
                            end 
                            else begin
                                skip_en_1 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd2))begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd3))begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd4))begin
                                skip_en_5 <= 1'b1;
                            end 
                            else begin
                                skip_en_5 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd5))begin
                                skip_en_6 <= 1'b1;
                            end 
                            else begin
                                skip_en_6 <= 1'b0;
                            end 
                            if((cnt_i2c_clk == 2'd2) && (step == 3'd6))begin
                                skip_en_7 <= 1'b1;
                            end 
                            else begin
                                skip_en_7 <= 1'b0;
                            end 
                            if(cnt_i2c_clk == 2'd2)begin
                                i2c_end <= 1'b1;
                            end 
                            else begin
                                i2c_end <= 1'b0;
                            end 
                            if((i2c_end == 1'b1) && ((step <= 3'd3) || step == 3'd5))begin
                                step <= step + 1'd1;
                            end 
                            else if((i2c_end == 1'b1) && (step == 3'd4) && (cfg_num == 6'd51))begin
                                step <= step + 1'd1;
                            end 
                            else begin
                                step <= step;                                    
                            end 
                        end 
            default:    begin
                            cnt_wait    <= 10'd0;
                            skip_en_1   <= 1'b0;
                            skip_en_2   <= 1'b0;
                            skip_en_3   <= 1'b0;
                            skip_en_4   <= 1'b0;
                            skip_en_5   <= 1'b0;
                            skip_en_6   <= 1'b0;
                            skip_en_7   <= 1'b0;
                            err_en      <= 1'b0;
                            step        <= step;
                            cnt_i2c_clk <= 2'd0;
                            cnt_bit     <= 3'd0;
                            i2c_end     <= 1'b0;
                        end 
        endcase
    end 
end 
//recv_data
always @(posedge i2c_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        recv_data <= 8'h0;
    end 
    else begin
        case(state_c)
            DATA:   begin
                        if((cnt_i2c_clk == 2'd1) && ((step == 3'd3) || (step == 3'd6)))begin
                            recv_data <= {recv_data[6:0], sda_in};
                        end 
                        else begin
                            recv_data <= recv_data;
                        end 
                    end 
            default: recv_data <= recv_data;
        endcase
    end 
end 
//ack
always @(*)begin
    case(state_c)
        ACK_1, ACK_2, ACK_3:    ack = ~sda_in;
        NACK:                   ack = i2c_sda;//主机发送NACK
        default:                ack = 1'b0;
    endcase
end 
//step
always @(*)begin
    case(step)
        3'd0:   begin
                    slave_addr = {SLAVE_ID, 1'b0};
                    device_addr = 8'h0;
                    wr_data     = 8'h0;
                end
        3'd1:   begin
                    slave_addr = {SLAVE_ID, 1'b0};
                    device_addr= {8'hef};
                    wr_data    = {8'h00};
                end 
        3'd2:   begin
                    slave_addr = {SLAVE_ID, 1'b0};
                    device_addr= {8'h00};
                    wr_data    = {8'h00};
                end
        3'd3:   begin
                    slave_addr = {SLAVE_ID, 1'b1};//读取
                    device_addr= {8'h00};
                    wr_data    = {8'h00};
                end
        3'd4:   begin
                    slave_addr = {SLAVE_ID, 1'b0};
                    device_addr= cfg_data[15: 8];
                    wr_data    = cfg_data[7: 0];
                end 
        3'd5:   begin
                    slave_addr = {SLAVE_ID, 1'b0};//配置
                    device_addr= 8'h43;
                    wr_data    = 8'h00;
                end 
        3'd6:   begin
                    slave_addr = {SLAVE_ID, 1'b1};//读取
                    device_addr= 8'h43;
                    wr_data    = 8'h00;
                end 
        default:begin
                    slave_addr  = 8'h0;
                    device_addr = 8'h0;
                    wr_data     = 8'h0;
                end
    endcase
end 
//i2c_scl
always @(*)begin
    case(state_c)
        IDLE:       i2c_scl = 1'b1;
        START:      i2c_scl = (cnt_i2c_clk <= 2'd2) ? 1'b1 : 1'b0;
        SLAVE_ADDR, DEVICE_ADDR, DATA, ACK_1, ACK_2, ACK_3, NACK: 
                    i2c_scl = ((cnt_i2c_clk == 2'd1) || (cnt_i2c_clk == 2'd2)) ? 1'b1 : 1'b0; 
        WAIT:       i2c_scl = 1'b0;
        STOP:       i2c_scl = (cnt_i2c_clk >= 2'd1) ? 1'b1 : 1'b0;    
    endcase
end 
//i2c_sda
always @(*)begin
    case(state_c)
        IDLE:       i2c_sda = 1'b1;
        START:      i2c_sda = (cnt_i2c_clk > 2'd1) ? 1'b0 : 1'b1;
        SLAVE_ADDR: i2c_sda = slave_addr[7 - cnt_bit];
        DEVICE_ADDR:i2c_sda = device_addr[7 - cnt_bit];
        DATA:       if((step == 3'd3) || (step == 3'd6))begin
                        i2c_sda = sda_in;
                    end
                    else begin
                        i2c_sda = wr_data[7 - cnt_bit];
                    end
        ACK_1, ACK_2, ACK_3:
                    i2c_sda = 1'b0;
        WAIT:       i2c_sda = 1'b0;
        NACK:       i2c_sda = 1'b1;//主机给从机发1 
        STOP:       i2c_sda = (cnt_i2c_clk >= 2'd2) ? 1'b1 : 1'b0;
        default:    i2c_sda = 1'b1;
    endcase
end 
assign scl = i2c_scl;
always @(posedge i2c_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        po_data <= 8'h0;
    end 
    else if((state_c == DATA) && (step == 3'd6) && (cnt_bit == 3'd7) && (cnt_i2c_clk == 2'd3) && (recv_data != 8'h00))begin
        po_data <= recv_data;
    end  
    else begin
        po_data <= po_data;
    end 
end 
endmodule