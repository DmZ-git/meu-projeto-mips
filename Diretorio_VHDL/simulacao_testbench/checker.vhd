library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity checker is
    Port (
        clk   : in  STD_LOGIC;
        A     : in  STD_LOGIC_VECTOR(31 downto 0);
        B     : in  STD_LOGIC_VECTOR(31 downto 0);
        funct : in  STD_LOGIC_VECTOR(5 downto 0);
        R     : in  STD_LOGIC_VECTOR(31 downto 0);
        ovfl  : in  STD_LOGIC
    );
end checker;

architecture behavior of checker is
begin

    process
        variable temp      : SIGNED(32 downto 0);
        variable res_exp   : SIGNED(31 downto 0);
        variable ovfl_exp  : STD_LOGIC;
    begin

        wait until rising_edge(clk);
        wait for 1 ns; -- ESSENCIAL (estabilização)

        case funct is

            -- =========================
            -- ADD
            -- =========================
            when "100000" =>
                temp := ('0' & SIGNED(A)) + ('0' & SIGNED(B));
                res_exp := temp(31 downto 0);

                if (A(31) = B(31)) and (res_exp(31) /= A(31)) then
                    ovfl_exp := '1';
                else
                    ovfl_exp := '0';
                end if;

            -- =========================
            -- ADDU
            -- =========================
            when "100001" =>
                temp := ('0' & SIGNED(A)) + ('0' & SIGNED(B));
                res_exp := temp(31 downto 0);
                ovfl_exp := '0';

            -- =========================
            -- SUB
            -- =========================
            when "100010" =>
                temp := ('0' & SIGNED(A)) - ('0' & SIGNED(B));
                res_exp := temp(31 downto 0);

                if (A(31) /= B(31)) and (res_exp(31) /= A(31)) then
                    ovfl_exp := '1';
                else
                    ovfl_exp := '0';
                end if;

            -- =========================
            -- SUBU
            -- =========================
            when "100011" =>
                temp := ('0' & SIGNED(A)) - ('0' & SIGNED(B));
                res_exp := temp(31 downto 0);
                ovfl_exp := '0';

            -- =========================
            -- AND / OR / XOR / NOR
            -- =========================
            when "100100" =>
                res_exp := SIGNED(A and B);          ovfl_exp := '0';
            when "100101" =>
                res_exp := SIGNED(A or B);           ovfl_exp := '0';
            when "100110" =>
                res_exp := SIGNED(A xor B);          ovfl_exp := '0';
            when "100111" =>
                res_exp := SIGNED(not (A or B));     ovfl_exp := '0';

            -- =========================
            -- SLT (signed)
            -- =========================
            when "101010" =>
                if SIGNED(A) < SIGNED(B) then res_exp := to_signed(1,32);
                else                          res_exp := to_signed(0,32); end if;
                ovfl_exp := '0';

            when others =>
                res_exp  := (others => '0');
                ovfl_exp := '0';

        end case;

        -- =========================
        -- ASSERTS
        -- =========================

        assert (R = STD_LOGIC_VECTOR(res_exp))
            report "ERRO: Resultado incorreto"
            severity error;

        assert (ovfl = ovfl_exp)
            report "ERRO: Overflow incorreto"
            severity error;

        -- mensagem de sucesso (opcional)
        report "OK: Operacao correta" severity note;

    end process;

end behavior;