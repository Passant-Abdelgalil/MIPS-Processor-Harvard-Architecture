vsim -gui work.processor
mem load -i {D:/Mariam/College/Computer Architecture/ProjectGit2/MIPS-Processor-Harvard-Architecture/instruction_memory2.mem} /processor/instructionMem/ram
add wave -position insertpoint sim:/processor/*
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/processor/INPORT 16#0030
force -freeze sim:/processor/rst 0
run
force -freeze sim:/processor/INPORT 16#0050
run
force -freeze sim:/processor/INPORT 16#0100
run
force -freeze sim:/processor/INPORT 16#0300
run