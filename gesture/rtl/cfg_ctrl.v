module cfg_ctrl (
    input           wire                    i2c_clk     ,//i2c时钟，和i2c_ctrl同步
    input           wire                    sys_rst_n   ,
    input           wire        [2:0]       step        ,//满足( step == 4 )工作
    input           wire                    cfg_start   ,//什么时候开始配置


    output          reg        [5:0]       cfg_num     ,//当前是第几个数据
    output          wire        [15:0]      cfg_data    ,//数据    
    output          reg                    i2c_start    //数据就绪             
);
//cfg_num

always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        cfg_num <= 6'd0;
    end
    else if ((cfg_start == 1'b1) && (step == 3'd4))begin
        cfg_num <= cfg_num +1'd1;
    end
    else begin
        cfg_num <= cfg_num;
    end
end 

//i2c_start
always @(posedge i2c_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        i2c_start <= 1'b0;
    end
    else if ((cfg_start == 1'b1) && (step == 3'd4))begin
        i2c_start <= 1'b1;
    end
    else begin
        i2c_start <= 1'b0;
    end
end

wire    [15:0]  data[50:0];//配置数据

assign cfg_data = (step == 3'd4)?data[cfg_num - 1]:16'h0000;
assign data[00] = {8'hEF,8'h00};
assign data[01] = {8'h37,8'h07};
assign data[02] = {8'h38,8'h17};
assign data[03] = {8'h39,8'h06};
assign data[04] = {8'h42,8'h01};
assign data[05] = {8'h46,8'h2D};
assign data[06] = {8'h47,8'h0F};
assign data[07] = {8'h48,8'h3C};
assign data[08] = {8'h49,8'h00};
assign data[09] = {8'h4A,8'h1E};
assign data[10] = {8'h4C,8'h20};
assign data[11] = {8'h51,8'h10};
assign data[12] = {8'h5E,8'h10};
assign data[13] = {8'h60,8'h27};
assign data[14] = {8'h80,8'h42};
assign data[15] = {8'h81,8'h44};
assign data[16] = {8'h82,8'h04};
assign data[17] = {8'h8B,8'h01};
assign data[18] = {8'h90,8'h06};
assign data[19] = {8'h95,8'h0A};
assign data[20] = {8'h96,8'h0C};
assign data[21] = {8'h97,8'h05};
assign data[22] = {8'h9A,8'h14};
assign data[23] = {8'h9C,8'h3F};
assign data[24] = {8'hA5,8'h19};
assign data[25] = {8'hCC,8'h19};
assign data[26] = {8'hCD,8'h0B};
assign data[27] = {8'hCE,8'h13};
assign data[28] = {8'hCF,8'h64};
assign data[29] = {8'hD0,8'h21};
assign data[30] = {8'hEF,8'h01};
assign data[31] = {8'h02,8'h0F};
assign data[32] = {8'h03,8'h10};
assign data[33] = {8'h04,8'h02};
assign data[34] = {8'h25,8'h01};
assign data[35] = {8'h27,8'h39};
assign data[36] = {8'h28,8'h7F};
assign data[37] = {8'h29,8'h08};
assign data[38] = {8'h3E,8'hFF};
assign data[39] = {8'h5E,8'h3D};
assign data[40] = {8'h65,8'h96};
assign data[41] = {8'h67,8'h97};
assign data[42] = {8'h69,8'hCD};
assign data[43] = {8'h6A,8'h01};
assign data[44] = {8'h6D,8'h2C};
assign data[45] = {8'h6E,8'h01};
assign data[46] = {8'h72,8'h01};
assign data[47] = {8'h73,8'h35};
assign data[48] = {8'h74,8'h00};
assign data[49] = {8'h77,8'h01};
assign data[50] = {8'hEF,8'h00};//bank0激活



endmodule