onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_controller/clk
add wave -noupdate -radix binary /tb_controller/n_rst
add wave -noupdate -divider inputs
add wave -noupdate -color Cyan -radix binary /tb_controller/dr
add wave -noupdate -color Yellow -radix binary /tb_controller/lc
add wave -noupdate -radix binary /tb_controller/overflow
add wave -noupdate -divider state
add wave -noupdate /tb_controller/DUT/current_state
add wave -noupdate /tb_controller/state
add wave -noupdate -divider outputs
add wave -noupdate -radix binary /tb_controller/op
add wave -noupdate -radix unsigned /tb_controller/src1
add wave -noupdate -radix unsigned /tb_controller/src2
add wave -noupdate -radix unsigned /tb_controller/dest
add wave -noupdate -radix binary /tb_controller/cnt_up
add wave -noupdate -radix binary /tb_controller/clear
add wave -noupdate -color {Dark Orchid} /tb_controller/DUT/modwait_next
add wave -noupdate -color {Dark Orchid} -radix binary /tb_controller/modwait
add wave -noupdate -radix binary /tb_controller/err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {168607 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {122143 ps} {222656 ps}
