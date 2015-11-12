//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <video_config.svh> is a part of <Verification> project
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

`ifndef __VIDEO_CONFIG_SVH__
`define __VIDEO_CONFIG_SVH__

//------------------------------------------------------------------------------
// CLASS: video_config
//
// Configuration object for video protocol
//------------------------------------------------------------------------------
class video_config extends uvm_object;
  //--- attributes ---
  
  // enum: is_active = UVM_PASSIVE
  // Decide whether the agent has the driver path (sequencer+driver)
  uvm_active_passive_enum is_active = UVM_PASSIVE;
  
  // bit: has_upper_layer = 0
  // If the protocol has upper layers, a *put_export* for layering will be created
  bit has_upper_layer = 0;
  
  // bit: has_monitor = 1
  // Decide whether the agent has the monitor
  bit has_monitor = 1;
  
  // file
  string data_name = "data";
  // record
  uvm_active_passive_enum record_active = UVM_PASSIVE;
  string record_name = "record";
  // video format info
  string fourcc = "RGB32";
  int width = 640;
  int height = 480;
  int stride = 2560; // stride = bytes_per_pixel*(width+pad)
  interlaced_t interlaced = PROGRESSIVE;
  synchronization_t synchronization = SYNCH_DONT_CARE;
  real frame_rate = 25;
  // fourcc
  int channels_per_pixel = 3;
  int bits_per_channel = 8;
  int pixels_per_word = 1;
  int channel_lsb = 0;
  
  //--- constraints ---
  
  //--- factory registration ---
  `uvm_object_utils(video_config)
  
  //--- methods ---
  extern function new(string name="video_config");
  extern virtual function void do_print(uvm_printer printer);
  extern virtual function void do_copy(uvm_object rhs);
  extern virtual function void read_config(string config_fname="");
  extern virtual function void decode_fourcc();
endclass : video_config

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function video_config::new(string name="video_config");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: do_print
//------------------------------------------------------------------------------
function void video_config::do_print(uvm_printer printer);
  printer.print_string("Agent mode", is_active.name());
  printer.print_int("Has upper layer", has_upper_layer, 1);
  printer.print_int("Has monitor", has_monitor, 1);
  printer.print_string("Data name", data_name);
  printer.print_string("Record mode", record_active.name());
  printer.print_string("Record name", record_name);
  printer.print_string("Fourcc", fourcc);
  printer.print_int("Width", width, 32);
  printer.print_int("Height", height, 32);
  printer.print_int("Stride", stride, 32);
  printer.print_string("Interlaced", interlaced.name());
  printer.print_string("Synchronization", synchronization.name());
  printer.print_real("Frame rate", frame_rate);
  printer.print_int("Channels per pixel", channels_per_pixel, 32);
  printer.print_int("Bits per channel", bits_per_channel, 32);
  printer.print_int("Pixels per word", pixels_per_word, 32);
  printer.print_int("Channel LSB", channel_lsb, 32);
endfunction : do_print

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void video_config::do_copy(uvm_object rhs);
  video_config rhs_;
  
  assert($cast(rhs_, rhs));
  is_active = rhs_.is_active;
  has_upper_layer = rhs_.has_upper_layer;
  has_monitor = rhs_.has_monitor;
  data_name = rhs_.data_name;
  record_active = rhs_.record_active;
  record_name = rhs_.record_name;
  fourcc = rhs_.fourcc;
  width = rhs_.width;
  height = rhs_.height;
  stride = rhs_.stride;
  interlaced = rhs_.interlaced;
  synchronization = rhs_.synchronization;
  frame_rate = rhs_.frame_rate;
  channels_per_pixel = rhs_.channels_per_pixel;
  bits_per_channel = rhs_.bits_per_channel;
  pixels_per_word = rhs_.pixels_per_word;
  channel_lsb = rhs_.channel_lsb;
endfunction : do_copy

//------------------------------------------------------------------------------
// Function: read_config
//------------------------------------------------------------------------------
function void video_config::read_config(string config_fname="");
  int config_fhandle;
  int error_code;
  string error_string;
  int status;
  string split [$];
  string sub_str;
  string config_string;
  real r;
  string s;
  
  if(config_fname=="") begin
    config_fname = data_name;
  end
  data_name = config_fname;
  config_fhandle = $fopen({config_fname, ".spc"}, "r");
  error_code = $ferror(config_fhandle, error_string);
  if(error_code != 0) begin
    `uvm_fatal(get_name(), $psprintf("File %s open failed, error_code=%x, error_string=%s", {config_fname, ".spc"}, error_code, error_string))
  end
  
  while(!$feof(config_fhandle)) begin
    status = $fgets(config_string, config_fhandle);
    uvm_split_string(config_string, " ", split);
    //if(split.size > 2)
    //  split[2] = split[2].substr(0, split[2].len()-3);  // remove blank lines
    if(split.size > 2) begin
      do begin  // remove blank lines
        sub_str = split[2].substr(split[2].len()-2, split[2].len()-1);
        split[2] = split[2].substr(0, split[2].len()-2);
      end while((sub_str==16'h0D0A) || (sub_str==8'h0A)); // \r\n does not work
    end
    case(split[0])
      "fourcc"    : fourcc     = split[2];
      "width"     : width      = split[2].atoi();
      "height"    : height     = split[2].atoi();
      "stride"    : stride     = split[2].atoi();
      "frame_rate": frame_rate = split[2].atoreal();
      "interlaced" : begin
        if(split[2] == "yes")
          interlaced = INTERLACED_F0;
        else
          interlaced = PROGRESSIVE;
      end
      "bottom_field_first": begin
        if(split[2] == "yes")
          interlaced = INTERLACED_F1;
        else
          interlaced = INTERLACED_F0;
      end
      default: ;
    endcase
  end
  decode_fourcc();
endfunction : read_config

//------------------------------------------------------------------------------
// Function: decode_fourcc
//------------------------------------------------------------------------------
function void video_config::decode_fourcc();
  case(fourcc)
    "RGB32","IYU2": begin
      channels_per_pixel = 3;
      pixels_per_word    = 1;
      bits_per_channel   = 8;
      channel_lsb        = 0;
    end 
    "YUY2": begin
      channels_per_pixel = 2;
      pixels_per_word    = 2;
      bits_per_channel   = 8;
      channel_lsb        = 0;
    end
    "Y410", "A2R10G10B10": begin
      channels_per_pixel = 3;
      pixels_per_word    = 1;
      bits_per_channel   = 10;
      channel_lsb        = 0;
    end
    "Y210": begin
      channels_per_pixel = 2;
      pixels_per_word    = 1;
      bits_per_channel   = 10;
      channel_lsb        = 6;
    end
    default: ;
  endcase
endfunction : decode_fourcc

`endif /* __VIDEO_CONFIG_SVH__ */
