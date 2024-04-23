module i2c_ctrl (
    input        wire   sys_clk,
    input        wire   sys_rst_n,

    output       reg   i2c_clk
);
parameter I2C_DIV_FRQ = 5'd25;
reg         [5-1:0]      cnt_i2c    ; //计数器
wire                    add_cnt_i2c; //开始计数
wire                    end_cnt_i2c; //计数器最大值
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
        i2c_clk<=~i2c_clk;
    end
    else begin
        i2c_clk <= i2c_clk;
    end
end



endmodule