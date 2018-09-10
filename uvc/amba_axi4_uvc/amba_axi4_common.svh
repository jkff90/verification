//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_common.svh> is a part of <Verification> project
//  Copyright (C) 2018  An Pham (anphambk@gmail.com)
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

`ifndef __AMBA_AXI4_COMMON_SVH__
`define __AMBA_AXI4_COMMON_SVH__

`ifndef AMBA_AXI4_VERSION
 `define AMBA_AXI4_VERSION "4.0"
`endif /* AMBA_AXI4_VERSION */

`ifndef AMBA_AXI4_IDW
 `define AMBA_AXI4_IDW 8
`endif /* AMBA_AXI4_IDW */

`ifndef AMBA_AXI4_ADDRW
 `define AMBA_AXI4_ADDRW 64
`endif /* AMBA_AXI4_ADDRW */

`ifndef AMBA_AXI4_DATAW
 `define AMBA_AXI4_DATAW 128
`endif /* AMBA_AXI4_DATAW */

`ifndef AMBA_AXI4_STRBW
 `define AMBA_AXI4_STRBW `AMBA_AXI4_DATAW / 8
`endif /* AMBA_AXI4_STRBW */

`ifndef AMBA_AXI4_USERW
 `define AMBA_AXI4_USERW 64
`endif /* AMBA_AXI4_USERW */

typedef enum bit {
      AMBA_AXI4_RW_READ  = 0
    , AMBA_AXI4_RW_WRITE = 1
} amba_axi4_rw_t;

typedef enum bit [1:0] {
      AMBA_AXI4_BURST_FIXED = 2'b00
    , AMBA_AXI4_BURST_INCR  = 2'b01
    , AMBA_AXI4_BURST_WRAP  = 2'b10
    , AMBA_AXI4_BURST_RSVD  = 2'b11
} amba_axi4_burst_t;

typedef enum bit [1:0] {
      AMBA_AXI4_RESP_OKAY   = 2'b00
    , AMBA_AXI4_RESP_EXOKAY = 2'b01
    , AMBA_AXI4_RESP_SLVERR = 2'b10
    , AMBA_AXI4_RESP_DECERR = 2'b11
} amba_axi4_resp_t;

typedef struct packed {
    bit privileged;
    bit secure;
    bit instruction;
} amba_axi4_prot_t;

`endif /* __AMBA_AXI4_COMMON_SVH__ */
