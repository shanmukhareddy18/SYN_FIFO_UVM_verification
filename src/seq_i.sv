`include "uvm_macros.svh"
import uvm_pkg::*;
`include "defines.svh"
class seq_item extends uvm_sequence_item;
`uvm_object_utils(seq_item)
function new(string name="seq_item");
 super.new(name);
endfunction

rand logic wr_cs;
rand logic rd_cs;
rand logic wr_en;
rand logic rd_en;
rand logic [`DW  -1:0]data_in;
logic [`DW -1:0]data_out;
logic full;
logic empty;
bit reset;

endclass


