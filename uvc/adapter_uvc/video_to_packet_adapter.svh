//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <video_to_packet_adapter.svh> is a part of <Verification> project
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

`ifndef __VIDEO_TO_PACKET_ADAPTER_SVH__
`define __VIDEO_TO_PACKET_ADAPTER_SVH__

//------------------------------------------------------------------------------
// Class: video_to_packet_adapter
//------------------------------------------------------------------------------
class video_to_packet_adapter extends adapter_base #(video_transaction, packet_transaction);
  //--- properties ---
  uvm_blocking_put_imp #(HIGH, video_to_packet_adapter) put_imp;
  uvm_tlm_analysis_fifo #(LOW) analysis_fifo;
  
  //--- local variables ---
  //---
  // Note: Flexible conversion
  //---
  local packet_config _packet_config;
  local video_config _video_config;
  local int beats_per_pixel;
  local int bits_per_beat;
  local int mask;
  //---
  
  //--- factory registration ---
  `uvm_component_utils(video_to_packet_adapter)
  
  //--- methods ---
  extern function new(string name="video_to_packet_adapter", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task put(HIGH high);
endclass : video_to_packet_adapter

//------------------------------------------------------------------------------
// Constructor: new
//------------------------------------------------------------------------------
function video_to_packet_adapter::new(string name="video_to_packet_adapter", uvm_component parent=null);
  super.new(name, parent);
  put_imp = new("put_imp", this);
  analysis_fifo = new("analysis_fifo", this);
endfunction : new

//------------------------------------------------------------------------------
// Function: build_phase
//------------------------------------------------------------------------------
function void video_to_packet_adapter::build_phase(uvm_phase phase);
  //---
  // Note: Flexible conversion
  //---
  assert(uvm_config_db #(packet_config)::get(this, "", "packet_config", _packet_config));
  assert(uvm_config_db #(video_config)::get(this, "", "video_config", _video_config));
  if(_video_config.bits_per_channel != _packet_config.bits_per_symbol) begin
    `uvm_fatal(get_full_name(), $psprintf("Configuration does not match: video_config.bits_per_channel=%0d packet_config.bits_per_symbol=%0d",
      _video_config.bits_per_channel, _packet_config.bits_per_symbol))
  end
  if(_video_config.channels_per_pixel%_packet_config.symbols_per_beat == 0)
    beats_per_pixel = _video_config.channels_per_pixel/_packet_config.symbols_per_beat;
  else
    beats_per_pixel = _video_config.channels_per_pixel/_packet_config.symbols_per_beat + 1;
  bits_per_beat = _packet_config.bits_per_symbol*_packet_config.symbols_per_beat;
  mask = (1<<bits_per_beat)-1;
  //---
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// Function: connect_phase
//------------------------------------------------------------------------------
function void video_to_packet_adapter::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  put_export.connect(put_imp);
  analysis_export.connect(analysis_fifo.analysis_export);
endfunction : connect_phase

//------------------------------------------------------------------------------
// Method: run_phase
//------------------------------------------------------------------------------
task video_to_packet_adapter::run_phase(uvm_phase phase);
  HIGH high;
  LOW low;
  
  super.run_phase(phase);
  forever begin
    high = new("high");
    // control
    do begin
      analysis_fifo.get(low);
    end while(low.packet_type != CONTROL_PACKET);
    high.width = low.width;
    high.height = low.height;
    case(low.interlaced[3:2])
      2'b00  : high.interlaced = PROGRESSIVE;
      2'b10  : high.interlaced = INTERLACED_F0;
      2'b11  : high.interlaced = INTERLACED_F1;
      default: high.interlaced = INTERLACED_DONT_KNOW;
    endcase
    case(low.interlaced[1:0])
      2'b00  : high.synchronization = SYNCH_F0;
      2'b01  : high.synchronization = SYNCH_F1;
      2'b11  : high.synchronization = SYNCH_DONT_CARE;
      default: high.synchronization = SYNCH_DONT_KNOW;
    endcase
    // data
    do begin
      analysis_fifo.get(low);
    end while(low.packet_type != DATA_PACKET);
    //---
    // Note: Flexible conversion
    //---
    high.pixels = new[low.data.size()/beats_per_pixel];
    foreach(high.pixels[i]) begin
      for(int j=0; j<beats_per_pixel; j++) begin
        high.pixels[i] |= low.data[i*beats_per_pixel+j]<<(j*bits_per_beat);
      end
    end
    //---
    //high.pixels = new[low.data.size()](low.data);
    //---
    analysis_port.write(high);
  end
endtask : run_phase

//------------------------------------------------------------------------------
// Method: put
//------------------------------------------------------------------------------
task video_to_packet_adapter::put(HIGH high);
  LOW low;
  int idx;
  
  // control
  low = new("low");
  low.packet_type = CONTROL_PACKET;
  low.width = high.width;
  low.height = high.height;
  case(high.interlaced)
    PROGRESSIVE  : low.interlaced[3:2] = 2'b00;
    INTERLACED_F0: low.interlaced[3:2] = 2'b10;
    INTERLACED_F1: low.interlaced[3:2] = 2'b11;
    default      : low.interlaced[3:2] = 2'b01;
  endcase
  case(high.synchronization)
    SYNCH_F0       : low.interlaced[1:0] = 2'b00;
    SYNCH_F1       : low.interlaced[1:0] = 2'b01;
    SYNCH_DONT_CARE: low.interlaced[1:0] = 2'b11;
    default        : low.interlaced[1:0] = 2'b10;
  endcase
  put_port.put(low);
  // data
  low = new("low");
  low.packet_type = DATA_PACKET;
  //---
  // Note: Flexible conversion
  //---
  low.data = new[beats_per_pixel*high.pixels.size()];
  idx = 0;
  foreach(high.pixels[i]) begin
    repeat(beats_per_pixel) begin
      low.data[idx] = high.pixels[i] & mask;
      high.pixels[i] >>= bits_per_beat;
      idx++;
    end
  end
  //---
  //low.data = new[high.pixels.size()](high.pixels);
  //---
  put_port.put(low);
endtask : put

`endif /* __VIDEO_TO_PACKET_ADAPTER_SVH__ */
