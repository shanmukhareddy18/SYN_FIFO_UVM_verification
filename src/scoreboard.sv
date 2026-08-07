class scoreboard extends uvm_scoreboard;
 `uvm_component_utils(scoreboard)
	uvm_tlm_analysis_fifo #(seq_item)inp_mon_fifo;
	uvm_tlm_analysis_fifo #(seq_item)out_mon_fifo;

	seq_item inp_mon_tx;
	seq_item inp_mon_hold;
	seq_item out_mon_tx;

 function new(string name="scoreboard",uvm_component parent);
	super.new(name,parent);
	inp_mon_fifo=new("inp_mon_fifo",this);
	out_mon_fifo=new("out_mon_fifo",this);
 endfunction
bit x=0;
task run_phase(uvm_phase phase);
forever begin
 out_mon_fifo.get(out_mon_tx);
 inp_mon_fifo.get(inp_mon_tx);
  
     `uvm_info("SCB INP_MON_TX",$sformatf("reset=%b, wr_cs=%b, wr_en=%b, rd_cs=%b, rd_en=%b, data_in=%d ",
          inp_mon_tx.reset, inp_mon_tx.wr_cs, inp_mon_tx.wr_en,  inp_mon_tx.rd_cs,  inp_mon_tx.rd_en,  inp_mon_tx.data_in),UVM_LOW)
  `uvm_info("SCB OUT_MON_TX", $sformatf("data_out:%d | full:%b | empty:%0b ",
      out_mon_tx.data_out, out_mon_tx.full, out_mon_tx.empty), UVM_NONE)
if(inp_mon_tx.reset)
 begin
  reference(inp_mon_tx);
  compare();
  inp_mon_hold=inp_mon_tx;
 end 
if(x==0)
   begin
    x=1;
    inp_mon_hold=inp_mon_tx;
   end
else
 begin
   reference(inp_mon_hold);
   compare();
  inp_mon_hold=inp_mon_tx;
 end
end
endtask

function void extract_phase(uvm_phase phase);
 super.extract_phase(phase);
`uvm_info("SCB",
        $sformatf("PASS=%0d FAIL=%0d", pass_count, fail_count),
        UVM_NONE)
endfunction
reg [`DW -1:0] fifo [(1<< `AW) -1:0];
bit full,empty;
int status_count=0;
bit [`DW -1:0] data_out;
bit [`AW -1:0] rd_p,wr_p;
int pass_count=0;
int fail_count=0;
task reference(seq_item tr);

     `uvm_info("SCB INP_MON_HOLD",$sformatf("reset=%b, wr_cs=%b, wr_en=%b, rd_cs=%b, rd_en=%b, data_in=%d ",
          tr.reset,tr.wr_cs, tr.wr_en,  tr.rd_cs, tr.rd_en,  tr.data_in),UVM_LOW)

 if(tr.reset)
  begin
   status_count=0;data_out=0;
   rd_p=0; wr_p=0;full=0; empty=1;
 end
 else
  begin
 if(tr.wr_en && tr.wr_cs && !full)
  begin
    fifo[wr_p]=tr.data_in;
    status_count++;
    wr_p++;
  end
 if(tr.rd_cs && tr.rd_en && !empty)
  begin
   data_out=fifo[rd_p];
   status_count--;
   rd_p++;
  end

 if(status_count==0)
     empty=1;
 else if(status_count== (1<<`AW))
     full=1;
  else
    begin empty=0; full=0; end
 end
`uvm_info("SCB EXP", $sformatf("data_out:%d | full:%b | empty:%0b | status_cnt=%d ",data_out, full, empty,status_count), UVM_NONE)

endtask

task compare();
 if(out_mon_tx.data_out==data_out && out_mon_tx.full==full && out_mon_tx.empty==empty)
  begin
   `uvm_info("SCB","PASS",UVM_NONE)
   pass_count++;
  
   `uvm_info("SCB",$sformatf("SUCCESS_CNT=%d",pass_count),UVM_NONE)
  end
 else
  begin 
   `uvm_info("SCB","FAIL",UVM_NONE)
   `uvm_info("SCB",$sformatf("FAIL_CNT=%d",fail_count),UVM_NONE)
  fail_count++; 
 end
endtask
endclass
