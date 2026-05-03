onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_counter/clk
add wave -noupdate -radix binary /tb_counter/n_rst
add wave -noupdate -divider inputs
add wave -noupdate -radix binary /tb_counter/cnt_up
add wave -noupdate -radix binary /tb_counter/clear
add wave -noupdate -divider outputs
add wave -noupdate -radix binary /tb_counter/one_k_samples
add wave -noupdate /tb_counter/count
add wave -noupdate -radix unsigned /tb_counter/DUT/cnt/count_out
add wave -noupdate -radix unsigned /tb_counter/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22878273 ps} 0}
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
WaveRestoreZoom {22721740 ps} {23024467 ps}
