//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <video_recorder.svh> is a part of <Verification> project
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

`ifndef __VIDEO_RECORDER_SVH__
`define __VIDEO_RECORDER_SVH__

//------------------------------------------------------------------------------
// Class: video_recorder
//
// Recorder for video protocol
//------------------------------------------------------------------------------
class video_recorder extends uvm_component;
  //--- properties ---
  video_config _config;
  int fhandle;
  uvm_analysis_export #(video_transaction) analysis_export;
  uvm_tlm_analysis_fifo #(video_transaction) analysis_fifo;
  
  //--- factory registration ---
  `uvm_component_utils(video_recorder)
  
  //--- methods ---
  extern function new(string name="video_recorder", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void extract_phase(uvm_phase phase);
  extern virtual function void create_spc_file(string spc_fname);
endclass : video_recorder

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function video_recorder::new(string name="video_recorder", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void video_recorder::build_phase(uvm_phase phase);
  assert(uvm_config_db #(video_config)::get(this, "", "_config", _config));
  analysis_export = new("analysis_export", this);
  analysis_fifo = new("analysis_fifo", this);
  fhandle = $fopen({_config.record_name, ".raw"}, "w");
  create_spc_file(_config.record_name);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void video_recorder::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  analysis_export.connect(analysis_fifo.analysis_export);
endfunction : connect_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task video_recorder::run_phase(uvm_phase phase);
  video_transaction trans;
  int pixels_in_word;
  int pixels_cnt;
  int word;
  int temp;
  int frame_size;
  int bits_per_pixel;
  
  super.run_phase(phase);
  forever begin
    analysis_fifo.get(trans);
    //---
    // NOTE: Control info change - Update later
    //---
    frame_size = _config.width*_config.height;
    bits_per_pixel = _config.bits_per_channel*_config.channels_per_pixel;
    pixels_cnt = 0;
    do begin
      pixels_in_word = 0;
      word = 0;
      temp = 0;
      do begin
        word <<= bits_per_pixel;
        word |= trans.pixels[pixels_cnt];
        pixels_in_word++;
        pixels_cnt++;
      end while(pixels_in_word<_config.pixels_per_word);
      temp |= (word & 32'hff000000) >> 24;
      temp |= (word & 32'h00ff0000) >>  8;
      temp |= (word & 32'h0000ff00) <<  8;
      temp |= (word & 32'h000000ff) << 24;
      $fwrite(fhandle, "%u", temp);
    end while(pixels_cnt<frame_size);
  end
endtask : run_phase

//------------------------------------------------------------------------------
// +Function: extract_phase
//------------------------------------------------------------------------------
function void video_recorder::extract_phase(uvm_phase phase);
  super.extract_phase(phase);
  $fclose(fhandle);
endfunction : extract_phase

//------------------------------------------------------------------------------
// Function: create_spc_file
//------------------------------------------------------------------------------
function void video_recorder::create_spc_file(string spc_fname);
  int spc_fhandle;
  string stemp;
  
  spc_fhandle = $fopen({spc_fname, ".spc"}, "wb");  
  $fwrite(spc_fhandle, "fourcc = %s\n", _config.fourcc);
  $fwrite(spc_fhandle, "width = %0d\n", _config.width);
  $fwrite(spc_fhandle, "height = %0d\n", _config.height);
  $fwrite(spc_fhandle, "stride = %0d\n", _config.stride);
  if(_config.interlaced[1]) begin
    $fwrite(spc_fhandle, "interlaced = yes\n");
  end
  if(_config.interlaced[0]) begin
    $fwrite(spc_fhandle, "bottom_field_first = yes\n");
  end
  stemp.realtoa(_config.frame_rate);
  $fwrite(spc_fhandle, "frame_rate = %s\n", stemp);
  $fclose(spc_fhandle);
endfunction : create_spc_file

`endif /* __VIDEO_RECORDER_SVH__ */
