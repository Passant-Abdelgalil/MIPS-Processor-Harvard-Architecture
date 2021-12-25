library ieee;
use ieee.std_logic_1164.all;

ENTITY M_W_Buffer IS
	PORT(
		en,clk,rst: IN std_logic;
		INDATA_M, PC_M,Mem_out_M: IN std_logic_vector(31 DOWNTO 0);
		offset_M: IN std_logic_vector(15 DOWNTO 0);
		ALU_res_M: IN std_logic_vector(15 DOWNTO 0);
		dst_M: IN std_logic_vector(2 DOWNTO 0);
		IN_en_M, OUT_en_M,
		MemRead_M, MemWrite_M,
		WriteBack_M, MemToReg_M,
		EX_en_M,
		SP_en_M, SP_op_M,
		STD_flag_M,
		Call_flag_M, INT_flag_M,
		RTI_flag_M: IN std_logic;


		INDATA_W, PC_W,Mem_out_W: OUT std_logic_vector(31 DOWNTO 0);
		offset_W: OUT std_logic_vector(15 DOWNTO 0);
		ALU_res_W: OUT std_logic_vector(15 DOWNTO 0);
		dst_W: OUT std_logic_vector(2 DOWNTO 0);
		IN_en_W, OUT_en_W,
		MemRead_W, MemWrite_W,
		WriteBack_W, MemToReg_W,
		EX_en_W,
		SP_en_W, SP_op_W,
		STD_flag_W,
		Call_flag_W, INT_flag_W,
		RTI_flag_W: OUT std_logic	
);
END ENTITY;


ARCHITECTURE M_W_Buffer_Arch of M_W_Buffer IS
BEGIN
	PROCESS (clk, rst) IS
	BEGIN
		IF (rst = '1') THEN
			INDATA_W <= (others=>'0');
			PC_W <= (others=>'0');
			Mem_out_W<=(others=>'0');
			offset_W <= (others=>'0');
			ALU_res_W <= (others=>'0');
			dst_W <= (others=>'0');
			IN_en_W <= '0';
			OUT_en_W <= '0';
			MemRead_W <= '0';
			MemWrite_W <= '0';
			WriteBack_W <= '0';
			MemToReg_W <= '0';
			SP_en_W <= '0';
			SP_op_W <= '0';
			Ex_en_W<='0';
			STD_flag_W <= '0';
			Call_flag_W <= '0';
			INT_flag_W <= '0';
			RTI_flag_W <= '0';
		ELSIF (rising_edge(clk) and en = '1') THEN
			INDATA_W <= INDATA_M;
			PC_W <= PC_M;
			Mem_out_W<=Mem_out_M;
			offset_W<= offset_M;
			ALU_res_W <= ALU_res_M;
			dst_W <= dst_M;
			IN_en_W <= IN_en_M;
			OUT_en_W <= OUT_en_M;
			MemRead_W <= MemRead_M;
			MemWrite_W<= MemWrite_M;
			WriteBack_W <= WriteBack_M;
			MemToReg_W<= MemToReg_M;
			SP_en_W <= SP_en_M;
			SP_op_W <= SP_op_M;
			Ex_en_W<=Ex_en_M;
			STD_flag_W <= STD_flag_M;
			Call_flag_W<= Call_flag_M;
			INT_flag_W<= INT_flag_M;
			RTI_flag_W<= RTI_flag_M;
		END IF;

	END PROCESS;
END Architecture;