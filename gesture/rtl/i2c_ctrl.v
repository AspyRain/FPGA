module i2c_ctrl(
    input   wire sys_clk    ,
    input   wire sys_rst_n  ,
    output  wire scl        ,
    inout   wire sda
);
parameter I2C_DIV_FRQ = 5'd25;
parameter MAX           = 10'd1000;//1000us
parameter SLAVE         = 7'h73;//器件ID
parameter IDLE          = 4'd0,
          START         = 4'd1,
          SLAVE_ID      = 4'd2,
          ACK_1         = 4'd3,
          DEVICE_ADDR   = 4'd4,
          ACK_2         = 4'd5,
          DATA          = 4'd6,
          ACK_3         = 4'd7,
          NACK          = 4'd8,
          STOP          = 4'd9;

reg [3: 0] state_c;//现态
reg [3: 0] state_n;//次态
reg [9: 0] cnt_wait;//1000us计数寄存器
reg [1: 0] cnt_i2c_clk;//i2c驱动时钟计数寄存器
reg [4: 0] cnt_i2c;//i2c时钟计数寄存器
reg [2: 0] cnt_bit;//8位计数寄存器
wire       add_cnt_i2c;
wire       end_cnt_i2c;
reg        i2c_clk;//i2c时钟
reg        i2c_end;//i2c结束寄存器
reg        i2c_scl;//i2c驱动时钟
reg        i2c_sda;//i2c数据寄存器

reg        skip_en_1;//唤醒操作跳转使能
reg        skip_en_2;//激活bank0跳转使能
reg        skip_en_3;//配置0x00寄存器跳转使能
reg        skip_en_4;//0x00寄存器跳转使能
reg        err_en   ;//错误使能

