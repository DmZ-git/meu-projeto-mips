# ==== Simulacao do PROCESSADOR COMPLETO (ModelSim-Altera) ====
# Copie memfile.dat para esta pasta antes:  copy ..\arquivos_auxiliares\memfile.dat .
vlib work
vmap work work

# --- hardware: folhas primeiro, top depois ---
vcom -2008 -work work ../hardware/pc.vhd
vcom -2008 -work work ../hardware/imem.vhd
vcom -2008 -work work ../hardware/dmem.vhd
vcom -2008 -work work ../hardware/regfile.vhd
vcom -2008 -work work ../hardware/ula.vhd
vcom -2008 -work work ../hardware/alu_control.vhd
vcom -2008 -work work ../hardware/control_unit.vhd
vcom -2008 -work work ../hardware/signext.vhd
vcom -2008 -work work ../hardware/sl2.vhd
vcom -2008 -work work ../hardware/processador_top.vhd
vcom -2008 -work work tb_processador_top.vhd

vsim -c work.tb_processador_top
add wave -r /tb_processador_top/DUT/*
run 900 ns
quit -f
