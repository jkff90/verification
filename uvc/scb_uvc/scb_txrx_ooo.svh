//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <scb_txrx_ooo.svh> is a part of <Verification> project
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

`ifndef __SCB_TXRX_OOO_SVH__
`define __SCB_TXRX_OOO_SVH__

//------------------------------------------------------------------------------
// CLASS: scb_txrx_ooo
//
// Out-of-order TX-RX scoreboard.
//------------------------------------------------------------------------------
class scb_txrx_ooo #(type TX=uvm_object, type RX=TX) extends scb_txrx_fifo #(TX, RX);
  //--- properties ---
  protected TX pending [] [scb_tag_t];
  
  //--- factory registration ---
  `uvm_component_param_utils(scb_txrx_ooo #(TX, RX))
  
  //--- methods ---
  extern function new(string name="scb_txrx_ooo", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task do_per_pair(int idx);
  extern virtual function scb_tag_t get_tx_tag(TX tx);
  extern virtual function scb_tag_t get_rx_tag(RX rx);
endclass : scb_txrx_ooo

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function scb_txrx_ooo::new(string name="scb_txrx_ooo", uvm_component parent=null);
  super.new(name,parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void scb_txrx_ooo::build_phase(uvm_phase phase);
  super.build_phase(phase);
  pending = new[cfg.num_pairs];
endfunction : build_phase

//------------------------------------------------------------------------------
// Method: do_per_pair
// Perform per-pair task based on the type of scoreboard.
//------------------------------------------------------------------------------
task scb_txrx_ooo::do_per_pair(int idx);
  fork
    begin : tx_side
      TX tx;
      scb_tag_t tag;
      
      forever begin
        tx_fifo[idx].get(tx);
        //`uvm_info(get_full_name(), $sformatf("TX[%0d] side gets transaction[%0d]: %s", idx, tx_cnt[idx], tx.convert2string()), UVM_LOW)
        tag = get_tx_tag(tx);
        if (!pending[idx].exists(tag)) pending[idx][tag] = tx;
        else `uvm_error(get_full_name(), $sformatf("TX[%0d] side gets a transaction[%0d] with existing tag=0x%X: %s", idx, tx_cnt[idx], tag, tx.convert2string()))
        tx_cnt[idx]++;
      end
    end
    begin : rx_side
      TX tx;
      RX rx;
      scb_tag_t tag;
      
      forever begin
        rx_fifo[idx].get(rx);
        //`uvm_info(get_full_name(), $sformatf("RX[%0d] side gets transaction[%0d]: %s", idx, rx_cnt[idx], rx.convert2string()), UVM_LOW)
        tag = get_rx_tag(rx);
        if (!pending[idx].exists(tag)) begin
          `uvm_error(get_full_name(), $sformatf("RX[%0d] side gets a transaction[%0d] with no coressponding tag=0x%X: %s", idx, rx_cnt[idx], tag, rx.convert2string()))
          continue;
        end
        tx = pending[idx][tag];
        verify(idx, tx, rx);
        pending[idx].delete(tag);
        rx_cnt[idx]++;
      end
    end
  join_none
endtask : do_per_pair

//------------------------------------------------------------------------------
// Function: get_tx_tag
// Get the scoreboard tag from TX transaction. This function must be implemented
// in derived class.
//------------------------------------------------------------------------------
function scb_tag_t scb_txrx_ooo::get_tx_tag(TX tx);
  return $urandom;
endfunction : get_tx_tag

//------------------------------------------------------------------------------
// Function: get_rx_tag
// Get the scoreboard tag from RX transaction by calling <get_tx_tag>.
//------------------------------------------------------------------------------
function scb_tag_t scb_txrx_ooo::get_rx_tag(RX rx);
  TX tx;
  
  assert($cast(tx, rx));
  return get_tx_tag(tx);
endfunction : get_rx_tag

`endif /* __SCB_TXRX_OOO_SVH__ */
