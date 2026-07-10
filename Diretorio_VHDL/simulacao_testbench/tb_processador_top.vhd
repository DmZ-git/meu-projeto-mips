library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_processador_top is
end entity;

architecture sim of tb_processador_top is

    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';

    type pc_array  is array (natural range <>) of integer;
    type alu_array is array (natural range <>) of STD_LOGIC_VECTOR(31 downto 0);

    -- Endereco de PC esperado em cada um dos 30 ciclos do programa de teste
    -- (memfile.dat), cobrindo ADDI, ADD, SUB, AND, OR, XOR, NOR, SLT, SLL,
    -- SRL, SRA, BEQ (tomado e nao-tomado), BNE e J.
    constant expected_pc  : pc_array(0 to 29) :=
        (0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 68, 72, 76,
         88, 92, 96, 100, 112, 116, 116, 116, 116, 116, 116, 116);

    -- Resultado esperado da ULA (alu_result) em cada um dos mesmos 30 ciclos
    constant expected_alu : alu_array(0 to 29) :=
        (x"0000000C", x"0000000A", x"FFFFFFF8", x"00000016", x"00000002",
         x"00000008", x"0000000E", x"00000006", x"FFFFFFF1", x"00000001",
         x"00000028", x"00000003", x"FFFFFFFC", x"0000000A", x"00000000",
         x"00000007", x"00000008", x"00000004", x"00000037", x"00000004",
         x"0000000B", x"00000000", x"0000002A", x"00000000", x"00000000",
         x"00000000", x"00000000", x"00000000", x"00000000", x"00000000");

    signal erro_total : integer := 0;

begin

    dut : entity work.processador_top
        port map(
            clk   => clk,
            reset => reset
        );

    clk <= not clk after 5 ns;

    stim : process
        -- Sondas VHDL-2008 (external names) para sinais internos do
        -- processador, usadas apenas para verificacao em simulacao.
        -- Nao alteram o projeto original (nao ha portas novas).
        alias pcw  is << signal .tb_processador_top.dut.pc_current  : STD_LOGIC_VECTOR(31 downto 0) >>;
        alias aluw is << signal .tb_processador_top.dut.alu_result : STD_LOGIC_VECTOR(31 downto 0) >>;

        variable pc_ok  : boolean;
        variable alu_ok : boolean;
    begin
        reset <= '1';
        wait for 12 ns;
        reset <= '0';

        for i in expected_pc'range loop

            if i > 0 then
                wait until rising_edge(clk);
            end if;
            wait for 1 ns;  -- deixa os sinais assentarem (evita corrida de delta-ciclo)

            pc_ok  := (to_integer(unsigned(pcw)) = expected_pc(i));
            alu_ok := (aluw = expected_alu(i));

            report "ciclo " & integer'image(i) &
                   "  pc=" & integer'image(to_integer(unsigned(pcw))) &
                   " (esp " & integer'image(expected_pc(i)) & ")" &
                   "  alu=0x" & to_hstring(aluw) &
                   " (esp 0x" & to_hstring(expected_alu(i)) & ")";

            if not pc_ok then
                report "FALHA no ciclo " & integer'image(i) & ": PC incorreto" severity error;
                erro_total <= erro_total + 1;
            end if;

            if not alu_ok then
                report "FALHA no ciclo " & integer'image(i) & ": alu_result incorreto" severity error;
                erro_total <= erro_total + 1;
            end if;

        end loop;

        wait for 1 ns;
        if erro_total = 0 then
            report "TODOS OS TESTES PASSARAM: ADD, ADDI, SUB, AND, OR, XOR, NOR, SLT, SLL, SRL, SRA, BEQ, BNE e J estao corretos." severity note;
        else
            report "FALHOU: verifique os ciclos marcados como FALHA acima (" &
                   integer'image(erro_total) & " erro(s))." severity error;
        end if;

        wait;
    end process;

end architecture;