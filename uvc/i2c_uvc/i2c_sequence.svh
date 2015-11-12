//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <i2c_sequence.svh> is a part of <Verification> project
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

`ifndef __I2C_SEQUENCE_SVH__
`define __I2C_SEQUENCE_SVH__

//------------------------------------------------------------------------------
// CLASS: i2c_sequence
//
// Basic sequence for i2c protocol
//------------------------------------------------------------------------------
class i2c_sequence extends uvm_sequence #(i2c_transaction);
  //--- attributes ---
  
  //--- factory registration ---
  `uvm_object_utils(i2c_sequence)
  `uvm_declare_p_sequencer(i2c_sequencer)
  
  //--- methods ---
  extern function new(string name="i2c_sequence");
  extern virtual task body();
endclass : i2c_sequence

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function i2c_sequence::new(string name="i2c_sequence");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Method: body
//------------------------------------------------------------------------------
task i2c_sequence::body();
  req = i2c_transaction::type_id::create("req");
  start_item(req);
  `ifndef DISABLE_SV_FEATURES
  assert(req.randomize() with {
  });
  `endif /* DISABLE_SV_FEATURES */
  finish_item(req);
endtask : body

`endif /* __I2C_SEQUENCE_SVH__ */
