//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlst_agent.svh> is a part of <Verification> project
//  Copyright (C) 2015  An Pham (anphambk@gmail.com)
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

`ifndef __AVLST_AGENT_SVH__
`define __AVLST_AGENT_SVH__

//------------------------------------------------------------------------------
// CLASS: avlst_agent
//
// Agent for avlst protocol
//------------------------------------------------------------------------------
class avlst_agent extends uvm_agent;
  //--- attributes ---
  
  // object: _config
  // Configuration object for this agent
  avlst_config _config;
  
  // object: _adapter
  // Adapter to lower protocols
  avlst_adapter _adapter;
  
  //--- TLM ports/exports ---
  // object: put_export
  // Blocking put export to one upper layer. If you want to connect to multiple
  // upper layers, please define a new TLM type.
  uvm_blocking_put_imp #(avlst_transaction, avlst_agent) put_export;
  
  // object: analysis_port
  // Analysis port to upper layers
  uvm_analysis_port #(avlst_transaction) analysis_port;
  
  //--- children ---
  protected avlst_driver driver;   // user should not access to driver directly
  protected avlst_monitor monitor; // user should not access to monitor directly
  
  // object: sequencer
  // UVM sequencer for <avlst_transaction> type
  avlst_sequencer sequencer;
  
  //--- factory registration ---
  `uvm_component_utils(avlst_agent)
  
  //--- methods ---
  extern function new(string name="avlst_agent", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task put(avlst_transaction t);
endclass : avlst_agent

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function avlst_agent::new(string name="avlst_agent", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void avlst_agent::build_phase(uvm_phase phase);
  // Get configurations
  if(_config == null) begin
    if(!uvm_config_db #(avlst_config)::get(this, "", "_config", _config)) begin
      `uvm_warning(get_full_name(), "Configuration object is not set to this agent, creating one with default fields.")
      _config = avlst_config::type_id::create("_config");
    end
  end
  if(_adapter == null) begin
    if(!uvm_config_db #(avlst_adapter)::get(this, "", "_adapter", _adapter)) begin
      `uvm_fatal(get_full_name(), "Adapter is not assigned to this agent.")
    end
  end
  // Start building
  if(_config.is_active == UVM_ACTIVE) begin
    sequencer = avlst_sequencer::type_id::create("sequencer", this);
    driver = avlst_driver::type_id::create("driver", this);
  end
  if(_config.has_monitor == 1'b1) begin
    monitor = avlst_monitor::type_id::create("monitor", this);
  end
  if(_config.has_upper_layer == 1'b1) begin
    put_export = new("put_export", this);
  end
  analysis_port = new("analysis_port", this);
  super.build_phase(phase);
  // Set configurations
  if(_config.is_active == UVM_ACTIVE) begin
    uvm_config_db #(avlst_config)::set(this, "sequencer", "_config", _config);
    uvm_config_db #(avlst_config)::set(this, "driver", "_config", _config);
    uvm_config_db #(avlst_adapter)::set(this, "driver", "_adapter", _adapter);
  end
  if(_config.has_monitor == 1'b1) begin
    uvm_config_db #(avlst_config)::set(this, "monitor", "_config", _config);
    uvm_config_db #(avlst_adapter)::set(this, "monitor", "_adapter", _adapter);
  end
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void avlst_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(_config.is_active == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
  if(_config.has_monitor == 1'b1) begin
    monitor.analysis_port.connect(analysis_port);
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
// +Method: put
//------------------------------------------------------------------------------
task avlst_agent::put(avlst_transaction t);
  sequencer.execute_item(t);
endtask : put

`endif /* __AVLST_AGENT_SVH__ */
