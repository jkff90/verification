//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <multi_two_sides_scb.svh> is a part of <Verification> project
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

`ifndef __MULTI_TWO_SIDES_SCB_SVH__
`define __MULTI_TWO_SIDES_SCB_SVH__

//------------------------------------------------------------------------------
// CLASS: multi_two_sides_scb
//
// Scoreboard with multiple two sides: TX and RX
//------------------------------------------------------------------------------
class multi_two_sides_scb #(type TX=uvm_object, type RX=TX) extends uvm_component;
  //--- properties ---
  uvm_analysis_export #(TX) tx_export [];
  uvm_analysis_export #(RX) rx_export [];
  
  protected uvm_tlm_analysis_fifo #(TX) tx_fifo [];
  protected uvm_tlm_analysis_fifo #(RX) rx_fifo [];
  protected int tx_cnt [];
  protected int rx_cnt [];
  protected scb_config _config;
  
  //--- factory registration ---
  `uvm_component_param_utils(multi_two_sides_scb #(TX, RX))
  
  //--- methods ---
  extern function new(string name="multi_two_sides_scb", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void phase_ready_to_end(uvm_phase phase);
  extern virtual function void extract_phase(uvm_phase phase);
  extern virtual function void check_phase(uvm_phase phase);
  extern virtual protected function void verify(TX tx, RX rx);
endclass : multi_two_sides_scb

//------------------------------------------------------------------------------
// Constructor: new
//------------------------------------------------------------------------------
function multi_two_sides_scb::new(string name="multi_two_sides_scb", uvm_component parent=null);
  super.new(name,parent);
endfunction : new

//------------------------------------------------------------------------------
// Function: build_phase
//------------------------------------------------------------------------------
function void multi_two_sides_scb::build_phase(uvm_phase phase);
  // Get configurations
  if(_config == null) begin
    if(!uvm_config_db #(scb_config)::get(this, "", "_config", _config)) begin
      `uvm_warning(get_full_name(), "Configuration object is not set to this scoreboard, creating one with default fields.")
      _config = scb_config::type_id::create("_config");
    end
  end
  // Initialize arrays
  tx_cnt = new[_config.num_pairs];
  rx_cnt = new[_config.num_pairs];
  tx_export = new[_config.num_pairs];
  rx_export = new[_config.num_pairs];
  tx_fifo = new[_config.num_pairs];
  rx_fifo = new[_config.num_pairs];
  // Start building
  foreach (tx_export[i]) tx_export[i] = new($sformatf("tx_export[%0d]", i), this);
  foreach (rx_export[i]) rx_export[i] = new($sformatf("rx_export[%0d]", i), this);
  foreach (tx_fifo[i]) tx_fifo[i] = new($sformatf("tx_fifo[%0d]", i), this);
  foreach (rx_fifo[i]) rx_fifo[i] = new($sformatf("rx_fifo[%0d]", i), this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// Function: connect_phase
//------------------------------------------------------------------------------
function void multi_two_sides_scb::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  foreach (tx_export[i]) tx_export[i].connect(tx_fifo[i].analysis_export);
  foreach (rx_export[i]) rx_export[i].connect(rx_fifo[i].analysis_export);
endfunction : connect_phase

//------------------------------------------------------------------------------
// Method: run_phase
//------------------------------------------------------------------------------
task multi_two_sides_scb::run_phase(uvm_phase phase);
  TX tx [];
  RX rx [];
  
  tx = new[_config.num_pairs];
  rx = new[_config.num_pairs];
  super.run_phase(phase);
  forever begin
    for (int i = 0; i < _config.num_pairs; i++) begin
      automatic int idx = i;
      fork
        begin : per_pair
          fork
            begin : tx_side
              tx_fifo[idx].get(tx[idx]);
              `uvm_info(get_full_name(), {"TX[%0d][%0d] side get transaction: ", idx, tx_cnt[idx], tx[idx].convert2string()}, UVM_LOW)
              tx_cnt[idx]++;
            end
            begin : rx_side
              rx_fifo[idx].get(rx[idx]);
              `uvm_info(get_full_name(), {"RX[%0d][%0d] side get transaction: ", idx, rx_cnt[idx], rx[idx].convert2string()}, UVM_LOW)
              rx_cnt[idx]++;
            end
          join
          verify(tx[idx], rx[idx]);
        end
      join_none
    end
  end
endtask : run_phase

//------------------------------------------------------------------------------
// Function: extract_phase
//------------------------------------------------------------------------------
function void multi_two_sides_scb::extract_phase(uvm_phase phase);
  super.extract_phase(phase);
  `uvm_info(get_full_name(), $psprintf("TX side get total %0d transaction", tx_cnt), UVM_NONE)
  `uvm_info(get_full_name(), $psprintf("RX side get total %0d transaction", rx_cnt), UVM_NONE)
endfunction : extract_phase

//------------------------------------------------------------------------------
// Function: check_phase
//------------------------------------------------------------------------------
function void multi_two_sides_scb::check_phase(uvm_phase phase);
  uvm_report_server srvr;
  
  super.check_phase(phase);
  //srvr = get_report_server(); // 1.1d
  srvr = uvm_report_server::get_server(); // 1.2, all the UVM features are accessed via UVM coresevice
  if(srvr.get_severity_count(UVM_ERROR)) begin
    $display("%c[1;31m",27);
    $display("||=====================================||");
    $display("||             TEST FAILED             ||");
    $display("||=====================================||");
    $display("%c[0m",27);
  end
  else begin
    $write("%c[1;34m",27); 
    $display("||=====================================||");
    $display("||             TEST PASSED             ||");
    $display("||=====================================||");
    $write("%c[0m",27);
  end
endfunction : check_phase

//------------------------------------------------------------------------------
// Function: phase_ready_to_end
//------------------------------------------------------------------------------
function void multi_two_sides_scb::phase_ready_to_end(uvm_phase phase);
  if(_config.wait_to_end) begin
    if(phase.get_name() == "run" || phase.get_name() == "main") begin
      foreach (tx_cnt[i]) begin
        automatic int idx = i;
        if (tx_cnt[idx] != rx_cnt[idx]) begin
          `uvm_warning(get_full_name(), $sformatf("Transaction count on two sides are different. The ending of this %s phase will be delayed until they are equal.", phase.get_name()))
          phase.raise_objection(this);
          fork
            begin
              fork
                begin
                  wait(tx_cnt[idx] == rx_cnt[idx]);
                  phase.drop_objection(this);
                end
                begin
                  #(_config.wait_timeout);
                  `uvm_fatal(get_full_name(), "Timeout while waiting last RX transaction")
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
// Function: verify
//------------------------------------------------------------------------------
function void multi_two_sides_scb::verify(TX tx, RX rx);
  if(!tx.compare(rx)) begin
    `uvm_error(get_full_name(), $sformatf("Transaction mismatch\n- Expected: %s\n- Actual: %s",
      tx.convert2string(), rx.convert2string()))
  end
endfunction : verify

`endif /* __MULTI_TWO_SIDES_SCB_SVH__ */
