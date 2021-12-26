library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY processor IS
PORT(
rst : IN std_logic;
clk: IN std_logic;
INPORT: IN std_logic_vector(15 DOWNTO 0);
OUTPORT: OUT std_logic_vector(15 DOWNTO 0)
);

END processor;

ARCHITECTURE processor1 OF processor IS
-- wires to hold pc value through stages [decode, execute, memory]
SIGNAL PC, PC_F_D, PC_D_E, PC_E_M, PC_M_W: std_logic_vector(31 DOWNTO 0);
-- wires to hold pc enable value through stages []
SIGNAL PC_en, PC_en_D_E, PC_en_E_M,PC_en_M_W: std_logic;
-- wire to hold new PC
SIGNAL new_PC: std_logic_vector(31 DOWNTO 0);
-- wire to hold PC reg in data
SIGNAL PC_in: std_logic_vector(31 DOWNTO 0);
-- wires to hold instruction through stages [fetch]
SIGNAL instruction: std_logic_vector(31 DOWNTO 0);
-- wires to hold offset value through stages [decode, execute]
SIGNAL offset, offset_F_D, offset_D_E, offset_E_M,offset_M_W: std_logic_vector(15 DOWNTO 0);
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
SIGNAL indata_F_D, indata_D_E, indata_E_M, indata_M_WB: std_logic_vector(15 DOWNTO 0);
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
SIGNAL MemRead, MemRead_D_E, MemRead_E_M,MemRead_M_W: std_logic;
-- wires to hold memory write signal through stages [execute, memory]
SIGNAL MemWrite, MemWrite_D_E, MemWrite_E_M,MemWrite_M_W: std_logic;
-- wires to hold writeback signal through stages [execute, memory, writeback]
SIGNAL WriteBack, WriteBack_D_E, WriteBack_E_M, WriteBack_M_W: std_logic;
-- wires to hold write32 signal through stages [execute, memory]
SIGNAL Write32, Write32_D_E, Write32_E_M: std_logic;
-- wires to hold memory to reg signal through stages [execute, memory, writeback]
SIGNAL MemToReg, MemToReg_D_E, MemToReg_E_M, MemToReg_M_W: std_logic;
-- wires to hold stack pointer reg enable through stages [execute, memory]
SIGNAL SP_en, SP_en_D_E, SP_en_E_M,SP_en_M_W: std_logic;
-- wires to hold stack pointer operation through stages [execute, memory]
SIGNAL SP_op, SP_op_D_E, SP_op_E_M,SP_op_M_W: std_logic;
-- wires to hold flags enable through stages [decode]
SIGNAL c_flag_en,n_flag_en,z_flag_en, c_flag_en_D_E,z_flag_en_D_E,n_flag_en_D_E: std_logic;
-- wires to hold std flag signal through stages [execute, memory]
SIGNAL STD_flag, STD_flag_D_E, STD_flag_E_M,STD_flag_M_W: std_logic;
-- wires to hold call flag signal through stages [execute, memory]
SIGNAL Call_flag, Call_flag_D_E, Call_flag_E_M,Call_flag_M_W: std_logic;
-- wires to hold interrupt flag signal through stages [execute, memory]
SIGNAL INT_flag, INT_flag_D_E, INT_flag_E_M,INT_flag_M_W: std_logic;
-- wires to hold branch flag signal through stages [execute, memory]
SIGNAL Branch_flag, Branch_flag_D_E, Branch_flag_E_M: std_logic;
-- wires to hold return  flag signal through stages [execute, memory]
SIGNAL RTI_flag, RTI_flag_D_E, RTI_flag_E_M,RTI_flag_M_W: std_logic;
-- wires to hold ALU sources selectors
SIGNAL src1_sel, src2_sel: std_logic_vector(1 DOWNTO 0); 
-- wires to hold memory output 
SIGNAL Mem_res, Mem_res_M_W, Mem_res_WB: std_logic_vector(31 DOWNTO 0);
-- wire to hold memory input
SIGNAL Mem_in: std_logic_vector(31 DOWNTO 0);
-- wire to hold memory address
SIGNAL Mem_Addr: std_logic_vector(31 DOWNTO 0);
-- wire to hold jump address
SIGNAL Jump_Addr: std_logic_vector(31 DOWNTO 0);
-- wire to hold jump flag
SIGNAL jump_flag: std_logic;
-- wire to hold exception flag
SIGNAL exception_flag: std_logic;
--signals from writeBack buffer 
SIGNAL write_data:std_logic_vector(15 DOWNTO 0);
SIGNAL Write_Address:std_logic_vector(2 DOWNTO 0);
SIGNAL inDataMuxOut1, inDataMuxOut2: std_logic_vector(15 downto 0);

SIGNAL CF,ZF,NF: std_logic;
SIGNAL Inst_F_D: std_logic_vector (31 downto 0);
SIGNAL OUT_DATA, OUT_DATA_M_W: std_logic_vector( 15 downto 0);
BEGIN


-- select between new_PC value and jump address and exception handler address
PC_mux: entity work.MUX_2_4 PORT MAP(In1 => new_PC, In2 => Mem_res_WB, In3 => Jump_Addr, In4 => new_PC, sel1 => jump_flag, sel2 => jump_flag, out_data => PC_in);

