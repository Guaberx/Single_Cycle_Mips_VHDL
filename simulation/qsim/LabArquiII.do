onerror {quit -f}
vlib work
vlog -work work LabArquiII.vo
vlog -work work LabArquiII.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.monociclo_vlg_vec_tst
vcd file -direction LabArquiII.msim.vcd
vcd add -internal monociclo_vlg_vec_tst/*
vcd add -internal monociclo_vlg_vec_tst/i1/*
add wave /*
run -all
