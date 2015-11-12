//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlst_video_env_config.svh> is a part of <Verification> project
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

`ifndef __AVLST_VIDEO_ENV_CONFIG__
`define __AVLST_VIDEO_ENV_CONFIG__

//------------------------------------------------------------------------------
// CLASS: avlst_video_env_config
//
// Configuration object for Avalon video steaming environment
//------------------------------------------------------------------------------
class avlst_video_env_config extends uvm_object;
  //--- properties ---
  
  // obj: avlst
  // Configuration object for Avalon ST agent
  avlst_config avlst;

  // obj: packet
  // Configuration object for packet agent
  packet_config packet;

  // obj: video
  // Configuration object for video agent
  video_config video;
  
  //--- factory registration ---
  `uvm_object_utils(avlst_video_env_config)
  
  //--- methods ---
  extern function new(string name="avlst_video_env_config");
  extern virtual function void do_copy(uvm_object rhs);
  extern virtual function void do_print(uvm_printer printer);
endclass : avlst_video_env_config

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function avlst_video_env_config::new(string name="avlst_video_env_config");
  super.new(name);
  avlst = avlst_config::type_id::create("avlst");
  packet = packet_config::type_id::create("packet");
  video = video_config::type_id::create("video");
  avlst.has_upper_layer = 1'b1;
  packet.has_upper_layer = 1'b1;
  video.has_upper_layer = 1'b0;
endfunction : new

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void avlst_video_env_config::do_copy(uvm_object rhs);
  avlst_video_env_config rhs_;
  
  assert($cast(rhs_, rhs));
  avlst.copy(rhs_.avlst);
  packet.copy(rhs_.packet);
  video.copy(rhs_.video);
endfunction : do_copy

//------------------------------------------------------------------------------
// +Function: do_print
//------------------------------------------------------------------------------
function void avlst_video_env_config::do_print(uvm_printer printer);
  if(printer == null) begin
    printer = uvm_default_table_printer;
  end
  avlst.print(printer);
  packet.print(printer);
  video.print(printer);
endfunction : do_print

`endif /* __AVLST_VIDEO_ENV_CONFIG__ */