-- PC register
PC_reg: entity work.REG PORT MAP(rst => rst, clk => clk, en => PC_en, datain => new_PC, rstData => (others=>'0'), dataout => PC);

-- Instruction Memory
instructionMem: entity work.ram PORT MAP(clk => clk, we => '0', write32 => '0', re => '1', address => PC,
 datain => (others=>'0'), dataout => instruction);

-- PC selection Module
increase_PC: entity work.PC_INCREMENT PORT MAP(old_PC => PC, selector => instruction(17), new_PC => new_PC);


-- Fetch/Decode intermmediate buffer
FE_DE_Buffer: entity work.F_D_Buffer PORT MAP (rst => rst, clk => clk, en => '1',
						PC_F=>PC ,PC_D=>PC_F_D,
						Inst_F=>instruction,Inst_D=>Inst_F_D,
						INDATA_F=>INPORT,INDATA_D=>indata_F_D);

-- Register File module instance
RegisterFile:entity work.Register_File PORT MAP(Read_Address_1=>src1_addr,Read_Address_2=>src2_addr,
Write_Address=>Write_Address,write_data=>write_data,Clk=>clk,Rst=>rst,WB_enable=>WriteBack_M_W,Src1_data=>src1,Src2_data=>src1);
-- Docoder Mux select for write data
Decoder_Mux:entity work.Decoder_Mux  port map(OUT_DATA,indata_M_WB,write_data,IN_en_M_W);

-- Control Unit module instance
controlUnit: entity work.control_unit PORT MAP(opCode => instruction(31 DOWNTO 27), IN_en => IN_en, OUT_en => OUT_en,
				ALU_en => ALU_en, MR => MemRead, MW => MemWrite, WB => WriteBack, MEM_REG => MemToReg,
				SP_en => SP_en, SP_op => SP_op, PC_en => PC_en, ALU_src=>ALU_src, CF_en=>c_flag_en, ZF_en=>z_flag_en,NF_en=>n_flag_en,
				STD_FLAG=>STD_flag, CALL_i=>Call_flag, INT_i=>INT_flag, BRANCH_i=>Branch_flag,
				RTI_i=>RTI_flag, ALU_op=>ALU_op
				);
-- decode/execute intermmediate buffer
DE_EX_buffer: entity work.DE_EX_Reg PORT MAP(rst=>rst, clk=>clk, en=>'1', INDATA_D=>indata_F_D, INDATA_E=>indata_D_E, 
				PC_D=>PC_F_D, PC_E=>PC_D_E, src1_D=>src1_F_D, src2_D=>src2_F_D,
				src1_E=>src1_D_E, src2_E=>src2_D_E, offset_D=>offset_F_D, offset_E=>offset_D_E,
				dst_D=>dest_F_D, dst_E=>dest_D_E, ALU_op_D=>ALU_op, ALU_op_E=>ALU_op_D_E,
				src1_D_addr=>src1_addr, src1_E_addr=>src1_addr_D_E, src2_D_addr=>src2_addr,
				src2_E_addr=>src2_addr_D_E,
				IN_en_D=>IN_en, IN_en_E=>IN_en_D_E, OUT_en_D=>OUT_en, OUT_en_E=>OUT_en_D_E,
				ALU_en_D=>ALU_en, ALU_en_E=>ALU_en_D_E, ALU_src_D=>ALU_src, ALU_src_E=>ALU_src_D_E,
				MemRead_D=>MemRead, MemRead_E=>MemRead_D_E, MemWrite_D=>MemWrite, MemWrite_E=>MemWrite_D_E,
				WriteBack_D=>WriteBack, WriteBack_E=>WriteBack_D_E, MemToReg_D=>MemToReg, MemToReg_E=>MemToReg_D_E,
				SP_en_D=>SP_en, SP_en_E=>SP_en_D_E, SP_op_D=>SP_op, SP_op_E=>SP_op_D_E,
				C_Flag_en_D=>c_flag_en,N_Flag_en_D=>n_flag_en,Z_Flag_en_D=>z_flag_en,
				C_Flag_en_E=>c_flag_en_D_E, N_Flag_en_E=>n_flag_en_D_E, Z_Flag_en_E=>z_flag_en_D_E, 
				STD_flag_D=>STD_flag, STD_flag_E=>STD_flag_D_E,
				Call_flag_D=>Call_flag, Call_flag_E=>Call_flag_D_E, INT_flag_D=>INT_flag, INT_flag_E=>INT_flag_D_E,
				Branch_flag_D=>Branch_flag, Branch_flag_E=>Branch_flag_D_E, RTI_flag_D=>RTI_flag, RTI_flag_E=>RTI_flag_D_E
				);
-- forwarding unit module instance
forwardUnit: entity work.ForwardingUnit PORT MAP(EXMem_WriteBack=>WriteBack_E_M, MemWB_WtiteBack=>WriteBack_M_W, EXMem_destAddress=>dest_E_M,
				MemWB_destAddress=>dest_M_W, DeEX_srcAddress1=>src1_addr_D_E, DeEX_srcAddress2=>src2_addr_D_E,
				src1Selectors=>src1_sel, src2Selectors=>src2_sel
				);
