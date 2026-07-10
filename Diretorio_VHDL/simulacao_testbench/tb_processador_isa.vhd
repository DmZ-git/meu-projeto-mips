library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity tb_processador_isa is
end tb_processador_isa;
architecture sim of tb_processador_isa is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    constant TCLK : time := 20 ns;
    type regarr is array (0 to 31) of std_logic_vector(31 downto 0);
    signal shadow : regarr := (others => (others => '0'));
begin
    DUT : entity work.processador_top port map (clk => clk, reset => reset);
    clk <= not clk after TCLK/2;
    reset_proc : process begin
        reset <= '1'; wait for 2*TCLK; reset <= '0'; wait;
    end process;
    monitor : process(clk)
        alias rw is << signal .tb_processador_isa.DUT.RegWrite  : std_logic >>;
        alias wr is << signal .tb_processador_isa.DUT.write_reg : std_logic_vector(4 downto 0) >>;
        alias wd is << signal .tb_processador_isa.DUT.write_data: std_logic_vector(31 downto 0) >>;
    begin
        if rising_edge(clk) then
            if reset='0' and rw='1' and unsigned(wr)/=0 then
                shadow(to_integer(unsigned(wr))) <= wd;
            end if;
        end if;
    end process;
    check_proc : process
        variable nfail : integer := 0;
        procedure chk(idx:integer; exp:std_logic_vector(31 downto 0); nm:string) is begin
            if shadow(idx)=exp then
                report "OK    $"&integer'image(idx)&" ("&nm&") = "&to_hstring(shadow(idx)) severity note;
            else
                report "FALHA $"&integer'image(idx)&" ("&nm&") = "&to_hstring(shadow(idx))&"  esperado "&to_hstring(exp) severity warning;
                nfail := nfail + 1;
            end if;
        end procedure;
    begin
        wait for 40*TCLK;
        report "===== PROGRAMA DE TESTE (ADDI/BEQ/BNE/J/SLT/SLL/SRL/SRA) =====" severity note;
        chk(1, x"00000005","addi");           chk(2, x"00000005","addi");
        chk(3, x"00000000","beq skip");        chk(4, x"00000000","beq skip");
        chk(5, x"00000007","addi beq-target"); chk(6, x"00000000","bne skip");
        chk(7, x"00000000","bne skip");        chk(8, x"00000001","slt bne-target");
        chk(9, x"0000001C","sll 7<<2");        chk(10,x"00000003","srl 7>>1");
        chk(12,x"FFFFFFF8","addi -8");         chk(11,x"FFFFFFFC","sra -8>>1");
        chk(13,x"00000000","j skip");          chk(14,x"0000002A","addi j-target");
        if nfail=0 then report "===== TODOS OS TESTES PASSARAM =====" severity note;
        else report "===== "&integer'image(nfail)&" FALHA(S) =====" severity failure; end if;
        std.env.stop;
    end process;
end sim;
