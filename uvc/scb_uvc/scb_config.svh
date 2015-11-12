//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <scb_config.svh> is a part of <Verification> project
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

`ifndef __SCB_CONFIG_SVH__
`define __SCB_CONFIG_SVH__

class scb_config extends uvm_object;
  //--- attributes ---

  // bit: wait_to_end
  // Scoreboard waits in phase_ready_to_end
  bit wait_to_end;
  
  //--- factory registration ---
  `uvm_object_utils(scb_config)
  
  //--- methods ---
  extern function new(string name="scb_config");
  extern virtual function void do_copy(uvm_object rhs);
  extern virtual function void do_print(uvm_printer printer);
endclass : scb_config

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function scb_config::new(string name="scb_config");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void scb_config::do_copy(uvm_object rhs);
  scb_config rhs_;
  
  assert($cast(rhs_, rhs));
  wait_to_end = rhs_.wait_to_end;
endfunction : do_copy

//------------------------------------------------------------------------------
// +Function: do_print
//------------------------------------------------------------------------------
function void scb_config::do_print(uvm_printer printer);
  printer.print_field("Wait to end", wait_to_end, 1);
endfunction : do_print

`endif /* __SCB_CONFIG_SVH__ */