-- ALU sources mux/s
-- mux to choose between src1 from instruction and forwarded data
inData1Mux:entity work.MUX_1_2 generic map (n   => 16)
PORT MAP(In1 => indata_E_M(15 downto 0), In2 => ALU_res_E_M, sel => IN_en_E_M, out_data => inDataMuxOut1);

inData2Mux:entity work.MUX_1_2 generic map (n   => 16)
PORT MAP(In1 => indata_M_WB(15 downto 0), In2 => Mem_res_M_W(31 DOWNTO 16), sel => IN_en_M_W, out_data => inDataMuxOut2); 

src1Mux: entity work.MUX_2_4 generic map (n   => 16) PORT MAP(In1 => src1_D_E, In2 => inDataMuxOut1, In3 => inDataMuxOut2,
				 In4 => src1_D_E, out_data => src1_selected, sel1 => src1_sel(1), sel2 => src1_sel(0));

				 -- mux to choose between src2 from instruction and forwarded data
src2Mux: entity work.MUX_2_4 generic map (n   => 16) PORT MAP(In1 => src2_D_E, In2 => inDataMuxOut1, In3 => inDataMuxOut2,
				 In4 => src2_D_E, out_data => src2_selected, sel1 => src2_sel(1), sel2 => src2_sel(0));
-- choose between selected src1 and src2 in case of STD
operand1Mux: entity work.MUX_1_2 generic map (n   => 16) PORT MAP(In1 => src1_selected, In2 => src2_D_E, sel => STD_flag_D_E, out_data => ALU_op1);
-- choose between selected src2 and offset in case of STD
operand2Mux: entity work.MUX_1_2 generic map (n   => 16) PORT MAP(In1 => src2_selected, In2 => offset_D_E, sel => STD_flag_D_E, out_data => ALU_op2);

-- 	TODO: mux to choose between data from execute stage and in_data
-- 	TODO: mux to choose between data from memory stage and in_data
--  TODO: flag registers with 'Store flag register'
 
-- ALU module instance
ALU: entity work.alu PORT MAP(ALU_op1,ALU_op2,ALU_op_D_E,ALU_res,CF,ZF,NF,c_flag_en_D_E,z_flag_en_D_E,n_flag_en_D_E,ALU_en_D_E);

-- Execute/Memory intermmediate buffer
EX_Mem_buffer: entity work.EX_MEM_Reg PORT MAP(rst=>rst,  clk=>clk, en=>'1', INDATA_E=>indata_D_E, INDATA_M=>indata_E_M, 
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

-- data memory
dataMem: entity work.ram PORT MAP(clk => clk, we => MemWrite_E_M, write32 => Write32_E_M, re => MemRead_E_M,
				 address => Mem_Addr, datain => Mem_in, dataout => Mem_res);


MEM_WB_buffer: entity work.M_W_Buffer PORT MAP(rst=>rst,
				clk=>clk, en=>'1',
				INDATA_M=>indata_E_M, INDATA_W=>indata_M_WB, 
				PC_M=>PC_E_M, PC_W=>PC_M_W, 
				Mem_out_M=>Mem_res,Mem_out_W=>Mem_res_M_W,
				offset_M=>offset_E_M, offset_W=>offset_M_W,
				ALU_res_M => ALU_res_E_M, ALU_res_W => ALU_res_M_W,
				dst_M=>dest_E_M, dst_W=>dest_M_W,
				IN_en_M=>IN_en_E_M, IN_en_W=>IN_en_M_W, 
				OUT_en_M=>OUT_en_E_M, OUT_en_W=>OUT_en_M_W,
				MemRead_M=>MemRead_E_M, MemRead_W=>MemRead_M_W,
				MemWrite_M=>MemWrite_E_M, MemWrite_W=>MemWrite_M_W,
				WriteBack_M=>WriteBack_E_M, WriteBack_W=>WriteBack_M_W,
				MemToReg_M=>MemToReg_E_M, MemToReg_W=>MemToReg_M_W,
				SP_en_M=>SP_en_E_M, SP_en_W=>SP_en_M_W, 
				SP_op_M=>SP_op_E_M, SP_op_W=>SP_op_M_W,
				STD_flag_M=>STD_flag_E_M, STD_flag_W=>STD_flag_M_W,
				Call_flag_M=>Call_flag_E_M, Call_flag_W=>Call_flag_M_W,
				INT_flag_M=>INT_flag_E_M, INT_flag_W=>INT_flag_M_W,
				RTI_flag_M=>RTI_flag_E_M, RTI_flag_W=>RTI_flag_M_W
				);

Out_Port_Mux: entity work.MUX_1_2 generic map (n   => 16) PORT MAP(In1 => ALU_res_M_W, In2 => Mem_res_M_W(31 downto 16), sel => MemToReg_M_W, out_data => OUT_DATA_M_W);
Out_Port: entity work. r_Register PORT MAP (clk,rst,OUT_en_M_W,OUT_DATA_M_W,OUT_DATA);

END processor1;
