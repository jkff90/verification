
`ifndef __BASE_TEST_SVH__
`define __BASE_TEST_SVH__

//------------------------------------------------------------------------------
// Class: video_file_test
//------------------------------------------------------------------------------
virtual class base_test extends uvm_test;
  // obj: env
  // test environment
  tb_env env;
    
  // obj: backdoor
  // Backdoor interface
  virtual backdoor_if backdoor;
  
  //--- local variables ---
  protected int mcd;
  protected bit is_grp_test;
  
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
  is_grp_test = $test$plusargs("testgrp");
  create_config();
  env = tb_env::type_id::create("env", this);
  assert(uvm_config_db #(virtual backdoor_if)::get(this, "broadcast", "backdoor", backdoor));
  set_config();
endfunction : build_phase

//------------------------------------------------------------------------------
// Function: start_of_simulation_phase
//------------------------------------------------------------------------------
function void base_test::start_of_simulation_phase(uvm_phase phase);
  uvm_coreservice_t cs;
  uvm_root root;
  uvm_report_server rsvr;
  uvm_factory factory;
  bit display;
  string test_log;

  cs = uvm_coreservice_t::get();
  root = cs.get_root(); // uvm_root::get();
  rsvr = cs.get_report_server(); // uvm_report_server::get_server();
  factory = cs.get_factory(); // uvm_factory::get();
  root.set_timeout(10ms);
  rsvr.set_max_quit_count(10);
  factory.print();
  check_config_usage();
  //
  if (!is_grp_test) begin
    if ($test$plusargs("display")) begin
      display = 1;
    end
    else begin
      display = sknobs::get_value("display", 0);
    end
    if (!$value$plusargs("+test_log=%s", test_log)) test_log = get_name();
    mcd = $fopen({test_log, ".log"}, "w");
    set_report_default_file_hier(mcd);
    set_report_severity_action_hier(UVM_INFO, UVM_LOG | display); // only print to log file
    set_report_severity_action_hier(UVM_WARNING, UVM_DISPLAY | UVM_LOG);
    set_report_severity_action_hier(UVM_ERROR, UVM_DISPLAY | UVM_LOG | UVM_COUNT);
    set_report_severity_action_hier(UVM_FATAL, UVM_DISPLAY | UVM_LOG | UVM_EXIT);
    env.scb.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_LOG);
  end
endfunction : start_of_simulation_phase

//------------------------------------------------------------------------------
// +Function: final_phase
//------------------------------------------------------------------------------
function void base_test::final_phase(uvm_phase phase);
  if (!is_grp_test) begin
    $fclose(mcd);
  end
endfunction : final_phase

`endif /* __BASE_TEST_SVH__ */
