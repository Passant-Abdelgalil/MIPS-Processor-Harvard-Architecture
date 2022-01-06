LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY memo_address_mux IS
    PORT (
        SP_en : IN STD_LOGIC;
        exception2 : IN STD_LOGIC;
        SP_used_Address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_res : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        -- INT_i_WB : IN STD_LOGIC;

        memo_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        exception1 : OUT STD_LOGIC
    );
END ENTITY memo_address_mux;

ARCHITECTURE instance OF memo_address_mux IS

BEGIN
    exception1 <= '1' WHEN
        (unsigned(ALU_res) > x"ff00") AND (SP_en = '0')
        ELSE
        '0';
    memo_address <=
        -- x"00000000" WHEN -- ?????? Add int_ from WB to read int address?
        -- INT_i_WB = '1'
        -- ELSE
        -- x"00000002" WHEN
        -- (exception2 = '1')
        -- ELSE
        -- x"00000004" WHEN (unsigned(ALU_res) > x"ff00" AND SP_en = '0')
        -- ELSE
        SP_used_Address
        WHEN SP_en = '1'
        ELSE
        x"0000" & ALU_res
        ;
END instance;