//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_agent.svh> is a part of <Verification> project
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

`ifndef __AMBA_AXI4_AGENT_SVH__
`define __AMBA_AXI4_AGENT_SVH__

//------------------------------------------------------------------------------
// CLASS: amba_axi4_agent
//
// Agent for amba_axi4 protocol
//------------------------------------------------------------------------------
class amba_axi4_agent extends uvm_agent;
    //--- attributes ---
    
    // object: cfg
    // Configuration object for this agent
    amba_axi4_config cfg;
    
    // object: adapter
    // Adapter to AXI IF
    amba_axi4_adapter adapter;
    
    //--- TLM ports/exports ---
    
    // object: put_export
    // Blocking put export to one upper layer. If you want to connect to multiple
    // upper layers, please define a new TLM type.
    uvm_blocking_put_imp #(amba_axi4_transaction, amba_axi4_agent) put_export;
    
    // object: analysis_port
    // Analysis port to upper layers
    uvm_analysis_port #(amba_axi4_transaction) analysis_port;
    
    //--- children ---
    /*protected*/ amba_axi4_driver driver;   // user should not access to driver directly
    /*protected*/ amba_axi4_monitor monitor; // user should not access to monitor directly
    
    // object: sequencer
    // UVM sequencer for <amba_axi4_transaction> type
    amba_axi4_sequencer sequencer;
    
    // object: coverage
    // Coverage collector for <amba_axi4_transaction> type
    amba_axi4_coverage coverage;
    
    //--- factory registration ---
    `uvm_component_utils(amba_axi4_agent)
    
    //--- methods ---
    extern function new(string name="amba_axi4_agent", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual task put(amba_axi4_transaction t);
endclass : amba_axi4_agent

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_agent::new(string name="amba_axi4_agent", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void amba_axi4_agent::build_phase(uvm_phase phase);
    // Get configurations
    if (cfg == null) begin
        if (!uvm_config_db #(amba_axi4_config)::get(this, "", "cfg", cfg)) begin
            `uvm_warning(get_full_name(), "Configuration object is not set to this agent, creating one with default fields.")
            cfg = amba_axi4_config::type_id::create("cfg");
        end
    end
    if (adapter == null) begin
        if (!uvm_config_db #(amba_axi4_adapter)::get(this, "", "adapter", adapter)) begin
            `uvm_fatal(get_full_name(), "Adapter to interface is not assigned to this agent.")
        end
    end
    // Start building
    if (cfg.is_active == UVM_ACTIVE) begin
        sequencer = amba_axi4_sequencer::type_id::create("sequencer", this);
        driver = amba_axi4_driver::type_id::create("driver", this);
    end
    if (cfg.has_monitor == 1'b1) begin
        monitor = amba_axi4_monitor::type_id::create("monitor", this);
        if (cfg.enable_coverage == 1'b1) begin
            coverage = amba_axi4_coverage::type_id::create("coverage", this);
        end
    end
    if (cfg.has_upper_layer == 1'b1) begin
        put_export = new("put_export", this);
    end
    analysis_port = new("analysis_port", this);
    // Set configurations
    if (cfg.is_active == UVM_ACTIVE) begin
        uvm_config_db #(amba_axi4_config)::set(this, "sequencer", "cfg", cfg);
        uvm_config_db #(amba_axi4_config)::set(this, "driver", "cfg", cfg);
        uvm_config_db #(amba_axi4_adapter)::set(this, "driver", "adapter", adapter);
    end
    if (cfg.has_monitor == 1'b1) begin
        uvm_config_db #(amba_axi4_config)::set(this, "monitor", "cfg", cfg);
        uvm_config_db #(amba_axi4_adapter)::set(this, "monitor", "adapter", adapter);
        if (cfg.enable_coverage == 1'b1) begin
            uvm_config_db #(amba_axi4_config)::set(this, "coverage", "cfg", cfg);
        end
    end
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void amba_axi4_agent::connect_phase(uvm_phase phase);
    if (cfg.is_active == UVM_ACTIVE) begin
        driver.seq_item_port.connect(sequencer.seq_item_export);
    end
    if (cfg.has_monitor == 1'b1) begin
        monitor.analysis_port.connect(analysis_port);
        if (cfg.enable_coverage == 1'b1) begin
            monitor.analysis_port.connect(coverage.analysis_export);
        end
    end
endfunction : connect_phase

//------------------------------------------------------------------------------
// +Function: start_of_simulation_phase
//------------------------------------------------------------------------------
function void amba_axi4_agent::start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf("Printing configuration:\n%s", cfg.sprint()), UVM_LOW)
endfunction : start_of_simulation_phase

//------------------------------------------------------------------------------
// +Method: put
//------------------------------------------------------------------------------
task amba_axi4_agent::put(amba_axi4_transaction t);
    sequencer.execute_item(t);
endtask : put

`endif /* __AMBA_AXI4_AGENT_SVH__ */
