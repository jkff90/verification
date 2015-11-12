//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <video_transaction.svh> is a part of <Verification> project
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

`ifndef __VIDEO_TRANSACTION_SVH__
`define __VIDEO_TRANSACTION_SVH__

//------------------------------------------------------------------------------
// CLASS: video_transaction
//
// Transaction type for video protocol
//------------------------------------------------------------------------------
class video_transaction extends uvm_sequence_item;
  //--- attributes ---
  rand int width;
  rand int height;
  rand interlaced_t interlaced;
  rand synchronization_t synchronization;
  rand int pixels [];
  
  //--- constraints ---
  constraint c_pixels {
    pixels.size == width*height;
  }
  
  //--- factory registration ---
  `uvm_object_utils(video_transaction)
  
  //--- methods ---
  extern function new(string name="video_transaction");
  extern virtual function string convert2string();
  //extern virtual function void do_print(uvm_printer printer);
  //extern virtual function void do_record(uvm_recorder recorder);
  extern virtual function void do_copy(uvm_object rhs);
  //extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  //extern virtual function void do_pack(uvm_packer packer);
  //extern virtual function void do_unpack(uvm_packer packer);
endclass : video_transaction

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function video_transaction::new(string name="video_transaction");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: convert2string
//------------------------------------------------------------------------------
function string video_transaction::convert2string();
  string s;
  
  s = $psprintf("WIDTH=%0d HEIGHT=%0d INTERLACED=%s SYNCHRONIZATION=%s PIXELS=0x",
    width, height, interlaced.name(), synchronization.name());
  foreach(pixels[i]) begin
    s = $psprintf("%s%X_", s, pixels[i]);
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
function void video_transaction::do_copy(uvm_object rhs);
  video_transaction rhs_;
  
  assert($cast(rhs_, rhs));
  width = rhs_.width;
  height = rhs_.height;
  interlaced = rhs_.interlaced;
  synchronization = rhs_.synchronization;
  pixels = new[rhs_.pixels.size()](rhs_.pixels);
endfunction : do_copy

`endif /* __VIDEO_TRANSACTION_SVH__ */
