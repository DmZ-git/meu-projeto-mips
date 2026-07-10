library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

------------------------------------------------------------------
-- pcnext: calcula o proximo valor do PC.
--
-- Concentra em um unico componente tudo que antes ficava solto
-- no top level (PC+4, endereco de branch, endereco de jump e o
-- mux final). Isso evita que o RTL viewer "explode" essa logica
-- em dezenas de muxes de 1 bit, ja que agora ela tem fronteira
-- de instancia propria (igual pc, imem, ula, etc.).
------------------------------------------------------------------
entity pcnext is
    port(
        pc_current  : in  STD_LOGIC_VECTOR(31 downto 0);  -- PC atual
        instr_25_0  : in  STD_LOGIC_VECTOR(25 downto 0);  -- instruction(25 downto 0), p/ jump
        signimm_sl2 : in  STD_LOGIC_VECTOR(31 downto 0);  -- offset de branch (signimm << 2)
        Jump        : in  STD_LOGIC;
        pcsrc       : in  STD_LOGIC;                      -- branch tomado (BEQ/BNE)
        pc_next     : out STD_LOGIC_VECTOR(31 downto 0)
    );
end pcnext;

architecture behave of pcnext is

    signal pc_plus4   : STD_LOGIC_VECTOR(31 downto 0);
    signal branch_addr: STD_LOGIC_VECTOR(31 downto 0);
    signal jump_addr  : STD_LOGIC_VECTOR(31 downto 0);

begin

    ------------------------------------------------------------------
    -- PC + 4
    ------------------------------------------------------------------
    pc_plus4 <= std_logic_vector(unsigned(pc_current) + 4);

    ------------------------------------------------------------------
    -- Endereco de branch: PC+4 + (signimm << 2)
    ------------------------------------------------------------------
    branch_addr <= std_logic_vector(unsigned(pc_plus4) + unsigned(signimm_sl2));

    ------------------------------------------------------------------
    -- Endereco de jump: {PC+4[31:28], instr[25:0], "00"}
    ------------------------------------------------------------------
    jump_addr <= pc_plus4(31 downto 28) &
                 instr_25_0 &
                 "00";

    ------------------------------------------------------------------
    -- Mux final: Jump > Branch > PC+4
    ------------------------------------------------------------------
    pc_next <= jump_addr   when Jump  = '1' else
               branch_addr when pcsrc = '1' else
               pc_plus4;

end behave;
