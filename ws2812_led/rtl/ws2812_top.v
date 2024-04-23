module ws2812_top(
    input  wire sys_clk,
    input  wire sys_rst_n,

    output wire dout
);
wire [4: 0]  cnt_bit    ;  
wire [6: 0]  cnt_pixel  ;
wire         bit        ;
wire [3: 0]  ges_data   ;
wire [3:0 ]  cnt_counter ;
wire [3:0]   cnt_in_data;
assign cnt_in_data = (cnt_counter>3)?(6-cnt_counter):(cnt_counter);

ws2812_ctrl ws2812_ctrl_inst(
.sys_clk     (sys_clk   ),
.sys_rst_n   (sys_rst_n ),
.bit         (bit       ),//01数据

.cnt_bit     (cnt_bit   ),
.cnt_pixel   (cnt_pixel ),
.dout        (dout      )
);
data_cfg    data_cfg_inst(
.cnt_bit     (cnt_bit   ),
.cnt_pixel   (cnt_pixel ),
.ges_data    (ges_data  ),
.cnt_in      (cnt_counter),

.bit         (bit       )
);
counter#(
    .TIME_MS(1000),    // TIME_MS参数的值为100
    .TIME_MAX(3)      // TIME_MAX参数的值为5
  )      counter_inst(
.sys_clk     (sys_clk   ),
.sys_rst_n   (sys_rst_n ),
.cnt_out     (cnt_counter)
);
endmodule