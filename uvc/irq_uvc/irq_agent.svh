//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <irq_agent.svh> is a part of <Verification> project
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

`ifndef __IRQ_AGENT_SVH__
`define __IRQ_AGENT_SVH__

//------------------------------------------------------------------------------
// CLASS: irq_agent
//
// Agent for irq protocol
//------------------------------------------------------------------------------
class irq_agent extends uvm_agent;
  //--- attributes ---
  
  // object: _config
  // Configuration object for this agent
  irq_config _config;
  
  // object: _vif
  // Virtual interface for this protocol
  virtual irq_if _vif;
  
  //--- TLM ports/exports ---
  
  // object: put_export
  // Blocking put export to one upper layer. If you want to connect to multiple
  // upper layers, please define a new TLM type.
  uvm_blocking_put_imp #(irq_transaction, irq_agent) put_export;
  
  // object: analysis_port
  // Analysis port to upper layers
  uvm_analysis_port #(irq_transaction) analysis_port;
  
  //--- children ---
  protected irq_driver driver;   // user should not access to driver directly
  protected irq_monitor monitor; // user should not access to monitor directly
  
  // object: sequencer
  // UVM sequencer for <irq_transaction> type
  irq_sequencer sequencer;
  
  //--- factory registration ---
  `uvm_component_utils(irq_agent)
  
  //--- methods ---
  extern function new(string name="irq_agent", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task put(irq_transaction t);
endclass : irq_agent

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function irq_agent::new(string name="irq_agent", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void irq_agent::build_phase(uvm_phase phase);
  // Get configurations
  if(_config == null) begin
    if(!uvm_config_db #(irq_config)::get(this, "", "_config", _config)) begin
      `uvm_warning(get_full_name(), "Configuration object is not set to this agent, creating one with default fields.")
      _config = irq_config::type_id::create("_config");
    end
  end
  if(_vif == null) begin
    if(!uvm_config_db #(virtual irq_if)::get(this, "", "_vif", _vif)) begin
      `uvm_fatal(get_full_name(), "Virtual interface is not assigned to this agent.")
    end
  end
  // Start building
  if(_config.is_active == UVM_ACTIVE) begin
    sequencer = irq_sequencer::type_id::create("sequencer", this);
    driver = irq_driver::type_id::create("driver", this);
  end
  if(_config.has_monitor == 1'b1) begin
    monitor = irq_monitor::type_id::create("monitor", this);
  end
  if(_config.has_upper_layer == 1'b1) begin
    put_export = new("put_export", this);
  end
  analysis_port = new("analysis_port", this);
  super.build_phase(phase);
  // Set configurations
  if(_config.is_active == UVM_ACTIVE) begin
    uvm_config_db #(irq_config)::set(this, "sequencer", "_config", _config);
    uvm_config_db #(irq_config)::set(this, "driver", "_config", _config);
    uvm_config_db #(virtual irq_if)::set(this, "driver", "_vif", _vif);
  end
  if(_config.has_monitor == 1'b1) begin
    uvm_config_db #(irq_config)::set(this, "monitor", "_config", _config);
    uvm_config_db #(virtual irq_if)::set(this, "monitor", "_vif", _vif);
  end
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void irq_agent::connect_phase(uvm_phase phase);
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
task irq_agent::put(irq_transaction t);
  sequencer.execute_item(t);
endtask : put

`endif /* __IRQ_AGENT_SVH__ */
