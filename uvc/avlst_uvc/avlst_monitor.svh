//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlst_monitor.svh> is a part of <Verification> project
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

`ifndef __AVLST_MONITOR_SVH__
`define __AVLST_MONITOR_SVH__

//------------------------------------------------------------------------------
// CLASS: avlst_monitor
//
// Monitor for avlst protocol
//------------------------------------------------------------------------------
class avlst_monitor extends uvm_component;
  //--- attributes ---
  protected avlst_config _config;   // protect configuration objects from external access
  protected avlst_adapter _adapter; // protect adapter from external access
  
  //--- TLM ports/exports
  
  // object: analysis_port
  // Analysis port that sends monitored transactions to upper layers
  uvm_analysis_port #(avlst_transaction) analysis_port;
  
  //--- factory registration ---
  `uvm_component_utils(avlst_monitor)
  
  //--- methods ---
  extern function new(string name="avlst_monitor", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : avlst_monitor

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function avlst_monitor::new(string name="avlst_monitor", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void avlst_monitor::build_phase(uvm_phase phase);
  assert(uvm_config_db #(avlst_config)::get(this, "", "_config", _config));
  assert(uvm_config_db #(avlst_adapter)::get(this, "", "_adapter", _adapter));
  analysis_port = new("analysis_port", this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task avlst_monitor::run_phase(uvm_phase phase);
  avlst_transaction trans;
  
  super.run_phase(phase);
  _adapter.wait_init();
  forever begin
    trans = avlst_transaction::type_id::create("trans");
    _adapter.pop_transaction(trans);
    `uvm_info(get_full_name(), {"Get transaction: ", trans.convert2string()}, UVM_HIGH)
    analysis_port.write(trans);
  end
endtask : run_phase

`endif /* __AVLST_MONITOR_SVH__ */
