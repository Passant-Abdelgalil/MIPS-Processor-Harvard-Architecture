vsim -gui work.processor
add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/INPORT
add wave -position end  sim:/processor/OUTPORT
add wave -position end  sim:/processor/PC
add wave -position end  sim:/processor/instruction
add wave -position end  sim:/processor/INST_ADDR
add wave -position insertpoint sim:/processor/controlUnit/*
add wave -position insertpoint sim:/processor/RegisterFile/*
add wave -position insertpoint sim:/processor/alu/*
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
mem load -i instruction_memory2.mem -update_properties /processor/instructionMem/ram
run
force -freeze sim:/processor/rst 0 0
run
run
run
run
force -freeze sim:/processor/INPORT 0000000000000101 0
run
force -freeze sim:/processor/INPORT 0000000000010000 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run