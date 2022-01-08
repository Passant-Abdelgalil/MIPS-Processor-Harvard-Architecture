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
--  ########################## FETCH STAGE SIGNALS DEFINITION#####################

-- wire to hold pc value
SIGNAL PC: std_logic_vector(31 DOWNTO 0);
-- wire to hold pc enable
SIGNAL PC_en: std_logic;
-- wire to hold new PC
SIGNAL new_PC: std_logic_vector(31 DOWNTO 0);
-- wire to hold instruction value
SIGNAL instruction: std_logic_vector(31 DOWNTO 0);
-- wire to hold interrupt address
SIGNAL interrupt_address: std_logic_vector(31 DOWNTO 0);
-- wire to hold exception1_interrupts_mux output
SIGNAL execption_one_or_interrupt: std_logic_vector(31 DOWNTO 0);
-- wire to hold exception2_interrupts_mux output
SIGNAL exception_interrupt_address: std_logic_vector(31 DOWNTO 0);
-- signal to hold selector value for the mux that chooses between pc and exception/interrupt address
SIGNAL pc_excp_interr_MUX_sel: std_logic;
-- signal to hold exception_interrupt_or_PC_mux output
SIGNAL pc_or_exception_interrupt: std_logic_vector(31 DOWNTO 0);
-- signal to hold instruction address to be fed into memory address input signal
SIGNAL INST_ADDR: std_logic_vector(31 DOWNTO 0);
-- signal to hold PC_EXCP_INTERR_mux output
SIGNAL PC_withoutJump: std_logic_vector(31 DOWNTO 0);
-- signal to hold final PC value
SIGNAL final_PC: std_logic_vector(31 DOWNTO 0);
-- signal to select between expected PC and exception/interrupts/rst data
SIGNAL pc_or_rst_exception_interrupt: std_logic;
--####################### END FETCH STAGE SIGNALS DEFINITION ###############################

-- wires to hold pc value through stages [decode, execute, memory]
SIGNAL PC_F_D, PC_D_E, PC_E_M, PC_M_W: std_logic_vector(31 DOWNTO 0);
-- wires to hold pc enable value through stages []
SIGNAL PC_en_D_E, PC_en_E_M,PC_en_M_W: std_logic;

-- wires to hold instruction through stages [fetch]
SIGNAL Inst_F_D: std_logic_vector(31 DOWNTO 0);
-- wires to hold offset value through stages [decode, execute]
SIGNAL offset_D_E, offset_E_M,offset_M_W: std_logic_vector(15 DOWNTO 0);
-- wires to hold source register value through stages[decode, execute, memory]
SIGNAL src1, src2, src1_D_E, src2_D_E, src1_E_M: std_logic_vector(15 DOWNTO 0);
-- wires to hold source registers address through stages [decode, execute]
--src1_addr_E_M, src2_addr_E_M
SIGNAL src1_addr_D_E, src2_addr_D_E: std_logic_vector(2 DOWNTO 0);
-- wires to hold intermmediate buffer enables
SIGNAL F_D_en, D_E_en, E_M_en, M_W_en: std_logic;
-- wires to hold ALU_src control signal through stages[decode, execute]
SIGNAL ALU_src, ALU_src_D_E: std_logic;
-- wires to hold ALU_en signal though stages [execute]
SIGNAL ALU_en, ALU_en_D_E: std_logic;
-- wires to hold  input data through stages [decode, execute, memory]
SIGNAL indata_F_D, indata_D_E, indata_E_M, indata_M_WB: std_logic_vector(15 DOWNTO 0);
-- wires to hold dest reg address through stages [decode, execute, memory]
SIGNAL dest_D_E, dest_E_M, dest_M_W: std_logic_vector(2 DOWNTO 0);
-- wires to hold ALU_op code through stages [execute]
SIGNAL ALU_op, ALU_op_D_E,JMP_op,JMP_op_D_E: std_logic_vector(2 DOWNTO 0);
-- wires to hold selected sources for ALU
SIGNAL src1_selected, src2_selected: std_logic_vector(15 DOWNTO 0);
-- wires to hold ALU operands
SIGNAL ALU_op1, ALU_op2: std_logic_vector(15 DOWNTO 0);
-- wires to hold ALU result through stages [execute, memory, writeback]
SIGNAL ALU_res, ALU_res_E_M: std_logic_vector(15 DOWNTO 0);
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
-- wires to hold read32 signal through stages [execute, memory]
SIGNAL Read32, Read32_D_E, Read32_E_M: std_logic;
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
-- wires to hold RET flag signal through stages [execute, memory]
SIGNAL RET_flag, RET_flag_D_E, RET_flag_E_M, RET_flag_M_W: STD_LOGIC;
-- wires to hold ALU sources selectors
SIGNAL src1_sel, src2_sel: std_logic_vector(1 DOWNTO 0); 
-- wires to hold memory output 
SIGNAL Mem_res: std_logic_vector(31 DOWNTO 0);
-- wire to hold final data to be written
SIGNAL final_write_data, final_write_data_W: std_logic_vector(15 DOWNTO 0);
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
-- wires to hold exception1 and exception2 flags
SIGNAL exception1_flag, exception2_flag: STD_LOGIC;
--signals from writeBack buffer 
SIGNAL write_data:std_logic_vector(15 DOWNTO 0);
SIGNAL inDataMuxOut1, inDataMuxOut2: std_logic_vector(15 downto 0);

