library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.math_real;
 
entity VHDLproject is
  port (
    clock		: in std_logic;   
    x    		: in  std_logic_vector (3 downto 0);
    y    		: in  std_logic_vector (3 downto 0);
    tryb    	: in  std_logic_vector (1 downto 0);
    final 		: out  std_logic_vector (3 downto 0)
    );
end VHDLproject;
 
architecture rtl of VHDLproject is
begin
  process(clock, x, y, mode)
  type tab is array (0 to 7) of integer range 0 to 7;
  variable Z		: tab := (4, 7, 3, 5, 0, 2, 1, 6);
  variable result 	: integer range -3 to 8;
  variable tmp1 	: integer range -7 to 8;
  variable tx 		: integer range -7 to 8;
  variable ty 		: integer range -7 to 8;
  variable vec 		: std_logic_vector(3 downto 0);
  begin

	tx := to_integer(signed(x));
	ty := to_integer(signed(y));
	result := 0;
	
	if(tx < 0) then
		tx := -1;
	end if;
	if(ty < 0) then
		ty := -1;
	end if;
	if(tx > ty and (mode="00" or mode="01")) then
		tmp1 := tx;
		tx := ty;
		ty := tmp1;
	end if;
	
	
	if (mode="00") then
		if(tx = -1 or ty = -1) then 
			result := ty;
		else
			tmp1 :=(ty-tx) mod 8;
		if(tmp1 = 4) then
			result := -1;
		else
			result := (tx + Z(tmp1)) mod 8;
		end if;
		end if;
	end if;
	
	if (mode="01") then
		if(tx > -1 and ty > -1) then
			result := (tx + ty) mod 8;
		end if;
		if(tx = -1 or ty = -1) then 
			result := -1;
		end if;
	end if;
	
	if (mode="10") then
		if(tx /= -1) then
			result := (tx + 4) mod 8;
		else 
			result := -1;
		end if;
	end if;
	
	if (mode="11") then
		if(tx > 0) then 
			result := 8 - tx;
		else if(tx = 0) then
			result := 0;
		else
			result := -2;
		end if;
		end if;
	end if;
	
	final <= std_logic_vector(to_signed(result,vec'length));
  end process;
  end rtl;