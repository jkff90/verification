//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlst_video_env.svh> is a part of <Verification> project
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

`ifndef __AVLST_VIDEO_ENV__
`define __AVLST_VIDEO_ENV__

//------------------------------------------------------------------------------
// CLASS: avlst_video_env
//
// Avalon video steaming environment
//------------------------------------------------------------------------------
class avlst_video_env extends uvm_env;
  //--- properties ---
  avlst_video_env_config _config;
  
  //--- children ---
  avlst_agent avlst;
  packet_agent packet;
  video_agent video;
  packet_to_avlst_adapter packet_to_avlst;
  video_to_packet_adapter video_to_packet;
  uvm_analysis_port #(video_transaction) analysis_port;
  
  //--- factory registration ---
  `uvm_component_utils(avlst_video_env)
  
  //--- methods ---
  extern function new(string name="avlst_video_env", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass : avlst_video_env

//------------------------------------------------------------------------------
// Constructor: new
//------------------------------------------------------------------------------
function avlst_video_env::new(string name="avlst_video_env", uvm_component parent=null);
  super.new(name,parent);
endfunction : new

//------------------------------------------------------------------------------
// Function: build_phase
//------------------------------------------------------------------------------
function void avlst_video_env::build_phase(uvm_phase phase);
  // Get configurations
  if(_config == null) begin
    if(!uvm_config_db #(avlst_video_env_config)::get(this, "", "_config", _config)) begin
      `uvm_warning(get_full_name(), "No configuration object is set to this environment, create one with default fields.")
      _config = avlst_video_env_config::type_id::create("_config");
    end
  end
  // Start building
  avlst = avlst_agent::type_id::create("avlst", this);
  packet = packet_agent::type_id::create("packet", this);
  video = video_agent::type_id::create("video", this);
  packet_to_avlst = packet_to_avlst_adapter::type_id::create("packet_to_avlst", this);
  video_to_packet = video_to_packet_adapter::type_id::create("video_to_packet", this);
  analysis_port = new("analysis_port", this);
  super.build_phase(phase);
  // Set configurations
  uvm_config_db #(avlst_config)::set(this, "avlst", "_config", _config.avlst);
  uvm_config_db #(packet_config)::set(this, "packet", "_config", _config.packet);
  uvm_config_db #(video_config)::set(this, "video", "_config", _config.video);
  uvm_config_db #(packet_config)::set(this, "video_to_packet", "packet_config", _config.packet);
  uvm_config_db #(video_config)::set(this, "video_to_packet", "video_config", _config.video);
endfunction : build_phase

//------------------------------------------------------------------------------
// Function: connect_phase
//------------------------------------------------------------------------------
function void avlst_video_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // driver path
  video.put_port.connect(video_to_packet.put_export);
  video_to_packet.put_port.connect(packet.put_export);
  packet.put_port.connect(packet_to_avlst.put_export);
  packet_to_avlst.put_port.connect(avlst.put_export);
  // monitor path
  avlst.analysis_port.connect(packet_to_avlst.analysis_export);
  packet_to_avlst.analysis_port.connect(packet.analysis_export);
  packet.analysis_port.connect(video_to_packet.analysis_export);
  video_to_packet.analysis_port.connect(video.analysis_export);
  video.analysis_port.connect(analysis_port);
endfunction : connect_phase

`endif /* __AVLST_VIDEO_ENV__ */
