//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <packet_agent.svh> is a part of <Verification> project
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

`ifndef __PACKET_AGENT_SVH__
`define __PACKET_AGENT_SVH__

//------------------------------------------------------------------------------
// CLASS: packet_agent
//
// Agent for packet protocol
//------------------------------------------------------------------------------
class packet_agent extends uvm_agent;
  //--- attributes ---
  
  // object: _config
  // Configuration object for this agent
  packet_config _config;
  
  //--- TLM ports/exports ---
  
  // object: put_export
  // Blocking put export to one upper layer. If you want to connect to multiple
  // upper layers, please define a new TLM type.
  uvm_blocking_put_imp #(packet_transaction, packet_agent) put_export;
  
  // object: analysis_port
  // Analysis port to upper layers
  uvm_analysis_port #(packet_transaction) analysis_port;
  
  // object: put_port
  // Blocking put port to a lower layer. If you want to connect to multiple
  // lower layers, please define a new TLM type.
  uvm_blocking_put_port #(packet_transaction) put_port;
  
  // object: analysis_export
  // Analysis export to lower layers
  uvm_analysis_export #(packet_transaction) analysis_export;
  
  //--- children ---
  protected packet_driver driver;   // user should not access to driver directly
  protected packet_monitor monitor; // user should not access to monitor directly
  
  // object: sequencer
  // UVM sequencer for <packet_transaction> type
  packet_sequencer sequencer;
  
  //--- factory registration ---
  `uvm_component_utils(packet_agent)
  
  //--- methods ---
  extern function new(string name="packet_agent", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task put(packet_transaction t);
endclass : packet_agent

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function packet_agent::new(string name="packet_agent", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void packet_agent::build_phase(uvm_phase phase);
  // Get configurations
  if(_config == null) begin
    if(!uvm_config_db #(packet_config)::get(this, "", "_config", _config)) begin
      `uvm_warning(get_full_name(), "Configuration object is not set to this agent, creating one with default fields.")
      _config = packet_config::type_id::create("_config");
    end
  end
  // Start building
  if(_config.is_active == UVM_ACTIVE) begin
    sequencer = packet_sequencer::type_id::create("sequencer", this);
    driver = packet_driver::type_id::create("driver", this);
    put_port = new("put_port", this);
  end
  if(_config.has_monitor == 1'b1) begin
    monitor = packet_monitor::type_id::create("monitor", this);
    analysis_export = new("analysis_export", this);
  end
  if(_config.has_upper_layer == 1'b1) begin
    put_export = new("put_export", this);
  end
  analysis_port = new("analysis_port", this);
  super.build_phase(phase);
  // Set configurations
  if(_config.is_active == UVM_ACTIVE) begin
    uvm_config_db #(packet_config)::set(this, "sequencer", "_config", _config);
    uvm_config_db #(packet_config)::set(this, "driver", "_config", _config);
  end
  if(_config.has_monitor == 1'b1) begin
    uvm_config_db #(packet_config)::set(this, "monitor", "_config", _config);
  end
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void packet_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(_config.is_active == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
    driver.put_port.connect(put_port);
  end
  if(_config.has_monitor == 1'b1) begin
    analysis_export.connect(monitor.analysis_export);
    monitor.analysis_port.connect(analysis_port);
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
// +Method: put
//------------------------------------------------------------------------------
task packet_agent::put(packet_transaction t);
  sequencer.execute_item(t);
endtask : put

`endif /* __PACKET_AGENT_SVH__ */
