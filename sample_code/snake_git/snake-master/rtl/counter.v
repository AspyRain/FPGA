module counter #(parameter TIME_MS=1000,parameter TIME_MAX=10)(
    input   wire        sys_clk     ,
    input   wire        sys_rst_n   ,

    output  reg [10:0] cnt_out
);

    parameter   TIME_1MS = 50_000;//默认十进制 1s/20ns
    parameter   couter_time = TIME_1MS * TIME_MS;
    reg         [25:0]      cnt     ; //计数器
    wire                    add_cnt1; //开始计数
    wire                    end_cnt1; //计数器最大值
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)begin
            cnt <= 26'b0;
        end
        else if (cnt == couter_time - 1)begin
            cnt <= 26'b0;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
    //过了多少秒
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)begin
            cnt_out <= 10'b0; // ==>cnt1 <= 0
        end
        else if(add_cnt1)begin //开启计数器
            if (end_cnt1)begin
                cnt_out <= 10'b0;
            end
            else begin
                cnt_out <= cnt_out+1'b1;
            end
        end
        else begin
            cnt_out <= cnt_out;
        end
    end
    assign add_cnt1 = cnt ==    couter_time - 1;
    assign end_cnt1 = cnt_out==TIME_MAX - 1&& add_cnt1;

endmodule