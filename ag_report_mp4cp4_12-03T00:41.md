# AG Report MP4CP4 2023-12-03T00:41:09-06:00 
Report generated at 2023-12-03T01:41:01-06:00, using commit ``c2d6b96651c3434b5fcad01cfe9ca86607258757``

Autograder Run ID: ad84ab5c-1901-42e1-94d6-d4ea94aa8e17

Autograder Job ID: 81ac6566-ffd0-43e2-93d5-ae9ffb568c8f


## Logs
<details><summary>Compile ❌</summary> 

 ``` 
 mkdir -p sim
cd sim && vcs /tmp/dut/pkg/types.sv /tmp/dut/hdl/mem_interface/mem_word_adaptor.sv /tmp/dut/hdl/mem_interface/cacheline_adaptor.sv /tmp/dut/hdl/mem_interface/arbiter.sv /tmp/dut/hdl/mem_interface/cache/valid.sv /tmp/dut/hdl/mem_interface/cache/ff_array.sv /tmp/dut/hdl/mem_interface/cache/dirty.sv /tmp/dut/hdl/mem_interface/cache/cache_datapath.sv /tmp/dut/hdl/mem_interface/cache/cache_control.sv /tmp/dut/hdl/mem_interface/cache/cache.sv /tmp/dut/hdl/mem_interface/cache/PLRU.sv /tmp/dut/hdl/ctrl_buffer/prefetch_buffer.sv /tmp/dut/hdl/ctrl_buffer/control_buffer.sv /tmp/dut/hdl/wb_stage.sv /tmp/dut/hdl/shift_reg.sv /tmp/dut/hdl/sext_half.sv /tmp/dut/hdl/sext_byte.sv /tmp/dut/hdl/register.sv /tmp/dut/hdl/regfile.sv /tmp/dut/hdl/pipeline_registers.sv /tmp/dut/hdl/multiply_and_divide.sv /tmp/dut/hdl/multiplier_v2.sv /tmp/dut/hdl/multiplier.sv /tmp/dut/hdl/mp4datapath.sv /tmp/dut/hdl/mp4control.sv /tmp/dut/hdl/mp4.sv /tmp/dut/hdl/mem_stage.sv /tmp/dut/hdl/mem_data_out.sv /tmp/dut/hdl/mar.sv /tmp/dut/hdl/hazard_queue.sv /tmp/dut/hdl/fetch_stage.sv /tmp/dut/hdl/exe_stage.sv /tmp/dut/hdl/divider_slow.sv /tmp/dut/hdl/div_compare.sv /tmp/dut/hdl/decode_stage.sv /tmp/dut/hdl/counter.sv /tmp/dut/hdl/cmp.sv /tmp/dut/hdl/alu.sv /tmp/dut/hvl/top_tb.sv /tmp/dut/hvl/rvfimon.v /tmp/dut/hvl/monitor.sv /tmp/dut/hvl/mon_itf.sv /tmp/dut/hvl/burst_memory.sv /tmp/dut/hvl/bmem_itf.sv  -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LCA_FEATURES_ENABLED -licqueue -msg_config=../vcs_warn.config -l compile.log -top top_tb -o top_tb
                         Chronologic VCS (TM)
      Version R-2020.12-SP1-1_Full64 -- Sun Dec  3 01:41:05 2023

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

Error-[SE] Syntax error
  Following verilog source has syntax error :
  "/tmp/dut/hdl/ctrl_buffer/prefetch_buffer.sv", 14: token is ')'
  );
   ^

1 error
CPU time: .309 seconds to compile
make: *** [Makefile:16: sim/top_tb] Error 255
 
 ``` 

 </details> 
