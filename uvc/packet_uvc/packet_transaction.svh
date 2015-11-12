//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <packet_transaction.svh> is a part of <Verification> project
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

`ifndef __PACKET_TRANSACTION_SVH__
`define __PACKET_TRANSACTION_SVH__

//------------------------------------------------------------------------------
// CLASS: packet_transaction
//
// Transaction type for packet protocol
//------------------------------------------------------------------------------
class packet_transaction extends uvm_sequence_item;
  //--- attributes ---
  rand packet_e packet_type;
  rand int data [];
  rand bit [15:0] width;
  rand bit [15:0] height;
  rand bit [3:0] interlaced;
  
  //--- constraints ---
  
  //--- factory registration ---
  `uvm_object_utils(packet_transaction)
  
  //--- methods ---
  extern function new(string name="packet_transaction");
  extern virtual function string convert2string();
  //extern virtual function void do_print(uvm_printer printer);
  //extern virtual function void do_record(uvm_recorder recorder);
  extern virtual function void do_copy(uvm_object rhs);
  //extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  //extern virtual function void do_pack(uvm_packer packer);
  //extern virtual function void do_unpack(uvm_packer packer);
endclass : packet_transaction

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function packet_transaction::new(string name="packet_transaction");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: convert2string
//------------------------------------------------------------------------------
function string packet_transaction::convert2string();
  string s;
  
  s = $psprintf("PACKET_TYPE=%s", packet_type.name());
  case(packet_type)
    CONTROL_PACKET: begin
      s = $psprintf("%s WIDTH=%0d HEIGHT=%0d INTERLACED=%0d", s, width, height, interlaced);
    end
    default: begin
      s = $psprintf("%s SIZE=%0d DATA=0x", s, data.size());
      foreach(data[i]) begin
        s = $psprintf("%s%X_", s, data[i]);
        if(i >= 40) begin
          s = {s, ".........."};
          break;
        end
      end
    end
  endcase
  return s;
endfunction : convert2string

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void packet_transaction::do_copy(uvm_object rhs);
  packet_transaction rhs_;
  
  assert($cast(rhs_, rhs));
  packet_type = rhs_.packet_type;
  data = new[rhs_.data.size()](rhs_.data);
  width = rhs_.width;
  height = rhs_.height;
  interlaced = rhs_.interlaced;
endfunction : do_copy

`endif /* __PACKET_TRANSACTION_SVH__ */
