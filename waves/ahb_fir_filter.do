onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_ahb_fir_filter/clk
add wave -noupdate -radix binary /tb_ahb_fir_filter/n_rst
add wave -noupdate -divider inputs
add wave -noupdate -color Gold -radix binary /tb_ahb_fir_filter/hsel
add wave -noupdate -color Gold /tb_ahb_fir_filter/htrans
add wave -noupdate -color Gold /tb_ahb_fir_filter/haddr
add wave -noupdate -color Gold /tb_ahb_fir_filter/hsize
add wave -noupdate -color Gold -radix binary /tb_ahb_fir_filter/hwrite
add wave -noupdate -color Gold /tb_ahb_fir_filter/hwdata
add wave -noupdate -divider {coeff loader internals}
add wave -noupdate -color {Cadet Blue} /tb_ahb_fir_filter/DUT/ldr/current_state
add wave -noupdate /tb_ahb_fir_filter/DUT/ldr/new_coefficient_set
add wave -noupdate -color {Dark Orchid} /tb_ahb_fir_filter/DUT/ldr/modwait
add wave -noupdate /tb_ahb_fir_filter/DUT/ldr/load_coeff
add wave -noupdate /tb_ahb_fir_filter/DUT/ldr/coefficient_num
add wave -noupdate -divider {fir internal}
add wave -noupdate -color {Cornflower Blue} /tb_ahb_fir_filter/DUT/fir/cu/current_state
add wave -noupdate -color {Cornflower Blue} /tb_ahb_fir_filter/DUT/fir/sample_data
add wave -noupdate -color {Cornflower Blue} /tb_ahb_fir_filter/DUT/fir/fir_coefficient
add wave -noupdate -color {Cornflower Blue} /tb_ahb_fir_filter/DUT/fir/fir_out
add wave -noupdate -color {Cornflower Blue} -radix binary /tb_ahb_fir_filter/DUT/fir/err
add wave -noupdate -color {Cornflower Blue} /tb_ahb_fir_filter/DUT/data_ready_m
add wave -noupdate -divider status
add wave -noupdate -color {Indian Red} /tb_ahb_fir_filter/status
add wave -noupdate -radix unsigned /tb_ahb_fir_filter/current_transaction_num
add wave -noupdate /tb_ahb_fir_filter/current_transaction_error
add wave -noupdate -divider outputs
add wave -noupdate -color {Dark Orchid} /tb_ahb_fir_filter/hrdata
add wave -noupdate /tb_ahb_fir_filter/hresp
add wave -noupdate -divider regs
add wave -noupdate -color Salmon -radix hexadecimal /tb_ahb_fir_filter/DUT/sub/status_reg
add wave -noupdate -color Turquoise /tb_ahb_fir_filter/DUT/sub/result_reg
add wave -noupdate -label {0: new sample} /tb_ahb_fir_filter/DUT/sub/new_sample_reg
add wave -noupdate -color Gold /tb_ahb_fir_filter/DUT/sub/F0_reg
add wave -noupdate -color Gold /tb_ahb_fir_filter/DUT/sub/F1_reg
add wave -noupdate -color Gold /tb_ahb_fir_filter/DUT/sub/F2_reg
add wave -noupdate -color Gold /tb_ahb_fir_filter/DUT/sub/F3_reg
add wave -noupdate /tb_ahb_fir_filter/DUT/sub/new_coeff_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {688686 ps} 0}
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
WaveRestoreZoom {0 ps} {3633 ns}
