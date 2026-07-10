library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_processador_check is
end tb_processador_check;

architecture sim of tb_processador_check is
    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    constant TCLK : time := 20 ns;

    type regarr is array (0 to 31) of std_logic_vector(31 downto 0);
    signal shadow : regarr := (others => (others => '0'));
begin

    DUT : entity work.processador_top
        port map (clk => clk, reset => reset);

    clk <= not clk after TCLK/2;

    reset_proc : process
    begin
        reset <= '1';
        wait for 2*TCLK;
        reset <= '0';
        wait;
    end process;

    -- Reconstrói o register file espionando o barramento de write-back
    monitor : process(clk)
        alias rw is << signal .tb_processador_check.DUT.RegWrite  : std_logic >>;
        alias wr is << signal .tb_processador_check.DUT.write_reg : std_logic_vector(4 downto 0) >>;
        alias wd is << signal .tb_processador_check.DUT.write_data: std_logic_vector(31 downto 0) >>;
    begin
        if rising_edge(clk) then
            if reset = '0' and rw = '1' then
                if unsigned(wr) /= 0 then
                    shadow(to_integer(unsigned(wr))) <= wd;
                end if;
            end if;
        end if;
    end process;

    check_proc : process
        procedure chk(idx : integer; exp : std_logic_vector(31 downto 0)) is
        begin
            assert shadow(idx) = exp
                report "FALHA: $" & integer'image(idx) & " = " &
                       to_hstring(shadow(idx)) & "  esperado " & to_hstring(exp)
                severity error;
            report "OK  $" & integer'image(idx) & " = " & to_hstring(shadow(idx))
                severity note;
        end procedure;
    begin
        wait for 30*TCLK;  -- tempo suficiente para o programa completar
        report "===== RESULTADO DO PROGRAMA memfile.dat =====" severity note;
        chk(1, x"00000005");  -- addiu $1,$0,5
        chk(2, x"0000000A");  -- addiu $2,$0,10
        chk(3, x"0000000F");  -- addu  $3,$1,$2 = 15
        chk(4, x"FFFFFFFB");  -- subu  $4,$1,$2 = -5
        chk(5, x"00000000");  -- and   $5,$1,$2 = 0
        chk(6, x"0000000F");  -- or    $6,$1,$2 = 15
        chk(7, x"0000000F");  -- xor   $7,$1,$2 = 15
        chk(8, x"FFFFFFF0");  -- nor   $8,$1,$2
        report "===== FIM =====" severity note;
        std.env.stop;
    end process;

end sim;
