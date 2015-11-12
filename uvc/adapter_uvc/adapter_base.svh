//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <adapter_base.svh> is a part of <Verification> project
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

`ifndef __ADAPTER_BASE_SVH__
`define __ADAPTER_BASE_SVH__

//-----------------------------------------------------------------------------
// CLASS: adapter_base
// Base class for adapters
//-----------------------------------------------------------------------------
virtual class adapter_base #(type HIGH=uvm_object, type LOW=uvm_object) extends uvm_component;
  //--- properties ---
  uvm_blocking_put_export #(HIGH) put_export;
  uvm_blocking_put_port #(LOW) put_port;
  uvm_analysis_export #(LOW) analysis_export;
  uvm_analysis_port #(HIGH) analysis_port;
  
  //--- methods ---
  extern function new(string name="adapter_base", uvm_component parent=null);
endclass : adapter_base

//-----------------------------------------------------------------------------
// +Constructor: new
//-----------------------------------------------------------------------------
function adapter_base::new(string name="adapter_base", uvm_component parent=null);
  super.new(name, parent);
  put_export = new("put_export", this);
  put_port = new("put_port", this);
  analysis_export = new("analysis_export", this);
  analysis_port = new("analysis_port", this);
endfunction : new

`endif /* __ADAPTER_BASE_SVH__ */
