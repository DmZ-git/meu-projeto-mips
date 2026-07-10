library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc is
    port(
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        pc_next : in  STD_LOGIC_VECTOR(31 downto 0);
        pc_out  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end pc;

architecture behave of pc is

    signal pc_reg : STD_LOGIC_VECTOR(31 downto 0);

begin

    process(clk, reset)
    begin

        if reset = '1' then

            pc_reg <= (others => '0');

        elsif rising_edge(clk) then

            pc_reg <= pc_next;

        end if;

    end process;

    pc_out <= pc_reg;

end behave;