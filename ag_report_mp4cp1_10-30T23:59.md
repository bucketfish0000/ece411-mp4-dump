# AG Report MP4CP1 2023-10-30T23:59:59-05:00 
Report generated at 2023-10-31T00:56:36-05:00, using commit ``ef9427e1619b82f2c78ca5e17a25a7c9a3d7f066``

Autograder Run ID: ac8145bf-312d-49ec-9e2a-4deb5e4037b7

Autograder Job ID: 68987ecb-d7bc-4f7a-af34-64e922cfaea3


## Logs
<details><summary>Compile ❌</summary> 

 ``` 
 mkdir -p sim
cd sim && vcs /tmp/dut/pkg/types.sv /tmp/dut/hdl/wb_stage.sv /tmp/dut/hdl/register.sv /tmp/dut/hdl/regfile.sv /tmp/dut/hdl/pipeline_registers.sv /tmp/dut/hdl/mp4datapath.sv /tmp/dut/hdl/mp4control.sv /tmp/dut/hdl/mp4.sv /tmp/dut/hdl/mem_stage.sv /tmp/dut/hdl/mem_data_out.sv /tmp/dut/hdl/mar.sv /tmp/dut/hdl/fetch_stage.sv /tmp/dut/hdl/exe_stage.sv /tmp/dut/hdl/exe_mem_reg.sv /tmp/dut/hdl/decode_stage.sv /tmp/dut/hdl/cmp.sv /tmp/dut/hdl/alu.sv /tmp/dut/hvl/top_tb.sv /tmp/dut/hvl/rvfimon.v /tmp/dut/hvl/monitor.sv /tmp/dut/hvl/mon_itf.sv /tmp/dut/hvl/mem_itf.sv /tmp/dut/hvl/magic_dual_port.sv /tmp/dut/hvl/burst_memory.sv /tmp/dut/hvl/bmem_itf.sv  -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LCA_FEATURES_ENABLED -licqueue -msg_config=../vcs_warn.config -l compile.log -top top_tb -o top_tb
                         Chronologic VCS (TM)
      Version R-2020.12-SP1-1_Full64 -- Tue Oct 31 00:56:39 2023

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


Error-[SE] Syntax error
  Following verilog source has syntax error :
  "/tmp/dut/pkg/types.sv", 10: token is 'cw_execute'
          cw_execute exe;
                    ^

7 errors
CPU time: .225 seconds to compile
make: *** [Makefile:16: sim/top_tb] Error 255
 
 ``` 

 </details> 
