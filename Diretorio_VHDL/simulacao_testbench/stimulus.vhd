library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity stimulus is
    Port (
        clk   : out STD_LOGIC;
        A     : out STD_LOGIC_VECTOR(31 downto 0);
        B     : out STD_LOGIC_VECTOR(31 downto 0);
        funct : out STD_LOGIC_VECTOR(5 downto 0)
    );
end stimulus;

architecture behavior of stimulus is
begin

    process
        file infile : text open read_mode is "input.txt";
        variable linha : line;

        variable A_hex     : STD_LOGIC_VECTOR(31 downto 0);
        variable B_hex     : STD_LOGIC_VECTOR(31 downto 0);
        variable funct_bin : STD_LOGIC_VECTOR(5 downto 0);

    begin

        -- loop de leitura do arquivo
        while not endfile(infile) loop

            readline(infile, linha);

            -- lê HEX e BIN
            hread(linha, A_hex);
            hread(linha, B_hex);
            read(linha, funct_bin);

            -- aplica estímulo
            A     <= A_hex;
            B     <= B_hex;
            funct <= funct_bin;

            -- pulso de clock (opcional, mas útil)
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;

        end loop;

        wait; -- fim da simulação

    end process;

end behavior;