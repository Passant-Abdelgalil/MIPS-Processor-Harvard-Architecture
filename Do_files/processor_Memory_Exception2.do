vsim -gui work.processor
add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/INPORT
add wave -position end  sim:/processor/OUTPORT
add wave -position end  sim:/processor/PC
add wave -position end  sim:/processor/instruction
add wave -position end  sim:/processor/exception_one
add wave -position end  sim:/processor/exception_two
add wave -position end  sim:/processor/CF
add wave -position end  sim:/processor/ZF
add wave -position end  sim:/processor/NF
add wave -position end  sim:/processor/memoryStage/SP_address_mux/SP_output
add wave -position end  sim:/processor/PC_en
add wave -position end  sim:/processor/RegisterFile/q0
add wave -position end  sim:/processor/RegisterFile/q1
add wave -position end  sim:/processor/RegisterFile/q2
add wave -position end  sim:/processor/RegisterFile/q3
add wave -position end  sim:/processor/RegisterFile/q4
add wave -position end  sim:/processor/RegisterFile/q5
add wave -position end  sim:/processor/RegisterFile/q6
add wave -position end  sim:/processor/RegisterFile/q7
add wave -position end sim:/processor/exception_PC/*
mem load -i instruction_memory.mem -update_properties /processor/instructionMem/ram
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/processor/rst 0 0
force -freeze sim:/processor/INPORT x"0019" 0
run
force -freeze sim:/processor/INPORT x"ffff" 0
run
force -freeze sim:/processor/INPORT x"f320" 0
run
force -freeze sim:/processor/INPORT x"0010" 0
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
run
run
run
run