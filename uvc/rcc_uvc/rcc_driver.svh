//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <rcc_driver.svh> is a part of <Verification> project
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

`ifndef __RCC_DRIVER_SVH__
`define __RCC_DRIVER_SVH__

//------------------------------------------------------------------------------
// CLASS: rcc_driver
//
// Driver for Reset/Clock Controller (RCC)
//------------------------------------------------------------------------------
class rcc_driver #(int NRESET = 1) extends uvm_component;
    //--- attributes ---
    
    // obj: rcc_config
    // Configuration object
    rcc_config #(NRESET) cfg;
    
    protected semaphore smp [NRESET]; // semaphore for reset control
    protected virtual rcc_if #(NRESET) vif;
    
    //--- factory registration ---
    `uvm_component_param_utils(rcc_driver #(NRESET))
    
    //--- methods ---
    extern function new(string name="rcc_driver", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task issue_reset(int id = 0);
    extern virtual function void assign_vif(virtual rcc_if #(NRESET) vif);
endclass : rcc_driver

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function rcc_driver::new(string name="rcc_driver", uvm_component parent=null);
    super.new(name, parent);
    foreach (smp[i]) smp[i] = new(1);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void rcc_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    void'(uvm_config_db#(rcc_config #(NRESET))::get(this, "", "cfg", cfg));
    void'(uvm_config_db#(virtual rcc_if #(NRESET))::get(this, "", "vif", vif));
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: start_of_simulation_phase
//------------------------------------------------------------------------------
function void rcc_driver::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    if (cfg == null) begin
        `uvm_warning(get_full_name(), "NULL config, create one with default values")
        cfg = rcc_config #(NRESET)::type_id::create("cfg");
    end
    if (vif == null) begin
        `uvm_fatal(get_full_name(), "NULL VIF")
    end
endfunction : start_of_simulation_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task rcc_driver::run_phase(uvm_phase phase);
    real half_cycle; // to support time precision < time unit
    
    super.run_phase(phase);
    half_cycle = cfg.get_clock_cycle()/2;
    
    vif.clk <= 0;
    foreach (vif.rst[i]) vif.rst[i] <= 0;
    
    for (int i = 0; i < NRESET; i++) begin : per_reset
        automatic int id = i;
        fork
            begin : auto_reset
                #0; // delay for setting up
                if (cfg.auto_reset[id]) issue_reset(id);
            end
            forever begin : gen_reset
                @(cfg.reset_e[id]);
                issue_reset(id);
            end
        join_none
    end
    
    fork
        forever begin : gen_clock
            #half_cycle vif.clk <= ~vif.clk;
        end
    join_none
    #0;
endtask : run_phase

//------------------------------------------------------------------------------
// Method: issue_reset
// Invoke a reset based on the configuration
//------------------------------------------------------------------------------
task rcc_driver::issue_reset(int id = 0);
    if (!smp[id].try_get(1)) return; // there is another process has issued the coressponding reset
    #(cfg.reset_delay[id]);
    if (cfg.sync_reset[id]) @(posedge vif.clk);
    vif.rst[id] <= 1'b1;
    #(cfg.reset_hold[id]);
    if (cfg.sync_reset[id]) @(posedge vif.clk);
    vif.rst[id] <= 1'b0;
    smp[id].put(1);
endtask : issue_reset

//------------------------------------------------------------------------------
// Function: assign_vif
// For old style compability
//------------------------------------------------------------------------------
function void rcc_driver::assign_vif(virtual rcc_if #(NRESET) vif);
    this.vif = vif;
endfunction : assign_vif

`endif /* __RCC_DRIVER_SVH__ */
