module ges_recognize(
    input   wire        sys_clk    ,
    input   wire        sys_rst_n  ,
    
    output  wire        scl        ,
    inout   wire        sda        ,
    output  wire [3: 0] led
);
wire [2: 0]     step        ;
wire [5: 0]     cfg_num     ;
wire [15: 0]    cfg_data    ;
wire            cfg_start   ;
wire            i2c_clk     ;
wire            i2c_start   ;
wire [7: 0]     po_data     ;
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
endmodule