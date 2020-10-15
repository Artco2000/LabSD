transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/Documents/Faculdade/3 Periodo/Lab SD/Aula 10/Projeto Quatus II/FFD.vhd}

