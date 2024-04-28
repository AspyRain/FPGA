module counter_key (
    input           clk     ,
    input           rst_n   ,
    output [16:0]   dout    ,
    input           key     ,
    output     reg      flag    
);

    parameter TIME_1S = 20_000_000;

    reg     [25:0]      cnt         ;   //计数1s
    wire                add_cnt     ;
    wire                end_cnt     ;

    reg     [5:0]       cnts        ;   //计数60s
    wire                add_cnts     ;
    wire                end_cnts     ;

    reg     [5:0]       cntm        ;   //计数60m
    wire                add_cntm    ;
    wire                end_cntm    ;
    
    reg     [4:0]       cnth        ;   //计数24h
    wire                add_cnth    ;
    wire                end_cnth    ;

    reg     [4:0]       cnt1s      ;   //计数24h
    wire                add_cnt1s     ;
    wire                end_cnt1s     ;

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin
            cnt1s <= 0;
        end 
        else if(add_cnt1s)begin 
            if(end_cnt1s)begin 
                cnt1s <= 0;
            end
            else begin 
                cnt1s <= cnt1s + 1;
            end 
        end
        else begin 
            cnt1s <= cnt1s;
        end 
    end 
    assign add_cnt1s = end_cnt && key == 1'b1;
    assign end_cnt1s = add_cnt1s && cnt1s == 1;
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin
            cnt <= 0;
        end 
        else if(add_cnt)begin 
            if(end_cnt)begin 
                cnt <= 0;
            end
            else begin 
                cnt <= cnt + 1;
            end 
        end
        else begin 
            cnt <= cnt;
        end 
    end 
    assign add_cnt = 1'b1;
    assign end_cnt = add_cnt && cnt ==  TIME_1S - 1;

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin
            cnts <= 0;
        end 
        else if(add_cnts)begin 
            if(end_cnts)begin 
                cnts <= 0;
            end
        else   if (key==1'b1&&cnt1s==1)begin
            cnts <= cnts + 6'd10;
        end
            else begin 
                cnts <= cnts + 1;
            end 
        end
        else begin 
            cnts <= cnts;
        end 
    end 
    assign add_cnts = end_cnt;
    assign end_cnts = add_cnts && cnts == 59 ;

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin
            cntm <= 0;
        end 
        else if(add_cntm)begin 
            if(end_cntm)begin 
                cntm <= 0;
            end
            else begin 
                cntm <= cntm + 1;
            end 
        end
        else begin 
            cntm <= cntm;
        end 
    end 
    assign add_cntm = end_cnts;
    assign end_cntm = add_cntm && cntm == 59;

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin
            cnth <= 0;
        end 
        else if(add_cnth)begin 
            if(end_cnth)begin 
                cnth <= 0;
            end
            else begin 
                cnth <= cnth + 1;
            end 
        end
        else begin 
            cnth <= cnth;
        end 
    end 
    assign add_cnth = end_cntm;
    assign end_cnth = add_cnth && cnth == 23;

    assign dout = {cnth,cntm,cnts};
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)begin
            flag <= 1'b0 ;
        end
        else if (cntm==6'b0&&cnts==6'd10)begin
            flag <= 1'b1 ;
        end
        else if (cnts == 6'd20)begin
            flag <= 1'b0;
        end
        else begin
            flag <= flag;
        end
    end

endmodule