
//------------------------------------------------------------------------------
// CLASS: tb_env
//------------------------------------------------------------------------------
class tb_env extends uvm_env;
  //--- children ---
  avlmm_agent master_agent;
  avlst_video_env background_env;
  avlst_video_env foreground_env;
  avlst_video_env alpha_env;
  avlst_video_env sink_env;
  scb_txrx_fifo #(video_transaction) scoreboard;
  
  //--- local variables ---
  
  //--- factory registration ---
  `uvm_component_utils(tb_env)
  
  //--- methods ---
  extern function new(string name="tb_env", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
endclass : tb_env

//------------------------------------------------------------------------------
// Constructor: new
//------------------------------------------------------------------------------
function tb_env::new(string name="tb_env", uvm_component parent=null);
  super.new(name,parent);
endfunction : new

//------------------------------------------------------------------------------
// Function: build_phase
//------------------------------------------------------------------------------
function void tb_env::build_phase(uvm_phase phase);
  master_agent = avlmm_agent::type_id::create("master_agent", this);
  background_env = avlst_video_env::type_id::create("background_env", this);
  foreground_env = avlst_video_env::type_id::create("foreground_env", this);
  alpha_env = avlst_video_env::type_id::create("alpha_env", this);
  sink_env = avlst_video_env::type_id::create("sink_env", this);
  scoreboard = scb_txrx_fifo #(video_transaction)::type_id::create("scoreboard", this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// Function: connect_phase
//------------------------------------------------------------------------------
function void tb_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  background_env.analysis_port.connect(scoreboard.tx_export[0]);
  sink_env.analysis_port.connect(scoreboard.rx_export[0]);
endfunction : connect_phase

//------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
//------------------------------------------------------------------------------
function void tb_env::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  print();
endfunction : end_of_elaboration_phase
