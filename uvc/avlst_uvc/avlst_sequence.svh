//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlst_sequence.svh> is a part of <Verification> project
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

`ifndef __AVLST_SEQUENCE_SVH__
`define __AVLST_SEQUENCE_SVH__

//------------------------------------------------------------------------------
// CLASS: avlst_sequence
//
// Basic sequence for avlst protocol
//------------------------------------------------------------------------------
class avlst_sequence extends uvm_sequence #(avlst_transaction);
  //--- attributes ---
  
  //--- factory registration ---
  `uvm_object_utils(avlst_sequence)
  `uvm_declare_p_sequencer(avlst_sequencer)
  
  //--- methods ---
  extern function new(string name="avlst_sequence");
  extern virtual task body();
endclass : avlst_sequence

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function avlst_sequence::new(string name="avlst_sequence");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Method: body
//------------------------------------------------------------------------------
task avlst_sequence::body();
  req = avlst_transaction::type_id::create("req");
  start_item(req);
  `ifndef DISABLE_SV_FEATURES
  assert(req.randomize() with {
  });
  `endif /* DISABLE_SV_FEATURES */
  finish_item(req);
endtask : body

`endif /* __AVLST_SEQUENCE_SVH__ */
