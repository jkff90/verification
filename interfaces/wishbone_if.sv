//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <wishbone_if.svh> is a part of <Verification> project
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

// INTERFACE: wishbone_if
// Wishbone interface from OpenCore,
// see <~HERE~ at http://cdn.opencores.org/downloads/wbspec_b4.pdf> for more detail
//
// Note:
//   + This interface is designed for Wishbone Slave (function call)
//   + *data_i, dat_o, tgd_i, tgd_o* are the only signals whose name still have the suffixes *_i, _o*
//   + Only support standard Wishbone protocol mode
//   + Does not support select (byte enable)
//   + A simplified version of WB is <SBA at http://en.wikipedia.org/wiki/Simple_Bus_Architecture>
//
// Common Wishbone connection:
// (see wishbone_interface.png)

interface wishbone_if (
    input logic clk,
    input logic rst
  );
  //------------------------------------
  // SECTION: Parameter
  //------------------------------------
  
  // const: WB_ADDRESS_W
  // Wishbone address width
  parameter int WB_ADDRESS_W = 8;
  
  // const: WB_WORD_W
  // Wishbone word width
  parameter int WB_WORD_W = 8;
  
  parameter int WB_SEL_W          = 1;
  parameter int WB_DATA_TAG_W     = 1;
  parameter int WB_ADDRESS_TAG_W  = 1;
  parameter int WB_CYCLE_TAG_W    = 1;
  
  //--- local ---
  localparam WB_DATA_W = WB_WORD_W*WB_SEL_W;
  
  
  //------------------------------------
  // SECTION: Properties
  //------------------------------------
  function int _linex(input int width);
    _linex = (width > 0)?(width-1):0;
  endfunction : _linex
  
  //--- essential ---
  
  // bit: adr
  // Wishbone address bus
  logic [_linex(WB_ADDRESS_W):0] adr;
  
  // bit: dat_i
  // Wishbone data bus from master to slave
  logic [_linex(WB_DATA_W):0] dat_i;
  
  // bit: dat_o
  // Wishbone data bus from slave to master
  logic [_linex(WB_DATA_W):0] dat_o;
  
  // bit: ack
  // Wishbone acknowledgement pin
  logic ack;
  
  // bit: stb
  // Wishbone strobe pin
  logic stb;
  
  // bit: we
  // Wishbone write enable pin
  logic we;
  
  //--- optional ---
  
  // bit: cyc
  // Wishbone cycle pin
  logic cyc;
  
  logic [_linex(WB_SEL_W):0]         sel;
  logic                              stall;
  logic                              err;
  logic                              lock;
  logic                              rty;
  logic [_linex(WB_ADDRESS_TAG_W):0] tga;
  logic [_linex(WB_DATA_TAG_W):0]    tgd_i;
  logic [_linex(WB_DATA_TAG_W):0]    tgd_o;
  logic [_linex(WB_CYCLE_TAG_W):0]   tgc;
  
  // prop: master
  // Master modport
  modport master (
    output adr   ,
    input  dat_i ,
    output dat_o ,
    input  ack   ,
    output stb   ,
    output we    ,
    output cyc   ,
    output sel   ,
    input  stall ,
    output err   ,
    output lock  ,
    input  rty   ,
    output tga   ,
    input  tgd_i ,
    output tgd_o ,
    output tgc   
  );
  
  // prop: slave
  // Slave modport
  modport slave (
    input  adr   ,
    output dat_i ,
    input  dat_o ,
    output ack   ,
    input  stb   ,
    input  we    ,
    input  cyc   ,
    input  sel   ,
    output stall ,
    input  err   ,
    input  lock  ,
    output rty   ,
    input  tga   ,
    output tgd_i ,
    input  tgd_o ,
    input  tgc   
  );
  
  //------------------------------------
  // SECTION: Processes
  //------------------------------------
  
endinterface : wishbone_if
