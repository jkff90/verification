//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <packet_config.svh> is a part of <Verification> project
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

`ifndef __PACKET_CONFIG_SVH__
`define __PACKET_CONFIG_SVH__

//------------------------------------------------------------------------------
// CLASS: packet_config
//
// Configuration object for packet protocol
//------------------------------------------------------------------------------
class packet_config extends uvm_object;
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
  
  // int: min_packet_size
  // Minimum packet size
  int min_packet_size = 64;

  // int: max_packet_size
  // Maximum packet size
  int max_packet_size = 9600;

  // int: bits_per_symbol
  // The number of bits per symbol
  int bits_per_symbol = 8;

  // int: symbols_per_beat
  // The number of symbols that are transfered on every valid cycle
  int symbols_per_beat = 1;

  //--- constraints ---
  constraint c_bits_per_symbol {
    bits_per_symbol inside {[1:512]};
  }
  constraint c_symbols_per_beat {
    symbols_per_beat inside {[1:32]};
  }
  
  //--- factory registration ---
  `uvm_object_utils(packet_config)
  
  //--- methods ---
  extern function new(string name="packet_config");
  extern virtual function void do_print(uvm_printer printer);
  extern virtual function void do_copy(uvm_object rhs);
endclass : packet_config

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function packet_config::new(string name="packet_config");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: do_print
//------------------------------------------------------------------------------
function void packet_config::do_print(uvm_printer printer);
  printer.print_string("Agent mode", is_active.name());
  printer.print_int("Has upper layer", has_upper_layer, 1);
  printer.print_int("Has monitor", has_monitor, 1);
  printer.print_int("Minimum packet size", min_packet_size, 32);
  printer.print_int("Maximum packet size", max_packet_size, 32);
  printer.print_int("Bits per symbol", bits_per_symbol, 32);
  printer.print_int("Symbols per beat", symbols_per_beat, 32);
endfunction : do_print

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void packet_config::do_copy(uvm_object rhs);
  packet_config rhs_;
  
  assert($cast(rhs_, rhs));
  is_active = rhs_.is_active;
  has_upper_layer = rhs_.has_upper_layer;
  has_monitor = rhs_.has_monitor;
  min_packet_size = rhs_.min_packet_size;
  max_packet_size = rhs_.max_packet_size;
  bits_per_symbol = rhs_.bits_per_symbol;
  symbols_per_beat = rhs_.symbols_per_beat;
endfunction : do_copy

`endif /* __PACKET_CONFIG_SVH__ */
