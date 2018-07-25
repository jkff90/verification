//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <two_sides_scb.svh> is a part of <Verification> project
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

`ifndef __TWO_SIDES_SCB_SVH__
`define __TWO_SIDES_SCB_SVH__

//------------------------------------------------------------------------------
// CLASS: two_sides_scb
//
// Scoreboard with two sides: TX and RX
//------------------------------------------------------------------------------
class two_sides_scb #(type TX=uvm_object, type RX=TX) extends uvm_component;
  //--- properties ---
  uvm_analysis_export #(TX) tx_export;
  uvm_analysis_export #(RX) rx_export;
  
  protected uvm_tlm_analysis_fifo #(TX) tx_fifo;
  protected uvm_tlm_analysis_fifo #(RX) rx_fifo;
  protected int tx_cnt;
  protected int rx_cnt;
  protected scb_config cfg;
  
  //--- factory registration ---
  `uvm_component_param_utils(two_sides_scb #(TX, RX))
  
  //--- methods ---
  extern function new(string name="two_sides_scb", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void phase_ready_to_end(uvm_phase phase);
  extern virtual function void extract_phase(uvm_phase phase);
  extern virtual function void check_phase(uvm_phase phase);
  extern virtual protected function void verify(TX tx, RX rx);
endclass : two_sides_scb

//------------------------------------------------------------------------------
// Constructor: new
//------------------------------------------------------------------------------
function two_sides_scb::new(string name="two_sides_scb", uvm_component parent=null);
  super.new(name,parent);
endfunction : new

//------------------------------------------------------------------------------
// Function: build_phase
//------------------------------------------------------------------------------
function void two_sides_scb::build_phase(uvm_phase phase);
  // Get configurations
  if(cfg == null) begin
    if(!uvm_config_db #(scb_config)::get(this, "", "cfg", cfg)) begin
      `uvm_warning(get_full_name(), "Configuration object is not set to this scoreboard, creating one with default fields.")
      cfg = scb_config::type_id::create("cfg");
    end
  end
  // Start building
  tx_export = new("tx_export", this);
  rx_export = new("rx_export", this);
  tx_fifo = new("tx_fifo", this);
  rx_fifo = new("rx_fifo", this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// Function: connect_phase
//------------------------------------------------------------------------------
function void two_sides_scb::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  tx_export.connect(tx_fifo.analysis_export);
  rx_export.connect(rx_fifo.analysis_export);
endfunction : connect_phase

//------------------------------------------------------------------------------
// Method: run_phase
//------------------------------------------------------------------------------
task two_sides_scb::run_phase(uvm_phase phase);
  TX tx;
  RX rx;
  
  super.run_phase(phase);
  forever begin
    fork
      begin : tx_side
        tx_fifo.get(tx);
        `uvm_info(get_full_name(), {"TX[%0d] side get transaction: ", tx_cnt, tx.convert2string()}, UVM_LOW)
        tx_cnt++;
      end
      begin : rx_side
        rx_fifo.get(rx);
        `uvm_info(get_full_name(), {"RX[%0d] side get transaction: ", rx_cnt, rx.convert2string()}, UVM_LOW)
        rx_cnt++;
      end
    join
    verify(tx, rx);
  end
endtask : run_phase

//------------------------------------------------------------------------------
// Function: extract_phase
//------------------------------------------------------------------------------
function void two_sides_scb::extract_phase(uvm_phase phase);
  super.extract_phase(phase);
  `uvm_info(get_full_name(), $psprintf("TX side get total %0d transaction", tx_cnt), UVM_NONE)
  `uvm_info(get_full_name(), $psprintf("RX side get total %0d transaction", rx_cnt), UVM_NONE)
endfunction : extract_phase

//------------------------------------------------------------------------------
// Function: check_phase
//------------------------------------------------------------------------------
function void two_sides_scb::check_phase(uvm_phase phase);
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
function void two_sides_scb::phase_ready_to_end(uvm_phase phase);
  if(cfg.wait_to_end) begin
    if(phase.get_name() == "run" || phase.get_name() == "main") begin
      if(tx_cnt != rx_cnt) begin
        `uvm_warning(get_full_name(), $sformatf("Transaction count on two sides are different. \
The ending of this %s phase will be delayed until they are equal.", phase.get_name()))
        phase.raise_objection(this);
        fork
          begin
            fork
              begin
                wait(tx_cnt == rx_cnt);
                phase.drop_objection(this);
              end
              begin
                #(cfg.wait_timeout);
                `uvm_fatal(get_full_name(), "Timeout while waiting last RX transaction")
              end
            join_any
            disable fork;
          end
        join_none
      end
    end
  end
endfunction : phase_ready_to_end

//------------------------------------------------------------------------------
// Function: verify
//------------------------------------------------------------------------------
function void two_sides_scb::verify(TX tx, RX rx);
  if(!tx.compare(rx)) begin
    `uvm_error(get_full_name(), $sformatf("Transaction mismatch\n- Expected: %s\n- Actual: %s",
      tx.convert2string(), rx.convert2string()))
  end
endfunction : verify

`endif /* __TWO_SIDES_SCB_SVH__ */
