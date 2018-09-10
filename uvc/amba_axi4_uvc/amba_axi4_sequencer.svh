//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_sequencer.svh> is a part of <Verification> project
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

`ifndef __AMBA_AXI4_SEQUENCER_SVH__
`define __AMBA_AXI4_SEQUENCER_SVH__

//------------------------------------------------------------------------------
// CLASS: amba_axi4_sequencer
//
// Sequencer for amba_axi4 protocol
//------------------------------------------------------------------------------
class amba_axi4_sequencer extends uvm_sequencer #(amba_axi4_transaction);
    //--- attributes ---
    
    // obj: cfg
    // Make this visible for accessing from sequences
    amba_axi4_config cfg;
    
    //--- factory registration ---
    `uvm_component_utils(amba_axi4_sequencer)
    
    //--- methods ---
    extern function new(string name="amba_axi4_sequencer", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
endclass : amba_axi4_sequencer

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_sequencer::new(string name="amba_axi4_sequencer", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void amba_axi4_sequencer::build_phase(uvm_phase phase);
    assert(uvm_config_db #(amba_axi4_config)::get(this, "", "cfg", cfg));
    super.build_phase(phase);
endfunction : build_phase

`endif /* __AMBA_AXI4_SEQUENCER_SVH__ */
