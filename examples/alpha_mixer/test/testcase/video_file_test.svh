
//------------------------------------------------------------------------------
// Class: video_file_test
//------------------------------------------------------------------------------
class video_file_test extends base_test;
  //--- properties ---
  avlmm_config master_config;
  avlst_video_env_config alpha_config;
  avlst_video_env_config background_config;
  avlst_video_env_config foreground_config;
  avlst_video_env_config sink_config;
  
  //--- factory registration ---
  `uvm_component_utils(video_file_test)
  
  //--- methods ---
  extern function new(string name="uvm_test", uvm_component parent=null);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void create_config();
  extern virtual function void set_config();
endclass

//------------------------------------------------------------------------------
// Constructor: new
//------------------------------------------------------------------------------
function video_file_test::new(string name="uvm_test", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// Method: run_phase
//------------------------------------------------------------------------------
task video_file_test::run_phase(uvm_phase phase);
  dut_config_sequence master_seq;
  video_file_sequence background_seq;
  video_file_sequence foreground_seq;
  video_file_sequence alpha_seq;
  avlst_sequence      sink_seq;
  
  phase.raise_objection(this);
  $display("STH");
  master_seq = dut_config_sequence::type_id::create("master_seq");
  background_seq = video_file_sequence::type_id::create("background_seq");
  foreground_seq = video_file_sequence::type_id::create("foreground_seq");
  alpha_seq = video_file_sequence::type_id::create("alpha_seq");
  sink_seq = avlst_sequence::type_id::create("sink_seq");
  
  //--- config ---
  master_seq.start(env.master_agent.sequencer);
  fork
    //--- source ---
    fork
      background_seq.start(env.background_env.video.sequencer);
      foreground_seq.start(env.foreground_env.video.sequencer);
      alpha_seq.start(env.alpha_env.video.sequencer);
    join
    //--- sink ---
    forever begin
      sink_seq.start(env.sink_env.avlst.sequencer);
    end
  join_any
  #20ns; // delay from BFMs
  phase.drop_objection(this);
endtask : run_phase

//------------------------------------------------------------------------------
// Function: create_config
//------------------------------------------------------------------------------
function void video_file_test::create_config();
  a2e #(uvm_active_passive_enum) a2e_uvm_active_passive = new();

  //! Create
  master_config = avlmm_config::type_id::create("master_config");
  background_config = avlst_video_env_config::type_id::create("background_config");
  foreground_config = avlst_video_env_config::type_id::create("foreground_config");
  alpha_config = avlst_video_env_config::type_id::create("alpha_config");
  sink_config = avlst_video_env_config::type_id::create("sink_config");
  
  //! Config
  //
  master_config.is_active = UVM_ACTIVE;
  //
  background_config.avlst.is_active = UVM_ACTIVE;
  background_config.avlst.idle_probability = sknobs::get_value({get_full_name(), ".background_idle"}, 0);
  background_config.packet.is_active = UVM_ACTIVE;
  background_config.packet.bits_per_symbol = 8;
  background_config.packet.symbols_per_beat = 3;
  background_config.video.is_active = UVM_ACTIVE;
  background_config.video.read_config(sknobs::get_string({get_full_name(), ".background"}, "background"));
  //
  foreground_config.copy(background_config);
  foreground_config.avlst.idle_probability = sknobs::get_value({get_full_name(), ".foreground_idle"}, 0);
  foreground_config.video.read_config(sknobs::get_string({get_full_name(), ".foreground"}, "foreground"));
  //
  alpha_config.copy(background_config);
  alpha_config.avlst.idle_probability = sknobs::get_value({get_full_name(), ".alpha_idle"}, 0);
  alpha_config.packet.symbols_per_beat = 1;
  alpha_config.video.read_config(sknobs::get_string({get_full_name(), ".alpha"}, "alpha"));
  alpha_config.video.channels_per_pixel = 1;
  //
  sink_config.copy(background_config);
  sink_config.avlst.idle_probability = sknobs::get_value({get_full_name(), ".sink_idle"}, 0);
  sink_config.video.record_active = a2e_uvm_active_passive.convert(sknobs::get_string({get_full_name(), ".record"}, "UVM_ACTIVE"));
  sink_config.video.record_name = sknobs::get_string({get_full_name(), ".sink"}, "sink");
  //! Print
  background_config.print();
  foreground_config.print();
  alpha_config.print();
  sink_config.print();
endfunction : create_config

//------------------------------------------------------------------------------
// Function: set_config
//------------------------------------------------------------------------------
function void video_file_test::set_config();
  uvm_config_db #(avlmm_config)::set(this, "env.master_agent", "_config", master_config);
  uvm_config_db #(avlst_video_env_config)::set(this, "env.background_env", "_config", background_config);
  uvm_config_db #(avlst_video_env_config)::set(this, "env.foreground_env", "_config", foreground_config);
  uvm_config_db #(avlst_video_env_config)::set(this, "env.alpha_env", "_config", alpha_config);
  uvm_config_db #(avlst_video_env_config)::set(this, "env.sink_env", "_config", sink_config);
endfunction : set_config