SIGNAL CF,ZF,NF: std_logic;

SIGNAL OUT_DATA, OUT_DATA_M_W: std_logic_vector( 15 downto 0);

SIGNAL exception_one, exception_two: std_logic;

SIGNAL offset_or_register: std_logic;
BEGIN

--  ################### FETCH STAGE #####################

-- mux to choose between exception 1 handler and interrupts
exception1_interrupts_mux: entity work.MUX_1_2 PORT MAP(In1 => std_logic_vector(to_unsigned(2, 32)), In2 => interrupt_address, sel => exception_one, out_data => execption_one_or_interrupt);

-- mux to choose between exception 2 handler and exception1_interrupts_mux output
exception2_interrupts_mux: entity work.MUX_1_2 PORT MAP(In1 => std_logic_vector(to_unsigned(4,32)), In2 => execption_one_or_interrupt, sel => exception_two, out_data => exception_interrupt_address);

-- set selector for pc_excp_interr_MUX TODO: replace '0' with commented line
pc_excp_interr_MUX_sel <= '0'; --((exception_one or exception_two) or INT_flag);

-- mux to choose between exception/interrupt address and PC value
exception_interrupt_or_PC_mux: entity work.MUX_1_2 PORT MAP(In1 => PC, In2 => exception_interrupt_address, sel => pc_excp_interr_MUX_sel, out_data => pc_or_exception_interrupt);

-- mux to choose between expected instruction address and reset address for intial PC value
instruction_address: entity work.MUX_1_2 PORT MAP(In1 => pc_or_exception_interrupt, In2 => (others=>'0'), sel => rst, out_data => INST_ADDR);

-- mux to choose between new PC value and exception/interrupts handler address, TODO: replace selector with pc_excp_interr_MUX_sel
PC_EXCP_INTERR_mux: entity work.MUX_1_2 PORT MAP(In1 => new_PC, In2 => instruction, sel => rst, out_data => PC_withoutJump);

-- mux to choose between exepcted PC value and jump address TODO:(replace '0' with jump flag)
PC_JUMP_mux: entity work.MUX_1_2 PORT MAP(In1 => PC_withoutJump, IN2 => Jump_Addr, sel => '0', out_data => final_PC);

-- PC register
PC_reg: entity work.REG PORT MAP(clk => clk, en => PC_en, datain => final_PC, dataout => PC);

-- Instruction Memory
instructionMem: entity work.instructionRam PORT MAP(address => INST_ADDR, dataout => instruction);

-- PC selection Module
increase_PC: entity work.PC_INCREMENT PORT MAP(old_PC => PC, selector => instruction(17), new_PC => new_PC);

--  ################### END #####################

