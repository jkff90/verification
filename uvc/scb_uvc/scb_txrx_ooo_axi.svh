//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <scb_txrx_ooo_axi.svh> is a part of <Verification> project
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

`ifndef __SCB_TXRX_OOO_AXI_SVH__
`define __SCB_TXRX_OOO_AXI_SVH__

//------------------------------------------------------------------------------
// CLASS: scb_txrx_ooo_axi
//
// Out-of-order TX-RX scoreboard.
//------------------------------------------------------------------------------
class scb_txrx_ooo_axi extends scb_txrx_ooo #(amba_axi4_transaction);
    //--- factory registration ---
    `uvm_component_utils(scb_txrx_ooo_axi)

    //--- methods ---
    extern function new(string name="scb_txrx_ooo_axi", uvm_component parent=null);
    extern virtual function scb_tag_t get_tx_tag(amba_axi4_transaction tx);
endclass : scb_txrx_ooo_axi

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function scb_txrx_ooo_axi::new(string name="scb_txrx_ooo_axi", uvm_component parent=null);
    super.new(name,parent);
endfunction : new

//------------------------------------------------------------------------------
// Function: get_tx_tag
//------------------------------------------------------------------------------
function scb_tag_t scb_txrx_ooo_axi::get_tx_tag(amba_axi4_transaction tx);
    return tx.addr;
endfunction : get_tx_tag

`endif /* __SCB_TXRX_OOO_AXI_SVH__ */