reg [2: 0] step     ;//步骤计数寄存器
reg [7: 0] slave_addr;//从机地址寄存器
reg [7:0]  device_addr;
reg [7:0]   wr_data;
reg [7:0]   recv_data;
wire       sda_in    ;//从机输入信号
wire       sda_en    ;//三态门开关
reg       ack          ;//从机的应答
assign scl = i2c_scl;//i2c驱动时钟输出
//三态门
assign sda_en = ((state_c == ACK_1)||(state_c == ACK_2)||(state_c == ACK_3)||((state_c == DATA ) && (step == 3'd3)))?1'b0:1'b1;
assign sda_in = sda;
assign sda    = (sda_en == 1'b1)? i2c_sda: 1'bz;
always @(*)begin
    case(step)
        3'd0:       slave_addr = {SLAVE, 1'b0};//ID + 写
        3'd1:       begin
            slave_addr   =  {SLAVE,1'b0};//ID + 写
            device_addr  =  {8'hef};//bank0地址 
            wr_data      =  {8'h00};//0x00寄存器
        end
        // 3步修改代码 
        3'd2:       begin
            slave_addr   =  {SLAVE,1'b0};//ID + 写
            device_addr  =  {8'h00};//0x00寄存器 地址
        end
        // 第四步增加代码
        3'd3:     begin
            slave_addr = {SLAVE,1'b1};
        end
        default: begin
            slave_addr = 8'h00;
            device_addr= 8'h00;
            wr_data    = 8'h00;
        end
        
    endcase
end 
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        cnt_i2c <= 5'd0;
    end 
    else if(add_cnt_i2c)begin
        if(end_cnt_i2c)begin
            cnt_i2c <= 5'd0;
        end 
        else begin
            cnt_i2c <= cnt_i2c + 1'd1;
        end 
    end 
    else begin
        cnt_i2c <= cnt_i2c;
    end 
end
assign add_cnt_i2c = 1'b1;
assign end_cnt_i2c = add_cnt_i2c && cnt_i2c == I2C_DIV_FRQ - 1'd1;
//i2c_clk信号约束
always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        i2c_clk <= 1'b0;
    end 
    else if(end_cnt_i2c)begin
        i2c_clk <= ~i2c_clk;
    end 
    else begin
        i2c_clk <= i2c_clk;
    end 
end
//三段式状态机，第一段，实训逻辑
always @(posedge i2c_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        state_c <= IDLE;
    end 
    else begin
        state_c <= state_n;
    end 
end 
//第二段，组合逻辑，状态转移
always @(*)begin
    case(state_c)
        IDLE:       begin
                        if((skip_en_1 == 1'b1) || (skip_en_2 == 1'b1) || (skip_en_3 == 1'd1)|| (skip_en_4 == 1'd1))begin
                           state_n = START; 
                        end
                        else begin
                            state_n = IDLE;
                        end 
                    end 
        START:      begin
                        if((skip_en_1 == 1'b1) || (skip_en_2 == 1'b1)||(skip_en_3 == 1'b1) || (skip_en_4 == 1'd1))begin
                            state_n = SLAVE_ID;
                        end 
                        else begin
                            state_n = START;
                        end 
                    end 
        SLAVE_ID:   begin
                        if(skip_en_1 == 1'b1 )begin
                            state_n = STOP;
                        end 
                        else if ((skip_en_2 == 1'b1 )||(skip_en_3 == 1'b1)|| (skip_en_4 == 1'd1))begin
                            state_n = ACK_1;
                        end
                        else begin
                            state_n = SLAVE_ID;
                        end 
                    end 
        ACK_1:      begin
                        if ((skip_en_2 == 1'b1) ||(skip_en_3 == 1'b1))begin
                            state_n = DEVICE_ADDR;
                        end
                        else begin
                            state_n = ACK_1;
                        end   
        end
        DEVICE_ADDR:begin
                        if ((skip_en_2 == 1'b1) ||(skip_en_3 == 1'b1))begin
                            state_n = ACK_2;
                        end
                        else begin
                            state_n = DEVICE_ADDR;
                        end
        end
        ACK_2      :begin
                        if (skip_en_2 == 1'b1)begin
                            state_n = DATA;
                        end
                        else if (skip_en_3 == 1'b1)begin
                            state_n = STOP;
                        end
                        else begin
                            state_n = ACK_2;
                        end
        end
        DATA       :begin
                        if (skip_en_2 == 1'b1)begin
                            state_n = ACK_3;
                        end
                        else if (skip_en_4 == 1'b1)begin
                            state_n = NACK ;
                        end
                        else if (err_en == 1'b1)begin
                            state_n = IDLE ;
                        end
                        else begin
                            state_n = DATA ; 
                        end
        end
        NACK        :begin
                        if (skip_en_4 == 1'b1)begin
                            state_n = STOP;
                        end
                        else begin
                            state_n = NACK;
                        end
        end
        ACK_3       :begin
                        if (skip_en_2 == 1'b1)begin
                            state_n = STOP;
                        end
                        else begin
                            state_n = ACK_3;
                        end
        end                                 
        STOP    :   begin
                        if((skip_en_1 == 1'b1) || (skip_en_2 == 1'b1) ||(skip_en_3 == 1'b1)|| (skip_en_4 == 1'd1))begin
                            state_n = IDLE;
                        end 
                        else begin
                            state_n = STOP;
                        end 
                    end 
        default: state_n = IDLE;
    endcase
end 
//第三段，描述动作
always @(posedge i2c_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        cnt_wait    <= 10'd0;
        
        skip_en_1   <= 1'b0 ;
        skip_en_2   <= 1'b0;
        skip_en_3   <= 1'b0;
        skip_en_4   <= 1'b0;

        cnt_i2c_clk <= 2'd0 ;
        cnt_bit     <= 3'd0 ;
        i2c_end     <= 1'b0 ;
        step        <= 3'd0 ;
    end 
    else begin
        case(state_c)
            IDLE:       begin
                            if( cnt_wait == MAX - 1'd1)begin
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
                        end 
            START:      begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;//0~3

                            if((cnt_i2c_clk == 2'd2) && (step == 3'd0))begin
                                skip_en_1 <= 1'b1;
                            end  
                            else begin
                                skip_en_1 <= 1'b0;
                            end

                            if((cnt_i2c_clk == 2'd2)  && (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end  

                            if((cnt_i2c_clk == 2'd2)  && (step == 3'd2))begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end  

                            if((cnt_i2c_clk == 2'd2)  && (step == 3'd3))begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end  
                        end 
            SLAVE_ID:   begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;
                            if(cnt_i2c_clk == 2'd3 && cnt_bit == 3'd7)begin
                                cnt_bit <= 3'd0;
                            end
                            else if(cnt_i2c_clk == 2'd3)begin
                                cnt_bit <= cnt_bit + 1'd1;
                            end 
                            else begin
                                cnt_bit <= cnt_bit;
                            end 

                            if(cnt_i2c_clk == 2'd2 && cnt_bit == 3'd7 &&  (step == 3'd0))begin
                                skip_en_1 <= 1'b1;
                            end 
                            else begin
                                skip_en_1 <= 1'b0;
                            end 

                            if(cnt_i2c_clk == 2'd2 && cnt_bit == 3'd7 &&  (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end 

                            if(cnt_i2c_clk == 2'd2 && cnt_bit == 3'd7 &&  (step == 3'd2))begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end 

                            if(cnt_i2c_clk == 2'd2 && cnt_bit == 3'd7 &&  (step == 3'd3))begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end 
                        end
            ACK_1:      begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;

                            if ((ack == 1'b1)&&(cnt_i2c_clk == 3'd2)&& (step==3'd1))begin
                                skip_en_2 <= 1'b1;
                            end
                            else begin
                                skip_en_2 <= 1'b0;
                            end

                            if ((ack == 1'b1)&&(cnt_i2c_clk == 3'd2)&& (step==3'd2))begin
                                skip_en_3 <= 1'b1;
                            end
                            else begin
                                skip_en_3 <= 1'b0;
                            end

                            if ((ack == 1'b1)&&(cnt_i2c_clk == 3'd2)&& (step==3'd3))begin
                                skip_en_4 <= 1'b1;
                            end
                            else begin
                                skip_en_4 <= 1'b0;
                            end
            end
            DEVICE_ADDR:begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;

                            if(cnt_i2c_clk == 2'd3 && cnt_bit == 3'd7)begin
                                cnt_bit <= 3'd0;
                            end
                            else if(cnt_i2c_clk == 2'd3)begin
                                cnt_bit <= cnt_bit + 1'd1;
                            end 
                            else begin
                                cnt_bit <= cnt_bit;
                            end 


                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) &&  (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end 

                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) &&  (step == 3'd2))begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end 

                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) &&  (step == 3'd3))begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end 
                        end
            ACK_2:      begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;

                            if ((ack == 1'b1)&&(cnt_i2c_clk == 3'd2)&& (step==3'd1))begin
                                skip_en_2 <= 1'b1;
                            end
                            else begin
                                skip_en_2 <= 1'b0;
                            end

                            if ((ack == 1'b1)&&(cnt_i2c_clk == 3'd2)&& (step==3'd2))begin
                                skip_en_3 <= 1'b1;
                            end
                            else begin
                                skip_en_3 <= 1'b0;
                            end

                            if ((ack == 1'b1)&&(cnt_i2c_clk == 3'd2)&& (step==3'd3))begin
                                skip_en_4 <= 1'b1;
                            end
                            else begin
                                skip_en_4 <= 1'b0;
                            end
            end
            DATA:       begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;
                            if((cnt_i2c_clk == 2'd3) && (cnt_bit == 3'd7))begin
                                cnt_bit <= 3'd0;
                            end
                            else if(cnt_i2c_clk == 2'd3)begin
                                cnt_bit <= cnt_bit + 1'd1;
                            end 
                            else begin
                                cnt_bit <= cnt_bit;
                            end 

                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) &&  (step == 3'd1))begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end

                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) &&  (step == 3'd3) && (recv_data == 8'h20))begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end

                            if((cnt_i2c_clk == 2'd2) && (cnt_bit == 3'd7) &&  (step == 3'd3) && (recv_data != 8'h20))begin
                                err_en <= 1'b1;
                                step   <= 3'd0;
                            end 
                            else begin
                                err_en <= 1'b0;
                                step   <= step;
                            end

            end 
            NACK :      begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;
                            if ((ack == 1'b1)&&(cnt_i2c_clk == 3'd2)&& (step==3'd3))begin
                                skip_en_4 <= 1'b1;
                            end
                            else begin
                                skip_en_4 <= 1'b0;
                            end
            end 
            ACK_3:      begin
                             cnt_i2c_clk <= cnt_i2c_clk + 1'd1;
                            if ((ack == 1'b1)&&(cnt_i2c_clk == 3'd2)&& (step==3'd1))begin
                                skip_en_2 <= 1'b1;
                            end
                            else begin
                                skip_en_2 <= 1'b0;
                            end
            end
            STOP:       begin
                            cnt_i2c_clk <= cnt_i2c_clk + 1'd1;
                            if((cnt_i2c_clk == 2'd2)  && (step == 3'd0) )begin
                                skip_en_1 <= 1'b1;
                            end 
                            else begin
                                skip_en_1 <= 1'b0;
                            end
                            
                            if((cnt_i2c_clk == 2'd2)  && (step == 3'd1) )begin
                                skip_en_2 <= 1'b1;
                            end 
                            else begin
                                skip_en_2 <= 1'b0;
                            end

                            if((cnt_i2c_clk == 2'd2)  && (step == 3'd2) )begin
                                skip_en_3 <= 1'b1;
                            end 
                            else begin
                                skip_en_3 <= 1'b0;
                            end

                            if((cnt_i2c_clk == 2'd2)  && (step == 3'd3) )begin
                                skip_en_4 <= 1'b1;
                            end 
                            else begin
                                skip_en_4 <= 1'b0;
                            end

                            if (cnt_i2c_clk == 2'd2)begin
                                step <= step + 1'd1;
                            end
                            else begin
                                step <= step ;
                            end     
                        end 
            default:    begin
                            cnt_wait    <= 10'd0;
                            skip_en_1   <= 1'b0 ;
                            skip_en_2   <= 1'b0 ;
                            skip_en_3   <= 1'b0 ;
                            skip_en_4   <= 1'b0 ;
                            cnt_i2c_clk <= 2'd0 ;
                            cnt_bit     <= 3'd0 ;
                            i2c_end     <= 1'b0 ;
                            step        <= step ;                    
                        end 
        endcase
    end 
end 

always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        recv_data <= 8'h0;
    end
    else if ((cnt_i2c_clk == 1'b1) && (step == 3'd3) && (state_c == DATA)) begin
        recv_data <= {recv_data[6:0],sda_in};
        
    end
    else begin
        recv_data <= recv_data;
    end
end

//ack信号约束
always @(*) begin
    case (state_c)
        ACK_1,ACK_2,ACK_3:begin
                    ack = ~(sda_in);
        end  
        NACK:             begin
                    ack = i2c_sda; 
        end
        default: ack = 1'b0;
    endcase
end

//i2c_scl信号约束
always @(*)begin
    case(state_c)
        IDLE:       i2c_scl = 1'b1;
        START:      i2c_scl = cnt_i2c_clk < 2'd3;
        SLAVE_ID,
        DEVICE_ADDR,
        DATA,
        ACK_1,
        ACK_2,
        ACK_3,
        NACK:   i2c_scl = (cnt_i2c_clk == 2'd1) || (cnt_i2c_clk == 2'd2);
        STOP:       i2c_scl = cnt_i2c_clk > 2'd0;
        default:    i2c_scl = 1'b1;
    endcase
end 
//i2c_sda信号约束
always @(*)begin
    case(state_c)
        IDLE,NACK:              i2c_sda = 1'b1;
        START:             i2c_sda = cnt_i2c_clk < 2'd2;
        SLAVE_ID:          i2c_sda = slave_addr[7 - cnt_bit];//msb
        DEVICE_ADDR:       i2c_sda = device_addr[7- cnt_bit];
        DATA        :      i2c_sda = wr_data[7- cnt_bit];
        ACK_1,ACK_2,ACK_3: 
                           i2c_sda = 1'b0;
        STOP:              i2c_sda = cnt_i2c_clk > 2'd1;
        default:           i2c_sda = 1'b1;
    endcase
end 



endmodule 