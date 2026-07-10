# Processador MIPS de ciclo único — VHDL (Quartus II + ModelSim)

Estrutura de entrega:

    MeuProjetoMIPS/
    ├── Diretorio_LaTeX/                 # relatorio (artigo IEEE) — a preencher
    └── Diretorio_VHDL/
        ├── arquivos_projeto/            # processador_mips.qpf / .qsf (Cyclone IV E DE2-115)
        ├── hardware/                    # descricao de hardware (.vhd)
        ├── simulacao_testbench/         # testbench modular + TBs self-checking
        └── arquivos_auxiliares/         # memfile.dat, input.txt, generate_input.py

## Instrução (ISA) suportada
ADD, ADDI, ADDIU, BEQ, BNE, J, SUB/SUBU, AND, OR, XOR, SLT, NOR, SLL, SRL, SRA
(+ LW/SW no controle, para uso da memória de dados).

## Correções aplicadas nesta versão
- **BNE** implementado: caso do opcode `000101` em `control_unit.vhd` (sinal `Bne`,
  `ALUOp="01"`) e desvio corrigido em `processador_top.vhd`:
  `pcsrc <= (Branch and alu_zero) or (Bne and (not alu_zero))`.
- **ADDI** decodificado: caso do opcode `001000` em `control_unit.vhd`.
- Testbench modular reforçado: `checker.vhd` agora confere também AND/OR/XOR/NOR/SLT.

## Simulação no ModelSim (testbench modular exigido)

> **Ordem de compilação importa!** O `vcom` resolve dependências na hora, então
> as entidades usadas (`stimulus`, `ula`, `checker`) precisam ser compiladas
> **antes** do `tb_mips_modular`. Compilar o TB primeiro dá o erro
> "Could not find work.stimulus / work.checker".

Modo fácil — use os scripts `.do` prontos (a partir de `simulacao_testbench/`):

    # copie os dados lidos por caminho relativo para a pasta de trabalho:
    #   copy ..\arquivos_auxiliares\input.txt .
    #   copy ..\arquivos_auxiliares\memfile.dat .
    do run_modular.do        # testbench modular da ULA (checker)
    do run_processador.do    # processador completo (waveforms)

Manual (ordem correta):

    vlib work
    vcom -2008 -work work ../hardware/ula.vhd
    vcom -2008 -work work stimulus.vhd
    vcom -2008 -work work checker.vhd
    vcom -2008 -work work tb_mips_modular.vhd
    vsim work.tb_mips_modular
    run -all

Para capturar as formas de onda do programa MARS, use `tb_processador_top.vhd`
(roda `memfile.dat`; depois `add wave -r /tb_processador_top/DUT/*`).

> **ModelSim ASE 10.1d:** os TBs `tb_processador_check.vhd` e `tb_processador_isa.vhd`
> usam *external names* (VHDL-2008), que essa versão antiga do ModelSim **não**
> suporta — eles servem para verificação automática no GHDL / ModelSim recente.
> Na 10.1d use `tb_mips_modular` (exigido) e `tb_processador_top` (waveforms), que
> não dependem desse recurso.

> A mensagem "metavalue detected, returning 0" no instante 0 ns é benigna: ocorre
> antes do reset estabilizar os endereços das memórias e desaparece em seguida.

## Reproduzir com GHDL (opcional)
    ghdl -a --std=08 -fsynopsys ../hardware/*.vhd ../simulacao_testbench/*.vhd
    ghdl -e --std=08 -fsynopsys tb_mips_modular && ghdl -r --std=08 -fsynopsys tb_mips_modular --stop-time=500ns

## Observação sobre caminhos de arquivo
`imem.vhd` (`init_mem("memfile.dat")`) e `stimulus.vhd` (`open ... "input.txt"`) usam
caminho **relativo ao diretório de execução**. Garanta que os dois arquivos estejam
nessa pasta (ou ajuste o caminho no código).

## Síntese no Quartus II
Abra `arquivos_projeto/processador_mips.qpf`. O `.qsf` já referencia os `.vhd`
com caminhos relativos e define VHDL-2008. Se for sintetizar (não só simular),
inclua `memfile.dat` na pasta do projeto para a inicialização da ROM.
