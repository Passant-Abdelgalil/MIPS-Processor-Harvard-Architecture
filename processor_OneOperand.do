vsim -gui work.processor
# vsim -gui work.processor 
# Start time: 14:17:23 on Jan 07,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.processor(processor1)
# Loading work.mux_1_2(mux_1_2)
# Loading work.reg(reg)
# Loading work.instructionram(instructionmem)
# Loading work.pc_increment(pc_increment)
# Loading work.f_d_buffer(f_d_buffer_arch)
# Loading work.decoder_mux(structure)
# Loading work.register_file(register_file_structal)
# Loading work.r_register(register_structal)
# Loading work.control_unit(instance)
# Loading work.de_ex_reg(deexreg)
# Loading work.forwardingunit(funit)
# Loading work.mux_2_4(mux_2_4)
# Loading work.alu(alu_arch)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.parta(parta_arch)
# Loading work.partb(partb_arch)
# Loading work.n_adder(nadder)
# Loading work.adder(modeladder)
# Loading work.ex_mem_reg(exmemreg)
# Loading work.memorystage(instance)
# Loading work.sp_address_unit(instance)
# Loading work.sp_entity(sp_instance)
# Loading work.memo_data_mux(instance)
# Loading work.memo_address_mux(instance)
# Loading work.ram(syncrama)
# Loading work.m_w_buffer(m_w_buffer_arch)
# vsim -gui work.processor 
# Start time: 14:14:33 on Jan 07,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.processor(processor1)
# Loading work.mux_1_2(mux_1_2)
# Loading work.reg(reg)
# Loading work.instructionram(instructionmem)
# Loading work.pc_increment(pc_increment)
# Loading work.f_d_buffer(f_d_buffer_arch)
# Loading work.decoder_mux(structure)
# Loading work.register_file(register_file_structal)
# Loading work.r_register(register_structal)
# Loading work.control_unit(instance)
# Loading work.de_ex_reg(deexreg)
# Loading work.forwardingunit(funit)
# Loading work.mux_2_4(mux_2_4)
# Loading work.alu(alu_arch)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.parta(parta_arch)
# Loading work.partb(partb_arch)
# Loading work.n_adder(nadder)
# Loading work.adder(modeladder)
# Loading work.ex_mem_reg(exmemreg)
# Loading work.memorystage(instance)
# Loading work.sp_address_unit(instance)
# Loading work.sp_entity(sp_instance)
# Loading work.memo_data_mux(instance)
# Loading work.memo_address_mux(instance)
# Loading work.ram(syncrama)
# Loading work.m_w_buffer(m_w_buffer_arch)
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
mem load -i D:/GitHub/ArchProject/instruction_memory2.mem -update_properties /processor/instructionMem/ram
run
force -freeze sim:/processor/rst 0 0
run
run
run
run
force -freeze sim:/processor/INPORT 0000000000000101 0
run
force -freeze sim:/processor/INPORT 0000000000001010 0
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