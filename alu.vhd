Library ieee;
use ieee.std_logic_1164.all;

entity alu is
GENERIC (n : integer := 31);
port(
		a,b : in std_logic_vector(n-1 downto 0);
		op_code : in std_logic_vector (2 downto 0);
		f : out std_logic_vector(n-1 downto 0);
		c_flag,z_flag,n_flag : inout std_logic;
		c_flag_en,z_flag_en,n_flag_en: in std_logic;
		alu_en: in std_logic
);

end entity;

Architecture alu_arch of alu is
Component partA is
port(
		a : in std_logic_vector(n-1 downto 0);
		op_code : in std_logic_vector (2 downto 0);
		f : out std_logic_vector(n-1 downto 0);
		c_flag,z_flag,n_flag : inout std_logic;
		c_flag_en,z_flag_en,n_flag_en: in std_logic;
		alu_en: in std_logic
	);

end Component;

Component partB is
port(
		a,b : in std_logic_vector(n-1 downto 0);
		op_code : in std_logic_vector (2 downto 0);
		f : out std_logic_vector(n-1 downto 0);
		c_flag,z_flag,n_flag : inout std_logic;
		c_flag_en,z_flag_en,n_flag_en: in std_logic;
		alu_en: in std_logic
	);
end Component;
 
Signal x1,x2:std_logic_vector(n-1 downto 0);
Signal c1,c2,z1,z2,n1,n2:std_logic;
begin
u0:partA port map (a,op_code,x1,c1,z1,n1,c_flag_en,z_flag_en,n_flag_en,alu_en);
u1:partB port map (a,b,op_code,x2,c2,z2,n2,c_flag_en,z_flag_en,n_flag_en,alu_en);

f <= x1 WHEN (op_code(2)='0')
ELSE x2;

c_flag<=c1 WHEN (op_code(2)='0')
ELSE c2;

z_flag<=z1 WHEN (op_code(2)='0')
ELSE z2;

n_flag<=n1 WHEN (op_code(2)='0')
ELSE n2;
end Architecture;
