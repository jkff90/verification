//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <wishbone_sequence.svh> is a part of <Verification> project
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

`ifndef __WISHBONE_SEQUENCE_SVH__
`define __WISHBONE_SEQUENCE_SVH__

//------------------------------------------------------------------------------
// CLASS: wishbone_sequence
//
// Basic sequence for wishbone protocol
//------------------------------------------------------------------------------
class wishbone_sequence extends uvm_sequence #(wishbone_transaction);
  //--- attributes ---
  
  //--- factory registration ---
  `uvm_object_utils(wishbone_sequence)
  `uvm_declare_p_sequencer(wishbone_sequencer)
  
  //--- methods ---
  extern function new(string name="wishbone_sequence");
  extern virtual task body();
endclass : wishbone_sequence

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function wishbone_sequence::new(string name="wishbone_sequence");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Method: body
//------------------------------------------------------------------------------
task wishbone_sequence::body();
  req = wishbone_transaction::type_id::create("req");
  start_item(req);
  `ifndef DISABLE_SV_FEATURES
  assert(req.randomize() with {
  });
  `endif /* DISABLE_SV_FEATURES */
  finish_item(req);
endtask : body

`endif /* __WISHBONE_SEQUENCE_SVH__ */
