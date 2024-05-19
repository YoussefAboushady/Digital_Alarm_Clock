#CONSTRAINTS FILE

#clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

#reset
set_property PACKAGE_PIN V17 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

#enable
set_property PACKAGE_PIN V16 [get_ports enable]
set_property IOSTANDARD LVCMOS33 [get_ports enable]

#button up
set_property PACKAGE_PIN T18 [get_ports press[0]]						
set_property IOSTANDARD LVCMOS33 [get_ports press[0]]

#button right
set_property PACKAGE_PIN T17 [get_ports press[1]]						
set_property IOSTANDARD LVCMOS33 [get_ports press[1]]

#button down
set_property PACKAGE_PIN U17 [get_ports press[2]]						
set_property IOSTANDARD LVCMOS33 [get_ports press[2]]

#button left
set_property PACKAGE_PIN W19 [get_ports press[3]]						
set_property IOSTANDARD LVCMOS33 [get_ports press[3]]

#button center
set_property PACKAGE_PIN U18 [get_ports press[4]]						
set_property IOSTANDARD LVCMOS33 [get_ports press[4]]

#bcd 7-segments
set_property PACKAGE_PIN W7 [get_ports segments[6]]
set_property IOSTANDARD LVCMOS33 [get_ports segments[6]]
set_property PACKAGE_PIN W6 [get_ports segments[5]]
set_property IOSTANDARD LVCMOS33 [get_ports segments[5]]
set_property PACKAGE_PIN U8 [get_ports segments[4]]
set_property IOSTANDARD LVCMOS33 [get_ports segments[4]]
set_property PACKAGE_PIN V8 [get_ports segments[3]]
set_property IOSTANDARD LVCMOS33 [get_ports segments[3]]
set_property PACKAGE_PIN U5 [get_ports segments[2]]
set_property IOSTANDARD LVCMOS33 [get_ports segments[2]]
set_property PACKAGE_PIN V5 [get_ports segments[1]]
set_property IOSTANDARD LVCMOS33 [get_ports segments[1]]
set_property PACKAGE_PIN U7 [get_ports segments[0]]
set_property IOSTANDARD LVCMOS33 [get_ports segments[0]]

#common anode (digit to be displayed)
set_property PACKAGE_PIN W4 [get_ports anode_active[3]]
set_property IOSTANDARD LVCMOS33 [get_ports anode_active[3]]
set_property PACKAGE_PIN V4 [get_ports anode_active[2]]
set_property IOSTANDARD LVCMOS33 [get_ports anode_active[2]]
set_property PACKAGE_PIN U4 [get_ports anode_active[1]]
set_property IOSTANDARD LVCMOS33 [get_ports anode_active[1]]
set_property PACKAGE_PIN U2 [get_ports anode_active[0]]
set_property IOSTANDARD LVCMOS33 [get_ports anode_active[0]]

#led 0 (first one on the right)
set_property PACKAGE_PIN U16 [get_ports led0]						
set_property IOSTANDARD LVCMOS33 [get_ports led0]

#leds 12-15 (show state of adjust mode)
set_property PACKAGE_PIN L1 [get_ports leds[15]]						
set_property IOSTANDARD LVCMOS33 [get_ports leds[15]]

set_property PACKAGE_PIN P1 [get_ports leds[14]]						
set_property IOSTANDARD LVCMOS33 [get_ports leds[14]]

set_property PACKAGE_PIN N3 [get_ports leds[13]]						
set_property IOSTANDARD LVCMOS33 [get_ports leds[13]]

set_property PACKAGE_PIN P3 [get_ports leds[12]]						
set_property IOSTANDARD LVCMOS33 [get_ports leds[12]]

#decimal point
set_property PACKAGE_PIN V7 [get_ports decimal]						
set_property IOSTANDARD LVCMOS33 [get_ports decimal]

#to avoid errors
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets decimal_OBUF]

set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets det_center/re/led0_OBUF_inst_i_2_n_0]

set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets det_center/re/count[3]_i_3]
