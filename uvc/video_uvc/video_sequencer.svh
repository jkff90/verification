//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <video_sequencer.svh> is a part of <Verification> project
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

`ifndef __VIDEO_SEQUENCER_SVH__
`define __VIDEO_SEQUENCER_SVH__

//------------------------------------------------------------------------------
// CLASS: video_sequencer
//
// Sequencer for video protocol
//------------------------------------------------------------------------------
class video_sequencer extends uvm_sequencer #(video_transaction);
  //--- attributes ---

  // obj: _config
  // Make this visible for accessing from sequences
  video_config _config;
  
  //--- factory registration ---
  `uvm_component_utils(video_sequencer)
  
  //--- methods ---
  extern function new(string name="video_sequencer", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
endclass : video_sequencer

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function video_sequencer::new(string name="video_sequencer", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void video_sequencer::build_phase(uvm_phase phase);
  assert(uvm_config_db #(video_config)::get(this, "", "_config", _config));
  super.build_phase(phase);
endfunction : build_phase

`endif /* __VIDEO_SEQUENCER_SVH__ */
