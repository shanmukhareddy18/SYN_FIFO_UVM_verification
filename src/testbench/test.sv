class test extends uvm_test;
`uvm_component_utils(test)
function new(string name="test",uvm_component parent);
 super.new(name,parent);
endfunction

env ee;

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 ee=env::type_id::create("ee",this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
 super.end_of_elaboration_phase(phase);
 uvm_top.print_topology();
endfunction

sequence1 s1;
sequence2 s2;
sequence3 s3;
sequence4 s4;

task run_phase(uvm_phase phase);
 phase.raise_objection(this);
 s1=sequence1::type_id::create("s1");
 s2=sequence2::type_id::create("s2");
 s3=sequence3::type_id::create("s3");
 s4=sequence4::type_id::create("s4");
s1.start(ee.agnt_a.seqr);
// s2.start(ee.agnt_a.seqr);
 //s1.start(ee.agnt_a.seqr);
 //s2.start(ee.agnt_a.seqr);
s3.start(ee.agnt_a.seqr);
s1.start(ee.agnt_a.seqr);
s3.start(ee.agnt_a.seqr);
// s4.start(ee.agnt_a.seqr);
phase.drop_objection(this);
endtask

endclass
