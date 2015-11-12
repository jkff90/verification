//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <reg_adapter_wishbone.svh> is a part of <Verification> project
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

`ifndef __REG_ADAPTER_WISHBONE__
`define __REG_ADAPTER_WISHBONE__

//------------------------------------------------------------------------------
// CLASS: reg_adapter_wishbone
//------------------------------------------------------------------------------
class reg_adapter_wishbone extends uvm_reg_adapter;
  //--- factory registration ---
  `uvm_object_utils(reg_adapter_wishbone)
  
  //--- methods ---
  extern function new(string name="reg_adapter_wishbone");
  extern virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
  extern virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
endclass : reg_adapter_wishbone

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function reg_adapter_wishbone::new(string name="reg_adapter_wishbone");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: reg2bus
//------------------------------------------------------------------------------
function uvm_sequence_item reg_adapter_wishbone::reg2bus(const ref uvm_reg_bus_op rw);
  wishbone_transaction trans;
  
  trans = wishbone_transaction::type_id::create("trans");
  trans.address = rw.addr;
  trans.data = rw.data;
  trans.command = (rw.kind == UVM_READ) ? WISHBONE_COMMAND_READ : WISHBONE_COMMAND_WRITE;
  return trans;
endfunction : reg2bus

//------------------------------------------------------------------------------
// +Function: bus2reg
//------------------------------------------------------------------------------
function void reg_adapter_wishbone::bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
  wishbone_transaction trans;
  
  if (!$cast(trans, bus_item)) begin
    `uvm_fatal(get_full_name(),"Bus item is not of type wishbone_transaction")
  end
  case(trans.command)
    WISHBONE_COMMAND_READ : rw.kind = UVM_READ;
    WISHBONE_COMMAND_WRITE: rw.kind = UVM_WRITE;
    default: `uvm_fatal(get_full_name(), "Illegal command")
  endcase
  rw.addr = trans.address;
  rw.data = trans.data;
  rw.status = UVM_IS_OK;
endfunction : bus2reg

`endif /* __REG_ADAPTER_WISHBONE__ */
