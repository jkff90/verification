//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <packet_to_avlst_adapter.svh> is a part of <Verification> project
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

`ifndef __PACKET_TO_AVLST_ADAPTER_SVH__
`define __PACKET_TO_AVLST_ADAPTER_SVH__

//------------------------------------------------------------------------------
// Class: packet_to_avlst_adapter
//------------------------------------------------------------------------------
class packet_to_avlst_adapter extends adapter_base #(packet_transaction, avlst_transaction);
  //--- properties ---
  uvm_blocking_put_imp #(HIGH, packet_to_avlst_adapter) put_imp;
  uvm_tlm_analysis_fifo #(LOW) analysis_fifo;
  
  //--- factory registration ---
  `uvm_component_utils(packet_to_avlst_adapter)
  
  //--- methods ---
  extern function new(string name="packet_to_avlst_adapter", uvm_component parent=null);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task put(HIGH high);
endclass : packet_to_avlst_adapter

//------------------------------------------------------------------------------
// Constructor: new
//------------------------------------------------------------------------------
function packet_to_avlst_adapter::new(string name="packet_to_avlst_adapter", uvm_component parent=null);
  super.new(name, parent);
  put_imp = new("put_imp", this);
  analysis_fifo = new("analysis_fifo", this);
endfunction : new

//------------------------------------------------------------------------------
// Function: connect_phase
//------------------------------------------------------------------------------
function void packet_to_avlst_adapter::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  put_export.connect(put_imp);
  analysis_export.connect(analysis_fifo.analysis_export);
endfunction : connect_phase

//------------------------------------------------------------------------------
// Method: run_phase
//------------------------------------------------------------------------------
task packet_to_avlst_adapter::run_phase(uvm_phase phase);
  HIGH high;
  LOW low;
  int queue [$];
  
  super.run_phase(phase);
  forever begin
    high = new("high");
    do begin
      analysis_fifo.get(low);
      if(low.endofpacket == 1) begin
        `uvm_error(get_full_name(), "Missing start of packet")
      end
    end while(low.startofpacket == 0);
    case(low.data)
      15              : high.packet_type = CONTROL_PACKET  ;
      0               : high.packet_type = DATA_PACKET     ;
      13              : high.packet_type = ANCILLARY_PACKET;
      1,2,3,4,5,6,7,8 : high.packet_type = USER_PACKET     ;
      default         : high.packet_type = RAW_PACKET      ;
    endcase
    do begin
      analysis_fifo.get(low);
      if(low.startofpacket == 1) begin
        `uvm_error(get_full_name(), "Multiple start of packet")
      end
      queue.push_back(low.data);
    end while(low.endofpacket == 0);
    high.data = new[queue.size()];
    foreach(high.data[i]) begin
      high.data[i] = queue.pop_front();
    end
    analysis_port.write(high);
  end
endtask : run_phase

//------------------------------------------------------------------------------
// Method: put
//------------------------------------------------------------------------------
task packet_to_avlst_adapter::put(HIGH high);
  LOW low;
  int size;
  int i;
  
  size = high.data.size();
  if(high.packet_type == RAW_PACKET) begin
    low = new("low");
    low.startofpacket = 1;
    low.data = high.data[0];
    put_port.put(low);
    for(i=1; i<(size-1); i++) begin
      low = new("low");
      low.data = high.data[i];
      put_port.put(low);
    end
    low = new("low");
    low.endofpacket = 1;
    low.data = high.data[i];
    put_port.put(low);
    return;
  end
  
  low = new("low");
  low.startofpacket = 1;
  case(high.packet_type)
    CONTROL_PACKET: begin
      low.data = 15;
    end
    DATA_PACKET: begin
      low.data = 0;
    end
    USER_PACKET: begin
      low.data = $urandom_range(1,8);
    end
    ANCILLARY_PACKET: begin
      low.data = 13;
    end
    default: begin
    end
  endcase
  put_port.put(low);
  
  for(i=0; i<(size-1); i++) begin
    low = new("low");
    low.data = high.data[i];
    put_port.put(low);
  end
  
  low = new("low");
  low.endofpacket = 1;
  low.data = high.data[i];
  put_port.put(low);
endtask : put

`endif /* __PACKET_TO_AVLST_ADAPTER_SVH__ */