-- Fetch/Decode intermmediate buffer
FE_DE_Buffer: entity work.F_D_Buffer PORT MAP (rst => rst, clk => clk, en => '1',
						PC_F=>PC ,PC_D=>PC_F_D,
						Inst_F=>instruction,Inst_D=>Inst_F_D,
						INDATA_F=>INPORT,INDATA_D=>indata_F_D);
--  ################### DECODE STAGE #####################

-- Docoder Mux select for write data
Decoder_Mux:entity work.Decoder_Mux  port map(final_write_data_W,indata_M_WB,write_data,IN_en_M_W);
-- Register File module instance
RegisterFile:entity work.Register_File PORT MAP(Read_Address_1=>Inst_F_D(26 DOWNTO 24),Read_Address_2=>Inst_F_D(23 DOWNTO 21),
Write_Address=>dest_M_W,write_data=>write_data,Clk=>clk,Rst=>rst,WB_enable=>WriteBack_M_W,Src1_data=>src1,Src2_data=>src2);


-- Control Unit module instance
controlUnit: entity work.control_unit PORT MAP(opCode => Inst_F_D(31 DOWNTO 27), IN_en => IN_en, OUT_en => OUT_en, write32 => Write32,
				ALU_en => ALU_en, MR => MemRead, MW => MemWrite, WB => WriteBack, MEM_REG => MemToReg, read32 => Read32,
				SP_en => SP_en, SP_op => SP_op, PC_en => PC_en, ALU_src=>ALU_src, CF_en=>c_flag_en, ZF_en=>z_flag_en,NF_en=>n_flag_en,
				STD_FLAG=>STD_flag, CALL_i=>Call_flag, INT_i=>INT_flag, BRANCH_i=>Branch_flag,
				RTI_i=>RTI_flag, RET_i=>RET_flag, ALU_op=>ALU_op,JMP_op=>JMP_op
				);
-- decode/execute intermmediate buffer
DE_EX_buffer: entity work.DE_EX_Reg PORT MAP(rst=>rst, clk=>clk, en=>'1', INDATA_D=>indata_F_D, INDATA_E=>indata_D_E, 
				PC_D=>PC_F_D, PC_E=>PC_D_E, src1_D=>src1, src2_D=>src2, write32_D => Write32,
				src1_E=>src1_D_E, src2_E=>src2_D_E, offset_D=>Inst_F_D(15 DOWNTO 0), offset_E=>offset_D_E,
				dst_D=>Inst_F_D(20 DOWNTO 18), dst_E=>dest_D_E, ALU_op_D=>ALU_op, ALU_op_E=>ALU_op_D_E, read32_D => Read32,
				src1_D_addr=>Inst_F_D(26 DOWNTO 24), src1_E_addr=>src1_addr_D_E, src2_D_addr=>Inst_F_D(23 DOWNTO 21),
				src2_E_addr=>src2_addr_D_E,
				IN_en_D=>IN_en, IN_en_E=>IN_en_D_E, OUT_en_D=>OUT_en, OUT_en_E=>OUT_en_D_E,
				ALU_en_D=>ALU_en, ALU_en_E=>ALU_en_D_E, ALU_src_D=>ALU_src, ALU_src_E=>ALU_src_D_E,
				MemRead_D=>MemRead, MemRead_E=>MemRead_D_E, MemWrite_D=>MemWrite, MemWrite_E=>MemWrite_D_E,
				WriteBack_D=>WriteBack, WriteBack_E=>WriteBack_D_E, MemToReg_D=>MemToReg, MemToReg_E=>MemToReg_D_E,
				SP_en_D=>SP_en, SP_en_E=>SP_en_D_E, SP_op_D=>SP_op, SP_op_E=>SP_op_D_E,write32_E => Write32_D_E,
				C_Flag_en_D=>c_flag_en,N_Flag_en_D=>n_flag_en,Z_Flag_en_D=>z_flag_en, read32_E => Read32_D_E,
				C_Flag_en_E=>c_flag_en_D_E, N_Flag_en_E=>n_flag_en_D_E, Z_Flag_en_E=>z_flag_en_D_E, 
				STD_flag_D=>STD_flag, STD_flag_E=>STD_flag_D_E,
				Call_flag_D=>Call_flag, Call_flag_E=>Call_flag_D_E, INT_flag_D=>INT_flag, INT_flag_E=>INT_flag_D_E,
				Branch_flag_D=>Branch_flag, Branch_flag_E=>Branch_flag_D_E, RTI_flag_D=>RTI_flag, RTI_flag_E=>RTI_flag_D_E,
				RET_flag_D=>RET_flag, RET_flag_E=>RET_flag_D_E, JMP_op_D=>JMP_op, JMP_op_E=>JMP_op_D_E
				);
