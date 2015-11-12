//------------------------------------------------------------------------------
// Class: dut_config_sequence
//------------------------------------------------------------------------------
class dut_config_sequence extends uvm_sequence #(avlmm_transaction);
  //--- properties ---
  
  //--- factory registration ---
  `uvm_object_utils(dut_config_sequence)
  `uvm_declare_p_sequencer(avlmm_sequencer)
  
  //--- methods ---
  extern function new(string name="dut_config_sequence");
  extern virtual task body();
endclass : dut_config_sequence

//------------------------------------------------------------------------------
// Constructor: new
//------------------------------------------------------------------------------
function dut_config_sequence::new(string name="dut_config_sequence");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// Method: body
//------------------------------------------------------------------------------
task dut_config_sequence::body();
  req = avlmm_transaction::type_id::create("req");
  req.data = new[1];
  //--- set foreground X ---
  start_item(req);
  req.address = 2;
  req.data[0] = 40;
  req.request = AVLMM_WRITE_REQUEST;
  finish_item(req);
  //--- set foreground Y ---
  start_item(req);
  req.address = 3;
  req.data[0] = 40;
  req.request = AVLMM_WRITE_REQUEST;
  finish_item(req);
  //--- enable foreground ---
  start_item(req);
  req.address = 4;
  req.data[0] = 1;
  req.request = AVLMM_WRITE_REQUEST;
  finish_item(req);
  //--- set go & read status ---
  do begin
    start_item(req);
    req.address = 0;
    req.data[0] = 1;
    req.request = AVLMM_WRITE_REQUEST;
    finish_item(req);
    start_item(req);
    req.address = 1;
    req.data[0] = 0;
    req.request = AVLMM_READ_REQUEST;
    finish_item(req);
  end while(req.data[0] != 32'h1);
endtask : body
