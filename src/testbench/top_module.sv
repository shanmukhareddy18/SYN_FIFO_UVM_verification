`include "fifo_pkg.sv"
`include "syn_fifo.sv"
`include "interface.sv"
module top_module;
 import uvm_pkg::*; 
import fifo_pkg::*;
bit clk;
 bit reset;
  inf vif(clk,reset);
 syn_fifo dut(.clk(clk),.rst(reset),.wr_cs(vif.wr_cs),.wr_en(vif.wr_en),.rd_cs(vif.rd_cs),.rd_en(vif.rd_en),.data_in(vif.data_in),.data_out(vif.data_out),.full(vif.full),.empty(vif.empty));
   always #5 clk=~clk;
 initial begin
  reset=1;
  repeat(3) @(posedge clk);
  reset=0;
   //repeat(5) @(posedge clk);
 // reset=1;
 // repeat(1) @(posedge clk);
 // reset=0;
 end
 initial begin
 uvm_config_db #(virtual inf)::set(null ,"*","vif",vif);
  run_test("test");
 end

endmodule
