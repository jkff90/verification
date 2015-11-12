//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <packet_sequence.svh> is a part of <Verification> project
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

`ifndef __PACKET_SEQUENCE_SVH__
`define __PACKET_SEQUENCE_SVH__

//------------------------------------------------------------------------------
// CLASS: packet_sequence
//
// Basic sequence for packet protocol
//------------------------------------------------------------------------------
class packet_sequence extends uvm_sequence #(packet_transaction);
  //--- attributes ---
  
  //--- factory registration ---
  `uvm_object_utils(packet_sequence)
  `uvm_declare_p_sequencer(packet_sequencer)
  
  //--- methods ---
  extern function new(string name="packet_sequence");
  extern virtual task body();
endclass : packet_sequence

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function packet_sequence::new(string name="packet_sequence");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Method: body
//------------------------------------------------------------------------------
task packet_sequence::body();
  req = packet_transaction::type_id::create("req");
  start_item(req);
  `ifndef DISABLE_SV_FEATURES
  assert(req.randomize() with {
  });
  `endif /* DISABLE_SV_FEATURES */
  finish_item(req);
endtask : body

`endif /* __PACKET_SEQUENCE_SVH__ */
