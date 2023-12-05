# AG Report MP4CP4 2023-12-04T23:59:59-06:00 
Report generated at 2023-12-05T04:03:44-06:00, using commit ``4e12e4ad756bf9d2fada341fe7c356f3845f0a7d``

Autograder Run ID: 211e7554-8818-4d42-a7b8-92b9073d2fd5

Autograder Job ID: 3cb9fa3f-2c40-4c68-9e77-29f72096eca4


## Logs
<details><summary>Compile ⚠️</summary> 

 ``` 
 mkdir -p sim
cd sim && vcs /tmp/dut/pkg/types.sv /tmp/dut/hdl/mem_interface/mem_word_adaptor.sv /tmp/dut/hdl/mem_interface/cacheline_adaptor.sv /tmp/dut/hdl/mem_interface/arbiter.sv /tmp/dut/hdl/mem_interface/cache/i_cache_datapath.sv /tmp/dut/hdl/mem_interface/cache/i_cache_control.sv /tmp/dut/hdl/mem_interface/cache/i_cache.sv /tmp/dut/hdl/mem_interface/cache/valid.sv /tmp/dut/hdl/mem_interface/cache/ff_array.sv /tmp/dut/hdl/mem_interface/cache/dirty.sv /tmp/dut/hdl/mem_interface/cache/d_cache_datapath.sv /tmp/dut/hdl/mem_interface/cache/d_cache_control.sv /tmp/dut/hdl/mem_interface/cache/d_cache.sv /tmp/dut/hdl/mem_interface/cache/PLRU.sv /tmp/dut/hdl/ctrl_buffer/prefetch_buffer.sv /tmp/dut/hdl/ctrl_buffer/control_buffer.sv /tmp/dut/hdl/wb_stage.sv /tmp/dut/hdl/shift_reg.sv /tmp/dut/hdl/sext_half.sv /tmp/dut/hdl/sext_byte.sv /tmp/dut/hdl/register.sv /tmp/dut/hdl/regfile.sv /tmp/dut/hdl/pipeline_registers.sv /tmp/dut/hdl/multiply_and_divide.sv /tmp/dut/hdl/multiplier_v2.sv /tmp/dut/hdl/multiplier.sv /tmp/dut/hdl/mp4datapath.sv /tmp/dut/hdl/mp4control.sv /tmp/dut/hdl/mp4.sv /tmp/dut/hdl/mem_stage.sv /tmp/dut/hdl/mem_data_out.sv /tmp/dut/hdl/mar.sv /tmp/dut/hdl/hazard_queue.sv /tmp/dut/hdl/fetch_stage.sv /tmp/dut/hdl/exe_stage.sv /tmp/dut/hdl/divider_slow.sv /tmp/dut/hdl/div_compare.sv /tmp/dut/hdl/decode_stage.sv /tmp/dut/hdl/counter.sv /tmp/dut/hdl/cmp.sv /tmp/dut/hdl/alu.sv /tmp/dut/hvl/top_tb.sv /tmp/dut/hvl/rvfimon.v /tmp/dut/hvl/monitor.sv /tmp/dut/hvl/mon_itf.sv /tmp/dut/hvl/burst_memory.sv /tmp/dut/hvl/bmem_itf.sv /tmp/dut/sram/output/mp3_tag_array/mp3_tag_array.v /tmp/dut/sram/output/mp3_data_array/mp3_data_array.v -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LCA_FEATURES_ENABLED -licqueue -msg_config=../vcs_warn.config -l compile.log -top top_tb -o top_tb
                         Chronologic VCS (TM)
      Version R-2020.12-SP1-1_Full64 -- Tue Dec  5 04:05:20 2023

                    Copyright (c) 1991 - 2021 Synopsys, Inc.
   This software and the associated documentation are proprietary to Synopsys,
 Inc. This software may only be used in accordance with the terms and conditions
 of a written license agreement with Synopsys, Inc. All other use, reproduction,
            or distribution of this software is strictly prohibited.

Parsing design file '/tmp/dut/pkg/types.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/mem_word_adaptor.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cacheline_adaptor.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/arbiter.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/i_cache_datapath.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/i_cache_control.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/i_cache.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/valid.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/ff_array.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/dirty.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/d_cache_datapath.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/d_cache_control.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/d_cache.sv'
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
Parsing design file '/tmp/dut/sram/output/mp3_tag_array/mp3_tag_array.v'
Parsing design file '/tmp/dut/sram/output/mp3_data_array/mp3_data_array.v'
Top Level Modules:
       top_tb
TimeScale is 1 ps / 1 ps

Lint-[ONGS] Output never gets set
/tmp/dut/hdl/mem_interface/cache/i_cache_control.sv, 21
"pmem_address_mux"
  Output port 'pmem_address_mux' has never been assigned to any value.
  


Lint-[ONGS] Output never gets set
/tmp/dut/hdl/mem_interface/cache/i_cache_control.sv, 22
"data_wmask_mux"
  Output port 'data_wmask_mux' has never been assigned to any value.
  


Lint-[WMIA-L] Width mismatch in assignment
/tmp/dut/hdl/multiplier.sv, 172
  Width mismatch between LHS and RHS is found in assignment:
  The following 64-bit wide expression is assigned to a 32-bit LHS target:
  Source info: kara_16_0 <= {32'b0, karatsuba_16(rs1[15:0], rs2[15:0])};
  Expression: kara_16_0


Lint-[WMIA-L] Width mismatch in assignment
/tmp/dut/hdl/multiplier.sv, 173
  Width mismatch between LHS and RHS is found in assignment:
  The following 64-bit wide expression is assigned to a 32-bit LHS target:
  Source info: kara_16_2 <= {32'b0, karatsuba_16(rs1[31:16], rs1[31:16])};
  Expression: kara_16_2


Lint-[WMIA-L] Width mismatch in assignment
/tmp/dut/hdl/multiplier.sv, 174
  Width mismatch between LHS and RHS is found in assignment:
  The following 64-bit wide expression is assigned to a 32-bit LHS target:
  Source info: kara_16_1_0 <= {32'b0, karatsuba_16(rs1[31:16], rs2[15:0])};
  Expression: kara_16_1_0


Lint-[WMIA-L] Width mismatch in assignment
/tmp/dut/hdl/multiplier.sv, 175
  Width mismatch between LHS and RHS is found in assignment:
  The following 64-bit wide expression is assigned to a 32-bit LHS target:
  Source info: kara_16_1_1 <= {32'b0, karatsuba_16(rs1[15:0], rs2[31:16])};
  Expression: kara_16_1_1


Lint-[WMIA-L] Width mismatch in assignment
/tmp/dut/hdl/multiplier.sv, 187
  Width mismatch between LHS and RHS is found in assignment:
  The following 2-bit wide expression is assigned to a 1-bit LHS target:
  Source info: count <= 2'b0;
  Expression: count


Lint-[UI] Unused input
/tmp/dut/hdl/mem_interface/cache/i_cache_datapath.sv, 14
  Following is an unused input.
  Source info: wmask


Lint-[UI] Unused input
/tmp/dut/hdl/mem_interface/cache/i_cache_datapath.sv, 15
  Following is an unused input.
  Source info: cpu_data_write


Lint-[WMIA-L] Width mismatch in assignment
/tmp/dut/hdl/ctrl_buffer/control_buffer.sv, 127
  Width mismatch between LHS and RHS is found in assignment:
  The following 3-bit wide expression is assigned to a 2-bit LHS target:
  Source info: jtb_fetch_hit_index = clogb2({4'b0, jp_fetch_hits});
  Expression: jtb_fetch_hit_index

Notice: Ports coerced to inout, use -notice for details
Starting vcs inline pass...

86 modules and 0 UDP read.
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
recompiling module i_cache
recompiling module ff_array
recompiling module d_cache
recompiling module PLRU_4_way
recompiling module prefetch_buffer
recompiling module control_buffer
recompiling module btb_entry
recompiling module wb_stage
recompiling module dec_exe_reg
recompiling module mem_wb_reg
recompiling module mp4control
recompiling module mp4
recompiling module decode_stage
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
50 of 86 modules done
recompiling module riscv_formal_monitor_rv32imc_insn_divu
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
All of 86 modules done
make[1]: Entering directory '/tmp/dut/sim/csrc'
make[1]: Leaving directory '/tmp/dut/sim/csrc'
/srv/software/Synopsys-2021_x86_64/vcs-mx/O-2018.09-SP2-3/bin/vcs: line 31361: 44780 Segmentation fault      (core dumped) ${TOOL_HOME}/bin/cfs_ident_exec -f ${XML_INPUT_EXE} -o "${fsearchDir}/idents_tapi.xml" -o_SrcFile "${dirSrcFiles}/src_files_c" ${all_dyn_libs} > tapi_xml_writer.log
make[1]: Entering directory '/tmp/dut/sim/csrc'
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
if [ -x ../top_tb ]; then chmod a-x ../top_tb; fi
g++  -o ../top_tb      -rdynamic  -Wl,-rpath='$ORIGIN'/top_tb.daidir -Wl,-rpath=./top_tb.daidir -Wl,-rpath=/srv/software/Synopsys-2021_x86_64/vcs/R-2020.12-SP1-1/linux64/lib -L/srv/software/Synopsys-2021_x86_64/vcs/R-2020.12-SP1-1/linux64/lib  -Wl,-rpath-link=./  /usr/lib64/libnuma.so.1   objs/amcQw_d.o   _44624_archive_1.so  SIM_l.o      rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o           -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /srv/software/Synopsys-2021_x86_64/vcs/R-2020.12-SP1-1/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive        _vcs_pli_stub_.o   /srv/software/Synopsys-2021_x86_64/vcs/R-2020.12-SP1-1/linux64/lib/vcs_save_restore_new.o /srv/software/Synopsys-2021_x86_64/verdi/R-2020.12-SP1-1/share/PLI/VCS/LINUX64/pli.a -ldl  -lc -lm -lpthread -ldl 
../top_tb up to date
make[1]: Leaving directory '/tmp/dut/sim/csrc'
CPU time: 2.755 seconds to compile + .510 seconds to elab + .340 seconds to link
Verdi KDB elaboration done and the database successfully generated: 0 error(s), 0 warning(s)

[0;33mCompile finished with warnings:[0m
Lint-[ONGS] Output never gets set
Lint-[ONGS] Output never gets set
Lint-[WMIA-L] Width mismatch in assignment
Lint-[WMIA-L] Width mismatch in assignment
Lint-[WMIA-L] Width mismatch in assignment
Lint-[WMIA-L] Width mismatch in assignment
Lint-[WMIA-L] Width mismatch in assignment
Lint-[UI] Unused input
Lint-[UI] Unused input
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
/tmp/dut/synth/../sram/output/mp3_tag_array/mp3_tag_array_TT_1p0V_25C_lib.db /tmp/dut/synth/../sram/output/mp3_data_array/mp3_data_array_TT_1p0V_25C_lib.db
if {$sram_library eq ""} {
   set link_library [list "*" $target_library $synthetic_library]
} else {
   set link_library [list "*" $target_library $synthetic_library $sram_library]
}
* /srv/ece411ag/freepdk-45nm/stdcells.db dw_foundation.sldb {/tmp/dut/synth/../sram/output/mp3_tag_array/mp3_tag_array_TT_1p0V_25C_lib.db /tmp/dut/synth/../sram/output/mp3_data_array/mp3_data_array_TT_1p0V_25C_lib.db}
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
/tmp/dut/synth/../hdl/mem_interface/mem_word_adaptor.sv /tmp/dut/synth/../hdl/mem_interface/cacheline_adaptor.sv /tmp/dut/synth/../hdl/mem_interface/arbiter.sv /tmp/dut/synth/../hdl/mem_interface/cache/i_cache_datapath.sv /tmp/dut/synth/../hdl/mem_interface/cache/i_cache_control.sv /tmp/dut/synth/../hdl/mem_interface/cache/i_cache.sv /tmp/dut/synth/../hdl/mem_interface/cache/valid.sv /tmp/dut/synth/../hdl/mem_interface/cache/ff_array.sv /tmp/dut/synth/../hdl/mem_interface/cache/dirty.sv /tmp/dut/synth/../hdl/mem_interface/cache/d_cache_datapath.sv /tmp/dut/synth/../hdl/mem_interface/cache/d_cache_control.sv /tmp/dut/synth/../hdl/mem_interface/cache/d_cache.sv /tmp/dut/synth/../hdl/mem_interface/cache/PLRU.sv /tmp/dut/synth/../hdl/ctrl_buffer/prefetch_buffer.sv /tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv /tmp/dut/synth/../hdl/wb_stage.sv /tmp/dut/synth/../hdl/shift_reg.sv /tmp/dut/synth/../hdl/sext_half.sv /tmp/dut/synth/../hdl/sext_byte.sv /tmp/dut/synth/../hdl/register.sv /tmp/dut/synth/../hdl/regfile.sv /tmp/dut/synth/../hdl/pipeline_registers.sv /tmp/dut/synth/../hdl/multiply_and_divide.sv /tmp/dut/synth/../hdl/multiplier_v2.sv /tmp/dut/synth/../hdl/multiplier.sv /tmp/dut/synth/../hdl/mp4datapath.sv /tmp/dut/synth/../hdl/mp4control.sv /tmp/dut/synth/../hdl/mp4.sv /tmp/dut/synth/../hdl/mem_stage.sv /tmp/dut/synth/../hdl/mem_data_out.sv /tmp/dut/synth/../hdl/mar.sv /tmp/dut/synth/../hdl/hazard_queue.sv /tmp/dut/synth/../hdl/fetch_stage.sv /tmp/dut/synth/../hdl/exe_stage.sv /tmp/dut/synth/../hdl/divider_slow.sv /tmp/dut/synth/../hdl/div_compare.sv /tmp/dut/synth/../hdl/decode_stage.sv /tmp/dut/synth/../hdl/counter.sv /tmp/dut/synth/../hdl/cmp.sv /tmp/dut/synth/../hdl/alu.sv
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
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/i_cache_datapath.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/i_cache_control.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/i_cache.sv
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
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/d_cache_datapath.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/d_cache_control.sv
Presto compilation completed successfully.
Running PRESTO HDLC
Compiling source file /tmp/dut/synth/../hdl/mem_interface/cache/d_cache.sv
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
Presto compilation completed successfully.
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
Loading db file '/tmp/dut/sram/output/mp3_tag_array/mp3_tag_array_TT_1p0V_25C_lib.db'
Loading db file '/tmp/dut/sram/output/mp3_data_array/mp3_data_array_TT_1p0V_25C_lib.db'
Loading db file '/srv/software/Synopsys-2021_x86_64/syn/R-2020.09-SP4/libraries/syn/gtech.db'
Loading db file '/srv/software/Synopsys-2021_x86_64/syn/R-2020.09-SP4/libraries/syn/standard.sldb'
  Loading link library 'NangateOpenCellLibrary'
  Loading link library 'mp3_tag_array_TT_1p0V_25C_lib'
  Loading link library 'mp3_data_array_TT_1p0V_25C_lib'
  Loading link library 'gtech'
Running PRESTO HDLC
Presto compilation completed successfully. (mp4)
Elaborated 1 design.
Current design is now 'mp4'.
Information: Building the design 'mp4control'. (HDL-193)

Statistics for case statements in always block at line 298 in file
	'/tmp/dut/synth/../hdl/mp4control.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           299            |    auto/auto     |
===============================================

Statistics for case statements in always block at line 369 in file
	'/tmp/dut/synth/../hdl/mp4control.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           387            |    user/user     |
|           512            |    user/user     |
|           589            |    auto/auto     |
|           692            |    auto/auto     |
|           825            |    auto/auto     |
===============================================

Inferred memory devices in process
	in routine mp4control line 141 in file
		'/tmp/dut/synth/../hdl/mp4control.sv'.
=====================================================================================
|       Register Name       |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
=====================================================================================
| load_instuct_inserted_reg | Flip-flop |   1   |  N  | N  | Y  | N  | N  | N  | N  |
=====================================================================================

Inferred memory devices in process
	in routine mp4control line 219 in file
		'/tmp/dut/synth/../hdl/mp4control.sv'.
================================================================================
|    Register Name     |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
================================================================================
| prediction_delay_reg | Flip-flop |   1   |  N  | N  | Y  | N  | N  | N  | N  |
|   branch_taken_reg   | Flip-flop |   1   |  N  | N  | Y  | N  | N  | N  | N  |
|    jump_taken_reg    | Flip-flop |   1   |  N  | N  | Y  | N  | N  | N  | N  |
================================================================================

Inferred memory devices in process
	in routine mp4control line 293 in file
		'/tmp/dut/synth/../hdl/mp4control.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
| ctrl_buffer_sel_reg | Flip-flop |   1   |  N  | N  | N  | N  | N  | Y  | N  |
===============================================================================
Information:  Complex logic will not be considered for set/reset inference. (ELAB-2008)
Presto compilation completed successfully. (mp4control)
Information: Building the design 'd_cache'. (HDL-193)
Presto compilation completed successfully. (d_cache)
Information: Building the design 'i_cache'. (HDL-193)
Presto compilation completed successfully. (i_cache)
Information: Building the design 'cacheline_adaptor'. (HDL-193)

Statistics for case statements in always block at line 29 in file
	'/tmp/dut/synth/../hdl/mem_interface/cacheline_adaptor.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            39            |     no/auto      |
|            70            |     no/auto      |
|           139            |     no/auto      |
===============================================

Inferred memory devices in process
	in routine cacheline_adaptor line 29 in file
		'/tmp/dut/synth/../hdl/mem_interface/cacheline_adaptor.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|    fn_state_reg     | Flip-flop |   2   |  Y  | Y  | N  | N  | N  | N  | N  |
|     burst_o_reg     | Flip-flop |  64   |  Y  | Y  | N  | N  | N  | N  | N  |
|  routine_state_reg  | Flip-flop |   3   |  Y  | Y  | N  | N  | N  | N  | N  |
|     read_o_reg      | Flip-flop |   1   |  N  | N  | N  | N  | N  | N  | N  |
|     write_o_reg     | Flip-flop |   1   |  N  | N  | N  | N  | N  | N  | N  |
|     resp_o_reg      | Flip-flop |   1   |  N  | N  | N  | N  | N  | N  | N  |
|    address_o_reg    | Flip-flop |  32   |  Y  | Y  | N  | N  | N  | N  | N  |
|     line_o_reg      | Flip-flop |  256  |  Y  | Y  | N  | N  | N  | N  | N  |
===============================================================================
Information:  Complex logic will not be considered for set/reset inference. (ELAB-2008)
Presto compilation completed successfully. (cacheline_adaptor)
Information: Building the design 'cache_arbiter'. (HDL-193)

Statistics for case statements in always block at line 46 in file
	'/tmp/dut/synth/../hdl/mem_interface/arbiter.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            51            |    auto/auto     |
===============================================

Statistics for case statements in always block at line 113 in file
	'/tmp/dut/synth/../hdl/mem_interface/arbiter.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           115            |    auto/auto     |
===============================================

Statistics for case statements in always block at line 174 in file
	'/tmp/dut/synth/../hdl/mem_interface/arbiter.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           177            |    auto/auto     |
===============================================

Inferred memory devices in process
	in routine cache_arbiter line 97 in file
		'/tmp/dut/synth/../hdl/mem_interface/arbiter.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
| pf_writing_flag_reg | Flip-flop |   1   |  N  | N  | Y  | N  | N  | N  | N  |
|  pf_true_addr_reg   | Flip-flop |  32   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine cache_arbiter line 168 in file
		'/tmp/dut/synth/../hdl/mem_interface/arbiter.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|      state_reg      | Flip-flop |   2   |  Y  | Y  | N  | N  | Y  | N  | N  |
===============================================================================
Information:  Complex logic will not be considered for set/reset inference. (ELAB-2008)
Presto compilation completed successfully. (cache_arbiter)
Information: Building the design 'prefetch_buffer'. (HDL-193)

Inferred memory devices in process
	in routine prefetch_buffer line 38 in file
		'/tmp/dut/synth/../hdl/ctrl_buffer/prefetch_buffer.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|   cache_lines_reg   | Flip-flop |  512  |  Y  | Y  | Y  | N  | N  | N  | N  |
|    volatile_reg     | Flip-flop |   1   |  N  | N  | Y  | N  | N  | N  | N  |
|      addrs_reg      | Flip-flop |  56   |  Y  | Y  | Y  | N  | N  | N  | N  |
|      addrs_reg      | Flip-flop |   8   |  Y  | Y  | N  | Y  | N  | N  | N  |
===============================================================================
Presto compilation completed successfully. (prefetch_buffer)
Information: Building the design 'mem_word_adapter'. (HDL-193)
Presto compilation completed successfully. (mem_word_adapter)
Information: Building the design 'mp4datapath'. (HDL-193)

Statistics for case statements in always block at line 118 in file
	'/tmp/dut/synth/../hdl/mp4datapath.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           119            |    auto/auto     |
===============================================
Presto compilation completed successfully. (mp4datapath)
Information: Building the design 'control_buffer'. (HDL-193)
Warning:  /tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv:113: Statement unreachable (Branch condition impossible to meet).  (VER-61)
Warning:  /tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv:114: Statement unreachable (Branch condition impossible to meet).  (VER-61)
Warning:  /tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv:115: Statement unreachable (Branch condition impossible to meet).  (VER-61)
Warning:  /tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv:116: Statement unreachable (Branch condition impossible to meet).  (VER-61)

Statistics for case statements in always block at line 121 in file
	'/tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           108            |    auto/auto     |
===============================================

Inferred memory devices in process
	in routine control_buffer line 143 in file
		'/tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|    jtb_head_reg     | Flip-flop |   2   |  Y  | Y  | N  | N  | Y  | N  | N  |
|    btb_head_reg     | Flip-flop |   3   |  Y  | Y  | N  | N  | Y  | N  | N  |
===============================================================================
Statistics for MUX_OPs
========================================================
|  block name/line   | Inputs | Outputs | # sel inputs |
========================================================
| control_buffer/134 |   8    |    1    |      3       |
| control_buffer/135 |   8    |   32    |      3       |
| control_buffer/139 |   4    |   32    |      2       |
========================================================
Presto compilation completed successfully. (control_buffer)
Information: Building the design 'd_cache_control'. (HDL-193)

Statistics for case statements in always block at line 73 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/d_cache_control.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            75            |    auto/auto     |
===============================================

Statistics for case statements in always block at line 92 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/d_cache_control.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            95            |    auto/auto     |
===============================================

Statistics for case statements in always block at line 163 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/d_cache_control.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           169            |    auto/auto     |
===============================================

Inferred memory devices in process
	in routine d_cache_control line 52 in file
		'/tmp/dut/synth/../hdl/mem_interface/cache/d_cache_control.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|      state_reg      | Flip-flop |   2   |  Y  | Y  | N  | N  | Y  | N  | N  |
===============================================================================
Information:  Complex logic will not be considered for set/reset inference. (ELAB-2008)
Presto compilation completed successfully. (d_cache_control)
Information: Building the design 'd_cache_datapath'. (HDL-193)

Statistics for case statements in always block at line 155 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/d_cache_datapath.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           164            |    user/user     |
|           173            |    user/user     |
|           179            |    user/user     |
|           184            |    user/user     |
|           189            |    user/user     |
|           194            |    user/user     |
|           199            |    user/user     |
|           204            |    user/user     |
===============================================
Statistics for MUX_OPs
==========================================================
|   block name/line    | Inputs | Outputs | # sel inputs |
==========================================================
| d_cache_datapath/206 |   4    |   23    |      2       |
| d_cache_datapath/210 |   4    |   256   |      2       |
==========================================================
Presto compilation completed successfully. (d_cache_datapath)
Information: Building the design 'i_cache_control'. (HDL-193)

Statistics for case statements in always block at line 59 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/i_cache_control.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            61            |     no/auto      |
===============================================

Statistics for case statements in always block at line 76 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/i_cache_control.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            79            |     no/auto      |
===============================================

Statistics for case statements in always block at line 119 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/i_cache_control.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           125            |    auto/auto     |
===============================================

Inferred memory devices in process
	in routine i_cache_control line 45 in file
		'/tmp/dut/synth/../hdl/mem_interface/cache/i_cache_control.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|      state_reg      | Flip-flop |   2   |  Y  | Y  | N  | N  | Y  | N  | N  |
===============================================================================
Information:  Complex logic will not be considered for set/reset inference. (ELAB-2008)
Presto compilation completed successfully. (i_cache_control)
Information: Building the design 'i_cache_datapath'. (HDL-193)

Statistics for case statements in always block at line 146 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/i_cache_datapath.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           155            |    user/user     |
|           164            |    user/user     |
|           170            |    user/user     |
===============================================
Statistics for MUX_OPs
==========================================================
|   block name/line    | Inputs | Outputs | # sel inputs |
==========================================================
| i_cache_datapath/176 |   4    |   256   |      2       |
==========================================================
Presto compilation completed successfully. (i_cache_datapath)
Information: Building the design 'fetch_stage'. (HDL-193)

Statistics for case statements in always block at line 37 in file
	'/tmp/dut/synth/../hdl/fetch_stage.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            38            |    user/user     |
===============================================
Presto compilation completed successfully. (fetch_stage)
Information: Building the design 'fet_dec_reg'. (HDL-193)

Inferred memory devices in process
	in routine fet_dec_reg line 34 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|   prediction_reg    | Flip-flop |   1   |  N  | N  | N  | N  | Y  | N  | N  |
|      ready_reg      | Flip-flop |   1   |  N  | N  | N  | N  | Y  | N  | N  |
|      instr_reg      | Flip-flop |  32   |  Y  | Y  | N  | N  | Y  | N  | N  |
|      pc_r_reg       | Flip-flop |  32   |  Y  | Y  | N  | N  | Y  | N  | N  |
|      pc_w_reg       | Flip-flop |  32   |  Y  | Y  | N  | N  | Y  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine fet_dec_reg line 54 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|  order_counter_reg  | Flip-flop |  32   |  Y  | Y  | N  | Y  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine fet_dec_reg line 79 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     valid_o_reg     | Flip-flop |   1   |  N  | N  | Y  | N  | Y  | Y  | N  |
===============================================================================
Presto compilation completed successfully. (fet_dec_reg)
Information: Building the design 'decode_stage'. (HDL-193)
Presto compilation completed successfully. (decode_stage)
Information: Building the design 'dec_exe_reg'. (HDL-193)

Inferred memory devices in process
	in routine dec_exe_reg line 120 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     cw_data_reg     | Flip-flop |  382  |  Y  | Y  | N  | N  | Y  | N  | N  |
|     cw_data_reg     | Flip-flop |   1   |  N  | Y  | N  | N  | N  | Y  | N  |
|    imm_data_reg     | Flip-flop |  160  |  Y  | Y  | N  | N  | Y  | N  | N  |
|      ready_reg      | Flip-flop |   1   |  N  | N  | N  | N  | Y  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine dec_exe_reg line 195 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     valid_o_reg     | Flip-flop |   1   |  N  | N  | N  | N  | Y  | Y  | N  |
===============================================================================
Presto compilation completed successfully. (dec_exe_reg)
Information: Building the design 'exe_stage'. (HDL-193)
Warning:  /tmp/dut/synth/../hdl/exe_stage.sv:124: Case statement marked unique does not cover all possible conditions. (VER-504)

Statistics for case statements in always block at line 67 in file
	'/tmp/dut/synth/../hdl/exe_stage.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            68            |    auto/auto     |
===============================================

Statistics for case statements in always block at line 99 in file
	'/tmp/dut/synth/../hdl/exe_stage.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           100            |    user/user     |
|           107            |    user/user     |
|           114            |    user/user     |
|           119            |    user/user     |
|           124            |    user/user     |
===============================================

Inferred memory devices in process
	in routine exe_stage line 74 in file
		'/tmp/dut/synth/../hdl/exe_stage.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|   prev_order_reg    | Flip-flop |  32   |  Y  | Y  | N  | N  | N  | Y  | N  |
===============================================================================
Presto compilation completed successfully. (exe_stage)
Information: Building the design 'exe_mem_reg'. (HDL-193)

Statistics for case statements in always block at line 255 in file
	'/tmp/dut/synth/../hdl/pipeline_registers.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           256            |    user/user     |
===============================================

Statistics for case statements in always block at line 383 in file
	'/tmp/dut/synth/../hdl/pipeline_registers.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           384            |    user/user     |
===============================================

Statistics for case statements in always block at line 391 in file
	'/tmp/dut/synth/../hdl/pipeline_registers.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           399            |    auto/auto     |
|           415            |    auto/auto     |
===============================================

Inferred memory devices in process
	in routine exe_mem_reg line 265 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|  exe_fwd_data_reg   | Flip-flop |  32   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine exe_mem_reg line 275 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     cw_data_reg     | Flip-flop |  360  |  Y  | Y  | Y  | N  | N  | N  | N  |
|     cw_data_reg     | Flip-flop |   1   |  N  | Y  | N  | Y  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine exe_mem_reg line 336 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     br_en_o_reg     | Flip-flop |   1   |  N  | N  | Y  | N  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine exe_mem_reg line 346 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|  exe_mem_valid_reg  | Flip-flop |   1   |  N  | N  | Y  | N  | Y  | Y  | N  |
===============================================================================

Inferred memory devices in process
	in routine exe_mem_reg line 359 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|   exe_mem_rdy_reg   | Flip-flop |   1   |  N  | N  | Y  | N  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine exe_mem_reg line 369 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     u_imm_o_reg     | Flip-flop |  32   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine exe_mem_reg line 438 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
| mem_byte_enable_reg | Flip-flop |   4   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================
Presto compilation completed successfully. (exe_mem_reg)
Information: Building the design 'mem_stage'. (HDL-193)

Inferred memory devices in process
	in routine mem_stage line 32 in file
		'/tmp/dut/synth/../hdl/mem_stage.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|   prev_order_reg    | Flip-flop |  32   |  Y  | Y  | N  | N  | N  | Y  | N  |
===============================================================================

Inferred memory devices in process
	in routine mem_stage line 71 in file
		'/tmp/dut/synth/../hdl/mem_stage.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|  mem_resp_flag_reg  | Flip-flop |   1   |  N  | N  | N  | N  | Y  | Y  | N  |
===============================================================================
Presto compilation completed successfully. (mem_stage)
Information: Building the design 'mem_wb_reg'. (HDL-193)
Warning:  /tmp/dut/synth/../hdl/pipeline_registers.sv:559: Case statement marked unique does not cover all possible conditions. (VER-504)

Statistics for case statements in always block at line 505 in file
	'/tmp/dut/synth/../hdl/pipeline_registers.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           506            |    auto/auto     |
===============================================

Statistics for case statements in always block at line 548 in file
	'/tmp/dut/synth/../hdl/pipeline_registers.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           549            |    auto/auto     |
===============================================
Warning:  /tmp/dut/synth/../hdl/pipeline_registers.sv:559: Case statement marked unique does not cover all possible conditions. (VER-504)

Statistics for case statements in always block at line 558 in file
	'/tmp/dut/synth/../hdl/pipeline_registers.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|           559            |    user/user     |
===============================================

Inferred memory devices in process
	in routine mem_wb_reg line 567 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|  mem_fwd_data_reg   | Flip-flop |  32   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine mem_wb_reg line 577 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|  mem_rdata_D_o_reg  | Flip-flop |  32   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine mem_wb_reg line 587 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|    alu_out_o_reg    | Flip-flop |  32   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine mem_wb_reg line 598 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     cw_data_reg     | Flip-flop |  350  |  Y  | Y  | Y  | N  | N  | N  | N  |
|     cw_data_reg     | Flip-flop |   1   |  N  | Y  | N  | Y  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine mem_wb_reg line 676 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     br_en_o_reg     | Flip-flop |   1   |  N  | N  | Y  | N  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine mem_wb_reg line 686 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|  mem_wb_valid_reg   | Flip-flop |   1   |  N  | N  | Y  | N  | N  | Y  | N  |
===============================================================================

Inferred memory devices in process
	in routine mem_wb_reg line 696 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|   mem_wb_rdy_reg    | Flip-flop |   1   |  N  | N  | Y  | N  | N  | N  | N  |
===============================================================================

Inferred memory devices in process
	in routine mem_wb_reg line 706 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     u_imm_o_reg     | Flip-flop |  32   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================
Presto compilation completed successfully. (mem_wb_reg)
Information: Building the design 'wb_stage'. (HDL-193)

Statistics for case statements in always block at line 94 in file
	'/tmp/dut/synth/../hdl/wb_stage.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            95            |    user/user     |
===============================================

Inferred memory devices in process
	in routine wb_stage line 37 in file
		'/tmp/dut/synth/../hdl/wb_stage.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|   prev_order_reg    | Flip-flop |  32   |  Y  | Y  | N  | N  | N  | Y  | N  |
===============================================================================
Presto compilation completed successfully. (wb_stage)
Information: Building the design 'wb_fwd_reg'. (HDL-193)

Inferred memory devices in process
	in routine wb_fwd_reg line 728 in file
		'/tmp/dut/synth/../hdl/pipeline_registers.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|  wb_fwd_data_o_reg  | Flip-flop |  32   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================
Presto compilation completed successfully. (wb_fwd_reg)
Information: Building the design 'btb_entry'. (HDL-193)

Inferred memory devices in process
	in routine btb_entry line 231 in file
		'/tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
| prediction_hist_reg | Flip-flop |  10   |  Y  | Y  | N  | N  | Y  | N  | N  |
|    instr_pc_reg     | Flip-flop |  32   |  Y  | Y  | N  | N  | Y  | N  | N  |
|     offset_reg      | Flip-flop |  12   |  Y  | Y  | N  | N  | Y  | N  | N  |
|   branch_hist_reg   | Flip-flop |   1   |  N  | Y  | N  | N  | Y  | Y  | N  |
|   branch_hist_reg   | Flip-flop |   9   |  Y  | Y  | N  | N  | Y  | N  | N  |
===============================================================================
Presto compilation completed successfully. (btb_entry)
Information: Building the design 'jtb_entry'. (HDL-193)

Inferred memory devices in process
	in routine jtb_entry line 273 in file
		'/tmp/dut/synth/../hdl/ctrl_buffer/control_buffer.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|    target_pc_reg    | Flip-flop |  32   |  Y  | Y  | N  | N  | Y  | N  | N  |
|    instr_pc_reg     | Flip-flop |  32   |  Y  | Y  | N  | N  | Y  | N  | N  |
===============================================================================
Presto compilation completed successfully. (jtb_entry)
Information: Building the design 'dirty' instantiated from design 'd_cache_datapath' with
	the parameters "s_index=4,w_index=2". (HDL-193)

Statistics for case statements in always block at line 49 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/dirty.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            52            |    auto/auto     |
===============================================
Statistics for MUX_OPs
================================================================
|      block name/line       | Inputs | Outputs | # sel inputs |
================================================================
| dirty_s_index4_w_index2/36 |   4    |    1    |      2       |
================================================================
Presto compilation completed successfully. (dirty_s_index4_w_index2)
Information: Building the design 'valid' instantiated from design 'd_cache_datapath' with
	the parameters "s_index=4,w_index=2". (HDL-193)

Statistics for case statements in always block at line 49 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/valid.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            52            |    auto/auto     |
===============================================
Presto compilation completed successfully. (valid_s_index4_w_index2)
Information: Building the design 'PLRU_4_way' instantiated from design 'd_cache_datapath' with
	the parameters "s_index=4". (HDL-193)

Statistics for case statements in always block at line 35 in file
	'/tmp/dut/synth/../hdl/mem_interface/cache/PLRU.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            38            |    user/user     |
===============================================
Statistics for MUX_OPs
============================================================
|    block name/line     | Inputs | Outputs | # sel inputs |
============================================================
| PLRU_4_way_s_index4/48 |   16   |    2    |      4       |
============================================================
Presto compilation completed successfully. (PLRU_4_way_s_index4)
Information: Building the design 'register' instantiated from design 'fetch_stage' with
	the parameters "width=32,resetData=32'h40000000". (HDL-193)

Inferred memory devices in process
	in routine register_32_40000000 line 15 in file
		'/tmp/dut/synth/../hdl/register.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|      data_reg       | Flip-flop |  31   |  Y  | Y  | N  | N  | Y  | N  | N  |
|      data_reg       | Flip-flop |   1   |  N  | Y  | N  | N  | N  | Y  | N  |
===============================================================================
Presto compilation completed successfully. (register_32_40000000)
Information: Building the design 'regfile'. (HDL-193)

Inferred memory devices in process
	in routine regfile line 14 in file
		'/tmp/dut/synth/../hdl/regfile.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|      data_reg       | Flip-flop | 1024  |  Y  | Y  | N  | N  | Y  | N  | N  |
===============================================================================
Statistics for MUX_OPs
======================================================
| block name/line  | Inputs | Outputs | # sel inputs |
======================================================
|    regfile/30    |   32   |   32    |      5       |
|    regfile/31    |   32   |   32    |      5       |
======================================================
Presto compilation completed successfully. (regfile)
Information: Building the design 'cmp'. (HDL-193)

Statistics for case statements in always block at line 10 in file
	'/tmp/dut/synth/../hdl/cmp.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            11            |    user/user     |
===============================================
Presto compilation completed successfully. (cmp)
Information: Building the design 'alu'. (HDL-193)
Warning:  /tmp/dut/synth/../hdl/alu.sv:46: signed to unsigned assignment occurs. (VER-318)
Warning:  /tmp/dut/synth/../hdl/alu.sv:36: Case statement marked unique does not cover all possible conditions. (VER-504)

Statistics for case statements in always block at line 32 in file
	'/tmp/dut/synth/../hdl/alu.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            36            |    user/user     |
===============================================
Presto compilation completed successfully. (alu)
Information: Building the design 'mem_data_out'. (HDL-193)

Inferred memory devices in process
	in routine mem_data_out line 10 in file
		'/tmp/dut/synth/../hdl/mem_data_out.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     mdo_out_reg     | Flip-flop |  32   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================
Presto compilation completed successfully. (mem_data_out)
Information: Building the design 'mar'. (HDL-193)

Inferred memory devices in process
	in routine mar line 10 in file
		'/tmp/dut/synth/../hdl/mar.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|     mar_out_reg     | Flip-flop |  32   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================
Presto compilation completed successfully. (mar)
Information: Building the design 'sext_byte'. (HDL-193)
Presto compilation completed successfully. (sext_byte)
Information: Building the design 'sext_half'. (HDL-193)
Presto compilation completed successfully. (sext_half)
Information: Building the design 'ff_array' instantiated from design 'dirty_s_index4_w_index2' with
	the parameters "s_index=4,width=1". (HDL-193)

Inferred memory devices in process
	in routine ff_array_s_index4_width1 line 18 in file
		'/tmp/dut/synth/../hdl/mem_interface/cache/ff_array.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|      dout0_reg      | Flip-flop |   1   |  N  | N  | N  | N  | N  | N  | N  |
| internal_array_reg  | Flip-flop |  16   |  Y  | Y  | N  | N  | Y  | N  | N  |
===============================================================================
Statistics for MUX_OPs
=================================================================
|      block name/line        | Inputs | Outputs | # sel inputs |
=================================================================
| ff_array_s_index4_width1/29 |   16   |    1    |      4       |
=================================================================
Presto compilation completed successfully. (ff_array_s_index4_width1)
Information: Building the design 'PLRU_4_way_unit'. (HDL-193)

Inferred memory devices in process
	in routine PLRU_4_way_unit line 66 in file
		'/tmp/dut/synth/../hdl/mem_interface/cache/PLRU.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|      bits_reg       | Flip-flop |   3   |  Y  | Y  | N  | N  | Y  | N  | N  |
===============================================================================
Presto compilation completed successfully. (PLRU_4_way_unit)
Information: Building the design 'multiply_and_divide'. (HDL-193)

Statistics for case statements in always block at line 57 in file
	'/tmp/dut/synth/../hdl/multiply_and_divide.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            58            |    user/user     |
|            63            |    user/user     |
|            68            |    user/user     |
|            73            |    user/user     |
===============================================
Presto compilation completed successfully. (multiply_and_divide)
Information: Building the design 'multiplier'. (HDL-193)

Inferred memory devices in process
	in routine multiplier line 147 in file
		'/tmp/dut/synth/../hdl/multiplier.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|      count_reg      | Flip-flop |   1   |  N  | N  | Y  | N  | Y  | N  | N  |
|    kara_16_0_reg    | Flip-flop |  32   |  Y  | Y  | Y  | N  | Y  | N  | N  |
|   kara_16_1_0_reg   | Flip-flop |  32   |  Y  | Y  | Y  | N  | Y  | N  | N  |
|   kara_16_1_1_reg   | Flip-flop |  32   |  Y  | Y  | Y  | N  | Y  | N  | N  |
|    kara_16_2_reg    | Flip-flop |  32   |  Y  | Y  | Y  | N  | Y  | N  | N  |
|     rd_low_reg      | Flip-flop |  32   |  Y  | Y  | Y  | N  | Y  | N  | N  |
|     rd_high_reg     | Flip-flop |  32   |  Y  | Y  | Y  | N  | Y  | N  | N  |
|      done_reg       | Flip-flop |   1   |  N  | N  | Y  | N  | Y  | N  | N  |
===============================================================================
Information:  Complex logic will not be considered for set/reset inference. (ELAB-2008)
Presto compilation completed successfully. (multiplier)
Information: Building the design 'divider_slow'. (HDL-193)

Statistics for case statements in always block at line 50 in file
	'/tmp/dut/synth/../hdl/divider_slow.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            52            |    auto/auto     |
===============================================

Statistics for case statements in always block at line 91 in file
	'/tmp/dut/synth/../hdl/divider_slow.sv'
===============================================
|           Line           |  full/ parallel  |
===============================================
|            92            |    auto/auto     |
===============================================

Inferred memory devices in process
	in routine divider_slow line 121 in file
		'/tmp/dut/synth/../hdl/divider_slow.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|   div_counter_reg   | Flip-flop |   6   |  Y  | Y  | Y  | N  | N  | N  | N  |
|      state_reg      | Flip-flop |   2   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================
Information:  Complex logic will not be considered for set/reset inference. (ELAB-2008)
Presto compilation completed successfully. (divider_slow)
Information: Building the design 'shift_reg'. (HDL-193)

Inferred memory devices in process
	in routine shift_reg line 11 in file
		'/tmp/dut/synth/../hdl/shift_reg.sv'.
===============================================================================
|    Register Name    |   Type    | Width | Bus | MB | AR | AS | SR | SS | ST |
===============================================================================
|      z_out_reg      | Flip-flop |  64   |  Y  | Y  | Y  | N  | N  | N  | N  |
===============================================================================
Presto compilation completed successfully. (shift_reg)
Information: Building the design 'div_compare'. (HDL-193)
Presto compilation completed successfully. (div_compare)
1
current_design $design_toplevel
Current design is 'mp4'.
{mp4}
check_design
 
****************************************
check_design summary:
Version:     R-2020.09-SP4
Date:        Tue Dec  5 04:05:31 2023
****************************************

                   Name                                            Total
--------------------------------------------------------------------------------
No issues found.
--------------------------------------------------------------------------------

1
set_wire_load_model -name "5K_hvratio_1_1"
1
set_wire_load_mode enclosed
1
set clk_name $design_clock_pin
clk
set clk_period [expr [getenv CLOCK_PERIOD_PS] / 1000.0]
10.0
create_clock -period $clk_period -name my_clk $clk_name
1
set_fix_hold [get_clocks my_clk]
1
set_input_delay 0.5 [all_inputs] -clock my_clk
1
set_output_delay 0.5 [all_outputs] -clock my_clk
1
set_load 0.1 [all_outputs]
1
set_max_fanout 1 [all_inputs]
1
set_fanout_load 8 [all_outputs]
1
link

  Linking design 'mp4'
  Using the following designs and libraries:
  --------------------------------------------------------------------------
  * (44 designs)              /tmp/dut/synth/mp4.db, etc
  NangateOpenCellLibrary (library)
                              /srv/ece411ag/freepdk-45nm/stdcells.db
  dw_foundation.sldb (library)
                              /srv/software/Synopsys-2021_x86_64/syn/R-2020.09-SP4/libraries/syn/dw_foundation.sldb
  mp3_tag_array_TT_1p0V_25C_lib (library)
                              /tmp/dut/sram/output/mp3_tag_array/mp3_tag_array_TT_1p0V_25C_lib.db
  mp3_data_array_TT_1p0V_25C_lib (library)
                              /tmp/dut/sram/output/mp3_data_array/mp3_data_array_TT_1p0V_25C_lib.db

1
compile_ultra -gate_clock -retime
Information: Performing power optimization. (PWR-850)
Alib files are up-to-date.
Information: Evaluating DesignWare library utilization. (UISN-27)

============================================================================
| DesignWare Building Block Library  |         Version         | Available |
============================================================================
| Basic DW Building Blocks           | R-2020.09-DWBB_202009.4 |     *     |
| Licensed DW Building Blocks        | R-2020.09-DWBB_202009.4 |     *     |
============================================================================

Information: Sequential output inversion is enabled.  SVF file must be used for formal verification. (OPT-1208)
Information: Retiming is enabled. SVF file must be used for formal verification. (OPT-1210)


Information: Uniquified 2 instances of design 'mem_word_adapter'. (OPT-1056)
Information: Uniquified 8 instances of design 'btb_entry'. (OPT-1056)
Information: Uniquified 4 instances of design 'jtb_entry'. (OPT-1056)
Information: Uniquified 2 instances of design 'valid_s_index4_w_index2'. (OPT-1056)
Information: Uniquified 2 instances of design 'PLRU_4_way_s_index4'. (OPT-1056)
Information: Uniquified 12 instances of design 'ff_array_s_index4_width1'. (OPT-1056)
Information: Uniquified 32 instances of design 'PLRU_4_way_unit'. (OPT-1056)
  Simplifying Design 'mp4'
Information: Performing clock-gating with positive edge logic: 'integrated' and negative edge logic: 'or'. (PWR-1047)

Loaded alib file '/srv/ece411ag/freepdk-45nm/alib/alib-52/stdcells.db.alib'
  Building model 'DW01_NAND2'
Information: Ungrouping 88 of 191 hierarchies before Pass 1 (OPT-775)
Information: State dependent leakage is now switched from on to off.

  Beginning Pass 1 Mapping
  ------------------------
  Processing 'mp4'
Information: Added key list 'DesignWare' to design 'mp4'. (DDB-72)
 Implement Synthetic for 'mp4'.
  Processing 'mp4datapath'
Information: Added key list 'DesignWare' to design 'mp4datapath'. (DDB-72)
 Implement Synthetic for 'mp4datapath'.
  Processing 'multiplier'
Information: Added key list 'DesignWare' to design 'multiplier'. (DDB-72)
 Implement Synthetic for 'multiplier'.
  Processing 'regfile'
  Processing 'control_buffer'
Information: Added key list 'DesignWare' to design 'control_buffer'. (DDB-72)
 Implement Synthetic for 'control_buffer'.
  Processing 'd_cache_datapath'
Information: Added key list 'DesignWare' to design 'd_cache_datapath'. (DDB-72)
 Implement Synthetic for 'd_cache_datapath'.
  Processing 'multiply_and_divide'
 Implement Synthetic for 'multiply_and_divide'.
  Processing 'alu'
 Implement Synthetic for 'alu'.
Information: Added key list 'DesignWare' to design 'alu'. (DDB-72)
  Processing 'exe_stage'
Information: Added key list 'DesignWare' to design 'exe_stage'. (DDB-72)
 Implement Synthetic for 'exe_stage'.
  Processing 'd_cache'
  Processing 'decode_stage'
  Processing 'SNPS_CLOCK_GATE_HIGH_ff_array_s_index4_width1_0_0'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_prefetch_buffer_0'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_cache_arbiter'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_cacheline_adaptor_0'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_mp4control'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_jtb_entry_0_0'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_btb_entry_0_0'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_control_buffer'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_mar'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_mem_data_out'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_register_32_40000000'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_wb_fwd_reg'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_wb_stage'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_mem_wb_reg'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_mem_stage'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_exe_mem_reg_0'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_dec_exe_reg'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_fet_dec_reg_0'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_shift_reg'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_divider_slow'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_multiplier_0'
  Mapping integrated clock gating circuitry
  Processing 'SNPS_CLOCK_GATE_HIGH_regfile_0'
  Mapping integrated clock gating circuitry

  Updating timing information
Information: Updating design information... (UID-85)
Information: Performing clock-gating on design mp4. (PWR-730)
Information: Performing clock-gating on design d_cache_datapath. (PWR-730)
Information: Performing clock-gating on design exe_stage. (PWR-730)
Information: Performing clock-gating on design mp4datapath. (PWR-730)
Information: Performing clock-gating on design d_cache. (PWR-730)
Information: Performing clock-gating on design control_buffer. (PWR-730)
Information: Performing clock-gating on design multiply_and_divide. (PWR-730)
Information: Performing clock-gating on design regfile. (PWR-730)
Information: Performing clock-gating on design multiplier. (PWR-730)
Information: Converting capacitance units for library 'mp3_data_array_TT_1p0V_25C_lib' since those in library 'NangateOpenCellLibrary' differ. (TIM-106)
Information: Converting capacitance units for library 'mp3_tag_array_TT_1p0V_25C_lib' since those in library 'NangateOpenCellLibrary' differ. (TIM-106)
Information: Complementing port 'instruct_in_mem[opcode][5]' in design 'mp4datapath'.
	 The new name of the port is 'instruct_in_mem[opcode][5]_BAR'. (OPT-319)
Information: Complementing port 'instruct_in_wb[opcode][5]' in design 'mp4datapath'.
	 The new name of the port is 'instruct_in_wb[opcode][5]_BAR'. (OPT-319)
Information: Complementing port 'cr[func3][2]' in design 'mp4datapath'.
	 The new name of the port is 'cr[func3][2]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][14]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][14]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][14]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][14]_BAR'. (OPT-319)
Information: Complementing port 'cr[func3][2]' in design 'decode_stage'.
	 The new name of the port is 'cr[func3][2]_BAR'. (OPT-319)
Information: Complementing port 'instruction[14]' in design 'decode_stage'.
	 The new name of the port is 'instruction[14]_BAR'. (OPT-319)
Information: Complementing port 'cr[func3][1]' in design 'mp4datapath'.
	 The new name of the port is 'cr[func3][1]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][13]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][13]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][13]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][13]_BAR'. (OPT-319)
Information: Complementing port 'cr[func3][1]' in design 'decode_stage'.
	 The new name of the port is 'cr[func3][1]_BAR'. (OPT-319)
Information: Complementing port 'instruction[13]' in design 'decode_stage'.
	 The new name of the port is 'instruction[13]_BAR'. (OPT-319)
Information: Complementing port 'cr[func3][0]' in design 'mp4datapath'.
	 The new name of the port is 'cr[func3][0]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][12]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][12]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][12]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][12]_BAR'. (OPT-319)
Information: Complementing port 'cr[func3][0]' in design 'decode_stage'.
	 The new name of the port is 'cr[func3][0]_BAR'. (OPT-319)
Information: Complementing port 'instruction[12]' in design 'decode_stage'.
	 The new name of the port is 'instruction[12]_BAR'. (OPT-319)
Information: Complementing port 'cr[func7][5]' in design 'mp4datapath'.
	 The new name of the port is 'cr[func7][5]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[i_imm][10]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[i_imm][10]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][30]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][30]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][10]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][10]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][10]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][10]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][10]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][10]_BAR'. (OPT-319)
Information: Complementing port 'cr[func7][5]' in design 'decode_stage'.
	 The new name of the port is 'cr[func7][5]_BAR'. (OPT-319)
Information: Complementing port 'instruction[30]' in design 'decode_stage'.
	 The new name of the port is 'instruction[30]_BAR'. (OPT-319)
Information: Complementing port 'cr[func7][0]' in design 'mp4datapath'.
	 The new name of the port is 'cr[func7][0]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[i_imm][5]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[i_imm][5]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][25]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][25]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][5]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][5]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][5]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][5]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][5]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][5]_BAR'. (OPT-319)
Information: Complementing port 'cr[func7][0]' in design 'decode_stage'.
	 The new name of the port is 'cr[func7][0]_BAR'. (OPT-319)
Information: Complementing port 'instruction[25]' in design 'decode_stage'.
	 The new name of the port is 'instruction[25]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[i_imm][1]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[i_imm][1]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][21]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][21]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][1]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][1]_BAR'. (OPT-319)
Information: Complementing port 'cr[rs2_addr][1]' in design 'decode_stage'.
	 The new name of the port is 'cr[rs2_addr][1]_BAR'. (OPT-319)
Information: Complementing port 'src_b[1]' in design 'regfile'.
	 The new name of the port is 'src_b[1]_BAR'. (OPT-319)
Information: Complementing port 'cr[rs2_addr][1]' in design 'mp4datapath'.
	 The new name of the port is 'cr[rs2_addr][1]_BAR'. (OPT-319)
Information: Complementing port 'instruction[21]' in design 'decode_stage'.
	 The new name of the port is 'instruction[21]_BAR'. (OPT-319)
Information: Complementing port 'cr[rd_addr][4]' in design 'mp4datapath'.
	 The new name of the port is 'cr[rd_addr][4]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][4]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][4]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][4]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][4]_BAR'. (OPT-319)
Information: Complementing port 'cr[rd_addr][4]' in design 'decode_stage'.
	 The new name of the port is 'cr[rd_addr][4]_BAR'. (OPT-319)
Information: Complementing port 'instruction[11]' in design 'decode_stage'.
	 The new name of the port is 'instruction[11]_BAR'. (OPT-319)
Information: Complementing port 'cr[rd_addr][3]' in design 'mp4datapath'.
	 The new name of the port is 'cr[rd_addr][3]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][3]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][3]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][3]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][3]_BAR'. (OPT-319)
Information: Complementing port 'cr[rd_addr][3]' in design 'decode_stage'.
	 The new name of the port is 'cr[rd_addr][3]_BAR'. (OPT-319)
Information: Complementing port 'instruction[10]' in design 'decode_stage'.
	 The new name of the port is 'instruction[10]_BAR'. (OPT-319)
Information: Complementing port 'cr[rd_addr][2]' in design 'mp4datapath'.
	 The new name of the port is 'cr[rd_addr][2]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][2]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][2]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][2]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][2]_BAR'. (OPT-319)
Information: Complementing port 'cr[rd_addr][2]' in design 'decode_stage'.
	 The new name of the port is 'cr[rd_addr][2]_BAR'. (OPT-319)
Information: Complementing port 'instruction[9]' in design 'decode_stage'.
	 The new name of the port is 'instruction[9]_BAR'. (OPT-319)
Information: Complementing port 'cr[rd_addr][1]' in design 'mp4datapath'.
	 The new name of the port is 'cr[rd_addr][1]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][1]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][1]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][1]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][1]_BAR'. (OPT-319)
Information: Complementing port 'cr[rd_addr][1]' in design 'decode_stage'.
	 The new name of the port is 'cr[rd_addr][1]_BAR'. (OPT-319)
Information: Complementing port 'instruction[8]' in design 'decode_stage'.
	 The new name of the port is 'instruction[8]_BAR'. (OPT-319)
Information: Complementing port 'cr[rd_addr][0]' in design 'mp4datapath'.
	 The new name of the port is 'cr[rd_addr][0]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][11]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][11]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][0]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][0]_BAR'. (OPT-319)
Information: Complementing port 'cr[rd_addr][0]' in design 'decode_stage'.
	 The new name of the port is 'cr[rd_addr][0]_BAR'. (OPT-319)
Information: Complementing port 'instruction[7]' in design 'decode_stage'.
	 The new name of the port is 'instruction[7]_BAR'. (OPT-319)
Information: Complementing port 'dcache_resp' in design 'mp4datapath'.
	 The new name of the port is 'dcache_resp_BAR'. (OPT-319)
Information: Complementing port 'mem_resp' in design 'd_cache'.
	 The new name of the port is 'mem_resp_BAR'. (OPT-319)
Information: Complementing port 'plru_update' in design 'd_cache_datapath'.
	 The new name of the port is 'plru_update_BAR'. (OPT-319)
Information: Complementing port 'address[8]' in design 'd_cache_datapath'.
	 The new name of the port is 'address[8]_BAR'. (OPT-319)
Information: Complementing port 'mem_address[8]' in design 'd_cache'.
	 The new name of the port is 'mem_address[8]_BAR'. (OPT-319)
Information: Complementing port 'pmem_address[8]' in design 'd_cache_datapath'.
	 The new name of the port is 'pmem_address[8]_BAR'. (OPT-319)
Information: Complementing port 'pmem_address[8]' in design 'd_cache'.
	 The new name of the port is 'pmem_address[8]_BAR'. (OPT-319)
Information: Complementing port 'mem_address_d[8]' in design 'mp4datapath'.
	 The new name of the port is 'mem_address_d[8]_BAR'. (OPT-319)
Information: Complementing port 'address[7]' in design 'd_cache_datapath'.
	 The new name of the port is 'address[7]_BAR'. (OPT-319)
Information: Complementing port 'mem_address[7]' in design 'd_cache'.
	 The new name of the port is 'mem_address[7]_BAR'. (OPT-319)
Information: Complementing port 'pmem_address[7]' in design 'd_cache_datapath'.
	 The new name of the port is 'pmem_address[7]_BAR'. (OPT-319)
Information: Complementing port 'pmem_address[7]' in design 'd_cache'.
	 The new name of the port is 'pmem_address[7]_BAR'. (OPT-319)
Information: Complementing port 'mem_address_d[7]' in design 'mp4datapath'.
	 The new name of the port is 'mem_address_d[7]_BAR'. (OPT-319)
Information: Complementing port 'address[6]' in design 'd_cache_datapath'.
	 The new name of the port is 'address[6]_BAR'. (OPT-319)
Information: Complementing port 'mem_address[6]' in design 'd_cache'.
	 The new name of the port is 'mem_address[6]_BAR'. (OPT-319)
Information: Complementing port 'pmem_address[6]' in design 'd_cache_datapath'.
	 The new name of the port is 'pmem_address[6]_BAR'. (OPT-319)
Information: Complementing port 'pmem_address[6]' in design 'd_cache'.
	 The new name of the port is 'pmem_address[6]_BAR'. (OPT-319)
Information: Complementing port 'mem_address_d[6]' in design 'mp4datapath'.
	 The new name of the port is 'mem_address_d[6]_BAR'. (OPT-319)
Information: Complementing port 'pmem_write' in design 'd_cache'.
	 The new name of the port is 'pmem_write_BAR'. (OPT-319)
Information: Complementing port 'dataout_sel_mux' in design 'd_cache_datapath'.
	 The new name of the port is 'dataout_sel_mux_BAR'. (OPT-319)
Information: Complementing port 'pmem_address_mux' in design 'd_cache_datapath'.
	 The new name of the port is 'pmem_address_mux_BAR'. (OPT-319)
Information: Complementing port 'mem_address_d[4]' in design 'mp4datapath'.
	 The new name of the port is 'mem_address_d[4]_BAR'. (OPT-319)
Information: Complementing port 'mem_address_d[3]' in design 'mp4datapath'.
	 The new name of the port is 'mem_address_d[3]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[i_imm][1]_BAR' in design 'decode_stage'.
	 The new name of the port is 'imm_data[i_imm][1]'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][21]_BAR' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][21]'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][1]_BAR' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][1]'. (OPT-319)
Information: Complementing port 'cr[rs2_addr][1]_BAR' in design 'decode_stage'.
	 The new name of the port is 'cr[rs2_addr][1]'. (OPT-319)
Information: Complementing port 'src_b[1]_BAR' in design 'regfile'.
	 The new name of the port is 'src_b[1]'. (OPT-319)
Information: Complementing port 'cr[rs2_addr][1]_BAR' in design 'mp4datapath'.
	 The new name of the port is 'cr[rs2_addr][1]'. (OPT-319)
Information: Complementing port 'instruction[21]_BAR' in design 'decode_stage'.
	 The new name of the port is 'instruction[21]'. (OPT-319)
Information: Complementing port 'imm_data[i_imm][9]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[i_imm][9]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][29]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][29]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][9]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][9]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][9]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][9]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][9]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][9]_BAR'. (OPT-319)
Information: Complementing port 'instruction[29]' in design 'decode_stage'.
	 The new name of the port is 'instruction[29]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[i_imm][8]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[i_imm][8]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][28]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][28]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][8]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][8]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][8]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][8]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][8]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][8]_BAR'. (OPT-319)
Information: Complementing port 'instruction[28]' in design 'decode_stage'.
	 The new name of the port is 'instruction[28]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[i_imm][7]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[i_imm][7]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][27]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][27]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][7]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][7]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][7]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][7]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][7]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][7]_BAR'. (OPT-319)
Information: Complementing port 'instruction[27]' in design 'decode_stage'.
	 The new name of the port is 'instruction[27]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[i_imm][6]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[i_imm][6]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[u_imm][26]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[u_imm][26]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[b_imm][6]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[b_imm][6]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[s_imm][6]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[s_imm][6]_BAR'. (OPT-319)
Information: Complementing port 'imm_data[j_imm][6]' in design 'decode_stage'.
	 The new name of the port is 'imm_data[j_imm][6]_BAR'. (OPT-319)
Information: Complementing port 'instruction[26]' in design 'decode_stage'.
	 The new name of the port is 'instruction[26]_BAR'. (OPT-319)
Information: Complementing port 'mem_address_d[4]_BAR' in design 'mp4datapath'.
	 The new name of the port is 'mem_address_d[4]'. (OPT-319)

  Beginning Mapping Optimizations  (Ultra High effort)
  -------------------------------
Information: Added key list 'DesignWare' to design 'multiply_and_divide'. (DDB-72)
Information: Ungrouping hierarchy dcache0 'd_cache' #insts = 22. (OPT-777)
Information: Ungrouping hierarchy control_buffer 'control_buffer' #insts = 2457. (OPT-777)
Information: Ungrouping hierarchy dcache0/datapath 'd_cache_datapath' #insts = 2376. (OPT-777)
Information: Ungrouping hierarchy datapath/decode 'decode_stage' #insts = 0. (OPT-777)
Information: Ungrouping hierarchy datapath/execute 'exe_stage' #insts = 877. (OPT-777)
Information: Ungrouping hierarchy datapath/execute/alu_logic/multi_div 'multiply_and_divide' #insts = 747. (OPT-777)
  Mapping Optimization (Phase 1)

                                  TOTAL                                                            
   ELAPSED            WORST NEG   SETUP    DESIGN                              LEAKAGE   MIN DELAY 
    TIME      AREA      SLACK     COST    RULE COST         ENDPOINT            POWER      COST    
  --------- --------- --------- --------- --------- ------------------------- --------- -----------
    0:01:46  150128.8      0.00       0.0    5040.7                           2212466.2500      0.00  
    0:01:48  150112.9      0.08      83.5    5066.6                           2212062.7500      0.00  

  Beginning Constant Register Removal
  -----------------------------------
    0:01:51  150272.2      0.37     377.0    5044.7                           2220526.0000      0.00  
    0:01:52  150272.2      0.37     377.0    5044.7                           2220526.0000      0.00  

  Beginning Global Optimizations
  ------------------------------
  Numerical Synthesis (Phase 1)
  Numerical Synthesis (Phase 2)
  Global Optimization (Phase 1)
  Global Optimization (Phase 2)
  Global Optimization (Phase 3)
  Global Optimization (Phase 4)
  Global Optimization (Phase 5)
  Global Optimization (Phase 6)
  Global Optimization (Phase 7)
  Global Optimization (Phase 8)
  Global Optimization (Phase 9)
  Global Optimization (Phase 10)
  Global Optimization (Phase 11)
  Global Optimization (Phase 12)
  Global Optimization (Phase 13)
  Global Optimization (Phase 14)
  Global Optimization (Phase 15)
  Global Optimization (Phase 16)
  Global Optimization (Phase 17)
  Global Optimization (Phase 18)
  Global Optimization (Phase 19)
  Global Optimization (Phase 20)
  Global Optimization (Phase 21)
  Global Optimization (Phase 22)
  Global Optimization (Phase 23)
  Global Optimization (Phase 24)
  Global Optimization (Phase 25)
  Global Optimization (Phase 26)
  Global Optimization (Phase 27)
  Global Optimization (Phase 28)
  Global Optimization (Phase 29)
  Global Optimization (Phase 30)
  Global Optimization (Phase 31)
  Selecting critical implementations
  Mapping 'alu_DW01_sub_0'
  Mapping 'alu_DW01_sub_1'

  Beginning Isolate Ports
  -----------------------

  Beginning Delay Optimization
  ----------------------------
    0:02:03  126733.6      0.02      16.5    4362.3                           985650.8750      0.00  
    0:02:03  126742.6      0.00       0.0    4362.3                           986252.5625      0.00  
    0:02:03  126742.6      0.00       0.0    4362.3                           986252.5625      0.00  
    0:02:04  126739.2      0.00       0.0    4362.3                           986168.8125      0.00  
    0:02:07  126638.1      0.00       0.0    4341.3                           983597.2500      0.00  
    0:02:09  126428.7      0.00       0.0    4332.6                           977835.1875      0.00  

  Beginning WLM Backend Optimization
  --------------------------------------
    0:02:18  125779.7      0.00       0.0    4283.2                           949536.8750      0.00  
    0:02:18  125657.6      0.00       0.0    4282.1                           945303.5000      0.00  
    0:02:19  125657.6      0.00       0.0    4282.1                           945303.5000      0.00  
    0:02:19  125657.6      0.00       0.0    4282.1                           945303.5000      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  


  Beginning Design Rule Fixing  (max_transition)  (max_fanout)  (max_capacitance)
  ----------------------------

                                  TOTAL                                                            
   ELAPSED            WORST NEG   SETUP    DESIGN                              LEAKAGE   MIN DELAY 
    TIME      AREA      SLACK     COST    RULE COST         ENDPOINT            POWER      COST    
  --------- --------- --------- --------- --------- ------------------------- --------- -----------
    0:02:21  125300.4      0.00       0.0    4206.4                           919489.8125      0.00  
  Global Optimization (Phase 32)
  Global Optimization (Phase 33)
  Global Optimization (Phase 34)
    0:02:23  125832.1      0.00       0.0    3210.1 bmem_rdata[0]             937590.8125      0.00  
    0:02:23  125856.8      0.00       0.0    3100.5                           937938.4375      0.00  
    0:02:23  125856.8      0.00       0.0    3100.5                           937938.4375      0.00  


  Beginning Leakage Power Optimization  (max_leakage_power 0)
  ------------------------------------

                                  TOTAL                                                            
   ELAPSED            WORST NEG   SETUP    DESIGN                              LEAKAGE   MIN DELAY 
    TIME      AREA      SLACK     COST    RULE COST         ENDPOINT            POWER      COST    
  --------- --------- --------- --------- --------- ------------------------- --------- -----------
    0:02:23  125856.8      0.00       0.0    3100.5                           937938.4375      0.00  
  Global Optimization (Phase 35)
  Global Optimization (Phase 36)
  Global Optimization (Phase 37)
  Global Optimization (Phase 38)
  Global Optimization (Phase 39)
  Global Optimization (Phase 40)
  Global Optimization (Phase 41)
  Global Optimization (Phase 42)
  Global Optimization (Phase 43)
  Global Optimization (Phase 44)
  Global Optimization (Phase 45)
  Global Optimization (Phase 46)
  Global Optimization (Phase 47)
  Global Optimization (Phase 48)
  Global Optimization (Phase 49)
  Global Optimization (Phase 50)
Information: Complementing port 'instruct_in_wb[opcode][3]' in design 'mp4datapath'.
	 The new name of the port is 'instruct_in_wb[opcode][3]_BAR'. (OPT-319)
Information: Complementing port 'cr[instruction][2]' in design 'mp4datapath'.
	 The new name of the port is 'cr[instruction][2]_BAR'. (OPT-319)
Information: Complementing port 'cr[instruction][1]' in design 'mp4datapath'.
	 The new name of the port is 'cr[instruction][1]_BAR'. (OPT-319)
Information: Complementing port 'cr[instruction][0]' in design 'mp4datapath'.
	 The new name of the port is 'cr[instruction][0]_BAR'. (OPT-319)
Information: Complementing port 'cr[pc_rdata][30]' in design 'mp4datapath'.
	 The new name of the port is 'cr[pc_rdata][30]_BAR'. (OPT-319)
Information: Complementing port 'branch_prediction' in design 'mp4datapath'.
	 The new name of the port is 'branch_prediction_BAR'. (OPT-319)
Information: Complementing port 'prediction_exe' in design 'mp4datapath'.
	 The new name of the port is 'prediction_exe_BAR'. (OPT-319)
Information: Complementing port 'mem_byte_enable[3]' in design 'mp4datapath'.
	 The new name of the port is 'mem_byte_enable[3]_BAR'. (OPT-319)
Information: Complementing port 'mem_byte_enable[2]' in design 'mp4datapath'.
	 The new name of the port is 'mem_byte_enable[2]_BAR'. (OPT-319)
Information: Complementing port 'mem_byte_enable[1]' in design 'mp4datapath'.
	 The new name of the port is 'mem_byte_enable[1]_BAR'. (OPT-319)
Information: Complementing port 'mem_byte_enable[0]' in design 'mp4datapath'.
	 The new name of the port is 'mem_byte_enable[0]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[12]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[12]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[11]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[11]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[10]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[10]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[9]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[9]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[8]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[8]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[7]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[7]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[6]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[6]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[5]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[5]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[4]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[4]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[3]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[3]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[2]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[2]_BAR'. (OPT-319)
Information: Complementing port 'bimm_exec[1]' in design 'mp4datapath'.
	 The new name of the port is 'bimm_exec[1]_BAR'. (OPT-319)
    0:02:28  125663.7      0.00       0.0    2985.8                           928718.6250      0.00  
    0:02:28  125663.7      0.00       0.0    2985.8                           928718.6250      0.00  
    0:02:28  125663.7      0.00       0.0    2985.8                           928718.6250      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  
    0:02:29  125624.1      0.00       0.0    2988.3                           926511.3750      0.00  

                                  TOTAL                                                            
   ELAPSED            WORST NEG   SETUP    DESIGN                              LEAKAGE   MIN DELAY 
    TIME      AREA      SLACK     COST    RULE COST         ENDPOINT            POWER      COST    
  --------- --------- --------- --------- --------- ------------------------- --------- -----------
    0:02:31  125616.1      0.00       0.0    2988.3                           926393.1250      0.00  
    0:02:33  125460.8      0.00       0.0    3013.9                           920337.1875      0.00  
    0:02:33  125460.8      0.00       0.0    3013.9                           920337.1875      0.00  
    0:02:33  125460.8      0.00       0.0    3013.9                           920337.1875      0.00  
    0:02:34  125452.5      0.00       0.0    3016.5                           919743.6875      0.00  
    0:02:37  125504.1      0.00       0.0    2923.2 dcache0/datapath/data_o[0][228] 920372.1875      0.00  
    0:02:37  125769.3      0.00       0.0    2799.1                           930811.0625      0.00  
    0:02:37  125769.3      0.00       0.0    2799.1                           930811.0625      0.00  
    0:02:37  125769.3      0.00       0.0    2799.1                           930811.0625      0.00  
    0:02:37  125769.3      0.00       0.0    2799.1                           930811.0625      0.00  
    0:02:37  125769.3      0.00       0.0    2799.1                           930811.0625      0.00  
    0:02:37  125769.3      0.00       0.0    2799.1                           930811.0625      0.00  
    0:02:39  125676.2      0.00       0.0    2799.6                           925947.0625      0.00  
Loading db file '/srv/ece411ag/freepdk-45nm/stdcells.db'
Loading db file '/tmp/dut/sram/output/mp3_tag_array/mp3_tag_array_TT_1p0V_25C_lib.db'
Loading db file '/tmp/dut/sram/output/mp3_data_array/mp3_data_array_TT_1p0V_25C_lib.db'


Note: Symbol # after min delay cost means estimated hold TNS across all active scenarios 


  Optimization Complete
  ---------------------
Information: State dependent leakage is now switched from off to on.
Information: Propagating switching activity (low effort zero delay simulation). (PWR-6)
1
current_design $design_toplevel
Current design is 'mp4'.
{mp4}
report_area -hier > reports/area.rpt
report_timing -delay max > reports/timing.rpt
check_design > reports/check.rpt
write_file -format ddc -hierarchy -output outputs/synth.ddc
Writing ddc file 'outputs/synth.ddc'.
1
write_file -format verilog -hierarchy -output [format "outputs/%s.gate.v" $design_toplevel]
Writing verilog file '/tmp/dut/synth/outputs/mp4.gate.v'.
1
exit

Memory usage for this session 248 Mbytes.
Memory usage for this session including child processes 283 Mbytes.
CPU usage for this session 164 seconds ( 0.05 hours ).
Elapsed time for this session 174 seconds ( 0.05 hours ).

Thank you...
rm -f  *.log
rm -f  default.svf
rm -rf work

[0;32mTiming Met [0m
[0;31mArea Not Met [0m
 
 ``` 

 </details> 
