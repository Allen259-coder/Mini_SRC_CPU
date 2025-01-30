transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Registers {C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Registers/register_64.v}
vlog -vlog01compat -work work +incdir+C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Registers {C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Registers/register_32.v}
vlog -vlog01compat -work work +incdir+C:/Users/19ajl16/Desktop/Mini_SRC_CPU {C:/Users/19ajl16/Desktop/Mini_SRC_CPU/cpu_top.v}
vlog -vlog01compat -work work +incdir+C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Simulations {C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Simulations/cpu_top_tb.v}
vlog -vlog01compat -work work +incdir+C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Registers {C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Registers/special_registers.v}
vlog -vlog01compat -work work +incdir+C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Registers {C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Registers/register_file.v}
vlog -vlog01compat -work work +incdir+C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Registers {C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Registers/register.v}
vlog -vlog01compat -work work +incdir+C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Bus {C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Bus/bus.v}

vlog -vlog01compat -work work +incdir+C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Simulations {C:/Users/19ajl16/Desktop/Mini_SRC_CPU/Simulations/cpu_top_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  cpu_top_tb

add wave *
view structure
view signals
run 500 ms
