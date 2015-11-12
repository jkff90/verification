//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <irq_driver.svh> is a part of <Verification> project
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

`ifndef __IRQ_DRIVER_SVH__
`define __IRQ_DRIVER_SVH__

//------------------------------------------------------------------------------
// CLASS: irq_driver
//
// Driver for irq protocol
//------------------------------------------------------------------------------
class irq_driver extends uvm_driver #(irq_transaction);
  //--- attributes ---
  protected irq_config _config;  // protect configuration objects from external access
  protected virtual irq_if _vif; // protect interface from external access
  
  //--- factory registration ---
  `uvm_component_utils(irq_driver)
  
  //--- methods ---
  extern function new(string name="irq_driver", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : irq_driver

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function irq_driver::new(string name="irq_driver", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void irq_driver::build_phase(uvm_phase phase);
  assert(uvm_config_db #(irq_config)::get(this, "", "_config", _config));
  assert(uvm_config_db #(virtual irq_if)::get(this, "", "_vif", _vif));
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task irq_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    seq_item_port.get_next_item(req);
    // Drive signals
    `uvm_info(get_full_name(), {"Sent transaction: ", req.convert2string()}, UVM_HIGH)
    seq_item_port.item_done();
  end
endtask : run_phase

`endif /* __IRQ_DRIVER_SVH__ */
