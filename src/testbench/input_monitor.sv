class input_monitor extends uvm_monitor;
 `uvm_component_utils(input_monitor)
 virtual inf.INP_MON vif;
  uvm_analysis_port#(seq_item) inp_ap;
 seq_item trans;
function new(string name="input_monitor",uvm_component parent);
  super.new(name,parent);
 endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 inp_ap=new("inp_ap",this);
 if(!uvm_config_db #(virtual inf)::get(this,"","vif",vif))
    `uvm_fatal(get_type_name(),"Monitor failed")
endfunction

task run_phase(uvm_phase phase);
begin
 

forever begin
         @(vif.inp_mon_cb);
trans=seq_item::type_id::create("trans");
            trans.wr_cs        = vif.inp_mon_cb.wr_cs;
            trans.wr_en       = vif.inp_mon_cb.wr_en;
            trans.rd_en       = vif.inp_mon_cb.rd_en;
            trans.rd_cs       = vif.inp_mon_cb.rd_cs;
            trans.data_in      = vif.inp_mon_cb.data_in;
            trans.reset= vif.inp_mon_cb.reset; 
         `uvm_info("INP_MON",$sformatf("reset=%b, wr_cs=%b, wr_en=%b, rd_cs=%b, rd_en=%b, data_in=%d ",
          trans.reset, trans.wr_cs, trans.wr_en, trans.rd_cs, trans.rd_en, trans.data_in),UVM_LOW)
  
       inp_ap.write(trans);
       end

end
endtask
endclass

