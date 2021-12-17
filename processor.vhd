
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY processor IS
PORT(
rst : IN std_logic;
clk: IN std_logic;
INPORT: IN std_logic_vector(31 DOWNTO 0);
OUTPORT: OUT std_logic_vector(31 DOWNTO 0)
);

END processor;

ARCHITECTURE processor1 OF processor IS
-- wires to hold pc value through stages [decode, execute, memory]
SIGNAL PC, PC_F_D, PC_D_E, PC_E_M: std_logic_vector(31 DOWNTO 0);
-- wires to hold pc enable value through stages []
SIGNAL PC_en, PC_en_D_E, PC_en_E_M: std_logic;
-- wires to hold instruction through stages [fetch]
SIGNAL instruction: std_logic_vector(31 DOWNTO 0);
-- wires to hold offset value through stages [decode, execute]
SIGNAL offset, offset_F_D, offset_D_E, offset_E_M: std_logic_vector(15 DOWNTO 0);
-- wires to hold source register value through stages[decode, execute]
SIGNAL src1, src2, src1_F_D, src2_F_D, src1_D_E, src2_D_E: std_logic_vector(15 DOWNTO 0);
-- wires to hold source registers address through stages [decode, execute]
SIGNAL src1_addr, src2_addr, src1_addr_D_E, src2_addr_D_E, src1_addr_E_M, src2_addr_E_M: std_logic_vector(2 DOWNTO 0);
-- wires to hold intermmediate buffer enables
SIGNAL F_D_en, D_E_en, E_M_en, M_W_en: std_logic;
-- wires to hold ALU_src control signal through stages[decode, execute]
SIGNAL ALU_src, ALU_src_D_E: std_logic;
-- wires to hold ALU_en signal though stages [execute]
SIGNAL ALU_en, ALU_en_D_E: std_logic;
-- wires to hold  input data through stages [decode, execute, memory]
SIGNAL indata_F_D, indata_D_E, indata_E_M, indata_M_WB: std_logic_vector(31 DOWNTO 0);
-- wires to hold dest reg address through stages [decode, execute, memory]
SIGNAL dest, dest_F_D, dest_D_E, dest_E_M, dest_M_W: std_logic_vector(2 DOWNTO 0);
-- wires to hold ALU_op code through stages [execute]
SIGNAL ALU_op, ALU_op_D_E: std_logic_vector(2 DOWNTO 0);
-- wires to hold selected sources for ALU
SIGNAL src1_selected, src2_selected: std_logic_vector(15 DOWNTO 0);
-- wires to hold ALU operands
SIGNAL ALU_op1, ALU_op2: std_logic_vector(15 DOWNTO 0);
-- wires to hold ALU result through stages [execute, memory, writeback]
SIGNAL ALU_res, ALU_res_E_M, ALU_res_M_W: std_logic_vector(15 DOWNTO 0);
-- wires to hold IN_en signal through stages [execute, memory, writeback]
SIGNAL IN_en, IN_en_D_E, IN_en_E_M, IN_en_M_W: std_logic;
-- wires to hold OUT_en signal through stages [execute, memory, writeback]
SIGNAL OUT_en, OUT_en_D_E, OUT_en_E_M, OUT_en_M_W: std_logic;
-- wires to hold memory read signal through stages [execute, memory]
SIGNAL MemRead, MemRead_D_E, MemRead_E_M: std_logic;
-- wires to hold memory write signal through stages [execute, memory]
SIGNAL MemWrite, MemWrite_D_E, MemWrite_E_M: std_logic;
-- wires to hold writeback signal through stages [execute, memory, writeback]
SIGNAL WriteBack, WriteBack_D_E, WriteBack_E_M, WriteBack_M_W: std_logic;
-- wires to hold memory to reg signal through stages [execute, memory, writeback]
SIGNAL MemToReg, MemToReg_D_E, MemToReg_E_M, MemToReg_M_W: std_logic;
-- wires to hold stack pointer reg enable through stages [execute, memory]
SIGNAL SP_en, SP_en_D_E, SP_en_E_M: std_logic;
-- wires to hold stack pointer operation through stages [execute, memory]
SIGNAL SP_op, SP_op_D_E, SP_op_E_M: std_logic;
-- wires to hold flags enable through stages [decode]
SIGNAL flags_en, flags_en_D_E: std_logic;
-- wires to hold std flag signal through stages [execute, memory]
SIGNAL STD_flag, STD_flag_D_E, STD_flag_E_M: std_logic;
-- wires to hold call flag signal through stages [execute, memory]
SIGNAL Call_flag, Call_flag_D_E, Call_flag_E_M: std_logic;
-- wires to hold interrupt flag signal through stages [execute, memory]
SIGNAL INT_flag, INT_flag_D_E, INT_flag_E_M: std_logic;
-- wires to hold branch flag signal through stages [execute, memory]
SIGNAL Branch_flag, Branch_flag_D_E, Branch_flag_E_M: std_logic;
-- wires to hold return  flag signal through stages [execute, memory]
SIGNAL RTI_flag, RTI_flag_D_E, RTI_flag_E_M: std_logic;
-- wires to hold ALU sources selectors
SIGNAL src1_sel, src2_sel: std_logic_vector(1 DOWNTO 0); 
-- wires to hold memory output 
SIGNAL Mem_res, Mem_res_M_W: std_logic_vector(31 DOWNTO 0);

