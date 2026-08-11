class output_monitor extends uvm_monitor;
 `uvm_component_utils(output_monitor)
 virtual inf.OUT_MON vif;
  uvm_analysis_port#(seq_item) out_ap;
 seq_item tr;
function new(string name="output_monitor",uvm_component parent);
  super.new(name,parent);
 endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 out_ap=new("out_ap",this);
 if(!uvm_config_db #(virtual inf)::get(this,"","vif",vif))
    `uvm_fatal(get_type_name(),"Monitor failed")
endfunction

task run_phase(uvm_phase phase);
begin
 forever begin
	  @(vif.out_mon_cb);
 tr=seq_item::type_id::create("tr");
	tr.data_out=vif.out_mon_cb.data_out;
	tr.full=vif.out_mon_cb.full;
        tr.empty=vif.out_mon_cb.empty;
        
`uvm_info("OUT_MON", $sformatf(
      "DUT Outputs -> data_out:%d | full:%b | empty:%0b ",
      tr.data_out, tr.full, tr.empty), UVM_NONE)
        out_ap.write(tr);
       end

end
endtask

endclass 

