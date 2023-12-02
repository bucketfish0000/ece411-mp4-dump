# AG Report MP4CP4 2023-12-01T23:59:59-06:00 
Report generated at 2023-12-02T02:41:23-06:00, using commit ``342949367b6306126d0ec7926330ef3e875862e8``

Autograder Run ID: 2b97a9cb-d148-43c9-a4a0-24540cfd8e2f

Autograder Job ID: 98dbaa2a-3e27-472d-bd59-36ac53d9c7fe


## Logs
<details><summary>Compile ❌</summary> 

 ``` 
 mkdir -p sim
cd sim && vcs /tmp/dut/pkg/types.sv /tmp/dut/hdl/mem_interface/mem_word_adaptor.sv /tmp/dut/hdl/mem_interface/cacheline_adaptor.sv /tmp/dut/hdl/mem_interface/arbiter.sv /tmp/dut/hdl/mem_interface/cache/valid.sv /tmp/dut/hdl/mem_interface/cache/ff_array.sv /tmp/dut/hdl/mem_interface/cache/dirty.sv /tmp/dut/hdl/mem_interface/cache/cache_datapath.sv /tmp/dut/hdl/mem_interface/cache/cache_control.sv /tmp/dut/hdl/mem_interface/cache/cache.sv /tmp/dut/hdl/mem_interface/cache/PLRU.sv /tmp/dut/hdl/ctrl_buffer/prefetch_buffer.sv /tmp/dut/hdl/ctrl_buffer/control_buffer.sv /tmp/dut/hdl/wb_stage.sv /tmp/dut/hdl/shift_reg.sv /tmp/dut/hdl/sext_half.sv /tmp/dut/hdl/sext_byte.sv /tmp/dut/hdl/register.sv /tmp/dut/hdl/regfile.sv /tmp/dut/hdl/pipeline_registers.sv /tmp/dut/hdl/multiply_and_divide.sv /tmp/dut/hdl/multiplier_v2.sv /tmp/dut/hdl/multiplier.sv /tmp/dut/hdl/mp4datapath.sv /tmp/dut/hdl/mp4control.sv /tmp/dut/hdl/mp4.sv /tmp/dut/hdl/mem_stage.sv /tmp/dut/hdl/mem_data_out.sv /tmp/dut/hdl/mar.sv /tmp/dut/hdl/hazard_queue.sv /tmp/dut/hdl/fetch_stage.sv /tmp/dut/hdl/exe_stage.sv /tmp/dut/hdl/divider_slow.sv /tmp/dut/hdl/div_compare.sv /tmp/dut/hdl/decode_stage.sv /tmp/dut/hdl/counter.sv /tmp/dut/hdl/cmp.sv /tmp/dut/hdl/alu.sv /tmp/dut/hvl/top_tb.sv /tmp/dut/hvl/rvfimon.v /tmp/dut/hvl/monitor.sv /tmp/dut/hvl/mon_itf.sv /tmp/dut/hvl/burst_memory.sv /tmp/dut/hvl/bmem_itf.sv  -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LCA_FEATURES_ENABLED -licqueue -msg_config=../vcs_warn.config -l compile.log -top top_tb -o top_tb
                         Chronologic VCS (TM)
      Version R-2020.12-SP1-1_Full64 -- Sat Dec  2 02:41:27 2023

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
Top Level Modules:
       top_tb

Error-[CFCILFBI] Cannot find cell in liblist
/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv, 119
  Cell 'mp3_data_array' cannot be found in liblist for binding instance 
  'top_tb.dut.dcache0.datapath.arrays[0].data_array'.
  Liblist: work
  Config rule: global default liblist
  Source Info: mp3_data_array data_array( .clk0 ((~clk)),  .csb0 (1'b0),  
  .web0 (data_web[0]),  .wmask0 (data_wmask),  .addr0 (set),  .din0 (data_i), 
  .dout0 (data_o[0]));


Error-[CFCILFBI] Cannot find cell in liblist
/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv, 128
  Cell 'mp3_tag_array' cannot be found in liblist for binding instance 
  'top_tb.dut.dcache0.datapath.arrays[0].tag_array'.
  Liblist: work
  Config rule: global default liblist
  Source Info: mp3_tag_array tag_array( .clk0 ((~clk)),  .csb0 (1'b0),  .web0 
  (tag_web[0]),  .addr0 (set),  .din0 (tag_i),  .dout0 (tag_o[0]));


Error-[CFCILFBI] Cannot find cell in liblist
/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv, 119
  Cell 'mp3_data_array' cannot be found in liblist for binding instance 
  'top_tb.dut.dcache0.datapath.arrays[1].data_array'.
  Liblist: work
  Config rule: global default liblist
  Source Info: mp3_data_array data_array( .clk0 ((~clk)),  .csb0 (1'b0),  
  .web0 (data_web[1]),  .wmask0 (data_wmask),  .addr0 (set),  .din0 (data_i), 
  .dout0 (data_o[1]));


Error-[CFCILFBI] Cannot find cell in liblist
/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv, 128
  Cell 'mp3_tag_array' cannot be found in liblist for binding instance 
  'top_tb.dut.dcache0.datapath.arrays[1].tag_array'.
  Liblist: work
  Config rule: global default liblist
  Source Info: mp3_tag_array tag_array( .clk0 ((~clk)),  .csb0 (1'b0),  .web0 
  (tag_web[1]),  .addr0 (set),  .din0 (tag_i),  .dout0 (tag_o[1]));


Error-[CFCILFBI] Cannot find cell in liblist
/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv, 119
  Cell 'mp3_data_array' cannot be found in liblist for binding instance 
  'top_tb.dut.dcache0.datapath.arrays[2].data_array'.
  Liblist: work
  Config rule: global default liblist
  Source Info: mp3_data_array data_array( .clk0 ((~clk)),  .csb0 (1'b0),  
  .web0 (data_web[2]),  .wmask0 (data_wmask),  .addr0 (set),  .din0 (data_i), 
  .dout0 (data_o[2]));


Error-[CFCILFBI] Cannot find cell in liblist
/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv, 128
  Cell 'mp3_tag_array' cannot be found in liblist for binding instance 
  'top_tb.dut.dcache0.datapath.arrays[2].tag_array'.
  Liblist: work
  Config rule: global default liblist
  Source Info: mp3_tag_array tag_array( .clk0 ((~clk)),  .csb0 (1'b0),  .web0 
  (tag_web[2]),  .addr0 (set),  .din0 (tag_i),  .dout0 (tag_o[2]));


Error-[CFCILFBI] Cannot find cell in liblist
/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv, 119
  Cell 'mp3_data_array' cannot be found in liblist for binding instance 
  'top_tb.dut.dcache0.datapath.arrays[3].data_array'.
  Liblist: work
  Config rule: global default liblist
  Source Info: mp3_data_array data_array( .clk0 ((~clk)),  .csb0 (1'b0),  
  .web0 (data_web[3]),  .wmask0 (data_wmask),  .addr0 (set),  .din0 (data_i), 
  .dout0 (data_o[3]));


Error-[CFCILFBI] Cannot find cell in liblist
/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv, 128
  Cell 'mp3_tag_array' cannot be found in liblist for binding instance 
  'top_tb.dut.dcache0.datapath.arrays[3].tag_array'.
  Liblist: work
  Config rule: global default liblist
  Source Info: mp3_tag_array tag_array( .clk0 ((~clk)),  .csb0 (1'b0),  .web0 
  (tag_web[3]),  .addr0 (set),  .din0 (tag_i),  .dout0 (tag_o[3]));

8 errors
CPU time: .587 seconds to compile
make: *** [Makefile:16: sim/top_tb] Error 255
 
 ``` 

 </details> 