-- forwarding unit module instance
forwardUnit: entity work.ForwardingUnit PORT MAP(EXMem_WriteBack=>WriteBack_E_M, MemWB_WtiteBack=>WriteBack_M_W, EXMem_destAddress=>dest_E_M,
				MemWB_destAddress=>dest_M_W, DeEX_srcAddress1=>src1_addr_D_E, DeEX_srcAddress2=>src2_addr_D_E,
				src1Selectors=>src1_sel, src2Selectors=>src2_sel
				);
-- ALU sources mux/s
-- mux to choose between src1 from instruction and forwarded data
inData1Mux:entity work.MUX_1_2 generic map (n   => 16)
PORT MAP(In2 => indata_E_M(15 downto 0), In1 => ALU_res_E_M, sel => IN_en_E_M, out_data => inDataMuxOut1);

inData2Mux:entity work.MUX_1_2 generic map (n   => 16)
PORT MAP(In2 => indata_M_WB(15 downto 0), In1 => final_write_data_W, sel => IN_en_M_W, out_data => inDataMuxOut2); 

src1Mux: entity work.MUX_2_4 generic map (n   => 16) PORT MAP(In1 => src1_D_E, In2 => inDataMuxOut1, In3 => inDataMuxOut2,
				 In4 => src1_D_E, out_data => src1_selected, sel1 => src1_sel(1), sel2 => src1_sel(0));

				 -- mux to choose between src2 from instruction and forwarded data
src2Mux: entity work.MUX_2_4 generic map (n   => 16) PORT MAP(In1 => src2_D_E, In2 => inDataMuxOut1, In3 => inDataMuxOut2,
				 In4 => src2_D_E, out_data => src2_selected, sel1 => src2_sel(1), sel2 => src2_sel(0));
-- choose between selected src1 and src2 in case of STD
operand1Mux: entity work.MUX_1_2 generic map (n   => 16) PORT MAP(In1 => src1_selected, In2 => src2_D_E, sel => STD_flag_D_E, out_data => ALU_op1);
-- choose between offset and register value to enter as operand 2 to ALU
offset_or_register <= STD_flag_D_E or ALU_src_D_E;
-- choose between selected src2 and offset in case of STD
operand2Mux: entity work.MUX_1_2 generic map (n   => 16) PORT MAP(In1 => src2_selected, In2 => offset_D_E, sel => offset_or_register, out_data => ALU_op2);

JMP: entity work.jmp_detect PORT MAP(Branch_flag_D_E,JMP_op_D_E,CF,NF,ZF,src1_D_E,PC_D_E);
-- ALU module instance
-- TODO: rst flags on 'rst' signal
ALU: entity work.alu PORT MAP(ALU_op1,ALU_op2,ALU_op_D_E,ALU_res,CF,ZF,NF,c_flag_en_D_E,z_flag_en_D_E,n_flag_en_D_E,ALU_en_D_E,rst);

