

library ieee;
use ieee.std_logic_1164.all;

ENTITY EX_MEM_Reg IS
	PORT(
		en: IN std_logic;
		clk: IN std_logic;
		rst: IN std_logic;
	-- input data
		INDATA_E, PC_E: IN std_logic_vector(31 DOWNTO 0);
--		src1_E, src2_E, offset_E: IN std_logic_vector(15 DOWNTO 0);
		offset_E: IN std_logic_vector(15 DOWNTO 0);
		ALU_res_E: IN std_logic_vector(15 DOWNTO 0);
		dst_E: IN std_logic_vector(2 DOWNTO 0);
		-- control signals	
--		ALU_op_E: IN std_logic_vector(2 DOWNTO 0);
		IN_en_E, OUT_en_E,
--		ALU_en_E, ALU_src_E,
		MemRead_E, MemWrite_E,
		WriteBack_E, MemToReg_E,
		SP_en_E, SP_op_E,
--		PC_en_E,
--		Flags_en_E,
		STD_flag_E,
		Call_flag_E, INT_flag_E,
-- 		Branch_flag_E,
		RTI_flag_E: IN std_logic;
	-- output data
		INDATA_M, PC_M: OUT std_logic_vector(31 DOWNTO 0);
--		src1_M, src2_M, offset_M: OUT std_logic_vector(15 DOWNTO 0);
		offset_M: OUT std_logic_vector(15 DOWNTO 0);
		ALU_res_M: OUT std_logic_vector(15 DOWNTO 0);
		dst_M: OUT std_logic_vector(2 DOWNTO 0);
		-- control signals	
--		ALU_op_M: OUT std_logic_vector(2 DOWNTO 0);
		IN_en_M, OUT_en_M,
--		ALU_en_M, ALU_src_M,
		MemRead_M, MemWrite_M,
		WriteBack_M, MemToReg_M,
		SP_en_M, SP_op_M,
--		PC_en_M,
--		Flags_en_M,
		STD_flag_M,
		Call_flag_M, INT_flag_M,
--		Branch_flag_M,
		RTI_flag_M: OUT std_logic
	);
END EX_MEM_Reg;


ARCHITECTURE ExMemReg of EX_MEM_Reg IS
BEGIN
	PROCESS (clk, rst) IS
	BEGIN
		IF (rst = '1') THEN
			INDATA_M <= "0";
			PC_M <= "0";
--			src1_M <= "0";
--			src2_M <= "0";
			offset_M <= "0";
			ALU_res_M <= "0";
			dst_M <= "0";
--			ALU_op_M <= "0";
			IN_en_M <= '0';
			OUT_en_M <= '0';
--			ALU_en_M <= '0';
--			ALU_src_M <= '0';
			MemRead_M <= '0';
			MemWrite_M <= '0';
			WriteBack_M <= '0';
			MemToReg_M <= '0';
			SP_en_M <= '0';
			SP_op_M <= '0';
--			PC_en_M <= '0';
--			Flags_en_M <= '0';
			STD_flag_M <= '0';
			Call_flag_M <= '0';
			INT_flag_M <= '0';
--			Branch_flag_M <= '0';
			RTI_flag_M <= '0';
		ELSIF (rising_edge(clk) and en = '1') THEN
			INDATA_M <= INDATA_E;
			PC_M <= PC_E;
--			src1_M <= src1_E;
--			src2_M <= src2_E;
			offset_M <= offset_E;
			ALU_res_M <= ALU_res_E;
			dst_M <= dst_E;
--			ALU_op_M <= ALU_op_E;
			IN_en_M <= IN_en_E;
			OUT_en_M <= OUT_en_E;
--			ALU_en_M <= ALU_en_E;
--			ALU_src_M <= ALU_src_E;
			MemRead_M <= MemRead_E;
			MemWrite_M <= MemWrite_E;
			WriteBack_M <= WriteBack_E;
			MemToReg_M <= MemToReg_E;
			SP_en_M <= SP_en_E;
			SP_op_M <= SP_op_E;
--			PC_en_M <= PC_en_E;
--			Flags_en_M <= Flags_en_E;
			STD_flag_M <= STD_flag_E;
			Call_flag_M <= Call_flag_E;
			INT_flag_M <= INT_flag_E;
--			Branch_flag_M <= Branch_flag_E;
			RTI_flag_M <= RTI_flag_E;
		END IF;

	END PROCESS;
END ExMemReg;