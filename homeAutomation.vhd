LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY HomeAutomation IS
PORT (
	rst, clk: IN std_logic;
	front, rear, window, fireAlarm: IN std_logic;
	temperature: IN std_logic_logic(7 DOWNTO 0);
	fDoor, rDoor, buzz, windw, cooler, heater: OUT std_logic;
	display: OUT std_logic_vector(2 DOWNTO 0)
);
END HomeAutomation;


ARCHITECTURE homeAutomation OF HomeAutomation IS
SIGNAL state, next_state: std_logic_vector(2 DOWNTO 0);

BEGIN
-- process to set next state
PROCESS(clk, rst)
BEGIN
	if rising_edge(clk) THEN
		if (rst = '1') THEN
			state <= "000";
		ELSE
			state <= next_state;
	ELSE
		state <= state;
END PROCESS

-- process to set next state based on inputs & state
PROCESS (state, front, rear, window, fireAlarm, temperature)
BEGIN

	IF (state = "000") THEN -- ideal state
		IF (front = '1') THEN
			fDoor <= '1';
			next_state <= "001";
		ELSE
			IF (rear = '1') THEN 
				fDoor <= '1';
				next_state <= "010";
			ELSE
				IF (window = '1') THEN
					windw <= '1';
					next_state <= "011";
				ELSE
					IF (fireAlarm <= '1') THEN
						buzz <= '1';
						next_state <= "100";
					ELSE
						IF (tmp < b"50") THEN
							heater <= '1';
							next_state <= "101";
						

END PROCESS;

END homeAutomation;
