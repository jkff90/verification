//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <video_driver.svh> is a part of <Verification> project
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

`ifndef __VIDEO_DRIVER_SVH__
`define __VIDEO_DRIVER_SVH__

//------------------------------------------------------------------------------
// CLASS: video_driver
//
// Driver for video protocol
//------------------------------------------------------------------------------
class video_driver extends uvm_driver #(video_transaction);
  //--- attributes ---
  protected video_config _config; // protect configuration objects from external access
  
  //--- TLM ports/exports ---
  
  // object: put_port
  // Blocking put port to send transactions to one lower layers. Please take a
  // note that a TLM *put_port* is only able to connect with one *put_export*
  uvm_blocking_put_port #(video_transaction) put_port;
  
  //--- factory registration ---
  `uvm_component_utils(video_driver)
  
  //--- methods ---
  extern function new(string name="video_driver", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : video_driver

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function video_driver::new(string name="video_driver", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void video_driver::build_phase(uvm_phase phase);
  assert(uvm_config_db #(video_config)::get(this, "", "_config", _config));
  put_port = new("put_port", this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task video_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    seq_item_port.get_next_item(req);
    put_port.put(req);
    `uvm_info(get_full_name(), {"Sent transaction: ", req.convert2string()}, UVM_HIGH)
    seq_item_port.item_done();
  end
endtask : run_phase

`endif /* __VIDEO_DRIVER_SVH__ */
