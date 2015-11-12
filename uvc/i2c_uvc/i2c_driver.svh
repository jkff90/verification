//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <i2c_driver.svh> is a part of <Verification> project
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

`ifndef __I2C_DRIVER_SVH__
`define __I2C_DRIVER_SVH__

//------------------------------------------------------------------------------
// CLASS: i2c_driver
//
// Driver for i2c protocol
//------------------------------------------------------------------------------
class i2c_driver extends uvm_driver #(i2c_transaction);
  //--- attributes ---
  protected i2c_config _config;  // protect configuration objects from external access
  protected virtual i2c_if _vif; // protect interface from external access
  
  //--- factory registration ---
  `uvm_component_utils(i2c_driver)
  
  //--- methods ---
  extern function new(string name="i2c_driver", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : i2c_driver

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function i2c_driver::new(string name="i2c_driver", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void i2c_driver::build_phase(uvm_phase phase);
  assert(uvm_config_db #(i2c_config)::get(this, "", "_config", _config));
  assert(uvm_config_db #(virtual i2c_if)::get(this, "", "_vif", _vif));
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task i2c_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    seq_item_port.get_next_item(req);
    // Drive signals
    `uvm_info(get_full_name(), {"Sent transaction: ", req.convert2string()}, UVM_HIGH)
    seq_item_port.item_done();
  end
endtask : run_phase

`endif /* __I2C_DRIVER_SVH__ */
