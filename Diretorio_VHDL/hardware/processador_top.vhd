library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processador_top is
    port(
        clk   : in STD_LOGIC;
        reset : in STD_LOGIC
    );
end processador_top;

architecture structural of processador_top is

    ------------------------------------------------------------------
    -- PC
    ------------------------------------------------------------------
    signal pc_current : STD_LOGIC_VECTOR(31 downto 0);
    signal pc_next    : STD_LOGIC_VECTOR(31 downto 0);

    ------------------------------------------------------------------
    -- Instruction
    ------------------------------------------------------------------
    signal instruction : STD_LOGIC_VECTOR(31 downto 0);

    signal opcode : STD_LOGIC_VECTOR(5 downto 0);
    signal rs     : STD_LOGIC_VECTOR(4 downto 0);
    signal rt     : STD_LOGIC_VECTOR(4 downto 0);
    signal rd     : STD_LOGIC_VECTOR(4 downto 0);
    signal shamt  : STD_LOGIC_VECTOR(4 downto 0);
    signal funct  : STD_LOGIC_VECTOR(5 downto 0);
    signal imm    : STD_LOGIC_VECTOR(15 downto 0);

    ------------------------------------------------------------------
    -- Control
    ------------------------------------------------------------------
    signal RegDst    : STD_LOGIC;
    signal ALUSrc    : STD_LOGIC;
    signal MemToReg  : STD_LOGIC;
    signal RegWrite  : STD_LOGIC;
    signal MemWrite  : STD_LOGIC;
    signal Branch    : STD_LOGIC;   -- BEQ
    signal Bne       : STD_LOGIC;   -- BNE
    signal Jump      : STD_LOGIC;
    signal ALUOp     : STD_LOGIC_VECTOR(1 downto 0);

    ------------------------------------------------------------------
    -- Register File
    ------------------------------------------------------------------
    signal srcA      : STD_LOGIC_VECTOR(31 downto 0);
    signal srcB      : STD_LOGIC_VECTOR(31 downto 0);

    signal write_reg : STD_LOGIC_VECTOR(4 downto 0);
    signal write_data: STD_LOGIC_VECTOR(31 downto 0);

    ------------------------------------------------------------------
    -- Immediate & Branch
    ------------------------------------------------------------------
    signal signimm      : STD_LOGIC_VECTOR(31 downto 0);
    signal signimm_sl2  : STD_LOGIC_VECTOR(31 downto 0);  -- signimm << 2
    signal pcsrc        : STD_LOGIC;                       -- Branch AND zero

    ------------------------------------------------------------------
    -- ALU
    ------------------------------------------------------------------
    signal alu_srcB  : STD_LOGIC_VECTOR(31 downto 0);
    signal alu_funct : STD_LOGIC_VECTOR(5 downto 0);

    signal alu_result : STD_LOGIC_VECTOR(31 downto 0);
    signal alu_zero   : STD_LOGIC;
    signal alu_ovfl   : STD_LOGIC;

    ------------------------------------------------------------------
    -- Data Memory
    ------------------------------------------------------------------
    signal mem_data : STD_LOGIC_VECTOR(31 downto 0);

begin

    ------------------------------------------------------------------
    -- Decode
    ------------------------------------------------------------------
    opcode <= instruction(31 downto 26);
    rs     <= instruction(25 downto 21);
    rt     <= instruction(20 downto 16);
    rd     <= instruction(15 downto 11);
    shamt  <= instruction(10 downto 6);
    funct  <= instruction(5 downto 0);
    imm    <= instruction(15 downto 0);

    ------------------------------------------------------------------
    -- Branch logic (BEQ/BNE)
    ------------------------------------------------------------------
    -- BEQ desvia quando zero='1'; BNE desvia quando zero='0'
    pcsrc <= (Branch and alu_zero) or (Bne and (not alu_zero));

    ------------------------------------------------------------------
    -- Next PC: PC+4 / branch / jump, encapsulado em componente
    -- proprio (evita que a logica "exploda" no RTL view)
    ------------------------------------------------------------------
    U_PCNEXT : entity work.pcnext
    port map(
        pc_current  => pc_current,
        instr_25_0  => instruction(25 downto 0),
        signimm_sl2 => signimm_sl2,
        Jump        => Jump,
        pcsrc       => pcsrc,
        pc_next     => pc_next
    );

    ------------------------------------------------------------------
    -- Write Register MUX
    ------------------------------------------------------------------
    write_reg <= rd when RegDst='1'
                 else rt;

    ------------------------------------------------------------------
    -- Write Back MUX
    ------------------------------------------------------------------
    write_data <= mem_data when MemToReg='1'
                  else alu_result;

    ------------------------------------------------------------------
    -- ALU Source MUX
    ------------------------------------------------------------------
    alu_srcB <= signimm when ALUSrc='1'
                else srcB;

    ------------------------------------------------------------------
    -- PC
    ------------------------------------------------------------------
    U_PC : entity work.pc
    port map(
        clk     => clk,
        reset   => reset,
        pc_next => pc_next,
        pc_out  => pc_current
    );

    ------------------------------------------------------------------
    -- Instruction Memory
    ------------------------------------------------------------------
    U_IMEM : entity work.imem
    port map(
        a  => pc_current(7 downto 2),
        rd => instruction
    );

    ------------------------------------------------------------------
    -- Main Control
    ------------------------------------------------------------------
    U_CONTROL : entity work.control_unit
    port map(
        opcode   => opcode,
        RegDst   => RegDst,
        ALUSrc   => ALUSrc,
        MemToReg => MemToReg,
        RegWrite => RegWrite,
        MemWrite => MemWrite,
        Branch   => Branch,
        Bne      => Bne,
        Jump     => Jump,
        ALUOp    => ALUOp
    );

    ------------------------------------------------------------------
    -- Register File
    ------------------------------------------------------------------
    U_REGFILE : entity work.regfile
    port map(
        clk => clk,

        we3 => RegWrite,

        ra1 => rs,
        ra2 => rt,

        wa3 => write_reg,

        wd3 => write_data,

        rd1 => srcA,
        rd2 => srcB
    );

    ------------------------------------------------------------------
    -- Sign Extend
    ------------------------------------------------------------------
    U_SIGNEXT : entity work.signext
    port map(
        a => imm,
        y => signimm
    );

    ------------------------------------------------------------------
    -- Shift Left 2 (for branch offset)
    ------------------------------------------------------------------
    U_SL2 : entity work.sl2
    port map(
        a => signimm,
        y => signimm_sl2
    );

    ------------------------------------------------------------------
    -- ALU CONTROL
    ------------------------------------------------------------------
    U_ALUCTRL : entity work.alu_control
    port map(
        ALUOp     => ALUOp,
        funct     => funct,
        alu_funct => alu_funct
    );

    ------------------------------------------------------------------
    -- ALU
    ------------------------------------------------------------------
    U_ALU : entity work.ula
    port map(
        A      => srcA,
        B      => alu_srcB,
        shamt  => shamt,
        funct  => alu_funct,

        R      => alu_result,

        zero   => alu_zero,
        ovfl   => alu_ovfl
    );

    ------------------------------------------------------------------
    -- Data Memory
    ------------------------------------------------------------------
    U_DMEM : entity work.dmem
    port map(
        clk  => clk,
        we   => MemWrite,

        addr => alu_result,
        wd   => srcB,

        rd   => mem_data
    );

end structural;