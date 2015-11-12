//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <irq_transaction.svh> is a part of <Verification> project
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

`ifndef __IRQ_TRANSACTION_SVH__
`define __IRQ_TRANSACTION_SVH__

//------------------------------------------------------------------------------
// CLASS: irq_transaction
//
// Transaction type for irq protocol
//------------------------------------------------------------------------------
class irq_transaction extends uvm_sequence_item;
  //--- attributes ---
  
  // var: sense
  // Sense type
  irq_sense_t sense;
  
  //--- constraints ---
  
  //--- factory registration ---
  `uvm_object_utils(irq_transaction)
  
  //--- methods ---
  extern function new(string name="irq_transaction");
  extern virtual function string convert2string();
  //extern virtual function void do_print(uvm_printer printer);
  //extern virtual function void do_record(uvm_recorder recorder);
  extern virtual function void do_copy(uvm_object rhs);
  //extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  //extern virtual function void do_pack(uvm_packer packer);
  //extern virtual function void do_unpack(uvm_packer packer);
endclass : irq_transaction

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function irq_transaction::new(string name="irq_transaction");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: convert2string
//------------------------------------------------------------------------------
function string irq_transaction::convert2string();
  string s;
  
  s = $sformatf("SENSE=%s", sense.name());
  return s;
endfunction : convert2string

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void irq_transaction::do_copy(uvm_object rhs);
  irq_transaction rhs_;
  
  assert($cast(rhs_, rhs));
  sense = rhs_.sense;
endfunction : do_copy

`endif /* __IRQ_TRANSACTION_SVH__ */
