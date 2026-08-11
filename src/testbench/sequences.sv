class sequence1 extends uvm_sequence#(seq_item);
 `uvm_object_utils(sequence1)
 function new(string name="sequence1");
 super.new(name);
endfunction

task body();
 repeat(10) begin
 req=seq_item::type_id::create("req");
 start_item(req);
 if(!(req.randomize() with { wr_cs==1; wr_en==1;rd_cs==0;rd_en==0; }))
    `uvm_fatal("RAND","Randomization failed") 
finish_item(req);end
endtask

endclass

class sequence2 extends uvm_sequence#(seq_item);
 `uvm_object_utils(sequence2)
 function new(string name="sequence2");
 super.new(name);
endfunction

task body();
 repeat(10) begin
 req=seq_item::type_id::create("req");
 start_item(req);
 assert(req.randomize() with { rd_cs==1; rd_en==1;wr_cs==0;wr_en==0; });
 finish_item(req);end
endtask

endclass

class sequence3 extends uvm_sequence #(seq_item);
 `uvm_object_utils(sequence3)
 function new(string name="sequence3");
 super.new(name);
endfunction

task body();
 repeat(10) begin
 req=seq_item::type_id::create("req");
 start_item(req);
 assert(req.randomize() with { wr_cs==1; wr_en==1;rd_cs==1; rd_en==1; });
 finish_item(req);end
endtask

endclass

class sequence4 extends uvm_sequence #(seq_item);
 `uvm_object_utils(sequence4)
 function new(string name="sequence4");
 super.new(name);
endfunction

task body();
 repeat(50) begin
 req=seq_item::type_id::create("req");
 start_item(req);
 assert(req.randomize() with { wr_cs==0; wr_en==0; });
 finish_item(req);end
endtask

endclass

