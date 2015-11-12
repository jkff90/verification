//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <i2c_agent.svh> is a part of <Verification> project
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

`ifndef __I2C_AGENT_SVH__
`define __I2C_AGENT_SVH__

//------------------------------------------------------------------------------
// CLASS: i2c_agent
//
// Agent for i2c protocol
//------------------------------------------------------------------------------
class i2c_agent extends uvm_agent;
  //--- attributes ---
  
  // object: _config
  // Configuration object for this agent
  i2c_config _config;
  
  // object: _vif
  // Virtual interface for this protocol
  virtual i2c_if _vif;
  
  //--- TLM ports/exports ---
  
  // object: put_export
  // Blocking put export to one upper layer. If you want to connect to multiple
  // upper layers, please define a new TLM type.
  uvm_blocking_put_imp #(i2c_transaction, i2c_agent) put_export;
  
  // object: analysis_port
  // Analysis port to upper layers
  uvm_analysis_port #(i2c_transaction) analysis_port;
  
  //--- children ---
  protected i2c_driver driver;   // user should not access to driver directly
  protected i2c_monitor monitor; // user should not access to monitor directly
  
  // object: sequencer
  // UVM sequencer for <i2c_transaction> type
  i2c_sequencer sequencer;
  
  //--- factory registration ---
  `uvm_component_utils(i2c_agent)
  
  //--- methods ---
  extern function new(string name="i2c_agent", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task put(i2c_transaction t);
endclass : i2c_agent

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function i2c_agent::new(string name="i2c_agent", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void i2c_agent::build_phase(uvm_phase phase);
  // Get configurations
  if(_config == null) begin
    if(!uvm_config_db #(i2c_config)::get(this, "", "_config", _config)) begin
      `uvm_warning(get_full_name(), "Configuration object is not set to this agent, creating one with default fields.")
      _config = i2c_config::type_id::create("_config");
    end
  end
  if(_vif == null) begin
    if(!uvm_config_db #(virtual i2c_if)::get(this, "", "_vif", _vif)) begin
      `uvm_fatal(get_full_name(), "Virtual interface is not assigned to this agent.")
    end
  end
  // Start building
  if(_config.is_active == UVM_ACTIVE) begin
    sequencer = i2c_sequencer::type_id::create("sequencer", this);
    driver = i2c_driver::type_id::create("driver", this);
  end
  if(_config.has_monitor == 1'b1) begin
    monitor = i2c_monitor::type_id::create("monitor", this);
  end
  if(_config.has_upper_layer == 1'b1) begin
    put_export = new("put_export", this);
  end
  analysis_port = new("analysis_port", this);
  super.build_phase(phase);
  // Set configurations
  if(_config.is_active == UVM_ACTIVE) begin
    uvm_config_db #(i2c_config)::set(this, "sequencer", "_config", _config);
    uvm_config_db #(i2c_config)::set(this, "driver", "_config", _config);
    uvm_config_db #(virtual i2c_if)::set(this, "driver", "_vif", _vif);
  end
  if(_config.has_monitor == 1'b1) begin
    uvm_config_db #(i2c_config)::set(this, "monitor", "_config", _config);
    uvm_config_db #(virtual i2c_if)::set(this, "monitor", "_vif", _vif);
  end
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void i2c_agent::connect_phase(uvm_phase phase);
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
task i2c_agent::put(i2c_transaction t);
  sequencer.execute_item(t);
endtask : put

`endif /* __I2C_AGENT_SVH__ */
