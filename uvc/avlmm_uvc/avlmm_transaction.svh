//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlmm_transaction.svh> is a part of <Verification> project
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

`ifndef __AVLMM_TRANSACTION_SVH__
`define __AVLMM_TRANSACTION_SVH__

//------------------------------------------------------------------------------
// CLASS: avlmm_transaction
//
// Transaction type for avlmm protocol
//------------------------------------------------------------------------------
class avlmm_transaction extends uvm_sequence_item;
  //--- attributes ---

  // var: request
  // Request type
  rand avlmm_request_t request;

  // var: address
  // Address of the request
  rand avlmm_address_t address;

  // var: data []
  // An array contains request data
  rand avlmm_data_t data [];

  // var: byte_enable
  // An array contains byte_enable for each data
  rand avlmm_byte_enable_t byte_enable [];
  
  //--- constraints ---
  constraint c_size {
    data.size() == byte_enable.size();
  }
  
  //--- factory registration ---
  `uvm_object_utils(avlmm_transaction)
  
  //--- methods ---
  extern function new(string name="avlmm_transaction");
  extern virtual function string convert2string();
  //extern virtual function void do_print(uvm_printer printer);
  //extern virtual function void do_record(uvm_recorder recorder);
  extern virtual function void do_copy(uvm_object rhs);
  //extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  //extern virtual function void do_pack(uvm_packer packer);
  //extern virtual function void do_unpack(uvm_packer packer);
endclass : avlmm_transaction

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function avlmm_transaction::new(string name="avlmm_transaction");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: convert2string
//------------------------------------------------------------------------------
function string avlmm_transaction::convert2string();
  string s;
  
  s = $psprintf("REQUEST=%s, ADDRESS=%0d, SIZE=%0d, DATA=0x",
    request.name(), address, data.size());
  foreach(data[i]) begin
    s = $psprintf("%s%X_", s, data[i]);
    if(i >= 40) begin
      s = {s, ".........."};
      break;
    end
  end
  return s;
endfunction : convert2string

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void avlmm_transaction::do_copy(uvm_object rhs);
  avlmm_transaction rhs_;
  
  assert($cast(rhs_, rhs));
  request = rhs_.request;
  address = rhs_.address;
  data = new[rhs_.data.size()](rhs_.data);
  byte_enable = new[rhs_.byte_enable.size()](rhs_.byte_enable);
endfunction : do_copy

`endif /* __AVLMM_TRANSACTION_SVH__ */
