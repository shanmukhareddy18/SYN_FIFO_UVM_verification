`include "defines.svh"
interface inf(input clk,input reset);
logic wr_cs,rd_cs,wr_en,rd_en,full,empty;
logic [`DW -1:0]data_in,data_out;

clocking drv_cb @(posedge clk);
default input #1 output #1; 
 output wr_cs,rd_cs,wr_en,rd_en,data_in;
endclocking

clocking out_mon_cb @(posedge clk);
default input #1 output #1; 
 input data_out,full,empty;
endclocking  

clocking inp_mon_cb @(posedge clk);
default input #1 output #1; 
input reset,wr_cs,rd_cs,wr_en,rd_en,data_in;
endclocking

modport DRV(clocking drv_cb);
modport INP_MON(clocking inp_mon_cb);
modport OUT_MON(clocking out_mon_cb);

endinterface
