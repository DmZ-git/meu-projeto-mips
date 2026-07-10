library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity signext is
    port(
        a : in  STD_LOGIC_VECTOR(15 downto 0);
        y : out STD_LOGIC_VECTOR(31 downto 0)
    );
end signext;

architecture behave of signext is
begin

    y <= x"FFFF" & a when a(15) = '1'
         else x"0000" & a;

end behave;