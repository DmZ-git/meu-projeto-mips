# ==== Simulacao do TESTBENCH MODULAR da ULA (ModelSim-Altera) ====
# Execute a partir de simulacao_testbench/ com os dados em arquivos_auxiliares/
# copiados para esta pasta:  copy ..\arquivos_auxiliares\input.txt .
vlib work
vmap work work

# --- dependencias primeiro, tb por ultimo ---
vcom -2008 -work work ../hardware/ula.vhd
vcom -2008 -work work stimulus.vhd
vcom -2008 -work work checker.vhd
vcom -2008 -work work tb_mips_modular.vhd

vsim -c work.tb_mips_modular
run 600 ns
quit -f
