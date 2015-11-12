//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlst_common.svh> is a part of <Verification> project
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

`ifndef __AVLST_COMMON_SVH__
`define __AVLST_COMMON_SVH__

`ifndef AVLST_SYMBOL_WIDTH
`define AVLST_SYMBOL_WIDTH 8
`endif

`ifndef AVLST_NUM_SYMBOLS
`define AVLST_NUM_SYMBOLS 4
`endif

`ifndef AVLST_CHANNEL_WIDTH
`define AVLST_CHANNEL_WIDTH 8
`endif

`ifndef AVLST_EMPTY_WIDTH
`define AVLST_EMPTY_WIDTH 4
`endif

`ifndef AVLST_ERROR_WIDTH
`define AVLST_ERROR_WIDTH 4
`endif

typedef bit [`AVLST_SYMBOL_WIDTH*`AVLST_NUM_SYMBOLS-1:0] avlst_data_t;
typedef bit [`AVLST_CHANNEL_WIDTH-1:0] avlst_channel_t;
typedef bit [`AVLST_EMPTY_WIDTH-1:0] avlst_empty_t;
typedef bit [`AVLST_ERROR_WIDTH-1:0] avlst_error_t;

`endif /* __AVLST_COMMON_SVH__ */
