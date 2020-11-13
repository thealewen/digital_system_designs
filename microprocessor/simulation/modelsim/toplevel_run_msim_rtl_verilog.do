transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/reg_16.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/HexDriver.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/sync.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/SLC3_2.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/Mem2IO.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/ISDU.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/test_memory.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/datapath.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/mux4to1.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/mux2to1.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/ALUK.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/regfile.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/nzp.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/slc3.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/memory_contents.sv}
vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/slc3_testtop.sv}

vlog -sv -work work +incdir+D:/ECE\ 385\ Quartus/Practise/microprocessor {D:/ECE 385 Quartus/Practise/microprocessor/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 5000000 ps
