transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/study/github/FPGA/gesture/rtl {D:/study/github/FPGA/gesture/rtl/i2c_ctrl.v}

