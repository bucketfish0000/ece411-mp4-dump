# AG Report MP4CP1 2023-11-01T23:59:59-05:00 
Report generated at 2023-11-02T00:07:51-05:00, using commit ``4ecdfb03097f54de1eca4d6e9a44301e57709115``

Autograder Run ID: b3b52aaf-d2f7-4e96-bea7-9c4c3414225b

Autograder Job ID: 46fec43e-70ee-468a-83b1-d319ad2c42f7


## Logs
<details><summary>Compile ❌</summary> 

 ``` 
 mkdir -p sim
cd sim && vcs /tmp/dut/pkg/types.sv /tmp/dut/hdl/mp4control.sv /tmp/dut/hdl/mp4.sv /tmp/dut/hdl/decode_stage.sv /tmp/dut/hdl/register.sv /tmp/dut/hdl/regfile.sv /tmp/dut/hdl/mem_stage.sv /tmp/dut/hdl/mem_data_out.sv /tmp/dut/hdl/mar.sv /tmp/dut/hdl/mp4datapath.sv /tmp/dut/hdl/alu.sv /tmp/dut/hdl/cmp.sv /tmp/dut/hdl/wb_stage.sv /tmp/dut/hdl/pipeline_registers.sv /tmp/dut/hdl/fetch_stage.sv /tmp/dut/hdl/exe_stage.sv /tmp/dut/hvl/top_tb.sv /tmp/dut/hvl/rvfimon.v /tmp/dut/hvl/monitor.sv /tmp/dut/hvl/mon_itf.sv /tmp/dut/hvl/mem_itf.sv /tmp/dut/hvl/magic_dual_port.sv /tmp/dut/hvl/burst_memory.sv /tmp/dut/hvl/bmem_itf.sv  -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LCA_FEATURES_ENABLED -licqueue -msg_config=../vcs_warn.config -l compile.log -top top_tb -o top_tb
                         Chronologic VCS (TM)
      Version R-2020.12-SP1-1_Full64 -- Thu Nov  2 00:07:55 2023

                    Copyright (c) 1991 - 2021 Synopsys, Inc.
   This software and the associated documentation are proprietary to Synopsys,
 Inc. This software may only be used in accordance with the terms and conditions
 of a written license agreement with Synopsys, Inc. All other use, reproduction,
            or distribution of this software is strictly prohibited.

Parsing design file '/tmp/dut/pkg/types.sv'

Error-[SV-LCM-PND] Package not defined
/tmp/dut/pkg/types.sv, 2
cpuIO, "rv32i_types::"
  Package scope resolution failed. Token 'rv32i_types' is not a package. 
  Originating module 'cpuIO'.
  Move package definition before the use of the package.


Error-[SV-EEM-SRE] Scope resolution error
/tmp/dut/pkg/types.sv, 11
cpuIO, "rs1mux::rs1_sel_t"
  Target for scope resolution operator does not exist. Token 'rs1mux' is not a
  class/package.  Originating module 'cpuIO'.
  Check that class or package exists with referred token as the name.


Error-[SE] Syntax error
  Following verilog source has syntax error :
  "/tmp/dut/pkg/types.sv", 11: token is 'rs1_sel_t'
          rs1mux::rs1_sel_t rs1_sel;
                           ^

3 errors
CPU time: .233 seconds to compile
make: *** [Makefile:16: sim/top_tb] Error 255
 
 ``` 

 </details> 
