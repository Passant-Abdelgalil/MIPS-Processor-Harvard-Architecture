LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;;


ENTITY processor_tb IS
END;

ARCHITECTURE testbench OF processor_tb IS

CONSTANT clockPeriod: TIME := 10ns;

SIGNAL clock, rst: std_logic;
SIGNAL inPort, outPort: std_logic_vector(15 DOWNTO 0);

BEGIN

--- rest processor
RESET: PROCESS
BEGIN
rst <= '1';
WAIT FOR clockPeriod/2;
rst <= '0';
WAIT;
END PROCESS;
---  Process to generate clock
GENERATE_CLOCK: PROCESS
BEGIN
LOOP clock <= '0', '1' AFTER clockPeriod / 2;
WAIT FOR clockPeriod;
	END LOOP;
WAIT;
END PROCESS;

--- Processor instantiation
processor_unit: entity work.processor PORT MAP ( rst 	=> rst,
						 clk 	=> clock;
						 INPORT	=> inPort;
						 OUTPORT=> outPort);


END testbench;