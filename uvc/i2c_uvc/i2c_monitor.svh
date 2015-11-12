//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <i2c_monitor.svh> is a part of <Verification> project
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

`ifndef __I2C_MONITOR_SVH__
`define __I2C_MONITOR_SVH__

//------------------------------------------------------------------------------
// CLASS: i2c_monitor
//
// Monitor for i2c protocol
//------------------------------------------------------------------------------
class i2c_monitor extends uvm_component;
  //--- attributes ---
  protected i2c_config _config;  // protect configuration objects from external access
  protected virtual i2c_if _vif; // protect interface from external access
  
  //--- TLM ports/exports
  
  // object: analysis_port
  // Analysis port that sends monitored transactions to upper layers
  uvm_analysis_port #(i2c_transaction) analysis_port;
  
  //--- factory registration ---
  `uvm_component_utils(i2c_monitor)
  
  //--- methods ---
  extern function new(string name="i2c_monitor", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : i2c_monitor

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function i2c_monitor::new(string name="i2c_monitor", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void i2c_monitor::build_phase(uvm_phase phase);
  assert(uvm_config_db #(i2c_config)::get(this, "", "_config", _config));
  assert(uvm_config_db #(virtual i2c_if)::get(this, "", "_vif", _vif));
  analysis_port = new("analysis_port", this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task i2c_monitor::run_phase(uvm_phase phase);
  i2c_transaction trans;
  
  super.run_phase(phase);
  wait(_vif.scl !== 'x && _vif.sda !== 'x);
  forever begin
    trans = i2c_transaction::type_id::create("trans");
    // Monitor signals
    fork
      // start
      @(negedge _vif.sda iff(_vif.scl === 1'b1)) begin
        trans.command_e = I2C_COMMAND_START;
        trans.data = 0;
        trans.ack = 0;
      end
      // stop
      @(posedge _vif.sda iff(_vif.scl === 1'b1)) begin
        trans.command_e = I2C_COMMAND_STOP;
        trans.data = 0;
        trans.ack = 0;
      end
      // data
      begin
        repeat(8) begin
          @(posedge _vif.scl);
          trans.data <<= 1;
          trans.data |= _vif.sda;
        end
        @(posedge _vif.scl);
        trans.ack = ~_vif.sda;
        trans.command_e = I2C_COMMAND_DATA;
      end
    join_any
    disable fork;
    `uvm_info(get_full_name(), {"Get transaction: ", trans.convert2string()}, UVM_HIGH)
    analysis_port.write(trans);
  end
endtask : run_phase

`endif /* __I2C_MONITOR_SVH__ */
