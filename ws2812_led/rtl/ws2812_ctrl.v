
`define T0H 4'd15
`define T0L 4'd40
`define T1H 4'd40
`define T1L 4'd40
`define RST 14'd15_000
module ws2812_ctrl (
    input   wire    sys_clk,
    input   wire    sys_rst_n,
    input   wire    bit,

    output  wire    dout
);

reg  [5:0]  cnt_0;//bit0计数寄存器
wire        add_cnt0;//bit0开始计数条件
wire        end_cnt0;//bit0结束计数条件

reg  [6:0]  cnt_1;//bit1计数寄存器
wire        add_cnt1;//bit1开始计数条件
wire        end_cnt1;//bit1结束计数条件

reg  [4:0]  cnt_bit;//24个bit计数寄存器
wire        add_cnt_bit;//24个bit开始计数条件
wire        end_cnt_bit;//24个bit结束计数条件

reg  [7:0]  cnt_led;//led计数寄存器
wire        add_cnt_led;//led开始计数条件
wire        end_cnt_led;//led结束计数条件

reg  [7:0]  cnt_rst;//rst计数寄存器
wire        add_cnt_rst;//rst开始计数条件
wire        end_cnt_rst;//rst结束计数条件

reg flag_rst;

//0 计数器
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        cnt_0 <= 6'b0;
    end
    else if(add_cnt0)begin
        if (end_cnt0)begin
            cnt_0 <= 6'd0;
        end
        else begin
            cnt_0 <= cnt_0 +6'b1;
        end
    end
    else begin
        cnt_0 <= 6'b0;
    end
end

assign add_cnt0 = ~bit && flag_rst == 0;//如果bit是0
assign end_cnt0 = add_cnt0 && (cnt_0 == `T0H + `T0L - 1);

//1 计数器
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        cnt_1 <= 7'd0;
    end
    else if (add_cnt1)begin
        if (end_cnt1)begin
            cnt_1 <= 7'd0;
        end
        else begin
            cnt_1 <= cnt_1 +1'd1;
        end
    end
    else begin
        cnt_1 <= 7'd0;
    end
end
assign add_cnt1 = bit && flag_rst == 0;
assign end_cnt1 = add_cnt1 && (cnt_1 == `T1H + `T1L - 1);

//cnt_bit 计数器设计
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        cnt_bit <= 5'd0;
    end
    else if (add_cnt_bit)begin
        if (end_cnt_bit)begin
            cnt_bit<=5'd0;
        end
        else begin
            cnt_bit <= cnt_bit +1'd1;
        end
    end
    else begin
        cnt_bit <= cnt_bit;
    end
end
assign add_cnt_bit = end_cnt0 || end_cnt1 ;
assign end_cnt_bit = add_cnt_bit && (cnt_bit == 5'd23);//24个bit结束计数条件成立


//cnt_led计数器设计
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
         cnt_led <= 7'd0;
    end
    else if (add_cnt_led)begin
        if (end_cnt_led)begin
            cnt_led<= 7'd0;
        end
        else begin
             cnt_led<= cnt_led +1'd1;
        end
    end
    else begin
        cnt_led <= cnt_led;
    end
end
assign add_cnt_led = end_cnt_bit;
assign end_cnt_led = add_cnt_led && (cnt_led == 7'd64);

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
         cnt_rst <= 5'd0;
    end
    else if (add_cnt_rst)begin
        if (end_cnt_rst)begin
            cnt_rst<=14'd0;
        end
        else begin
            cnt_rst <= cnt_rst +1'd1;
        end
    end
    else begin
        cnt_rst <= cnt_rst;
    end
end
assign add_cnt_rst = end_cnt_led && flag_rst;
assign end_cnt_rst = add_cnt_led && (cnt_rst == `RST - 1 );

//flag_rst寄存器设计
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        flag_rst <= 1'b0;//初始化0 ，复位计数器关闭
    end
    else if (end_cnt_led)begin
        flag_rst <= 1'b1;// 64 个 led数据发送完成,复位计数器打开
    end
    else if (end_cnt_rst)begin
        flag_rst <= 1'b0; //复位计数器结束,复位计数器关闭
    end
    else begin
        flag_rst <= flag_rst; // 其他时候保持不变
    end
end
//数据输出
assign dout = (flag_rst == 0 )?( (cnt_0 < `T0H ? 1'b0 : 1'b1)|(cnt_1 < `T1H ? 1'b0 : 1'b1) ): 1'b0;
endmodule