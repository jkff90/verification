//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <i2c_adapter.svh> is a part of <Verification> project
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

`ifndef __I2C_ADAPTER_SVH__
`define __I2C_ADAPTER_SVH__

//------------------------------------------------------------------------------
// CLASS: i2c_adapter
//
// Abstract adapter for i2c protocol
//------------------------------------------------------------------------------
virtual class i2c_adapter extends uvm_component;
  //--- attributes ---
  protected event init_done;
  
  //--- methods ---
  extern function new(string name="i2c_adapter", uvm_component parent=null);
  extern virtual task init();
  extern virtual task wait_init();
  
  // Method: push_transaction
  // Pure virtual method, works as a software interface. 
  // Push transaction down to lower protocol
  pure virtual task push_transaction(ref i2c_transaction trans);
  
  // Method: pop_transaction
  // Pure virtual method, works as a software interface. 
  // Pop transaction from lower protocol
  pure virtual task pop_transaction(ref i2c_transaction trans);
endclass : i2c_adapter

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function i2c_adapter::new(string name="i2c_adapter", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// Method: init
//------------------------------------------------------------------------------
task i2c_adapter::init();
  -> init_done;
endtask : init

//------------------------------------------------------------------------------
// Method: wait_init
//------------------------------------------------------------------------------
task i2c_adapter::wait_init();
  @(init_done);
endtask : wait_init

`endif /* __I2C_ADAPTER_SVH__ */
