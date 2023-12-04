# AG Report MP4CP4 2023-12-04T11:14:06-06:00 
Report generated at 2023-12-04T11:23:29-06:00, using commit ``0b884193c7fa222f95fe977d184e69353cc37338``

Autograder Run ID: ac5c41fe-9f5e-4756-8b1f-b959ed9eb11b

Autograder Job ID: a66b68fb-f0ca-4230-ba31-f019bec6062f


## Logs
<details><summary>Compile ⚠️</summary> 

 ``` 
 mkdir -p sim
cd sim && vcs /tmp/dut/pkg/types.sv /tmp/dut/hdl/mem_interface/mem_word_adaptor.sv /tmp/dut/hdl/mem_interface/cacheline_adaptor.sv /tmp/dut/hdl/mem_interface/arbiter.sv /tmp/dut/hdl/mem_interface/cache/valid.sv /tmp/dut/hdl/mem_interface/cache/ff_array.sv /tmp/dut/hdl/mem_interface/cache/dirty.sv /tmp/dut/hdl/mem_interface/cache/cache_datapath.sv /tmp/dut/hdl/mem_interface/cache/cache_control.sv /tmp/dut/hdl/mem_interface/cache/cache.sv /tmp/dut/hdl/mem_interface/cache/PLRU.sv /tmp/dut/hdl/ctrl_buffer/prefetch_buffer.sv /tmp/dut/hdl/ctrl_buffer/control_buffer.sv /tmp/dut/hdl/wb_stage.sv /tmp/dut/hdl/shift_reg.sv /tmp/dut/hdl/sext_half.sv /tmp/dut/hdl/sext_byte.sv /tmp/dut/hdl/register.sv /tmp/dut/hdl/regfile.sv /tmp/dut/hdl/pipeline_registers.sv /tmp/dut/hdl/multiply_and_divide.sv /tmp/dut/hdl/multiplier_v2.sv /tmp/dut/hdl/multiplier.sv /tmp/dut/hdl/mp4datapath.sv /tmp/dut/hdl/mp4control.sv /tmp/dut/hdl/mp4.sv /tmp/dut/hdl/mem_stage.sv /tmp/dut/hdl/mem_data_out.sv /tmp/dut/hdl/mar.sv /tmp/dut/hdl/hazard_queue.sv /tmp/dut/hdl/fetch_stage.sv /tmp/dut/hdl/exe_stage.sv /tmp/dut/hdl/divider_slow.sv /tmp/dut/hdl/div_compare.sv /tmp/dut/hdl/decode_stage.sv /tmp/dut/hdl/counter.sv /tmp/dut/hdl/cmp.sv /tmp/dut/hdl/alu.sv /tmp/dut/hvl/top_tb.sv /tmp/dut/hvl/rvfimon.v /tmp/dut/hvl/monitor.sv /tmp/dut/hvl/mon_itf.sv /tmp/dut/hvl/burst_memory.sv /tmp/dut/hvl/bmem_itf.sv /tmp/dut/sram/output/mp3_data_array/mp3_data_array.v /tmp/dut/sram/output/mp3_tag_array/mp3_tag_array.v -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LCA_FEATURES_ENABLED -licqueue -msg_config=../vcs_warn.config -l compile.log -top top_tb -o top_tb
                         Chronologic VCS (TM)
      Version R-2020.12-SP1-1_Full64 -- Mon Dec  4 11:25:04 2023

                    Copyright (c) 1991 - 2021 Synopsys, Inc.
   This software and the associated documentation are proprietary to Synopsys,
 Inc. This software may only be used in accordance with the terms and conditions
 of a written license agreement with Synopsys, Inc. All other use, reproduction,
            or distribution of this software is strictly prohibited.

Parsing design file '/tmp/dut/pkg/types.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/mem_word_adaptor.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cacheline_adaptor.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/arbiter.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/valid.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/ff_array.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/dirty.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/cache_control.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/cache.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/PLRU.sv'
Parsing design file '/tmp/dut/hdl/ctrl_buffer/prefetch_buffer.sv'
Parsing design file '/tmp/dut/hdl/ctrl_buffer/control_buffer.sv'
Parsing design file '/tmp/dut/hdl/wb_stage.sv'
Parsing design file '/tmp/dut/hdl/shift_reg.sv'
Parsing design file '/tmp/dut/hdl/sext_half.sv'
Parsing design file '/tmp/dut/hdl/sext_byte.sv'
Parsing design file '/tmp/dut/hdl/register.sv'
Parsing design file '/tmp/dut/hdl/regfile.sv'
Parsing design file '/tmp/dut/hdl/pipeline_registers.sv'
Parsing design file '/tmp/dut/hdl/multiply_and_divide.sv'
Parsing design file '/tmp/dut/hdl/multiplier_v2.sv'
Parsing design file '/tmp/dut/hdl/multiplier.sv'
Parsing design file '/tmp/dut/hdl/mp4datapath.sv'
Parsing design file '/tmp/dut/hdl/mp4control.sv'
Parsing design file '/tmp/dut/hdl/mp4.sv'

Warning-[IPDW] Identifier previously declared
/tmp/dut/hdl/mp4.sv, 123
  Second declaration for identifier 'pc_wdata' ignored
  Identifier 'pc_wdata' previously declared as logic. [/tmp/dut/hdl/mp4.sv, 
  93]

Parsing design file '/tmp/dut/hdl/mem_stage.sv'
Parsing design file '/tmp/dut/hdl/mem_data_out.sv'
Parsing design file '/tmp/dut/hdl/mar.sv'
Parsing design file '/tmp/dut/hdl/hazard_queue.sv'
Parsing design file '/tmp/dut/hdl/fetch_stage.sv'
Parsing design file '/tmp/dut/hdl/exe_stage.sv'
Parsing design file '/tmp/dut/hdl/divider_slow.sv'
Parsing design file '/tmp/dut/hdl/div_compare.sv'
Parsing design file '/tmp/dut/hdl/decode_stage.sv'
Parsing design file '/tmp/dut/hdl/counter.sv'
Parsing design file '/tmp/dut/hdl/cmp.sv'
Parsing design file '/tmp/dut/hdl/alu.sv'
Parsing design file '/tmp/dut/hvl/top_tb.sv'
Parsing design file '/tmp/dut/hvl/rvfimon.v'
Parsing design file '/tmp/dut/hvl/monitor.sv'
Parsing design file '/tmp/dut/hvl/mon_itf.sv'
Parsing design file '/tmp/dut/hvl/burst_memory.sv'
Parsing design file '/tmp/dut/hvl/bmem_itf.sv'
Parsing design file '/tmp/dut/sram/output/mp3_data_array/mp3_data_array.v'
Parsing design file '/tmp/dut/sram/output/mp3_tag_array/mp3_tag_array.v'
Top Level Modules:
       top_tb
TimeScale is 1 ps / 1 ps

Lint-[WMIA-L] Width mismatch in assignment
/tmp/dut/hdl/ctrl_buffer/control_buffer.sv, 127
  Width mismatch between LHS and RHS is found in assignment:
  The following 3-bit wide expression is assigned to a 2-bit LHS target:
  Source info: jtb_fetch_hit_index = clogb2({4'b0, jp_fetch_hits});
  Expression: jtb_fetch_hit_index

Notice: Ports coerced to inout, use -notice for details
Starting vcs inline pass...

85 modules and 0 UDP read.
recompiling package rv32i_cache_types
recompiling package pcmux
recompiling package marmux
recompiling package cmpmux
recompiling package alumux
recompiling package regfilemux
recompiling package rs1mux
recompiling package rs2mux
recompiling package exefwdmux
recompiling package memfwdmux
recompiling package rs1signunsignmux
recompiling package rs2signunsignmux
recompiling package multihighlowmux
recompiling package divremquotmux
recompiling package rv32i_types
recompiling package cpuIO
recompiling package hazards
recompiling package immediates
recompiling module mem_word_adapter
recompiling module cacheline_adaptor
recompiling module cache_arbiter
recompiling module ff_array
recompiling module cache
recompiling module prefetch_buffer
recompiling module control_buffer
recompiling module btb_entry
recompiling module wb_stage
recompiling module dec_exe_reg
recompiling module mem_wb_reg
recompiling module mp4control
recompiling module mp4
recompiling module decode_stage
recompiling module cmp
recompiling module top_tb
recompiling module riscv_formal_monitor_rv32imc_rob
recompiling module riscv_formal_monitor_rv32imc_insn_c_jr
recompiling module riscv_formal_monitor_rv32imc_insn_c_li
recompiling module riscv_formal_monitor_rv32imc_insn_c_lui
recompiling module riscv_formal_monitor_rv32imc_insn_c_lw
recompiling module riscv_formal_monitor_rv32imc_insn_c_lwsp
recompiling module riscv_formal_monitor_rv32imc_insn_c_mv
recompiling module riscv_formal_monitor_rv32imc_insn_c_or
recompiling module riscv_formal_monitor_rv32imc_insn_c_slli
recompiling module riscv_formal_monitor_rv32imc_insn_c_srai
recompiling module riscv_formal_monitor_rv32imc_insn_c_srli
recompiling module riscv_formal_monitor_rv32imc_insn_c_sub
recompiling module riscv_formal_monitor_rv32imc_insn_c_sw
recompiling module riscv_formal_monitor_rv32imc_insn_c_swsp
recompiling module riscv_formal_monitor_rv32imc_insn_c_xor
recompiling module riscv_formal_monitor_rv32imc_insn_divu
50 of 85 modules done
recompiling module riscv_formal_monitor_rv32imc_insn_jal
recompiling module riscv_formal_monitor_rv32imc_insn_jalr
recompiling module riscv_formal_monitor_rv32imc_insn_lb
recompiling module riscv_formal_monitor_rv32imc_insn_lbu
recompiling module riscv_formal_monitor_rv32imc_insn_lh
recompiling module riscv_formal_monitor_rv32imc_insn_lhu
recompiling module riscv_formal_monitor_rv32imc_insn_lui
recompiling module riscv_formal_monitor_rv32imc_insn_lw
recompiling module riscv_formal_monitor_rv32imc_insn_mul
recompiling module riscv_formal_monitor_rv32imc_insn_mulh
recompiling module riscv_formal_monitor_rv32imc_insn_mulhsu
recompiling module riscv_formal_monitor_rv32imc_insn_mulhu
recompiling module riscv_formal_monitor_rv32imc_insn_or
recompiling module riscv_formal_monitor_rv32imc_insn_ori
recompiling module riscv_formal_monitor_rv32imc_insn_remu
recompiling module riscv_formal_monitor_rv32imc_insn_sb
recompiling module riscv_formal_monitor_rv32imc_insn_sh
recompiling module riscv_formal_monitor_rv32imc_insn_sll
recompiling module riscv_formal_monitor_rv32imc_insn_slli
recompiling module riscv_formal_monitor_rv32imc_insn_slt
recompiling module riscv_formal_monitor_rv32imc_insn_slti
recompiling module riscv_formal_monitor_rv32imc_insn_sltiu
recompiling module riscv_formal_monitor_rv32imc_insn_sltu
recompiling module riscv_formal_monitor_rv32imc_insn_sra
recompiling module riscv_formal_monitor_rv32imc_insn_srai
recompiling module riscv_formal_monitor_rv32imc_insn_srl
recompiling module riscv_formal_monitor_rv32imc_insn_srli
recompiling module riscv_formal_monitor_rv32imc_insn_sub
recompiling module riscv_formal_monitor_rv32imc_insn_sw
recompiling module riscv_formal_monitor_rv32imc_insn_xor
recompiling module riscv_formal_monitor_rv32imc_insn_xori
recompiling module mon_itf
recompiling module burst_memory
recompiling module bmem_itf
recompiling module mp3_data_array
All of 85 modules done
make[1]: Entering directory '/tmp/dut/sim/csrc'
make[1]: Leaving directory '/tmp/dut/sim/csrc'
/srv/software/Synopsys-2021_x86_64/vcs-mx/O-2018.09-SP2-3/bin/vcs: line 31361: 193019 Segmentation fault      (core dumped) ${TOOL_HOME}/bin/cfs_ident_exec -f ${XML_INPUT_EXE} -o "${fsearchDir}/idents_tapi.xml" -o_SrcFile "${dirSrcFiles}/src_files_c" ${all_dyn_libs} > tapi_xml_writer.log
make[1]: Entering directory '/tmp/dut/sim/csrc'
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
if [ -x ../top_tb ]; then chmod a-x ../top_tb; fi
g++  -o ../top_tb      -rdynamic  -Wl,-rpath='$ORIGIN'/top_tb.daidir -Wl,-rpath=./top_tb.daidir -Wl,-rpath=/srv/software/Synopsys-2021_x86_64/vcs/R-2020.12-SP1-1/linux64/lib -L/srv/software/Synopsys-2021_x86_64/vcs/R-2020.12-SP1-1/linux64/lib  -Wl,-rpath-link=./  /usr/lib64/libnuma.so.1   objs/amcQw_d.o   _192863_archive_1.so  SIM_l.o      rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o           -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /srv/software/Synopsys-2021_x86_64/vcs/R-2020.12-SP1-1/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive        _vcs_pli_stub_.o   /srv/software/Synopsys-2021_x86_64/vcs/R-2020.12-SP1-1/linux64/lib/vcs_save_restore_new.o /srv/software/Synopsys-2021_x86_64/verdi/R-2020.12-SP1-1/share/PLI/VCS/LINUX64/pli.a -ldl  -lc -lm -lpthread -ldl 
../top_tb up to date
make[1]: Leaving directory '/tmp/dut/sim/csrc'
CPU time: 3.322 seconds to compile + .491 seconds to elab + .332 seconds to link
Verdi KDB elaboration done and the database successfully generated: 0 error(s), 0 warning(s)

[0;33mCompile finished with warnings:[0m
Warning-[IPDW] Identifier previously declared
Lint-[WMIA-L] Width mismatch in assignment
 
 ``` 

 </details> 
