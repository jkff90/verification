//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <wishbone_agent.svh> is a part of <Verification> project
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

`ifndef __WISHBONE_AGENT_SVH__
`define __WISHBONE_AGENT_SVH__

//------------------------------------------------------------------------------
// CLASS: wishbone_agent
//
// Agent for wishbone protocol
//------------------------------------------------------------------------------
class wishbone_agent extends uvm_agent;
  //--- attributes ---
  
  // object: _config
  // Configuration object for this agent
  wishbone_config _config;
  
  // object: _adapter
  // Adapter to lower protocols
  wishbone_adapter _adapter;
  
  //--- TLM ports/exports ---
  // object: put_export
  // Blocking put export to one upper layer. If you want to connect to multiple
  // upper layers, please define a new TLM type.
  uvm_blocking_put_imp #(wishbone_transaction, wishbone_agent) put_export;
  
  // object: analysis_port
  // Analysis port to upper layers
  uvm_analysis_port #(wishbone_transaction) analysis_port;
  
  //--- children ---
  protected wishbone_driver driver;   // user should not access to driver directly
  protected wishbone_monitor monitor; // user should not access to monitor directly
  
  // object: sequencer
  // UVM sequencer for <wishbone_transaction> type
  wishbone_sequencer sequencer;
  
  //--- factory registration ---
  `uvm_component_utils(wishbone_agent)
  
  //--- methods ---
  extern function new(string name="wishbone_agent", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task put(wishbone_transaction t);
endclass : wishbone_agent

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function wishbone_agent::new(string name="wishbone_agent", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void wishbone_agent::build_phase(uvm_phase phase);
  // Get configurations
  if(_config == null) begin
    if(!uvm_config_db #(wishbone_config)::get(this, "", "_config", _config)) begin
      `uvm_warning(get_full_name(), "Configuration object is not set to this agent, creating one with default fields.")
      _config = wishbone_config::type_id::create("_config");
    end
  end
  if(_adapter == null) begin
    if(!uvm_config_db #(wishbone_adapter)::get(this, "", "_adapter", _adapter)) begin
      `uvm_fatal(get_full_name(), "Adapter is not assigned to this agent.")
    end
  end
  // Start building
  if(_config.is_active == UVM_ACTIVE) begin
    sequencer = wishbone_sequencer::type_id::create("sequencer", this);
    driver = wishbone_driver::type_id::create("driver", this);
  end
  if(_config.has_monitor == 1'b1) begin
    monitor = wishbone_monitor::type_id::create("monitor", this);
  end
  if(_config.has_upper_layer == 1'b1) begin
    put_export = new("put_export", this);
  end
  analysis_port = new("analysis_port", this);
  super.build_phase(phase);
  // Set configurations
  if(_config.is_active == UVM_ACTIVE) begin
    uvm_config_db #(wishbone_config)::set(this, "sequencer", "_config", _config);
    uvm_config_db #(wishbone_config)::set(this, "driver", "_config", _config);
    uvm_config_db #(wishbone_adapter)::set(this, "driver", "_adapter", _adapter);
  end
  if(_config.has_monitor == 1'b1) begin
    uvm_config_db #(wishbone_config)::set(this, "monitor", "_config", _config);
    uvm_config_db #(wishbone_adapter)::set(this, "monitor", "_adapter", _adapter);
  end
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void wishbone_agent::connect_phase(uvm_phase phase);
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
task wishbone_agent::put(wishbone_transaction t);
  sequencer.execute_item(t);
endtask : put

`endif /* __WISHBONE_AGENT_SVH__ */
