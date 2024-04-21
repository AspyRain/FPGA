module ledflow(
input clk,
input rstn,
output [3:0]led_o
);


parameter CNT_MAX = 26'd50000000;

reg [25:0] cnt_1s; 
wire flag_1s; 
reg[3:0] led_reg;


always@(posedge clk or negedge rstn) begin
    if(!rstn)
        cnt_1s <= 26'd0;
    else if(cnt_1s >= CNT_MAX - 26'd1) 
        cnt_1s <= 26'd0;
    else
        cnt_1s <= cnt_1s + 26'd1;
end

assign flag_1s = cnt_1s >= CNT_MAX + 26'd1;


always@(posedge clk or negedge rstn) begin
    if(!rstn)
        led_reg <= 4'b0000;
    else if(flag_1s) 
        if(led_reg == 8'b0000)
            led_reg <= 8'b1110;
        else
            led_reg <= {led_reg[2:0],led_reg[3]}; 
    else
        led_reg <= led_reg;
end

assign led_o = led_reg;
endmodule