//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <wishbone_config.svh> is a part of <Verification> project
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

`ifndef __WISHBONE_CONFIG_SVH__
`define __WISHBONE_CONFIG_SVH__

//------------------------------------------------------------------------------
// CLASS: wishbone_config
//
// Configuration object for wishbone protocol
//------------------------------------------------------------------------------
class wishbone_config extends uvm_object;
  //--- attributes ---
  
  // enum: is_active = UVM_PASSIVE
  // Decide whether the agent has the driver path (sequencer+driver)
  uvm_active_passive_enum is_active = UVM_PASSIVE;
  
  // bit: has_upper_layer = 0
  // If the protocol has upper layers, a *put_export* for layering will be created
  bit has_upper_layer = 0;
  
  // bit: has_monitor = 1
  // Decide whether the agent has the monitor
  bit has_monitor = 1;
  
  //--- constraints ---
  
  //--- factory registration ---
  `uvm_object_utils(wishbone_config)
  
  //--- methods ---
  extern function new(string name="wishbone_config");
  extern virtual function void do_print(uvm_printer printer);
  extern virtual function void do_copy(uvm_object rhs);
endclass : wishbone_config

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function wishbone_config::new(string name="wishbone_config");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: do_print
//------------------------------------------------------------------------------
function void wishbone_config::do_print(uvm_printer printer);
  printer.print_string("Agent mode", is_active.name());
  printer.print_int("Has upper layer", has_upper_layer, 1);
  printer.print_int("Has monitor", has_monitor, 1);
endfunction : do_print

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void wishbone_config::do_copy(uvm_object rhs);
  wishbone_config rhs_;
  
  assert($cast(rhs_, rhs));
  is_active = rhs_.is_active;
  has_upper_layer = rhs_.has_upper_layer;
  has_monitor = rhs_.has_monitor;
endfunction : do_copy

`endif /* __WISHBONE_CONFIG_SVH__ */
