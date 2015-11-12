//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlst_transaction.svh> is a part of <Verification> project
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

`ifndef __AVLST_TRANSACTION_SVH__
`define __AVLST_TRANSACTION_SVH__

//------------------------------------------------------------------------------
// CLASS: avlst_transaction
//
// Transaction type for avlst protocol
//------------------------------------------------------------------------------
class avlst_transaction extends uvm_sequence_item;
  //--- attributes ---

  // int: idles
  // The number of idles cycle for the transaction
  rand int unsigned idles;

  // bit: startofpacket
  // Start of packet
  rand bit startofpacket;

  // bit: endofpacket
  // End of packet
  rand bit endofpacket;

  // var: data
  // Data value of Avalon ST transaction
  rand avlst_data_t data;

  // var: channel
  // Channel value of Avalon ST transaction
  rand avlst_channel_t channel;

  // var: empty
  // Empty value of Avalon ST transaction
  rand avlst_empty_t empty;

  // var: error
  // Error value of Avalon ST transaction
  rand avlst_error_t error;
  
  //--- constraints ---
  
  //--- factory registration ---
  `uvm_object_utils(avlst_transaction)
  
  //--- methods ---
  extern function new(string name="avlst_transaction");
  extern virtual function string convert2string();
  //extern virtual function void do_print(uvm_printer printer);
  //extern virtual function void do_record(uvm_recorder recorder);
  extern virtual function void do_copy(uvm_object rhs);
  //extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  //extern virtual function void do_pack(uvm_packer packer);
  //extern virtual function void do_unpack(uvm_packer packer);
endclass : avlst_transaction

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function avlst_transaction::new(string name="avlst_transaction");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: convert2string
//------------------------------------------------------------------------------
function string avlst_transaction::convert2string();
  string s;
  
  s = $psprintf("IDLES=%0d, SOP=%b, EOP=%b, CHANNEL=%0d, DATA=%X, ERROR=%0d, EMPTY=%0d",
    idles, startofpacket, endofpacket, channel, data, error, empty);
  return s;
endfunction : convert2string

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void avlst_transaction::do_copy(uvm_object rhs);
  avlst_transaction rhs_;
  
  assert($cast(rhs_, rhs));
  idles = rhs_.idles;
  startofpacket = rhs_.startofpacket;
  endofpacket = rhs_.endofpacket;
  channel = rhs_.channel;
  data = rhs_.data;
  error = rhs_.error;
  empty = rhs_.empty;
endfunction : do_copy

`endif /* __AVLST_TRANSACTION_SVH__ */
