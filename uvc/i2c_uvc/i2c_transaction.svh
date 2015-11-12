//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <i2c_transaction.svh> is a part of <Verification> project
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

`ifndef __I2C_TRANSACTION_SVH__
`define __I2C_TRANSACTION_SVH__

//------------------------------------------------------------------------------
// CLASS: i2c_transaction
//
// Transaction type for i2c protocol
//------------------------------------------------------------------------------
class i2c_transaction extends uvm_sequence_item;
  //--- attributes ---
  
  // int: command_e
  // Command START/STOP/DATA
  rand i2c_command_t command_e;
  
  // byte: int data
  // Transferred data
  rand byte data;
  
  // bit: ack
  // Returned acknowledgement
  bit ack;
  
  //--- constraints ---
  
  //--- factory registration ---
  `uvm_object_utils(i2c_transaction)
  
  //--- methods ---
  extern function new(string name="i2c_transaction");
  extern virtual function string convert2string();
  //extern virtual function void do_print(uvm_printer printer);
  //extern virtual function void do_record(uvm_recorder recorder);
  extern virtual function void do_copy(uvm_object rhs);
  extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  //extern virtual function void do_pack(uvm_packer packer);
  //extern virtual function void do_unpack(uvm_packer packer);
endclass : i2c_transaction

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function i2c_transaction::new(string name="i2c_transaction");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: convert2string
//------------------------------------------------------------------------------
function string i2c_transaction::convert2string();
  string s;
  
  $sformat(s, "COMMAND=%s, DATA=0x%X, ACK=%0b", command_e.name(), data, ack);
  return s;
endfunction : convert2string

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void i2c_transaction::do_copy(uvm_object rhs);
  i2c_transaction rhs_;
  
  assert($cast(rhs_, rhs));
  command_e = rhs_.command_e;
  data = rhs_.data;
  ack = rhs_.ack;
endfunction : do_copy

//------------------------------------------------------------------------------
// +Function: do_compare
//------------------------------------------------------------------------------
function bit i2c_transaction::do_compare(uvm_object rhs, uvm_comparer comparer);
  i2c_transaction rhs_;
  bit ok = 1;
  
  assert($cast(rhs_, rhs));
  ok &= comparer.compare_string("command", command_e.name(), rhs_.command_e.name());
  ok &= comparer.compare_field("data", data, rhs_.data, 8);
  ok &= comparer.compare_field("ack", ack, rhs_.ack, 1);
  return ok;
endfunction : do_compare

`endif /* __I2C_TRANSACTION_SVH__ */
