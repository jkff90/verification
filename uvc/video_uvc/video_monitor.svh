//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <video_monitor.svh> is a part of <Verification> project
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

`ifndef __VIDEO_MONITOR_SVH__
`define __VIDEO_MONITOR_SVH__

//------------------------------------------------------------------------------
// CLASS: video_monitor
//
// Monitor for video protocol
//------------------------------------------------------------------------------
class video_monitor extends uvm_component;
  //--- attributes ---
  protected video_config _config;  // protect configuration objects from external access
  
  //--- TLM ports/exports
  
  // object: analysis_port
  // Analysis port that sends monitored transactions to upper layers
  uvm_analysis_port #(video_transaction) analysis_port;
  
  // object: analysis_export
  // Analysis port that receives transactions from lower layers
  uvm_analysis_imp #(video_transaction, video_monitor) analysis_export;
  
  //--- factory registration ---
  `uvm_component_utils(video_monitor)
  
  //--- methods ---
  extern function new(string name="video_monitor", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void write(video_transaction trans);
endclass : video_monitor

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function video_monitor::new(string name="video_monitor", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void video_monitor::build_phase(uvm_phase phase);
  assert(uvm_config_db #(video_config)::get(this, "", "_config", _config));
  analysis_port = new("analysis_port", this);
  analysis_export = new("analysis_export", this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: write
//------------------------------------------------------------------------------
function void video_monitor::write(video_transaction trans);
  // Protocol check
  `uvm_info(get_full_name(), {"Get transaction: ", trans.convert2string()}, UVM_HIGH)
  analysis_port.write(trans);
endfunction : write

`endif /* __VIDEO_MONITOR_SVH__ */
