LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY Register_File is
port(Read_Address_1,
     Read_Address_2,
     Write_Address: in std_logic_vector(2 downto 0);
         Clk,Rst,WB_enable:in std_logic;
         write_data:in std_logic_vector(15 downto 0);        
Src1_data,Src2_data:out std_logic_vector(15 downto 0)

);

end ENTITY;

ARCHITECTURE Register_File_Structal of Register_File is
signal enable: std_logic_vector(7 downto 0);
signal q0,q1,q2,q3,q4,q5,q6,q7:std_logic_vector(15 downto 0);
signal d0,d1,d2,d3,d4,d5,d6,d7:std_logic_vector(15 downto 0);
component r_Register is
port(Clk,Rst,enable:in std_logic;
d:in std_logic_vector(15 downto 0 );
q:out std_logic_vector(15 downto 0)
);
end  component;
begin
PROCESS (Clk,rst,Read_Address_1,Read_Address_2,Write_Address,WB_enable,write_data)
begin
if(rst ='0' )then  
--enable(to_integer(unsigned(Read_Address_1)))<='1';
--enable(to_integer(unsigned(Read_Address_2)))<='1';
if(WB_enable='1') then
enable(to_integer(unsigned(Write_Address)))<='1';
end if;
end if;
end process;


r0:r_Register port map(Clk,Rst,enable(0),d0,q0);
r1:r_Register port map(Clk,Rst,enable(1),d1,q1);
r2:r_Register port map(Clk,Rst,enable(2),d2,q2);
r3:r_Register port map(Clk,Rst,enable(3),d3,q3);
r4:r_Register port map(Clk,Rst,enable(4),d4,q4);
r5:r_Register port map(Clk,Rst,enable(5),d5,q5);
r6:r_Register port map(Clk,Rst,enable(6),d6,q6);
r7:r_Register port map(Clk,Rst,enable(7),d7,q7);


Src1_data<=q0 when  Read_Address_1="000"
else q1 when  Read_Address_1="001"
else q2 when  Read_Address_1="010"
else q3 when  Read_Address_1="011"
else q4 when  Read_Address_1="100"
else q5 when  Read_Address_1="101"
else q6 when  Read_Address_1="110"
else q7 when  Read_Address_1="111";


Src2_data<=q0 when  Read_Address_2="000"
else q1 when  Read_Address_2="001"
else q2 when  Read_Address_2="010"
else q3 when  Read_Address_2="011"
else q4 when  Read_Address_2="100"
else q5 when  Read_Address_2="101"
else q6 when  Read_Address_2="110"
else q7 when  Read_Address_2="111";
--Write data
d0<= write_data when Write_Address<="000"; 
d1<= write_data when Write_Address<="001"; 
d2<= write_data when Write_Address<="010";
d3<= write_data when Write_Address<="011"; 
d4<= write_data when Write_Address<="100"; 
d5<= write_data when Write_Address<="101"; 
d6<= write_data when Write_Address<="110"; 
d7<= write_data when Write_Address<="111"; 

 


end Register_File_Structal;
