//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <wishbone_transaction.svh> is a part of <Verification> project
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

`ifndef __WISHBONE_TRANSACTION_SVH__
`define __WISHBONE_TRANSACTION_SVH__

//------------------------------------------------------------------------------
// CLASS: wishbone_transaction
//
// Transaction type for wishbone protocol
//------------------------------------------------------------------------------
class wishbone_transaction extends uvm_sequence_item;
  //--- attributes ---
  
  // var: command
  // Wishbone Read/Write/Idle command
  rand wishbone_command_t command;
  
  // var: addr
  // Wishbone transaction address
  rand wishbone_address_t address;
  
  // var: data
  // 
  rand wishbone_data_t data;
  
  //--- constraints ---
  
  //--- factory registration ---
  `uvm_object_utils(wishbone_transaction)
  
  //--- methods ---
  extern function new(string name="wishbone_transaction");
  extern virtual function string convert2string();
  //extern virtual function void do_print(uvm_printer printer);
  //extern virtual function void do_record(uvm_recorder recorder);
  extern virtual function void do_copy(uvm_object rhs);
  //extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  //extern virtual function void do_pack(uvm_packer packer);
  //extern virtual function void do_unpack(uvm_packer packer);
endclass : wishbone_transaction

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function wishbone_transaction::new(string name="wishbone_transaction");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: convert2string
//------------------------------------------------------------------------------
function string wishbone_transaction::convert2string();
  string s;
  
  $sformat(s, "COMMAND=%s, ADDRESS=%0d, DATA=0x%0X",
    command.name(), address, data);
  return s;
endfunction : convert2string

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void wishbone_transaction::do_copy(uvm_object rhs);
  wishbone_transaction rhs_;
  
  assert($cast(rhs_, rhs));
  command = rhs_.command;
  address = rhs_.address;
  data = rhs_.data;
endfunction : do_copy

`endif /* __WISHBONE_TRANSACTION_SVH__ */
