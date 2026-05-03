onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_ahb_subordinate/clk
add wave -noupdate -radix binary /tb_ahb_subordinate/n_rst
add wave -noupdate -divider inputs
add wave -noupdate -radix binary /tb_ahb_subordinate/clear_coeff
add wave -noupdate -radix unsigned /tb_ahb_subordinate/coefficient_num
add wave -noupdate /tb_ahb_subordinate/fir_out
add wave -noupdate -color Coral -radix binary /tb_ahb_subordinate/modwait
add wave -noupdate -radix binary /tb_ahb_subordinate/err
add wave -noupdate -divider internal
add wave -noupdate -color Yellow -radix binary /tb_ahb_subordinate/hsel
add wave -noupdate -color Yellow -radix unsigned /tb_ahb_subordinate/htrans
add wave -noupdate -color Yellow /tb_ahb_subordinate/haddr
add wave -noupdate -color Yellow -radix unsigned /tb_ahb_subordinate/hsize
add wave -noupdate -color Yellow -radix binary /tb_ahb_subordinate/hwrite
add wave -noupdate -color {Medium Slate Blue} /tb_ahb_subordinate/hwdata
add wave -noupdate -divider internal_reg
add wave -noupdate -color Goldenrod -radix binary /tb_ahb_subordinate/DUT/hsel_reg
add wave -noupdate -color Goldenrod /tb_ahb_subordinate/DUT/htrans_reg
add wave -noupdate -color Goldenrod /tb_ahb_subordinate/DUT/haddr_reg
add wave -noupdate -color Goldenrod -radix binary /tb_ahb_subordinate/DUT/hsize_reg
add wave -noupdate -color Goldenrod -radix binary /tb_ahb_subordinate/DUT/hwrite_reg
add wave -noupdate -divider {data ready}
add wave -noupdate -radix binary /tb_ahb_subordinate/DUT/data_ready_triggered
add wave -noupdate /tb_ahb_subordinate/DUT/dr_triggered1
add wave -noupdate /tb_ahb_subordinate/DUT/dr_triggered2
add wave -noupdate -color Gold -radix binary /tb_ahb_subordinate/data_ready
add wave -noupdate -divider status
add wave -noupdate /tb_ahb_subordinate/status
add wave -noupdate -radix unsigned /tb_ahb_subordinate/current_transaction_num
add wave -noupdate -radix binary /tb_ahb_subordinate/current_transaction_error
add wave -noupdate -divider outputs
add wave -noupdate /tb_ahb_subordinate/sample_data
add wave -noupdate -radix binary /tb_ahb_subordinate/new_coefficient_set
add wave -noupdate /tb_ahb_subordinate/fir_coefficient
add wave -noupdate -radix binary /tb_ahb_subordinate/DUT/is_raw
add wave -noupdate -color {Medium Slate Blue} /tb_ahb_subordinate/hrdata
add wave -noupdate -radix binary /tb_ahb_subordinate/hresp
add wave -noupdate -divider regs
add wave -noupdate /tb_ahb_subordinate/DUT/status_reg
add wave -noupdate /tb_ahb_subordinate/DUT/result_reg
add wave -noupdate /tb_ahb_subordinate/DUT/new_sample_reg
add wave -noupdate -color Orange /tb_ahb_subordinate/DUT/F0_reg
add wave -noupdate -color Orange /tb_ahb_subordinate/DUT/F1_reg
add wave -noupdate -color Orange /tb_ahb_subordinate/DUT/F2_reg
add wave -noupdate -color Orange /tb_ahb_subordinate/DUT/F3_reg
add wave -noupdate /tb_ahb_subordinate/DUT/new_coeff_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {131753 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 186
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {700 ps} {294700 ps}
