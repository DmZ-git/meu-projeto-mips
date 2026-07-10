library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity regfile is
    port(
        clk  : in  STD_LOGIC;

        we3  : in  STD_LOGIC;

        ra1  : in  STD_LOGIC_VECTOR(4 downto 0);
        ra2  : in  STD_LOGIC_VECTOR(4 downto 0);
        wa3  : in  STD_LOGIC_VECTOR(4 downto 0);

        wd3  : in  STD_LOGIC_VECTOR(31 downto 0);

        rd1  : out STD_LOGIC_VECTOR(31 downto 0);
        rd2  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end regfile;

architecture behave of regfile is

    type ramtype is array (31 downto 0)
        of STD_LOGIC_VECTOR(31 downto 0);

    signal mem : ramtype := (others => (others => '0'));

begin

    ----------------------------------------------------------------
    -- Escrita síncrona
    ----------------------------------------------------------------
    process(clk)
    begin

        if rising_edge(clk) then

            if we3 = '1' then

                if unsigned(wa3) /= 0 then
                    mem(to_integer(unsigned(wa3))) <= wd3;
                end if;

            end if;

        end if;

    end process;

    ----------------------------------------------------------------
    -- Leitura assíncrona
    ----------------------------------------------------------------
    process(ra1, ra2, mem)
    begin

        if unsigned(ra1) = 0 then
            rd1 <= x"00000000";
        else
            rd1 <= mem(to_integer(unsigned(ra1)));
        end if;

        if unsigned(ra2) = 0 then
            rd2 <= x"00000000";
        else
            rd2 <= mem(to_integer(unsigned(ra2)));
        end if;

    end process;

end behave;