# Script Projeto Laboratorio de Sistemas Digitais 2020/1 - UFMG
# Autores:
#   Arthur  Coelho  Ruback
#   Eduardo Cardoso Mendes
#   Ítalo   Azevedo Pereira

if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -93 "aeroporto.vhd"
vcom -explicit  -93 "counter.vhd"
vcom -explicit  -93 "smart_fifo.vhd"
vcom -explicit  -93 "up_counter.vhd"
vcom -explicit  -93 "register_1bit.vhd"
vcom -explicit  -93 "modified_dual_port_ram.vhd"
vcom -explicit  -93 "tb_aeroporto.vhd"
vsim -t 1ns   -lib work tb_aeroporto
add wave sim:/tb_aeroporto/*
#do {wave.do}
view wave
view structure
view signals
run 3000 ns
#quit -force
