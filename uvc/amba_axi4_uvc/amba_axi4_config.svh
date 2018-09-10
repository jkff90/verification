//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_config.svh> is a part of <Verification> project
//  Copyright (C) 2018  An Pham (anphambk@gmail.com)
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

`ifndef __AMBA_AXI4_CONFIG_SVH__
`define __AMBA_AXI4_CONFIG_SVH__

//------------------------------------------------------------------------------
// CLASS: amba_axi4_config
//
// Configuration object for amba_axi4 protocol
//------------------------------------------------------------------------------
class amba_axi4_config extends uvm_object;
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
    
    // bit: enable_coverage = 0
    // Enable the coverage collector, only valid of has_monitor is one.
    bit enable_coverage = 0;
    
    // int: outstanding
    // Number of outstanding requests
    int outstanding_rd = 1;
    
    // int: outstanding
    // Number of outstanding requests
    int outstanding_wr = 1;
    
    // int: burst_size
    // AXI burst size
    bit [3:0] burst_size = 3'b010; // 4-byte
    
    // bit: out_of_order
    // Allow out-of-order response (slave device only)
    bit out_of_order = 0;
    
    //--- constraints ---
    
    //--- factory registration ---
    `uvm_object_utils(amba_axi4_config)
    
    //--- methods ---
    extern function new(string name="amba_axi4_config");
    extern virtual function void do_print(uvm_printer printer);
    extern virtual function void do_copy(uvm_object rhs);
endclass : amba_axi4_config

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_config::new(string name="amba_axi4_config");
    super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: do_print
//------------------------------------------------------------------------------
function void amba_axi4_config::do_print(uvm_printer printer);
    printer.print_string("Agent mode", is_active.name());
    printer.print_int("Has upper layer", has_upper_layer, 1);
    printer.print_int("Has monitor", has_monitor, 1);
    printer.print_int("Enable coverage", enable_coverage, 1);
    printer.print_int("Outstanding read", outstanding_rd, 32);
    printer.print_int("Outstanding write", outstanding_wr, 32);
    printer.print_int("Burst size", burst_size, 4);
    printer.print_int("Out of order", out_of_order, 1);
endfunction : do_print

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void amba_axi4_config::do_copy(uvm_object rhs);
    amba_axi4_config rhs_;
    
    assert($cast(rhs_, rhs));
    is_active = rhs_.is_active;
    has_upper_layer = rhs_.has_upper_layer;
    has_monitor = rhs_.has_monitor;
    enable_coverage = rhs_.enable_coverage;
    outstanding_rd = rhs_.outstanding_rd;
    outstanding_wr = rhs_.outstanding_wr;
    burst_size = rhs_.burst_size;
    out_of_order = rhs_.out_of_order;
endfunction : do_copy

`endif /* __AMBA_AXI4_CONFIG_SVH__ */
