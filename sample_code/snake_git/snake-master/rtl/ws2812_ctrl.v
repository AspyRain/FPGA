module ws2812_ctrl(
    input   wire        sys_clk     ,
    input   wire        sys_rst_n   ,
    input   wire        bit         ,//01数据

    output  reg [4: 0]  cnt_bit     ,
    output  reg [6: 0]  cnt_pixel   ,
    output  wire        dout
);
parameter  T0H = 30     ,
           T0L = 15     ,
           T1H = 30     ,
           T1L = 30     ,
           RST = 15000  ;
reg [5: 0]  cnt_0       ;//bit0计数器
wire        add_cnt_0   ;
wire        end_cnt_0   ;

reg [5: 0]  cnt_1       ;//bit1计数器
wire        add_cnt_1   ;
wire        end_cnt_1   ;

//RGB计数器
wire        add_cnt_bit ;
wire        end_cnt_bit ;

//64个像素计数器
wire        add_cnt_pixel;
wire        end_cnt_pixel;

reg [13: 0] cnt_rst     ;//复位计数器
wire        add_cnt_rst ;
wire        end_cnt_rst ;
reg         flag_0      ;
reg         flag_1      ;
reg         flag_rst    ;
//bit0计数器设计
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        cnt_0 <= 0;
    end 
    else if(add_cnt_0)begin
        if(end_cnt_0)begin
            cnt_0 <= 0;
        end 
        else begin
            cnt_0 <= cnt_0 + 1;
        end 
    end
    else begin
        cnt_0 <= 0;
    end 
end
assign add_cnt_0 = flag_0 && flag_rst != 1'b1;
assign end_cnt_0 = add_cnt_0 && (cnt_0 == T0H + T0L -1);
//bit1计数器设计
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        cnt_1 <= 0;
    end 
    else if(add_cnt_1)begin
        if(end_cnt_1)begin
            cnt_1 <= 0;
        end 
        else begin
            cnt_1 <= cnt_1 + 1;
        end
    end 
    else begin
        cnt_1 <= 0;
    end 
end
assign add_cnt_1 = flag_1 && flag_rst != 1'b1;
assign end_cnt_1 = add_cnt_1 && (cnt_1 == T1H + T1L -1);
//RGB计数器设计
always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        cnt_bit <= 0;
    end 
    else if(add_cnt_bit)begin
        if(end_cnt_bit)begin
            cnt_bit <= 0;
        end 
        else begin
            cnt_bit <= cnt_bit + 1;
        end 
    end
    else begin
        cnt_bit <= cnt_bit;
    end 
end 
assign add_cnt_bit = end_cnt_0 || end_cnt_1;
assign end_cnt_bit = add_cnt_bit && (cnt_bit == 5'd23);
//64个像素计数器设计
always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        cnt_pixel <= 0;
    end 
    else if(add_cnt_pixel)begin
        if(end_cnt_pixel)begin
            cnt_pixel <= 0;
        end 
        else begin
            cnt_pixel <= cnt_pixel + 1;
        end 
    end
    else begin
        cnt_pixel <= cnt_pixel;
    end 
end 
assign add_cnt_pixel = end_cnt_bit;
assign end_cnt_pixel = add_cnt_pixel && (cnt_pixel == 7'd63);
//复位计数器设计
always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        cnt_rst <= 0;
    end 
    else if(add_cnt_rst)begin
        if(end_cnt_rst)begin
            cnt_rst <= 0;
        end 
        else begin
            cnt_rst <= cnt_rst + 1;
        end
    end 
    else begin
        cnt_rst <= 0;
    end     
end 
assign add_cnt_rst = flag_rst;
assign end_cnt_rst = add_cnt_rst && (cnt_rst == RST - 1);
//01判断器
always @(*)begin
    case(bit)
        0:  begin
                flag_0 = 1;
                flag_1 = 0;
            end
        1:  begin
                flag_0 = 0;
                flag_1 = 1;
            end 
    endcase
end 
//flag_rst约束
always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        flag_rst <= 0;
    end 
    else if(end_cnt_pixel)begin
        flag_rst <= 1;
    end 
    else if(end_cnt_rst)begin
        flag_rst <= 0;
    end 
    else begin
        flag_rst <= flag_rst;
    end 
end
assign dout = (flag_rst != 1'b1)? (((bit == 0) && (cnt_0 < T0L)) || ((bit == 1) &&(cnt_1 < T1L))): 1'b0;
endmodule 

