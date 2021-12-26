vsim -gui work.processor
mem load -i {D:/Mariam/College/Computer Architecture/Project ALU/inst_memory.mem} /processor/instructionMem/ram
add wave -position insertpoint sim:/processor/*
add wave -position insertpoint sim:/processor/controlUnit/*
add wave -position insertpoint sim:/processor/RegisterFile/*
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/PC 16#0000
force -freeze sim:/processor/rst 1
run
force -freeze sim:/processor/rst 0
noforce sim:/processor/PC
run