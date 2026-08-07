class driver extends uvm_driver #(seq_item);
 `uvm_component_utils(driver)
 virtual inf.DRV vif;
function new(string name="driver",uvm_component parent);
 super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 if(!uvm_config_db #(virtual inf)::get(this,"","vif",vif))
   `uvm_fatal(get_type_name(),"Driver failed")
endfunction
task  run_phase(uvm_phase phase);
 begin
 repeat(2)@(vif.drv_cb);
        forever begin
	  seq_item_port.get_next_item(req);
 	 drive(req);
  	seq_item_port.item_done();
   end
 end
endtask
task drive(seq_item trans);
 begin
     @(vif.drv_cb);
       `uvm_info("DRV",$sformatf("------------------------------------------------------------------------------"),UVM_NONE)

     `uvm_info("DRV",$sformatf("wr_cs=%b, wr_en=%b, rd_cs=%b, rd_en=%b, data_in=%d ",
          trans.wr_cs, trans.wr_en, trans.rd_cs, trans.rd_en, trans.data_in),UVM_NONE)
	
  	    vif.drv_cb.wr_cs        <= trans.wr_cs;
	    vif.drv_cb.wr_en        <= trans.wr_en;
	    vif.drv_cb.rd_cs        <= trans.rd_cs;
	    vif.drv_cb.rd_en        <= trans.rd_en;
            vif.drv_cb.data_in      <= trans.data_in;
            
  end
endtask
endclass
