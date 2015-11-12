//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <video_common.svh> is a part of <Verification> project
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

`ifndef __VIDEO_COMMON_SVH__
`define __VIDEO_COMMON_SVH__

typedef enum bit [1:0]{
  PROGRESSIVE           = 2'b00,
  INTERLACED_F0         = 2'b10,
  INTERLACED_F1         = 2'b11,
  INTERLACED_DONT_KNOW  = 2'b01
} interlaced_t;

typedef enum bit [1:0] {
  SYNCH_F0        = 2'b00,
  SYNCH_F1        = 2'b01,
  SYNCH_DONT_CARE = 2'b11,
  SYNCH_DONT_KNOW = 2'b10
} synchronization_t;


//------------------------------------------------------------------------------
// Function: video_open_data
//------------------------------------------------------------------------------
function automatic int video_open_data(string fname);
  int fhandle;
  int error_code;
  string error_string;
  
  fhandle = $fopen(fname, "rb");
  error_code = $ferror(fhandle, error_string);
  if(error_code != 0) begin
    `uvm_fatal("VIDEO", $psprintf("File %s open failed, error_code=%x, error_string=%s", fname, error_code, error_string))
  end
  return fhandle;
endfunction : video_open_data

//------------------------------------------------------------------------------
// Function: video_read_data
//------------------------------------------------------------------------------
function automatic bit video_read_data(int fhandle, ref int pixels [], int pixels_per_word);
  int frame_size;
  int status;
  int word;
  int pixels_cnt;
  int bits_per_pixel;
  int mask;
  int shifted;
  
  frame_size = pixels.size();
  if(frame_size == 0) begin
    `uvm_fatal("VIDEO", "Zero frame size!")
  end
  if(32%pixels_per_word != 0) begin
    `uvm_fatal("VIDEO", "Invalid pixels_per_word!")
  end
  bits_per_pixel = 32/pixels_per_word;
  mask = (1<<bits_per_pixel)-1;
  pixels_cnt = 0;
  do begin
    if($feof(fhandle)) begin
      `uvm_warning("VIDEO", $psprintf("File descriptor %d EOF!", fhandle))
      return 1;
    end
    status = $fread(word, fhandle);
    for(int i=pixels_per_word-1; i>=0; i--) begin
      shifted = word>>(i*bits_per_pixel);
      pixels[pixels_cnt] = shifted&mask;
      pixels_cnt++;
    end
  end while(pixels_cnt<frame_size);
  return 0;
endfunction : video_read_data

`endif /* __VIDEO_COMMON_SVH__ */