BEGIN

-- PC register

-- Instruction Memory

-- Fetch/Decode intermmediate buffer

-- Register File module instance

-- Control Unit module instance
controlUnit: entity work.control_unit PORT MAP(opCode => instruction(31 DOWNTO 27), IN_en => IN_en, OUT_en => OUT_en,
				ALU_en => ALU_en, MR => MemRead, MW => MemWrite, WB => WriteBack, MEM_REG => MemToReg,
				SP_en => SP_en, SP_op => SP_op, PC_en => PC_en, ALU_src=>ALU_src, F_en=>flags_en,
				STD_FLAG=>STD_flag, CALL_i=>Call_flag, INT_i=>INT_flag, BRANCH_i=>Branch_flag,
				RTI_i=>RTI_flag, ALU_op=>ALU_op
				);
-- decode/execute intermmediate buffer
DE_EX_buffer: entity work.DE_EX_Reg PORT MAP(rst=>rst, clk=>clk, en=>D_E_en, INDATA_D=>indata_F_D, INDATA_E=>indata_D_E, 
				PC_D=>PC_F_D, PC_E=>PC_D_E, src1_D=>src1_F_D, src2_D=>src2_F_D,
				src1_E=>src1_D_E, src2_E=>src2_D_E, offset_D=>offset_F_D, offset_E=>offset_D_E,
				dst_D=>dest_F_D, dst_E=>dest_D_E, ALU_op_D=>ALU_op, ALU_op_E=>ALU_op_D_E,
				src1_D_addr=>src1_addr, src1_E_addr=>src1_addr_D_E, src2_D_addr=>src2_addr,
				src2_E_addr=>src2_addr_D_E,
				IN_en_D=>IN_en, IN_en_E=>IN_en_D_E, OUT_en_D=>OUT_en, OUT_en_E=>OUT_en_D_E,
				ALU_en_D=>ALU_en, ALU_en_E=>ALU_en_D_E, ALU_src_D=>ALU_src, ALU_src_E=>ALU_src_D_E,
				MemRead_D=>MemRead, MemRead_E=>MemRead_D_E, MemWrite_D=>MemWrite, MemWrite_E=>MemWrite_D_E,
				WriteBack_D=>WriteBack, WriteBack_E=>WriteBack_D_E, MemToReg_D=>MemToReg, MemToReg_E=>MemToReg_D_E,
				SP_en_D=>SP_en, SP_en_E=>SP_en_D_E, SP_op_D=>SP_op, SP_op_E=>SP_op_D_E, Flags_en_D=>flags_en,
				Flags_en_E=>flags_en_D_E, STD_flag_D=>STD_flag, STD_flag_E=>STD_flag_D_E,
				Call_flag_D=>Call_flag, Call_flag_E=>Call_flag_D_E, INT_flag_D=>INT_flag, INT_flag_E=>INT_flag_D_E,
				Branch_flag_D=>Branch_flag, Branch_flag_E=>Branch_flag_D_E, RTI_flag_D=>RTI_flag, RTI_flag_E=>RTI_flag_D_E
				);
