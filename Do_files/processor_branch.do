vsim -gui work.processor
add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/INPORT
add wave -position end  sim:/processor/OUTPORT
add wave -position end  sim:/processor/PC
add wave -position end  sim:/processor/instruction
add wave -position end sim:/processor/controlUnit/*
add wave -position end  sim:/processor/RegisterFile/*
add wave -position end  sim:/processor/alu/*
add wave -position end  sim:/processor/exception_one
add wave -position end  sim:/processor/exception_two
add wave -position end sim:/processor/memoryStage/*
add wave -position end sim:/processor/exception_PC/*
add wave -position end sim:/processor/memoryStage/SP_address_mux/SP/*
add wave -position end  sim:/processor/offset_D_E
add wave -position end  sim:/processor/offset_E_M
add wave -position end  sim:/processor/offset_M_W
add wave -position end  sim:/processor/src1_D_E
add wave -position end  sim:/processor/src2_D_E
add wave -position end  sim:/processor/src1_E_M
add wave -position end  sim:/processor/PC_en
add wave -position end  sim:/processor/new_PC
add wave -position end  sim:/processor/interrupt_address
add wave -position end  sim:/processor/execption_one_or_interrupt
add wave -position end  sim:/processor/exception_interrupt_address
add wave -position end  sim:/processor/pc_excp_interr_MUX_sel
add wave -position end  sim:/processor/pc_or_exception_interrupt
add wave -position end  sim:/processor/INST_ADDR
add wave -position end  sim:/processor/PC_withoutJump
add wave -position end  sim:/processor/final_PC
add wave -position end  sim:/processor/pc_or_rst_exception_interrupt
add wave -position end  sim:/processor/PC_F_D
add wave -position end  sim:/processor/PC_D_E
add wave -position end  sim:/processor/PC_E_M
add wave -position end  sim:/processor/PC_M_W
add wave -position end  sim:/processor/PC_en_D_E
add wave -position end  sim:/processor/PC_en_E_M
add wave -position end  sim:/processor/PC_en_M_W
add wave -position end  sim:/processor/Inst_F_D
add wave -position end  sim:/processor/offset_D_E
add wave -position end  sim:/processor/offset_E_M
add wave -position end  sim:/processor/offset_M_W
add wave -position end  sim:/processor/src1
add wave -position end  sim:/processor/src2
add wave -position end  sim:/processor/src1_D_E
add wave -position end  sim:/processor/src2_D_E
add wave -position end  sim:/processor/src1_E_M
add wave -position end  sim:/processor/src1_addr_D_E
add wave -position end  sim:/processor/src2_addr_D_E
add wave -position end  sim:/processor/F_D_en
add wave -position end  sim:/processor/D_E_en
add wave -position end  sim:/processor/E_M_en
add wave -position end  sim:/processor/M_W_en
add wave -position end  sim:/processor/ALU_src
add wave -position end  sim:/processor/ALU_src_D_E
add wave -position end  sim:/processor/ALU_en
add wave -position end  sim:/processor/ALU_en_D_E
add wave -position end  sim:/processor/indata_F_D
add wave -position end  sim:/processor/indata_D_E
add wave -position end  sim:/processor/indata_E_M
add wave -position end  sim:/processor/indata_M_WB
add wave -position end  sim:/processor/dest_D_E
add wave -position end  sim:/processor/dest_E_M
add wave -position end  sim:/processor/dest_M_W
add wave -position end  sim:/processor/ALU_op
add wave -position end  sim:/processor/ALU_op_D_E
add wave -position end  sim:/processor/src1_selected
add wave -position end  sim:/processor/src2_selected
add wave -position end  sim:/processor/ALU_op1
add wave -position end  sim:/processor/ALU_op2
add wave -position end  sim:/processor/ALU_res
add wave -position end  sim:/processor/ALU_res_E_M
add wave -position end  sim:/processor/final_write_data
add wave -position end  sim:/processor/final_write_data_W
add wave -position end  sim:/processor/IN_en
add wave -position end  sim:/processor/IN_en_D_E
add wave -position end  sim:/processor/IN_en_E_M
add wave -position end  sim:/processor/IN_en_M_W
add wave -position end  sim:/processor/OUT_en
add wave -position end  sim:/processor/OUT_en_D_E
add wave -position end  sim:/processor/OUT_en_E_M
add wave -position end  sim:/processor/OUT_en_M_W
add wave -position end  sim:/processor/MemRead
add wave -position end  sim:/processor/MemRead_D_E
add wave -position end  sim:/processor/MemRead_E_M
add wave -position end  sim:/processor/MemRead_M_W
add wave -position end  sim:/processor/MemWrite
add wave -position end  sim:/processor/MemWrite_D_E
add wave -position end  sim:/processor/MemWrite_E_M
add wave -position end  sim:/processor/MemWrite_M_W
add wave -position end  sim:/processor/WriteBack
add wave -position end  sim:/processor/WriteBack_D_E
add wave -position end  sim:/processor/WriteBack_E_M
add wave -position end  sim:/processor/WriteBack_M_W
add wave -position end  sim:/processor/Write32
add wave -position end  sim:/processor/Write32_D_E
add wave -position end  sim:/processor/Write32_E_M
add wave -position end  sim:/processor/Read32
add wave -position end  sim:/processor/Read32_D_E
add wave -position end  sim:/processor/Read32_E_M
add wave -position end  sim:/processor/MemToReg
add wave -position end  sim:/processor/MemToReg_D_E
add wave -position end  sim:/processor/MemToReg_E_M
add wave -position end  sim:/processor/MemToReg_M_W
add wave -position end  sim:/processor/SP_en
add wave -position end  sim:/processor/SP_en_D_E
add wave -position end  sim:/processor/SP_en_E_M
add wave -position end  sim:/processor/SP_en_M_W
add wave -position end  sim:/processor/SP_op
add wave -position end  sim:/processor/SP_op_D_E
add wave -position end  sim:/processor/SP_op_E_M
add wave -position end  sim:/processor/SP_op_M_W
add wave -position end  sim:/processor/c_flag_en
add wave -position end  sim:/processor/n_flag_en
add wave -position end  sim:/processor/z_flag_en
add wave -position end  sim:/processor/c_flag_en_D_E
add wave -position end  sim:/processor/z_flag_en_D_E
add wave -position end  sim:/processor/n_flag_en_D_E
add wave -position end  sim:/processor/STD_flag
add wave -position end  sim:/processor/STD_flag_D_E
add wave -position end  sim:/processor/STD_flag_E_M
add wave -position end  sim:/processor/STD_flag_M_W
add wave -position end  sim:/processor/Call_flag
add wave -position end  sim:/processor/Call_flag_D_E
add wave -position end  sim:/processor/Call_flag_E_M
add wave -position end  sim:/processor/Call_flag_M_W
add wave -position end  sim:/processor/INT_flag
add wave -position end  sim:/processor/INT_flag_D_E
add wave -position end  sim:/processor/INT_flag_E_M
add wave -position end  sim:/processor/INT_flag_M_W
add wave -position end  sim:/processor/Branch_flag
add wave -position end  sim:/processor/Branch_flag_D_E
add wave -position end  sim:/processor/Branch_flag_E_M
add wave -position end  sim:/processor/RTI_flag
add wave -position end  sim:/processor/RTI_flag_D_E
add wave -position end  sim:/processor/RTI_flag_E_M
add wave -position end  sim:/processor/RTI_flag_M_W
add wave -position end  sim:/processor/RET_flag
add wave -position end  sim:/processor/RET_flag_D_E
add wave -position end  sim:/processor/RET_flag_E_M
add wave -position end  sim:/processor/RET_flag_M_W
add wave -position end  sim:/processor/src1_sel
add wave -position end  sim:/processor/src2_sel
add wave -position end  sim:/processor/Mem_res
add wave -position end  sim:/processor/Mem_in
add wave -position end  sim:/processor/Mem_Addr
add wave -position end  sim:/processor/Jump_Addr
add wave -position end  sim:/processor/jump_flag
add wave -position end  sim:/processor/exception_flag
add wave -position end  sim:/processor/write_data
add wave -position end  sim:/processor/inDataMuxOut1
add wave -position end  sim:/processor/inDataMuxOut2
add wave -position end  sim:/processor/CF
add wave -position end  sim:/processor/ZF
add wave -position end  sim:/processor/NF
add wave -position end  sim:/processor/PC_or_RET
mem load -i instruction_memory.mem -update_properties /processor/instructionMem/ram
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/processor/rst 0 0
force -freeze sim:/processor/INPORT x"0030" 0
run
force -freeze sim:/processor/INPORT x"0050" 0
run
force -freeze sim:/processor/INPORT x"0100" 0
run
force -freeze sim:/processor/INPORT x"0300" 0
run
force -freeze sim:/processor/INPORT x"0700" 0
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
