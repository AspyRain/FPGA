module led_ctrl(
    input   wire        sys_clk     ,
    input   wire        sys_rst_n   ,
    input   wire [7: 0] po_data     ,

    output  reg  [3: 0] led
);
wire [3: 0] data;
assign data = po_data[3: 0];
always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        led <= 4'b0000;
    end 
    else begin
        led <= data;
    end
end 

endmodule