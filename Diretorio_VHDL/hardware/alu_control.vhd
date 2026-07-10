library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_control is
    port(
        ALUOp      : in  STD_LOGIC_VECTOR(1 downto 0);
        funct      : in  STD_LOGIC_VECTOR(5 downto 0);

        alu_funct  : out STD_LOGIC_VECTOR(5 downto 0)
    );
end alu_control;

architecture behave of alu_control is
begin

process(ALUOp, funct)
begin

    case ALUOp is

        ------------------------------------------------
        -- LW SW ADDIU
        ------------------------------------------------
        when "00" =>

            alu_funct <= "100001"; -- ADDU

        ------------------------------------------------
        -- BEQ
        ------------------------------------------------
        when "01" =>

            alu_funct <= "100011"; -- SUBU

        ------------------------------------------------
        -- Tipo R
        ------------------------------------------------
        when "10" =>

            alu_funct <= funct;

        ------------------------------------------------
        -- Default
        ------------------------------------------------
        when others =>

            alu_funct <= "100001";

    end case;

end process;

end behave;