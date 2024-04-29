module tubu(
    input               clk     ,
    input               rst_n   ,
    input  [3:0]        score_data    ,   //分数 
	
    output reg  [5:0]   sel     ,   // 片选
    output reg  [7:0]   dig         // 段选
);

    reg     [3:0]       count   ;   //计数1s
    parameter   ZER = 8'b1100_0000,
                ONE = 8'b1111_1001,
                TWO = 8'b1010_0100,
                THR = 8'b1011_0000,
                FOU = 8'b1001_1001,
                FIV = 8'b1001_0010,
                SIX = 8'b1000_0010,
                SEV = 8'b1111_1000,
                EIG = 8'b1000_0000,
                NIN = 8'b1001_0000;


    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            sel <= 6'b011_111;
        end else begin  
            case (score_data)
                4'd0: dig <= ZER;
                4'd1: dig <= ONE;
                4'd2: dig <= TWO;
                4'd3: dig <= THR;
                4'd4: dig <= FOU;
                4'd5: dig <= ZER;
                4'd6: dig <= SIX;
                4'd7: dig <= SEV;
                4'd8: dig <= EIG;
                4'd9: dig <= NIN;
                default: dig <= 8'b1111_1111; // default 显示空
            endcase
            sel <= 6'b011_111; // 选择秒的个位，也可以根据需求选择不同的片选
        end
    end

endmodule