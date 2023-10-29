# AG Report MP4CP1 2023-10-29T02:00:34-05:00 
Report generated at 2023-10-29T02:01:32-05:00, using commit ``4b1c705``

Autograder Run ID: 6a45864d-2d18-4453-b7d8-57f950c6165f

Autograder Job ID: 0ca6d469-a385-4c6b-a3e4-1537cc3ddaf3


## Logs
<details><summary>Compile ❌</summary> 

 ``` 
 mkdir -p sim
cd sim && vcs /tmp/dut/pkg/types.sv /tmp/dut/hdl/wb_stage.sv /tmp/dut/hdl/register.sv /tmp/dut/hdl/regfile.sv /tmp/dut/hdl/pipeline_registers.sv /tmp/dut/hdl/mp4datapath.sv /tmp/dut/hdl/mp4control.sv /tmp/dut/hdl/mp4.sv /tmp/dut/hdl/mem_stage.sv /tmp/dut/hdl/mem_data_out.sv /tmp/dut/hdl/mar.sv /tmp/dut/hdl/fetch_stage.sv /tmp/dut/hdl/exe_stage.sv /tmp/dut/hdl/exe_mem_reg.sv /tmp/dut/hdl/decode_stage.sv /tmp/dut/hdl/cmp.sv /tmp/dut/hdl/alu.sv /tmp/dut/hvl/top_tb.sv /tmp/dut/hvl/rvfimon.v /tmp/dut/hvl/monitor.sv /tmp/dut/hvl/mon_itf.sv /tmp/dut/hvl/mem_itf.sv /tmp/dut/hvl/magic_dual_port.sv /tmp/dut/hvl/burst_memory.sv /tmp/dut/hvl/bmem_itf.sv -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LNX_OS_VERUN -suppress=LINX_KRNL -suppress=LCA_FEATURES_ENABLED -licqueue -msg_config=../vcs_warn.config -l compile.log -top top_tb -o top_tb

Warning-[LNX_OS_VERUN] Unsupported Linux version
  Linux version 'AlmaLinux release 8.7 (Stone Smilodon)' is not supported on 
  'x86_64' officially, assuming linux compatibility by default. Set 
  VCS_ARCH_OVERRIDE to linux or suse32 to override.
  Please refer to release notes for information on supported platforms.


Warning-[LINX_KRNL] Unsupported Linux kernel
  Linux kernel '4.15.0-213-generic' is not supported.
  Supported versions are 2.4* or 2.6*.

                         Chronologic VCS (TM)
      Version R-2020.12-SP1-1_Full64 -- Sun Oct 29 02:01:35 2023

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
CPU time: .245 seconds to compile
make: *** [Makefile:14: sim/top_tb] Error 255
 
 ``` 

 </details> 