-- Execute/Memory intermmediate buffer
EX_Mem_buffer: entity work.EX_MEM_Reg PORT MAP(rst=>rst,  clk=>clk, en=>'1', INDATA_E=>indata_D_E, INDATA_M=>indata_E_M, 
				PC_E=>PC_D_E, PC_M=>PC_E_M, write32_E=>Write32_D_E, read32_E => Read32_D_E, src1_E=>src1_D_E,-- src2_E=>src2_D_E,
				src1_M=>src1_E_M, --src2_M=>src2_E_M,
				offset_E=>offset_D_E, offset_M=>offset_E_M, ALU_res_E => ALU_res, ALU_res_M => ALU_res_E_M,
				dst_E=>dest_D_E, dst_M=>dest_E_M,-- ALU_op_E=>ALU_op_D_E, ALU_op_M=>ALU_op_E_M,
				IN_en_E=>IN_en_D_E, IN_en_M=>IN_en_E_M, OUT_en_E=>OUT_en_D_E, OUT_en_M=>OUT_en_E_M,
				--ALU_en_E=>ALU_en_D_E, ALU_en_M=>ALU_en_E_M, ALU_src_E=>ALU_src_D_E, ALU_src_M=>ALU_src_E_M,
				MemRead_E=>MemRead_D_E, MemRead_M=>MemRead_E_M, MemWrite_E=>MemWrite_D_E, MemWrite_M=>MemWrite_E_M,
				WriteBack_E=>WriteBack_D_E, WriteBack_M=>WriteBack_E_M, MemToReg_E=>MemToReg_D_E, MemToReg_M=>MemToReg_E_M,
				SP_en_E=>SP_en_D_E, SP_en_M=>SP_en_E_M, SP_op_E=>SP_op_D_E, SP_op_M=>SP_op_E_M, write32_M => Write32_E_M,
				-- Flags_en_E=>flags_en_D_E, Flags_en_M=>flags_en_E_M,
				STD_flag_E=>STD_flag_D_E, STD_flag_M=>STD_flag_E_M, read32_M => Read32_E_M,
				Call_flag_E=>Call_flag_D_E, Call_flag_M=>Call_flag_E_M, INT_flag_E=>INT_flag_D_E, INT_flag_M=>INT_flag_E_M,
				RTI_flag_E=>RTI_flag_D_E, RTI_flag_M=>RTI_flag_E_M, --Branch_flag_E=>Branch_flag_D_E, Branch_flag_M=>Branch_flag_E_M
				RET_flag_E=>RET_flag_D_E, RET_flag_M=>RET_flag_E_M
				);

-- Memory Stage
-- dataMem: entity work.ram PORT MAP(clk => clk, we => MemWrite_E_M, write32 => Write32_E_M, re => MemRead_E_M,
-- 				 address => Mem_Addr, datain => Mem_in, dataout => Mem_res);
memoryStage: ENTITY work.MemoryStage PORT MAP(
			clk=>clk, rst=>rst, CALL_i=>Call_flag_E_M, RET_i=>RET_flag_E_M, INT_i=>INT_flag_E_M, 
			RTI_i=>RTI_flag_E_M, SP_en=>SP_en_E_M, write32=>Write32_E_M, read32=>Read32_E_M,
			MW=>MemWrite_E_M, MR=>MemRead_E_M,
			Rsrc1=>src1_E_M, PC=>PC_E_M, ALU_res=>ALU_res_E_M,
			exception1=>exception1_flag, exception2=>exception2_flag ,dataout=>Mem_res
		);
		
		exception_flag <= exception1_flag OR exception2_flag;
		
final_write_data_mux: entity work.MUX_1_2 generic map (n => 16) PORT MAP(In1 => ALU_res_E_M, In2 => Mem_res(31 DOWNTO 16), sel => MemToReg_E_M, out_data => final_write_data);
MEM_WB_buffer: entity work.M_W_Buffer PORT MAP(rst=>rst,
				clk=>clk, en=>'1',
				INDATA_M=>indata_E_M, INDATA_W=>indata_M_WB, 
				PC_M=>PC_E_M, PC_W=>PC_M_W, 
				offset_M=>offset_E_M, offset_W=>offset_M_W,
				final_writeData_M => final_write_data, final_writeData_W => final_write_data_W,
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

--Out_Port_Mux: entity work.MUX_1_2 generic map (n   => 16) PORT MAP(In1 => ALU_res_M_W, In2 => Mem_res_M_W(31 downto 16), sel => MemToReg_M_W, out_data => OUT_DATA_M_W);
Out_Port: entity work.r_Register PORT MAP (clk,rst,OUT_en_M_W,final_write_data_W,OUTPORT);

END processor1;
