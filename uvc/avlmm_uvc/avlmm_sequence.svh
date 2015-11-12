//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlmm_sequence.svh> is a part of <Verification> project
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

`ifndef __AVLMM_SEQUENCE_SVH__
`define __AVLMM_SEQUENCE_SVH__

//------------------------------------------------------------------------------
// CLASS: avlmm_sequence
//
// Basic sequence for avlmm protocol
//------------------------------------------------------------------------------
class avlmm_sequence extends uvm_sequence #(avlmm_transaction);
  //--- attributes ---
  
  //--- factory registration ---
  `uvm_object_utils(avlmm_sequence)
  `uvm_declare_p_sequencer(avlmm_sequencer)
  
  //--- methods ---
  extern function new(string name="avlmm_sequence");
  extern virtual task body();
endclass : avlmm_sequence

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function avlmm_sequence::new(string name="avlmm_sequence");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Method: body
//------------------------------------------------------------------------------
task avlmm_sequence::body();
  req = avlmm_transaction::type_id::create("req");
  start_item(req);
  `ifndef DISABLE_SV_FEATURES
  assert(req.randomize() with {
  });
  `endif /* DISABLE_SV_FEATURES */
  finish_item(req);
endtask : body

`endif /* __AVLMM_SEQUENCE_SVH__ */
