
library ieee;
use ieee.std_logic_1164.all;


ENTITY MUX_2_4 IS
GENERIC (n : integer:=32);
	PORT(
		In1, In2, In3, In4: IN std_logic_vector(n-1 DOWNTO 0);
		sel: IN std_logic_vector(1 DOWNTO 0);
		out_data: OUT std_logic_vector(n-1 DOWNTO 0)
	);
END MUX_2_4;

ARCHITECTURE mux_2_4 OF MUX_2_4 IS
BEGIN
	out_data <= In1 WHEN sel = "00" ELSE
		    In2 WHEN sel = "01" ELSE
		    In3 WHEN sel = "10" ELSE
		    In4;
END mux_2_4;