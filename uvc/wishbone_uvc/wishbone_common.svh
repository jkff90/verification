//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <wishbone_common.svh> is a part of <Verification> project
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

`ifndef __WISHBONE_COMMON_SVH__
`define __WISHBONE_COMMON_SVH__

`ifndef WISHBONE_ADDRESS_WIDTH
`define WISHBONE_ADDRESS_WIDTH 32
`endif

`ifndef WISHBONE_SYMBOL_WIDTH
`define WISHBONE_SYMBOL_WIDTH 8
`endif

`ifndef WISHBONE_NUM_SYMBOLS
`define WISHBONE_NUM_SYMBOLS 4
`endif

typedef enum {
  WISHBONE_COMMAND_IDLE,
  WISHBONE_COMMAND_READ,
  WISHBONE_COMMAND_WRITE
} wishbone_command_t;
typedef bit [`WISHBONE_ADDRESS_WIDTH-1:0] wishbone_address_t;
typedef bit [`WISHBONE_SYMBOL_WIDTH*`WISHBONE_NUM_SYMBOLS-1:0] wishbone_data_t;

`endif /* __WISHBONE_COMMON_SVH__ */
