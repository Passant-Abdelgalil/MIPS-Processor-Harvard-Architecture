add wave -position insertpoint sim:/alu/*
force -freeze sim:/alu/a 1111111100000000 0
force -freeze sim:/alu/b 0000000011111111
force -freeze sim:/alu/op_code 110 0
force -freeze sim:/alu/rst 1 0
force -freeze sim:/alu/alu_en 0 0
force -freeze sim:/alu/n_flag_en 1 0
force -freeze sim:/alu/z_flag_en 1 0
force -freeze sim:/alu/c_flag_en 1 0
run
force -freeze sim:/alu/alu_en 1 0
force -freeze sim:/alu/rst 0 0
run
# ** Warning: There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es).
#    Time: 100 ps  Iteration: 1  Instance: /alu/u1
force -freeze sim:/alu/b 1111111111111111
run
force -freeze sim:/alu/b 0000000000000000
run
force -freeze sim:/alu/op_code 001 0
force -freeze sim:/alu/c_flag_en 0 0