-- forwarding unit module instance
forwardUnit: entity work.ForwardingUnit PORT MAP(EXMem_WriteBack=>WriteBack_E_M, MemWB_WtiteBack=>WriteBack_M_W, EXMem_destAddress=>dest_E_M,
				MemWB_destAddress=>dest_M_W, DeEX_srcAddress1=>src1_addr_D_E, DeEX_srcAddress2=>src2_addr_D_E,
				src1Selectors=>src1_sel, src2Selectors=>src2_sel
				);
-- ALU sources mux/s
src1Mux: entity work.MUX_2_4 PORT MAP(In1 => src1_D_E, In2 => ALU_res_E_M, In3 => Mem_res_M_W(31 DOWNTO 16),
				 In4 => src1_D_E, out_data => src1_selected, sel => src1_sel);
src2Mux: entity work.MUX_2_4 PORT MAP(In1 => src2_D_E, In2 => ALU_res_E_M, In3 => Mem_res_M_W(31 DOWNTO 16),
				 In4 => src2_D_E, out_data => src2_selected, sel => src2_sel);
-- choose between selected src1 and src2 in case of STD
operand1Mux: entity work.MUX_1_2 PORT MAP(In1 => src1_selected, In2 => src2_D_E, sel => STD_flag_D_E, out_data => ALU_op1);
-- choose between selected src2 and offset in case of STD
operand2Mux: entity work.MUX_1_2 PORT MAP(In1 => src2_selected, In2 => offset_D_E, sel => STD_flag_D_E, out_data => ALU_op2);

-- ALU module instance

-- Execute/Memory intermmediate buffer
EX_Mem_buffer: entity work.EX_MEM_Reg PORT MAP(rst=>rst,  clk=>clk, en=>E_M_en, INDATA_E=>indata_D_E, INDATA_M=>indata_E_M, 
				PC_E=>PC_D_E, PC_M=>PC_E_M, --src1_E=>src1_D_E, src2_E=>src2_D_E,
				--src1_M=>src1_E_M, src2_M=>src2_E_M,
				offset_E=>offset_D_E, offset_M=>offset_E_M, ALU_res_E => ALU_res, ALU_res_M => ALU_res_E_M,
				dst_E=>dest_D_E, dst_M=>dest_E_M,-- ALU_op_E=>ALU_op_D_E, ALU_op_M=>ALU_op_E_M,
				IN_en_E=>IN_en_D_E, IN_en_M=>IN_en_E_M, OUT_en_E=>OUT_en_D_E, OUT_en_M=>OUT_en_E_M,
				--ALU_en_E=>ALU_en_D_E, ALU_en_M=>ALU_en_E_M, ALU_src_E=>ALU_src_D_E, ALU_src_M=>ALU_src_E_M,
				MemRead_E=>MemRead_D_E, MemRead_M=>MemRead_E_M, MemWrite_E=>MemWrite_D_E, MemWrite_M=>MemWrite_E_M,
				WriteBack_E=>WriteBack_D_E, WriteBack_M=>WriteBack_E_M, MemToReg_E=>MemToReg_D_E, MemToReg_M=>MemToReg_E_M,
				SP_en_E=>SP_en_D_E, SP_en_M=>SP_en_E_M, SP_op_E=>SP_op_D_E, SP_op_M=>SP_op_E_M,
				-- Flags_en_E=>flags_en_D_E, Flags_en_M=>flags_en_E_M,
				STD_flag_E=>STD_flag_D_E, STD_flag_M=>STD_flag_E_M,
				Call_flag_E=>Call_flag_D_E, Call_flag_M=>Call_flag_E_M, INT_flag_E=>INT_flag_D_E, INT_flag_M=>INT_flag_E_M,
				RTI_flag_E=>RTI_flag_D_E, RTI_flag_M=>RTI_flag_E_M --Branch_flag_E=>Branch_flag_D_E, Branch_flag_M=>Branch_flag_E_M
				);


END processor1;