<details><summary>Synthesis ❌</summary> 

 ``` 
 rm -f  *.log
rm -f  default.svf
rm -rf work
rm -rf reports
rm -rf outputs
mkdir -p reports outputs
dc_shell -f synthesis.tcl |& tee reports/synthesis.log
/srv/software/Synopsys-2021_x86_64/syn/R-2020.09-SP4/bin/dc_shell: /srv/software/Synopsys-2021_x86_64/syn/R-2020.09-SP4/bin/snps_platform: /bin/csh: bad interpreter: No such file or directory

                           Design Compiler Graphical 
                                 DC Ultra (TM)
                                  DFTMAX (TM)
                              Power Compiler (TM)
                                 DesignWare (R)
                                 DC Expert (TM)
                               Design Vision (TM)
                               HDL Compiler (TM)
                               VHDL Compiler (TM)
                                  DFT Compiler
                               Design Compiler(R)

               Version R-2020.09-SP4 for linux64 - Mar 02, 2021 

                    Copyright (c) 1988 - 2021 Synopsys, Inc.
   This software and the associated documentation are proprietary to Synopsys,
 Inc. This software may only be used in accordance with the terms and conditions
 of a written license agreement with Synopsys, Inc. All other use, reproduction,
            or distribution of this software is strictly prohibited.
Initializing...
set hdlin_ff_always_sync_set_reset true
true
set hdlin_ff_always_async_set_reset true
true
set hdlin_infer_multibit default_all
default_all
set hdlin_check_no_latch true
true
set_app_var report_default_significant_digits 6
6
set design_toplevel mp4
mp4
# output port '%s' is connected directly to output port '%s'
suppress_message LINT-31
# In design '%s', output port '%s' is connected directly to '%s'.
suppress_message LINT-52
# '%s' is not connected to any nets
suppress_message LINT-28
# output port '%s' is connected directly to output port '%s'
suppress_message LINT-29
# a pin on submodule '%s' is connected to logic 1 or logic 0
suppress_message LINT-32
# the same net is connected to more than one pin on submodule '%s'
suppress_message LINT-33
# '%s' is not connected to any nets
suppress_message LINT-28
# In design '%s', cell '%s' does not drive any nets.
suppress_message LINT-1
# There are %d potential problems in your design. Please run 'check_design' for more information.
suppress_message LINT-99
# In design '%s', net '%s' driven by pin '%s' has no loads.
suppress_message LINT-2
# The register '' is a constant and will be removed.
suppress_message OPT-1206
# The register '' will be removed.
suppress_message OPT-1207
# Can't read link_library file '%s'
suppress_message UID-3
# Design '%s' contains %d high-fanout nets.
suppress_message TIM-134
# The trip points for the library named %s differ from those in the library named %s.
suppress_message TIM-164
# Design has unannotated black box outputs.
suppress_message PWR-428
# Skipping clock gating on design %s, since there are no registers.
suppress_message PWR-806
# Ungrouping hierarchy %s before Pass 1.
suppress_message OPT-776
# Verilog 'assign' or 'tran' statements are written out.
suppress_message VO-4
# Verilog writer has added %d nets to module %s using %s as prefix.
suppress_message VO-11
# %s DEFAULT branch of CASE statement cannot be reached.
suppress_message ELAB-311
# Netlist for always_comb block is empty.
suppress_message ELAB-982
# Netlist for always_ff block is empty.
suppress_message ELAB-984
define_design_lib WORK -path ./work
1
set alib_library_analysis_path [getenv STD_CELL_ALIB]
/srv/ece411ag/freepdk-45nm/alib
set symbol_library [list generic.sdb]
generic.sdb
set synthetic_library [list dw_foundation.sldb]
dw_foundation.sldb
set target_library [getenv STD_CELL_LIB]
/srv/ece411ag/freepdk-45nm/stdcells.db
set sram_library [getenv SRAM_LIB]
/tmp/dut/synth/../sram/output/mp3_data_array/mp3_data_array_TT_1p0V_25C_lib.db /tmp/dut/synth/../sram/output/mp3_tag_array/mp3_tag_array_TT_1p0V_25C_lib.db
if {$sram_library eq ""} {
   set link_library [list "*" $target_library $synthetic_library]
} else {
   set link_library [list "*" $target_library $synthetic_library $sram_library]
}
* /srv/ece411ag/freepdk-45nm/stdcells.db dw_foundation.sldb {/tmp/dut/synth/../sram/output/mp3_data_array/mp3_data_array_TT_1p0V_25C_lib.db /tmp/dut/synth/../sram/output/mp3_tag_array/mp3_tag_array_TT_1p0V_25C_lib.db}
set design_clock_pin clk
clk
set design_reset_pin rst
rst
analyze -library WORK -format sverilog [getenv PKG_SRCS]
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../pkg/types.sv
Presto compilation completed successfully.
Loading db file '/srv/ece411ag/freepdk-45nm/stdcells.db'
Loading db file '/srv/software/Synopsys-2021_x86_64/syn/R-2020.09-SP4/libraries/syn/dw_foundation.sldb'
1
set modules [split [getenv HDL_SRCS] " "]
/tmp/dut/synth/../hdl/mem_interface/mem_word_adaptor.sv /tmp/dut/synth/../hdl/mem_interface/cacheline_adaptor.sv /tmp/dut/synth/../hdl/mem_interface/arbiter.sv /tmp/dut/synth/../hdl/mem_interface/cache/valid.sv /tmp/dut/synth/../hdl/mem_interface/cache/ff_array.sv /tmp/dut/synth/../hdl/mem_interface/cache/dirty.sv /tmp/dut/synth/../hdl/mem_interface/cache/cache_datapath.sv /tmp/dut/synth/../hdl/mem_interface/cache/cache_control.sv /tmp/dut/synth/../hdl/mem_interface/cache/cache.sv /tmp/dut/synth/../hdl/mem_interface/cache/PLRU.sv /tmp/dut/synth/../hdl/ctrl_buffer/prefetch_buffer.sv /tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv /tmp/dut/synth/../hdl/wb_stage.sv /tmp/dut/synth/../hdl/shift_reg.sv /tmp/dut/synth/../hdl/sext_half.sv /tmp/dut/synth/../hdl/sext_byte.sv /tmp/dut/synth/../hdl/register.sv /tmp/dut/synth/../hdl/regfile.sv /tmp/dut/synth/../hdl/pipeline_registers.sv /tmp/dut/synth/../hdl/multiply_and_divide.sv /tmp/dut/synth/../hdl/multiplier_v2.sv /tmp/dut/synth/../hdl/multiplier.sv /tmp/dut/synth/../hdl/mp4datapath.sv /tmp/dut/synth/../hdl/mp4control.sv /tmp/dut/synth/../hdl/mp4.sv /tmp/dut/synth/../hdl/mem_stage.sv /tmp/dut/synth/../hdl/mem_data_out.sv /tmp/dut/synth/../hdl/mar.sv /tmp/dut/synth/../hdl/hazard_queue.sv /tmp/dut/synth/../hdl/fetch_stage.sv /tmp/dut/synth/../hdl/exe_stage.sv /tmp/dut/synth/../hdl/divider_slow.sv /tmp/dut/synth/../hdl/div_compare.sv /tmp/dut/synth/../hdl/decode_stage.sv /tmp/dut/synth/../hdl/counter.sv /tmp/dut/synth/../hdl/cmp.sv /tmp/dut/synth/../hdl/alu.sv
foreach module $modules {
   analyze -library WORK -format sverilog "${module}"
}
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/mem_word_adaptor.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cacheline_adaptor.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/arbiter.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/valid.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/ff_array.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/dirty.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/cache_datapath.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/cache_control.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/cache.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/PLRU.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/ctrl_buffer/prefetch_buffer.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/wb_stage.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/shift_reg.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/sext_half.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/sext_byte.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/register.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/regfile.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/pipeline_registers.sv
Warning:  /tmp/dut/synth/../hdl/pipeline_registers.sv:560: Nonstandard package access 'memfwdmux::'; this name has a more local definition. (VER-734)
Warning:  /tmp/dut/synth/../hdl/pipeline_registers.sv:561: Nonstandard package access 'memfwdmux::'; this name has a more local definition. (VER-734)
Warning:  /tmp/dut/synth/../hdl/pipeline_registers.sv:562: Nonstandard package access 'memfwdmux::'; this name has a more local definition. (VER-734)
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/multiply_and_divide.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/multiplier_v2.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/multiplier.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mp4datapath.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mp4control.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mp4.sv
Error:  /tmp/dut/synth/../hdl/mp4.sv:123: The register symbol 'pc_wdata' has already been defined. (VER-954)
*** Presto compilation terminated with 1 errors. ***
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_stage.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_data_out.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mar.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/hazard_queue.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/fetch_stage.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/exe_stage.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/divider_slow.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/div_compare.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/decode_stage.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/counter.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/cmp.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/alu.sv
Presto compilation completed successfully.
elaborate $design_toplevel
Loading db file '/tmp/dut/sram/output/mp3_data_array/mp3_data_array_TT_1p0V_25C_lib.db'
Loading db file '/tmp/dut/sram/output/mp3_tag_array/mp3_tag_array_TT_1p0V_25C_lib.db'
Loading db file '/srv/software/Synopsys-2021_x86_64/syn/R-2020.09-SP4/libraries/syn/gtech.db'
Loading db file '/srv/software/Synopsys-2021_x86_64/syn/R-2020.09-SP4/libraries/syn/standard.sldb'
  Loading link library 'NangateOpenCellLibrary'
  Loading link library 'mp3_data_array_TT_1p0V_25C_lib'
  Loading link library 'mp3_tag_array_TT_1p0V_25C_lib'
  Loading link library 'gtech'
Error: Cannot find the design 'mp4' in the library 'WORK'. (LBR-0)
0
current_design $design_toplevel
Error: Can't find design 'mp4'. (UID-109)
Error: Current design is not defined. (UID-4)
check_design
Error: Current design is not defined. (UID-4)
0
set_wire_load_model -name "5K_hvratio_1_1"
Error: Current design is not defined. (UID-4)
0
set_wire_load_mode enclosed
Error: Current design is not defined. (UID-4)
0
set clk_name $design_clock_pin
clk
set clk_period [expr [getenv CLOCK_PERIOD_PS] / 1000.0]
10.0
create_clock -period $clk_period -name my_clk $clk_name
Error: Current design is not defined. (UID-4)
Error: Can't find object 'clk'. (UID-109)
Error: Value for list 'source_objects' must have 1 elements. (CMD-036)
0
set_fix_hold [get_clocks my_clk]
Error: Current design is not defined. (UID-4)
Error: Can't find clock 'my_clk'. (UID-109)
Error: Value for list '<clock_list>' must have 1 elements. (CMD-036)
0
set_input_delay 0.5 [all_inputs] -clock my_clk
Error: Current design is not defined. (UID-4)
Error: Value for list 'port_pin_list' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Can't find clock 'my_clk'. (UID-109)
Error: Value for list '-clock' must have 1 elements. (CMD-036)
0
set_output_delay 0.5 [all_outputs] -clock my_clk
Error: Current design is not defined. (UID-4)
Error: Value for list 'port_pin_list' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Can't find clock 'my_clk'. (UID-109)
Error: Value for list '-clock' must have 1 elements. (CMD-036)
0
set_load 0.1 [all_outputs]
Error: Current design is not defined. (UID-4)
Error: Value for list 'objects' must have 1 elements. (CMD-036)
0
set_max_fanout 1 [all_inputs]
Error: Current design is not defined. (UID-4)
Error: Value for list 'object_list' must have 1 elements. (CMD-036)
0
set_fanout_load 8 [all_outputs]
Error: Current design is not defined. (UID-4)
Error: Value for list 'port_list' must have 1 elements. (CMD-036)
0
link
Error: Current design is not defined. (UID-4)
0
compile_ultra -gate_clock -retime
Error: Current design is not defined. (UID-4)
0
current_design $design_toplevel
Error: Can't find design 'mp4'. (UID-109)
Error: Current design is not defined. (UID-4)
report_area -hier > reports/area.rpt
report_timing -delay max > reports/timing.rpt
check_design > reports/check.rpt
write_file -format ddc -hierarchy -output outputs/synth.ddc
Error: No files or designs were specified. (UID-22)
0
write_file -format verilog -hierarchy -output [format "outputs/%s.gate.v" $design_toplevel]
Error: No files or designs were specified. (UID-22)
0
exit

Memory usage for this session 86 Mbytes.
Memory usage for this session including child processes 86 Mbytes.
CPU usage for this session 2 seconds ( 0.00 hours ).
Elapsed time for this session 3 seconds ( 0.00 hours ).

Thank you...
rm -f  *.log
rm -f  default.svf
rm -rf work

[0;31mSynthesis failed:[0m
Error:  /tmp/dut/synth/../hdl/mp4.sv:123: The register symbol 'pc_wdata' has already been defined. (VER-954)
Error: Cannot find the design 'mp4' in the library 'WORK'. (LBR-0)
Error: Can't find design 'mp4'. (UID-109)
Error: Current design is not defined. (UID-4)
Error: Current design is not defined. (UID-4)
Error: Current design is not defined. (UID-4)
Error: Current design is not defined. (UID-4)
Error: Current design is not defined. (UID-4)
Error: Can't find object 'clk'. (UID-109)
Error: Value for list 'source_objects' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Can't find clock 'my_clk'. (UID-109)
Error: Value for list '<clock_list>' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Value for list 'port_pin_list' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Can't find clock 'my_clk'. (UID-109)
Error: Value for list '-clock' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Value for list 'port_pin_list' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Can't find clock 'my_clk'. (UID-109)
Error: Value for list '-clock' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Value for list 'objects' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Value for list 'object_list' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Value for list 'port_list' must have 1 elements. (CMD-036)
Error: Current design is not defined. (UID-4)
Error: Current design is not defined. (UID-4)
Error: Can't find design 'mp4'. (UID-109)
Error: Current design is not defined. (UID-4)
Error: No files or designs were specified. (UID-22)
Error: No files or designs were specified. (UID-22)
 
 ``` 

 </details> 
