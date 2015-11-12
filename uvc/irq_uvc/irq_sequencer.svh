//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <irq_sequencer.svh> is a part of <Verification> project
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

`ifndef __IRQ_SEQUENCER_SVH__
`define __IRQ_SEQUENCER_SVH__

//------------------------------------------------------------------------------
// CLASS: irq_sequencer
//
// Sequencer for irq protocol
//------------------------------------------------------------------------------
class irq_sequencer extends uvm_sequencer #(irq_transaction);
  //--- attributes ---

  // obj: _config
  // Make this visible for accessing from sequences
  irq_config _config;
  
  //--- factory registration ---
  `uvm_component_utils(irq_sequencer)
  
  //--- methods ---
  extern function new(string name="irq_sequencer", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
endclass : irq_sequencer

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function irq_sequencer::new(string name="irq_sequencer", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void irq_sequencer::build_phase(uvm_phase phase);
  assert(uvm_config_db #(irq_config)::get(this, "", "_config", _config));
  super.build_phase(phase);
endfunction : build_phase

`endif /* __IRQ_SEQUENCER_SVH__ */
