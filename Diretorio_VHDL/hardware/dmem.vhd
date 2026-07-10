library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dmem is
    port(
        clk       : in  STD_LOGIC;
        we        : in  STD_LOGIC;

        addr      : in  STD_LOGIC_VECTOR(31 downto 0);
        wd        : in  STD_LOGIC_VECTOR(31 downto 0);

        rd        : out STD_LOGIC_VECTOR(31 downto 0)
    );
end dmem;

architecture behave of dmem is

    type ram_type is array (0 to 63)
        of STD_LOGIC_VECTOR(31 downto 0);

    signal RAM : ram_type := (others => (others => '0'));

begin

    ----------------------------------------------------
    -- Escrita síncrona
    ----------------------------------------------------
    process(clk)
    begin

        if rising_edge(clk) then

            if we = '1' then

                RAM(to_integer(unsigned(addr(7 downto 2))))
                    <= wd;

            end if;

        end if;

    end process;

    ----------------------------------------------------
    -- Leitura assíncrona
    ----------------------------------------------------
    rd <= RAM(
            to_integer(
            unsigned(addr(7 downto 2))
            )
          );

end behave;