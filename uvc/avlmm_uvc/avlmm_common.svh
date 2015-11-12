//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlmm_common.svh> is a part of <Verification> project
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

`ifndef __AVLMM_COMMON_SVH__
`define __AVLMM_COMMON_SVH__

`ifndef AVLMM_ADDRESS_WIDTH
`define AVLMM_ADDRESS_WIDTH 32
`endif

`ifndef AVLMM_SYMBOL_WIDTH
`define AVLMM_SYMBOL_WIDTH 8
`endif

`ifndef AVLMM_NUM_SYMBOLS
`define AVLMM_NUM_SYMBOLS 4
`endif

typedef enum int {
  AVLMM_READ_REQUEST ,
  AVLMM_WRITE_REQUEST
} avlmm_request_t;
typedef bit [`AVLMM_ADDRESS_WIDTH-1:0] avlmm_address_t;
typedef bit [`AVLMM_SYMBOL_WIDTH*`AVLMM_NUM_SYMBOLS-1:0] avlmm_data_t;
typedef bit [`AVLMM_NUM_SYMBOLS-1:0] avlmm_byte_enable_t;

`endif /* __AVLMM_COMMON_SVH__ */
