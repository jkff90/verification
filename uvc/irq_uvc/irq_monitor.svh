//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <irq_monitor.svh> is a part of <Verification> project
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

`ifndef __IRQ_MONITOR_SVH__
`define __IRQ_MONITOR_SVH__

//------------------------------------------------------------------------------
// CLASS: irq_monitor
//
// Monitor for irq protocol
//------------------------------------------------------------------------------
class irq_monitor extends uvm_component;
  //--- attributes ---
  protected irq_config _config;  // protect configuration objects from external access
  protected virtual irq_if _vif; // protect interface from external access
  
  //--- TLM ports/exports
  
  // object: analysis_port
  // Analysis port that sends monitored transactions to upper layers
  uvm_analysis_port #(irq_transaction) analysis_port;
  
  //--- factory registration ---
  `uvm_component_utils(irq_monitor)
  
  //--- methods ---
  extern function new(string name="irq_monitor", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : irq_monitor

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function irq_monitor::new(string name="irq_monitor", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void irq_monitor::build_phase(uvm_phase phase);
  assert(uvm_config_db #(irq_config)::get(this, "", "_config", _config));
  assert(uvm_config_db #(virtual irq_if)::get(this, "", "_vif", _vif));
  analysis_port = new("analysis_port", this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task irq_monitor::run_phase(uvm_phase phase);
  irq_transaction trans;
  
  super.run_phase(phase);
  forever begin
    trans = irq_transaction::type_id::create("trans");
    // Monitor signals
    case(_config.sense)
      IRQ_SENSE_HIGH: begin
        @(posedge _vif.clk iff( _vif.irq === 1'b1));
      end
      IRQ_SENSE_LOW: begin
        @(posedge _vif.clk iff( _vif.irq === 1'b0));
      end
      IRQ_SENSE_POSEGDE: begin
        @(posedge _vif.irq );
      end
      IRQ_SENSE_NEGEDGE: begin
        @(negedge _vif.irq);
      end
      IRQ_SENSE_BOTHEDGE: begin
        //@(edge _vif.irq); // @edge for interface is not yet supported by IUS 12.2
        @(posedge _vif.irq, negedge _vif.irq);
      end
      default: begin
        `uvm_fatal(get_full_name(),"Unsupported IRQ sense type!")
      end
    endcase
    trans.sense = _config.sense;
    `uvm_info(get_full_name(), {"Get transaction: ", trans.convert2string()}, UVM_HIGH)
    analysis_port.write(trans);
  end
endtask : run_phase

`endif /* __IRQ_MONITOR_SVH__ */
