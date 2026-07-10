library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mips_modular is
end tb_mips_modular;

architecture behavior of tb_mips_modular is

    signal clk   : STD_LOGIC;

    signal A     : STD_LOGIC_VECTOR(31 downto 0);
    signal B     : STD_LOGIC_VECTOR(31 downto 0);

    signal shamt : STD_LOGIC_VECTOR(4 downto 0);

    signal funct : STD_LOGIC_VECTOR(5 downto 0);

    signal R     : STD_LOGIC_VECTOR(31 downto 0);

    signal zero  : STD_LOGIC;
    signal ovfl  : STD_LOGIC;

begin

    ----------------------------------------------------
    -- Stimulus
    ----------------------------------------------------
    stim_inst : entity work.stimulus
        port map (
            clk   => clk,
            A     => A,
            B     => B,
            funct => funct
        );

    ----------------------------------------------------
    -- ULA
    ----------------------------------------------------
    ula_inst : entity work.ula
        port map (
            A      => A,
            B      => B,
            shamt  => shamt,
            funct  => funct,
            R      => R,
            zero   => zero,
            ovfl   => ovfl
        );

    ----------------------------------------------------
    -- Checker
    ----------------------------------------------------
    checker_inst : entity work.checker
        port map (
            clk   => clk,
            A     => A,
            B     => B,
            funct => funct,
            R     => R,
            ovfl  => ovfl
        );

    ----------------------------------------------------
    -- Shamt fixo para testes
    ----------------------------------------------------
    shamt <= "00000";

end behavior;