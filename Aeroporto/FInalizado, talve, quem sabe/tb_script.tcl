#vsim -do tb_script.do
#puts {
#  Arquivo Exemplo de um FFD para Guia de aula_10
#  Laboratoria de Sistemas Digitais 
#  Autores: Professores da Area de Eletronica UFMG
#}

# Exemplo simples de como usar um script em TCL 
# para automatizar as simulacoes com ModelSim
# Para cada novo projeto devem ser modificados 
# os nomes relativos aos arquivos dentro do projeto. 

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
