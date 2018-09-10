//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <scb_txrx_fifo.svh> is a part of <Verification> project
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

`ifndef __SCB_TXRX_FIFO_SVH__
`define __SCB_TXRX_FIFO_SVH__

//------------------------------------------------------------------------------
// CLASS: scb_txrx_fifo
//
// Scoreboard with multiple two sides: TX and RX. The transactions comming in
// from RX# will be compared with the corresponding TX#.
//------------------------------------------------------------------------------
class scb_txrx_fifo #(type TX=uvm_object, type RX=TX) extends uvm_component;
  //--- properties ---
  
  // array: tx_export [];
  // TX analysis export
  uvm_analysis_export #(TX) tx_export [];
  
  // array: rx_export []
  // RX analysis export
  uvm_analysis_export #(RX) rx_export [];
  
  protected uvm_tlm_analysis_fifo #(TX) tx_fifo [];
  protected uvm_tlm_analysis_fifo #(RX) rx_fifo [];
  protected int tx_cnt [];
  protected int rx_cnt [];
  protected scb_config cfg;
  
  //--- factory registration ---
  `uvm_component_param_utils(scb_txrx_fifo #(TX, RX))
  
  //--- methods ---
  extern function new(string name="scb_txrx_fifo", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void phase_ready_to_end(uvm_phase phase);
  extern virtual function void extract_phase(uvm_phase phase);
  extern virtual task do_per_pair(int idx);
  extern virtual protected function void verify(int id, TX tx, RX rx);
endclass : scb_txrx_fifo

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function scb_txrx_fifo::new(string name="scb_txrx_fifo", uvm_component parent=null);
  super.new(name,parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void scb_txrx_fifo::build_phase(uvm_phase phase);
  // Get configurations
  if(cfg == null) begin
    if(!uvm_config_db #(scb_config)::get(this, "", "cfg", cfg)) begin
      `uvm_warning(get_full_name(), "Configuration object is not set to this scoreboard, creating one with default fields.")
      cfg = scb_config::type_id::create("cfg");
    end
  end
  // Initialize arrays
  tx_cnt = new[cfg.num_pairs];
  rx_cnt = new[cfg.num_pairs];
  tx_export = new[cfg.num_pairs];
  rx_export = new[cfg.num_pairs];
  tx_fifo = new[cfg.num_pairs];
  rx_fifo = new[cfg.num_pairs];
  // Start building
  foreach (tx_export[i]) tx_export[i] = new($sformatf("tx_export[%0d]", i), this);
  foreach (rx_export[i]) rx_export[i] = new($sformatf("rx_export[%0d]", i), this);
  foreach (tx_fifo[i]) tx_fifo[i] = new($sformatf("tx_fifo[%0d]", i), this);
  foreach (rx_fifo[i]) rx_fifo[i] = new($sformatf("rx_fifo[%0d]", i), this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void scb_txrx_fifo::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  foreach (tx_export[i]) tx_export[i].connect(tx_fifo[i].analysis_export);
  foreach (rx_export[i]) rx_export[i].connect(rx_fifo[i].analysis_export);
endfunction : connect_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task scb_txrx_fifo::run_phase(uvm_phase phase);
  super.run_phase(phase);
  for (int i = 0; i < cfg.num_pairs; i++) begin
    automatic int idx = i;
    fork
      do_per_pair(idx);
    join_none
  end
endtask : run_phase

//------------------------------------------------------------------------------
// +Function: extract_phase
//------------------------------------------------------------------------------
function void scb_txrx_fifo::extract_phase(uvm_phase phase);
  super.extract_phase(phase);
  foreach (tx_cnt[i]) begin
    `uvm_info(get_full_name(), $sformatf("TX[%0d] side gets total %0d transactions", i, tx_cnt[i]), UVM_NONE)
    `uvm_info(get_full_name(), $sformatf("RX[%0d] side gets total %0d transactions", i, rx_cnt[i]), UVM_NONE)
  end
endfunction : extract_phase

//------------------------------------------------------------------------------
// +Function: phase_ready_to_end
//------------------------------------------------------------------------------
function void scb_txrx_fifo::phase_ready_to_end(uvm_phase phase);
  if (cfg.wait_to_end) begin
    if (phase.get_name() == "run" || phase.get_name() == "main") begin
      foreach (tx_cnt[i]) begin
        automatic int idx = i;
        if (tx_cnt[idx] != rx_cnt[idx]) begin
          `uvm_warning(get_full_name(), $sformatf("Transaction count[%0d] are different: tx=%0d, rx=%0d. The ending of this %s phase will be delayed until they are equal.",
            idx, tx_cnt[idx], rx_cnt[idx], phase.get_name()))
          phase.raise_objection(this);
          fork
            begin
              fork
                begin
                  wait(tx_cnt[idx] == rx_cnt[idx]);
                  phase.drop_objection(this);
                end
                begin
                  if (cfg.wait_timeout) #(cfg.wait_timeout);
                  else wait(0); // wait forever
                  `uvm_fatal(get_full_name(), "Timeout while waiting remaining RX transactions.")
                end
              join_any
              disable fork;
            end
          join_none
        end
      end
    end
  end
endfunction : phase_ready_to_end

//------------------------------------------------------------------------------
// Method: do_per_pair
// Perform per-pair task based on the type of scoreboard.
//------------------------------------------------------------------------------
task scb_txrx_fifo::do_per_pair(int idx);
  TX tx;
  RX rx;
  
  forever begin
    fork
      begin : tx_side
        tx_fifo[idx].get(tx);
        //`uvm_info(get_full_name(), $sformatf("TX[%0d] side gets transaction[%0d]: %s", idx, tx_cnt[idx], tx.convert2string()), UVM_LOW)
        tx_cnt[idx]++;
      end
      begin : rx_side
        rx_fifo[idx].get(rx);
        //`uvm_info(get_full_name(), $sformatf("RX[%0d] side gets transaction[%0d]: %s", idx, rx_cnt[idx], rx.convert2string()), UVM_LOW)
        rx_cnt[idx]++;
      end
    join
    verify(idx, tx, rx);
  end
endtask : do_per_pair

//------------------------------------------------------------------------------
// Function: verify
// Compare TX and RX transaction using the *reflection API* _compare_.
//------------------------------------------------------------------------------
function void scb_txrx_fifo::verify(int id, TX tx, RX rx);
  if(!tx.compare(rx)) begin
    `uvm_error(get_full_name(), $sformatf("[id=%0d] Transactions[%0d] mismatch\n- Expected: %s\n- Actual: %s",
      id, rx_cnt[id], tx.convert2string(), rx.convert2string()))
  end
  else begin
    `uvm_info(get_full_name(), $sformatf("[id=%0d] Transactions[%0d] match\n- Expected: %s\n- Actual: %s",
      id, rx_cnt[id], tx.convert2string(), rx.convert2string()), UVM_LOW)
  end
endfunction : verify

`endif /* __SCB_TXRX_FIFO_SVH__ */
