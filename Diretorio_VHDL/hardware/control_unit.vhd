library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    port(
        opcode    : in  STD_LOGIC_VECTOR(5 downto 0);

        RegDst    : out STD_LOGIC;
        ALUSrc    : out STD_LOGIC;
        MemToReg  : out STD_LOGIC;
        RegWrite  : out STD_LOGIC;
        MemWrite  : out STD_LOGIC;
        Branch    : out STD_LOGIC;   -- BEQ  (desvia se zero = '1')
        Bne       : out STD_LOGIC;   -- BNE  (desvia se zero = '0')
        Jump      : out STD_LOGIC;

        ALUOp     : out STD_LOGIC_VECTOR(1 downto 0)
    );
end control_unit;

architecture behave of control_unit is
begin

process(opcode)
begin

    --------------------------------------------------
    -- Valores padrão
    --------------------------------------------------
    RegDst   <= '0';
    ALUSrc   <= '0';
    MemToReg <= '0';
    RegWrite <= '0';
    MemWrite <= '0';
    Branch   <= '0';
    Bne      <= '0';
    Jump     <= '0';
    ALUOp    <= "00";

    case opcode is

        --------------------------------------------------
        -- R-TYPE
        --------------------------------------------------
        when "000000" =>

            RegDst   <= '1';
            RegWrite <= '1';
            ALUSrc   <= '0';
            ALUOp    <= "10";

        --------------------------------------------------
        -- ADDI  (exigido pela especificacao)
        --------------------------------------------------
        when "001000" =>

            RegDst   <= '0';
            ALUSrc   <= '1';
            RegWrite <= '1';
            ALUOp    <= "00";

        --------------------------------------------------
        -- ADDIU
        --------------------------------------------------
        when "001001" =>

            RegDst   <= '0';
            ALUSrc   <= '1';
            RegWrite <= '1';
            ALUOp    <= "00";

        --------------------------------------------------
        -- LW
        --------------------------------------------------
        when "100011" =>

            RegDst   <= '0';
            ALUSrc   <= '1';
            MemToReg <= '1';
            RegWrite <= '1';
            ALUOp    <= "00";

        --------------------------------------------------
        -- SW
        --------------------------------------------------
        when "101011" =>

            ALUSrc   <= '1';
            MemWrite <= '1';
            ALUOp    <= "00";

        --------------------------------------------------
        -- BEQ
        --------------------------------------------------
        when "000100" =>

            Branch <= '1';
            ALUOp  <= "01";   -- SUB para gerar a flag zero

        --------------------------------------------------
        -- BNE  (exigido pela especificacao)
        --------------------------------------------------
        when "000101" =>

            Bne   <= '1';
            ALUOp <= "01";    -- SUB para gerar a flag zero

        --------------------------------------------------
        -- J
        --------------------------------------------------
        when "000010" =>

            Jump <= '1';

        --------------------------------------------------
        -- Default
        --------------------------------------------------
        when others =>

            null;

    end case;

end process;

end behave;