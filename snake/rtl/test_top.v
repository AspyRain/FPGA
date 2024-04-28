module test_top(
    input  wire sys_clk,
    input  wire sys_rst_n,

    output  wire        scl        ,
    inout   wire        sda        ,
    
    output  wire [3: 0] led,
    output wire dout,

    output  [5:0]   sel     ,
    //xkc
    output  [3:0]   my_sel  ,
    output          move    ,
	output       snake_clk	,
	output       snake_clk1  ,
    output  [23:0] count    ,
    output [4:0]     state,
    output [4:0] next_state,
    output [5:0] score_position,
    output            en_random,  
    output  [31:0] lfsr_state,

    output  [7:0]   dig     ,
    output  [2:0]  snake_len   ,
    output         flag_add,
    input           key     ,
    output          pwm     
);
wire [4: 0]  cnt_bit    ;  
wire [6: 0]  cnt_pixel  ;
wire         bit        ;
wire [3: 0]  ges_data   ;

wire [(8*6)-1:0]   snake_body;
wire [(8*6)-1:0]   snake_index;

wire [7:0]   po_data;
wire [2: 0]     step        ;
wire [5: 0]     cfg_num     ;
wire [15: 0]    cfg_data    ;
wire            cfg_start   ;
wire            i2c_clk     ;
wire            i2c_start   ;
wire            roll_cnt    ;
wire [5:0]      water_index;
wire snake_en;


    wire    [16:0]  dout_beep    ;
    wire           flag=1'b1    ; // Assuming flag is an input or an internal signal


    // beep        inst_beep(
    //     .clk        (sys_clk     ),
    //     .rst_n      (sys_rst_n   ),
    //     .flag      (flag    ),
    //     .pwm       (pwm     )
    // );

ws2812_ctrl ws2812_ctrl_inst(
.sys_clk     (sys_clk   ),
.sys_rst_n   (sys_rst_n ),
.bit         (bit       ),

.cnt_bit     (cnt_bit   ),
.cnt_pixel   (cnt_pixel ),
.dout        (dout      )
);

data_cfg    data_cfg_inst(
.cnt_bit     (cnt_bit   ),
.cnt_pixel   (cnt_pixel ),
.ges_data    (ges_data  ),
.cnt_in      (cnt_index),
.snakebody_data  (snake_body),
.start_show_data(snake_index),
.score_position(score_position),
.bit         (bit       )
);

my_snake   my_snake_inst(
.sys_clk    (sys_clk    ),
.sys_rst_n  (sys_rst_n),
.po_data    (po_data     ),
.snake_body (snake_body  ),
.move       (move        ),
.sel        (my_sel        ),
.snake_clk  (snake_clk   ),
.snake_clk1 (snake_clk1  ),
.count      (count       ),
.score_position(score_position),
.en_random  (en_random   ),
.snake_len  (snake_len   ),
.flag_add   (flag_add    ),
.snake_en   (snake_en    ),
.lfsr_state (lfsr_state)
);

paj7620_cfg paj7620_cfg_inst(
.i2c_clk        (i2c_clk    ),
.sys_rst_n      (sys_rst_n  ),
.cfg_start      (cfg_start  ),
.step           (step       ),

.cfg_num        (cfg_num    ),
.cfg_data       (cfg_data   ),
.i2c_start      (i2c_start  )
);
i2c_ctrl    i2c_ctrl_inst(
.sys_clk        (sys_clk    ),
.sys_rst_n      (sys_rst_n  ),
.i2c_start      (i2c_start  ),
.cfg_num        (cfg_num    ),
.cfg_data       (cfg_data   ),

.cfg_start      (cfg_start  ),
.step           (step       ),
.i2c_clk        (i2c_clk    ),
.scl            (scl        ),
.sda            (sda        ),
.po_data        (po_data    )

);

led_ctrl    led_ctrl_inst(
.sys_clk        (sys_clk    ),
.sys_rst_n      (sys_rst_n  ),
.po_data        (po_data    ),
          
.led            (led        )
);
start_roll start_roll(
.sys_clk     (sys_clk   ),
.sys_rst_n   (sys_rst_n ),
.water_index    (water_index),
.roll_cnt       (roll_cnt),
.snake_body     (snake_body),

.snake_index (snake_index),
.snake_en   (snake_en)
);

counter#(
    .TIME_MS(20),    // TIME_MS参数的值为100
    .TIME_MAX(64)      // TIME_MAX参数的值为5
  )      counter_inst_2(
.sys_clk     (sys_clk   ),
.sys_rst_n   (sys_rst_n ),
.cnt_en      (~snake_en),
.add_cnt1    (roll_cnt),
.cnt_out     (water_index)
);

endmodule