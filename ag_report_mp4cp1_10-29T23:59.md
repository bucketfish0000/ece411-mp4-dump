# AG Report MP4CP1 2023-10-29T23:59:59-05:00 
Report generated at 2023-10-30T00:59:57-05:00, using commit ``4b1c705``

Autograder Run ID: f65780fa-44e2-47fb-9213-80ada9460e8c

Autograder Job ID: 38fac5d8-c22a-489a-ab26-ec031ac05e65


## Logs
<details><summary>Compile ❌</summary> 

 ``` 
 mkdir -p sim
cd sim && vcs /tmp/dut/pkg/types.sv /tmp/dut/hdl/wb_stage.sv /tmp/dut/hdl/register.sv /tmp/dut/hdl/regfile.sv /tmp/dut/hdl/pipeline_registers.sv /tmp/dut/hdl/mp4datapath.sv /tmp/dut/hdl/mp4control.sv /tmp/dut/hdl/mp4.sv /tmp/dut/hdl/mem_stage.sv /tmp/dut/hdl/mem_data_out.sv /tmp/dut/hdl/mar.sv /tmp/dut/hdl/fetch_stage.sv /tmp/dut/hdl/exe_stage.sv /tmp/dut/hdl/exe_mem_reg.sv /tmp/dut/hdl/decode_stage.sv /tmp/dut/hdl/cmp.sv /tmp/dut/hdl/alu.sv /tmp/dut/hvl/top_tb.sv /tmp/dut/hvl/rvfimon.v /tmp/dut/hvl/monitor.sv /tmp/dut/hvl/mon_itf.sv /tmp/dut/hvl/mem_itf.sv /tmp/dut/hvl/magic_dual_port.sv /tmp/dut/hvl/burst_memory.sv /tmp/dut/hvl/bmem_itf.sv -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LCA_FEATURES_ENABLED -licqueue -msg_config=../vcs_warn.config -l compile.log -top top_tb -o top_tb
                         Chronologic VCS (TM)
      Version R-2020.12-SP1-1_Full64 -- Mon Oct 30 01:00:00 2023

                    Copyright (c) 1991 - 2021 Synopsys, Inc.
   This software and the associated documentation are proprietary to Synopsys,
 Inc. This software may only be used in accordance with the terms and conditions
 of a written license agreement with Synopsys, Inc. All other use, reproduction,
            or distribution of this software is strictly prohibited.

Parsing design file '/tmp/dut/pkg/types.sv'

Error-[SV-LCM-PND] Package not defined
/tmp/dut/pkg/types.sv, 2
cpuIO, "pcmux::"
  Package scope resolution failed. Token 'pcmux' is not a package. Originating
  module 'cpuIO'.
  Move package definition before the use of the package.


Error-[SV-LCM-PND] Package not defined
/tmp/dut/pkg/types.sv, 3
cpuIO, "marmux::"
  Package scope resolution failed. Token 'marmux' is not a package. 
  Originating module 'cpuIO'.
  Move package definition before the use of the package.


Error-[SV-LCM-PND] Package not defined
/tmp/dut/pkg/types.sv, 4
cpuIO, "cmpmux::"
  Package scope resolution failed. Token 'cmpmux' is not a package. 
  Originating module 'cpuIO'.
  Move package definition before the use of the package.


Error-[SV-LCM-PND] Package not defined
/tmp/dut/pkg/types.sv, 5
cpuIO, "alumux::"
  Package scope resolution failed. Token 'alumux' is not a package. 
  Originating module 'cpuIO'.
  Move package definition before the use of the package.


Error-[SV-LCM-PND] Package not defined
/tmp/dut/pkg/types.sv, 6
cpuIO, "regfilemux::"
  Package scope resolution failed. Token 'regfilemux' is not a package. 
  Originating module 'cpuIO'.
  Move package definition before the use of the package.


Error-[SV-LCM-PND] Package not defined
/tmp/dut/pkg/types.sv, 7
cpuIO, "rsmux::"
  Package scope resolution failed. Token 'rsmux' is not a package. Originating
  module 'cpuIO'.
  Move package definition before the use of the package.


Error-[SV-EEM-SRE] Scope resolution error
/tmp/dut/pkg/types.sv, 10
cpuIO, "rv32i_types::rv32i_opcode"
  Target for scope resolution operator does not exist. Token 'rv32i_types' is 
  not a class/package.  Originating module 'cpuIO'.
  Check that class or package exists with referred token as the name.


Error-[SE] Syntax error
  Following verilog source has syntax error :
  "/tmp/dut/pkg/types.sv", 10: token is 'rv32i_opcode'
          rv32i_types::rv32i_opcode opcode;
                                   ^

8 errors
CPU time: .238 seconds to compile
make: *** [Makefile:15: sim/top_tb] Error 255
 
 ``` 

 </details> 
