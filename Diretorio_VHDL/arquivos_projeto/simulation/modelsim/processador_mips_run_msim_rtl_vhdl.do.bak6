transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/hardware/pc.vhd}
vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/hardware/imem.vhd}
vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/hardware/dmem.vhd}
vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/hardware/regfile.vhd}
vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/hardware/ula.vhd}
vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/hardware/alu_control.vhd}
vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/hardware/control_unit.vhd}
vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/hardware/signext.vhd}
vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/hardware/sl2.vhd}
vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/hardware/processador_top.vhd}

vcom -2008 -work work {C:/Users/Djmz2/Downloads/MeuProjetoMIPS/MeuProjetoMIPS/Diretorio_VHDL/arquivos_projeto/../simulacao_testbench/tb_processador_top.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  tb_processador_top

add wave *
view structure
view signals
run -all
