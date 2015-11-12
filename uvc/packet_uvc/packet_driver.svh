//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <packet_driver.svh> is a part of <Verification> project
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

`ifndef __PACKET_DRIVER_SVH__
`define __PACKET_DRIVER_SVH__

//------------------------------------------------------------------------------
// CLASS: packet_driver
//
// Driver for packet protocol
//------------------------------------------------------------------------------
class packet_driver extends uvm_driver #(packet_transaction);
  //--- attributes ---
  protected packet_config _config; // protect configuration objects from external access
  
  //--- TLM ports/exports ---
  
  // object: put_port
  // Blocking put port to send transactions to one lower layers. Please take a
  // note that a TLM *put_port* is only able to connect with one *put_export*
  uvm_blocking_put_port #(packet_transaction) put_port;
  
  //--- factory registration ---
  `uvm_component_utils(packet_driver)
  
  //--- methods ---
  extern function new(string name="packet_driver", uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void driver_pack(ref packet_transaction trans);
endclass : packet_driver

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function packet_driver::new(string name="packet_driver", uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void packet_driver::build_phase(uvm_phase phase);
  assert(uvm_config_db #(packet_config)::get(this, "", "_config", _config));
  put_port = new("put_port", this);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task packet_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    seq_item_port.get_next_item(req);
    driver_pack(req);
    put_port.put(req);
    `uvm_info(get_full_name(), {"Sent transaction: ", req.convert2string()}, UVM_HIGH)
    seq_item_port.item_done();
  end
endtask : run_phase

//------------------------------------------------------------------------------
// Function: driver_pack
// Pack the header for Avalon ST Video protocol
//------------------------------------------------------------------------------
function void packet_driver::driver_pack(ref packet_transaction trans);
  bit [3:0] nibble;
  bit [3:0] queue [$];
  int size;
  
  case(trans.packet_type)
    CONTROL_PACKET: begin
      queue.push_back(trans.width[15:12] );
      queue.push_back(trans.width[11:8]  );
      queue.push_back(trans.width[7:4]   );
      queue.push_back(trans.width[3:0]   );
      queue.push_back(trans.height[15:12]);
      queue.push_back(trans.height[11:8] );
      queue.push_back(trans.height[7:4]  );
      queue.push_back(trans.height[3:0]  );
      queue.push_back(trans.interlaced   );
      
      trans.data.delete();
      if(9%_config.symbols_per_beat == 0)
        size = 9/_config.symbols_per_beat;
      else
        size = 9/_config.symbols_per_beat+1;
      trans.data = new[size];
      foreach(trans.data[i]) begin
        for(int j=0; j<_config.symbols_per_beat; j++) begin
          if(queue.size() > 0) begin
            nibble = queue.pop_front();
            trans.data[i] |= nibble << (j*_config.bits_per_symbol);
          end
        end
      end
    end
    default: begin
    end
  endcase
endfunction : driver_pack

`endif /* __PACKET_DRIVER_SVH__ */
