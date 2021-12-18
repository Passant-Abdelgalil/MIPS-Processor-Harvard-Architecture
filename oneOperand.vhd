Library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity oneOperand is 
	GENERIC (n : integer := 4);
	port(
		op : in std_logic_vector(n-1 downto 0);
		op_code : in std_logic_vector (2 downto 0);
		outp : out std_logic_vector(n-1 downto 0);
		c_flag : inout std_logic;
		c_flag_en: in std_logic;
		z_flag: inout std_logic;
		z_flag_en: in std_logic;
		n_flag: inout std_logic;
		n_flag_en: in std_logic;
		alu_en: in std_logic
	);
end entity;

architecture oneOperandArch of oneOperand is
	signal temp: std_logic_vector(n downto 0);
	begin
		process(alu_en,op_code,op)
		begin
			if(alu_en='1') then
				case op_code is
	 				when "001" =>
 					temp <= '0' & not op;
 					outp <= not op;
 					when "010" =>
 					temp <= '0' & op + 1;
 					outp <= op + 1;
 					when "011" =>
 					outp <= op;
 					when others => NULL;
				end case;
			end if;
		end process;

		process(alu_en,op_code,op,c_flag_en,temp)
		begin
			if(alu_en='1') and (c_flag_en='1') then
				if(op_code="111")  then
					c_flag<='1';
				elsif(op_code="010") then
					c_flag<=temp(n);
				end if;
			end if;
		end process;

		process(alu_en,op_code,op,z_flag_en,temp)
		begin
			if(alu_en='1') and (z_flag_en='1') then
				if (temp(n-1 downto 0) = (temp(n-1 downto 0)'range => '0')) then
					z_flag<='1';
				else z_flag<='0';
				end if;
			end if;
		end process;

		process(alu_en,op_code,op,n_flag_en,temp)
		begin
			if(alu_en='1') and (n_flag_en='1') then
				if (temp(n-1)='1') then
					n_flag<='1';
				else n_flag<='0';
				end if;
			end if;
		end process;

end architecture;