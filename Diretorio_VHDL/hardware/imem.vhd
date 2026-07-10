library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity imem is
    port (
        a  : in  STD_LOGIC_VECTOR(5 downto 0);
        rd : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity;

architecture behavioral of imem is

    type ram_type is array (0 to 63) of STD_LOGIC_VECTOR(31 downto 0);

    impure function init_mem(file_name : in string) return ram_type is

        file text_file     : text open read_mode is file_name;
        variable text_line : line;
        variable mem_content : ram_type := (others => (others => '0'));
        variable hex_val : STD_LOGIC_VECTOR(31 downto 0);

    begin

        for i in 0 to 63 loop

            if not endfile(text_file) then

                readline(text_file, text_line);
                hread(text_line, hex_val);
                mem_content(i) := hex_val;

            end if;

        end loop;

        return mem_content;

    end function;

    signal RAM : ram_type := init_mem("memfile.dat");

begin

    rd <= RAM(to_integer(unsigned(a)));

end behavioral;