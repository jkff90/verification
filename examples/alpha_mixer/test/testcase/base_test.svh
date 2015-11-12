
//------------------------------------------------------------------------------
// Class: video_file_test
//------------------------------------------------------------------------------
virtual class base_test extends uvm_test;
  // obj: env
  // test environment
  tb_env env;
  
  //--- local variables ---
  
  //--- factory registration ---
  
  //--- methods ---
  extern function new(string name="uvm_test", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  pure virtual function void create_config();
  pure virtual function void set_config();
endclass

//------------------------------------------------------------------------------
// Constructor: new
//------------------------------------------------------------------------------
function base_test::new(string name="uvm_test", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// Function: build_phase
//------------------------------------------------------------------------------
function void base_test::build_phase(uvm_phase phase);
  create_config();
  env = tb_env::type_id::create("env", this);
  super.build_phase(phase);
  set_config();
endfunction : build_phase

//------------------------------------------------------------------------------
// Function: start_of_simulation_phase
//------------------------------------------------------------------------------
function void base_test::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
  factory.print();
endfunction : start_of_simulation_phase
