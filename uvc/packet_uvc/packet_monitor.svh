//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <packet_monitor.svh> is a part of <Verification> project
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

`ifndef __PACKET_MONITOR_SVH__
`define __PACKET_MONITOR_SVH__

//------------------------------------------------------------------------------
// CLASS: packet_monitor
//
// Monitor for packet protocol
//------------------------------------------------------------------------------
class packet_monitor extends uvm_component;
  //--- attributes ---
  protected packet_config _config;  // protect configuration objects from external access
  
  //--- TLM ports/exports
  
  // object: analysis_port
  // Analysis port that sends monitored transactions to upper layers
  uvm_analysis_port #(packet_transaction) analysis_port;
  
  // object: analysis_export
  // Analysis port that receives transactions from lower layers
  uvm_analysis_imp #(packet_transaction, packet_monitor) analysis_export;
  
  //--- factory registration ---
  `uvm_component_utils(packet_monitor)
  
  //--- methods ---
  extern function new(string name="packet_monitor", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void write(packet_transaction trans);
  extern virtual function void monitor_unpack(ref packet_transaction trans);
endclass : packet_monitor

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function packet_monitor::new(string name="packet_monitor", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void packet_monitor::build_phase(uvm_phase phase);
  assert(uvm_config_db #(packet_config)::get(this, "", "_config", _config));
  analysis_port = new("analysis_port", this);
  analysis_export = new("analysis_export", this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: write
//------------------------------------------------------------------------------
function void packet_monitor::write(packet_transaction trans);
  // Protocol check
  monitor_unpack(trans);
  `uvm_info(get_full_name(), {"Get transaction: ", trans.convert2string()}, UVM_HIGH)
  analysis_port.write(trans);
endfunction : write

//------------------------------------------------------------------------------
// Function: monitor_unpack
// Unpack packet header for Avalon ST Video protocol
//------------------------------------------------------------------------------
function void packet_monitor::monitor_unpack(ref packet_transaction trans);
  bit [3:0] nibble;
  bit [3:0] queue [$];
  int size;
  
  case(trans.packet_type)
    CONTROL_PACKET: begin
      size = trans.data.size();
      for(int i=0; i<size; i++) begin
        if(queue.size() < 9) begin
          repeat(_config.symbols_per_beat) begin
            nibble = trans.data[i];
            trans.data[i] >>= _config.bits_per_symbol;
            queue.push_back(nibble);
          end
        end
      end
      
      trans.data.delete();
      trans.width[15:12]  = queue.pop_front();
      trans.width[11:8]   = queue.pop_front();
      trans.width[7:4]    = queue.pop_front();
      trans.width[3:0]    = queue.pop_front();
      trans.height[15:12] = queue.pop_front();
      trans.height[11:8]  = queue.pop_front();
      trans.height[7:4]   = queue.pop_front();
      trans.height[3:0]   = queue.pop_front();
      trans.interlaced    = queue.pop_front();
    end
    default: begin
    end
  endcase
endfunction

`endif /* __PACKET_MONITOR_SVH__ */
