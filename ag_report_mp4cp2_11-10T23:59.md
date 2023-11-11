# AG Report MP4CP2 2023-11-10T23:59:59-06:00 
Report generated at 2023-11-11T00:42:44-06:00, using commit ``a64b0e70aed840fee101789990792cf215b137be``

Autograder Run ID: a9e46f6b-9c37-4ee9-b49d-95ffd4534bd0

Autograder Job ID: 39e51f02-6b48-4dfa-951c-02e668ce37cd


## Logs
<details><summary>Compile ❌</summary> 

 ``` 
 mkdir -p sim
cd sim && vcs /tmp/dut/pkg/types.sv /tmp/dut/hdl/mem_interface/cacheline_adaptor.sv /tmp/dut/hdl/mem_interface/cache/valid.sv /tmp/dut/hdl/mem_interface/cache/ff_array.sv /tmp/dut/hdl/mem_interface/cache/dirty.sv /tmp/dut/hdl/mem_interface/cache/cache_datapath.sv /tmp/dut/hdl/mem_interface/cache/cache_control.sv /tmp/dut/hdl/mem_interface/cache/cache.sv /tmp/dut/hdl/mem_interface/cache/PLRU.sv /tmp/dut/hdl/mem_interface/arbiter.sv /tmp/dut/hdl/multiply.sv /tmp/dut/hdl/multiplier.sv /tmp/dut/hdl/mp4control.sv /tmp/dut/hdl/exe_stage.sv /tmp/dut/hdl/register.sv /tmp/dut/hdl/regfile.sv /tmp/dut/hdl/mem_stage.sv /tmp/dut/hdl/mem_data_out.sv /tmp/dut/hdl/mar.sv /tmp/dut/hdl/mp4datapath.sv /tmp/dut/hdl/alu.sv /tmp/dut/hdl/cmp.sv /tmp/dut/hdl/decode_stage.sv /tmp/dut/hdl/fetch_stage.sv /tmp/dut/hdl/wb_stage.sv /tmp/dut/hdl/pipeline_registers.sv /tmp/dut/hdl/mp4.sv /tmp/dut/hdl/hazard_queue.sv /tmp/dut/hvl/top_tb.sv /tmp/dut/hvl/rvfimon.v /tmp/dut/hvl/monitor.sv /tmp/dut/hvl/mon_itf.sv /tmp/dut/hvl/burst_memory.sv /tmp/dut/hvl/bmem_itf.sv  -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LCA_FEATURES_ENABLED -licqueue -msg_config=../vcs_warn.config -l compile.log -top top_tb -o top_tb
                         Chronologic VCS (TM)
      Version R-2020.12-SP1-1_Full64 -- Sat Nov 11 00:42:48 2023

                    Copyright (c) 1991 - 2021 Synopsys, Inc.
   This software and the associated documentation are proprietary to Synopsys,
 Inc. This software may only be used in accordance with the terms and conditions
 of a written license agreement with Synopsys, Inc. All other use, reproduction,
            or distribution of this software is strictly prohibited.

Parsing design file '/tmp/dut/pkg/types.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cacheline_adaptor.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/valid.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/ff_array.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/dirty.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv'

Lint-[IWU] Implicit wire is used
/tmp/dut/hdl/mem_interface/cache/cache_datapath.sv, 113
  No type is specified for wire 'plru_num'. Default wire type is being applied
  according to the IEEE spec.
  See the Verilog LRM(1364-2005), section 4.5.

Parsing design file '/tmp/dut/hdl/mem_interface/cache/cache_control.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/cache/cache.sv'

Lint-[IWU] Implicit wire is used
/tmp/dut/hdl/mem_interface/cache/cache.sv, 43
  No type is specified for wire 'plru_rf'. Default wire type is being applied 
  according to the IEEE spec.
  See the Verilog LRM(1364-2005), section 4.5.

Parsing design file '/tmp/dut/hdl/mem_interface/cache/PLRU.sv'
Parsing design file '/tmp/dut/hdl/mem_interface/arbiter.sv'
Parsing design file '/tmp/dut/hdl/multiply.sv'
Parsing design file '/tmp/dut/hdl/multiplier.sv'
Parsing design file '/tmp/dut/hdl/mp4control.sv'
Parsing design file '/tmp/dut/hdl/exe_stage.sv'
Parsing design file '/tmp/dut/hdl/register.sv'
Parsing design file '/tmp/dut/hdl/regfile.sv'
Parsing design file '/tmp/dut/hdl/mem_stage.sv'
Parsing design file '/tmp/dut/hdl/mem_data_out.sv'
Parsing design file '/tmp/dut/hdl/mar.sv'
Parsing design file '/tmp/dut/hdl/mp4datapath.sv'
Parsing design file '/tmp/dut/hdl/alu.sv'
Parsing design file '/tmp/dut/hdl/cmp.sv'
Parsing design file '/tmp/dut/hdl/decode_stage.sv'
Parsing design file '/tmp/dut/hdl/fetch_stage.sv'
Parsing design file '/tmp/dut/hdl/wb_stage.sv'
Parsing design file '/tmp/dut/hdl/pipeline_registers.sv'
Parsing design file '/tmp/dut/hdl/mp4.sv'
Parsing design file '/tmp/dut/hdl/hazard_queue.sv'
Parsing design file '/tmp/dut/hvl/top_tb.sv'
Parsing design file '/tmp/dut/hvl/rvfimon.v'
Parsing design file '/tmp/dut/hvl/monitor.sv'
Parsing design file '/tmp/dut/hvl/mon_itf.sv'
Parsing design file '/tmp/dut/hvl/burst_memory.sv'
Parsing design file '/tmp/dut/hvl/bmem_itf.sv'
Top Level Modules:
       top_tb
TimeScale is 1 ps / 1 ps

Error-[UPIMI-E] Undefined port in module instantiation
/tmp/dut/hvl/top_tb.sv, 24
  Port "bmem_address" is not defined in module 'mp4' defined in 
  "/tmp/dut/hdl/mp4.sv", 1
  Module instance: mp4 dut( .clk (clk),  .rst (rst),  .bmem_address 
  (bmem_itf.addr),  .bmem_read (bmem_itf.read),  .bmem_write (bmem_itf.write),
  .bmem_rdata (bmem_itf.rdata),   ...


Error-[UPIMI-E] Undefined port in module instantiation
/tmp/dut/hvl/top_tb.sv, 24
  Port "bmem_read" is not defined in module 'mp4' defined in 
  "/tmp/dut/hdl/mp4.sv", 1
  Module instance: mp4 dut( .clk (clk),  .rst (rst),  .bmem_address 
  (bmem_itf.addr),  .bmem_read (bmem_itf.read),  .bmem_write (bmem_itf.write),
  .bmem_rdata (bmem_itf.rdata),   ...


Error-[UPIMI-E] Undefined port in module instantiation
/tmp/dut/hvl/top_tb.sv, 24
  Port "bmem_write" is not defined in module 'mp4' defined in 
  "/tmp/dut/hdl/mp4.sv", 1
  Module instance: mp4 dut( .clk (clk),  .rst (rst),  .bmem_address 
  (bmem_itf.addr),  .bmem_read (bmem_itf.read),  .bmem_write (bmem_itf.write),
  .bmem_rdata (bmem_itf.rdata),   ...


Error-[UPIMI-E] Undefined port in module instantiation
/tmp/dut/hvl/top_tb.sv, 24
  Port "bmem_rdata" is not defined in module 'mp4' defined in 
  "/tmp/dut/hdl/mp4.sv", 1
  Module instance: mp4 dut( .clk (clk),  .rst (rst),  .bmem_address 
  (bmem_itf.addr),  .bmem_read (bmem_itf.read),  .bmem_write (bmem_itf.write),
  .bmem_rdata (bmem_itf.rdata),   ...


Error-[UPIMI-E] Undefined port in module instantiation
/tmp/dut/hvl/top_tb.sv, 24
  Port "bmem_wdata" is not defined in module 'mp4' defined in 
  "/tmp/dut/hdl/mp4.sv", 1
  Module instance: mp4 dut( .clk (clk),  .rst (rst),  .bmem_address 
  (bmem_itf.addr),  .bmem_read (bmem_itf.read),  .bmem_write (bmem_itf.write),
  .bmem_rdata (bmem_itf.rdata),   ...


Error-[UPIMI-E] Undefined port in module instantiation
/tmp/dut/hvl/top_tb.sv, 24
  Port "bmem_resp" is not defined in module 'mp4' defined in 
  "/tmp/dut/hdl/mp4.sv", 1
  Module instance: mp4 dut( .clk (clk),  .rst (rst),  .bmem_address 
  (bmem_itf.addr),  .bmem_read (bmem_itf.read),  .bmem_write (bmem_itf.write),
  .bmem_rdata (bmem_itf.rdata),   ...

6 errors
CPU time: .550 seconds to compile
make: *** [Makefile:16: sim/top_tb] Error 255
 
 ``` 

 </details> 
