onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fir_filter/clk
add wave -noupdate /tb_fir_filter/n_rst
add wave -noupdate -divider status
add wave -noupdate /tb_fir_filter/status
add wave -noupdate -divider state
add wave -noupdate /tb_fir_filter/DUT/cu/current_state
add wave -noupdate -divider inputs
add wave -noupdate /tb_fir_filter/sample_data
add wave -noupdate /tb_fir_filter/fir_coefficient
add wave -noupdate -color Yellow -radix binary /tb_fir_filter/load_coeff
add wave -noupdate -color Violet -radix binary /tb_fir_filter/data_ready
add wave -noupdate -divider internals
add wave -noupdate -color Yellow -radix binary /tb_fir_filter/DUT/cu/lc
add wave -noupdate -color Violet -radix binary /tb_fir_filter/DUT/cu/dr
add wave -noupdate /tb_fir_filter/DUT/dp/ext_data1
add wave -noupdate /tb_fir_filter/DUT/dp/ext_data2
add wave -noupdate -radix unsigned /tb_fir_filter/DUT/src1_m
add wave -noupdate -radix unsigned /tb_fir_filter/DUT/src2_m
add wave -noupdate -radix unsigned /tb_fir_filter/DUT/dest_m
add wave -noupdate /tb_fir_filter/DUT/dp/dest_data
add wave -noupdate -divider outputs
add wave -noupdate -radix binary /tb_fir_filter/one_k_samples
add wave -noupdate -color Gold /tb_fir_filter/DUT/cu/modwait_next
add wave -noupdate -color {Medium Slate Blue} -radix binary /tb_fir_filter/modwait
add wave -noupdate /tb_fir_filter/fir_out
add wave -noupdate -radix binary /tb_fir_filter/err
add wave -noupdate -divider regs
add wave -noupdate -expand -subitemconfig {{/tb_fir_filter/DUT/dp/RF/regs_matrix[10]} {-color {Cornflower Blue}} {/tb_fir_filter/DUT/dp/RF/regs_matrix[8]} {-color Gold} {/tb_fir_filter/DUT/dp/RF/regs_matrix[7]} {-color Gold} {/tb_fir_filter/DUT/dp/RF/regs_matrix[6]} {-color Gold} {/tb_fir_filter/DUT/dp/RF/regs_matrix[5]} {-color Gold} {/tb_fir_filter/DUT/dp/RF/regs_matrix[4]} {-color Violet} {/tb_fir_filter/DUT/dp/RF/regs_matrix[3]} {-color Violet} {/tb_fir_filter/DUT/dp/RF/regs_matrix[2]} {-color Violet} {/tb_fir_filter/DUT/dp/RF/regs_matrix[1]} {-color Violet}} /tb_fir_filter/DUT/dp/RF/regs_matrix
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {380999 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {355027 ps} {522702 ps}
