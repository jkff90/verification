//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlst_source_bfm_wrapper.sv> is a part of <Verification> project
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

module avlst_source_bfm_wrapper (
 	input clk,
	input reset,
	altera_avalon_st_if aso
  );
  import avalon_utilities_pkg::*;
  import uvm_pkg::*;
  import uvc_pkg::*;
  
  parameter ST_SYMBOL_W       = 8;
  parameter ST_NUMSYMBOLS     = 4;
  parameter ST_CHANNEL_W      = 0;
  parameter ST_ERROR_W        = 0;
  parameter ST_EMPTY_W        = 0;
  
  parameter ST_READY_LATENCY  = 1;
  parameter ST_MAX_CHANNELS   = 1;
  
  parameter USE_PACKET        = 0;
  parameter USE_CHANNEL       = 0;
  parameter USE_ERROR         = 0;
  parameter USE_READY         = 1;
  parameter USE_VALID         = 1;
  parameter USE_EMPTY         = 0;
  parameter ST_BEATSPERCYCLE  = 1;  // Max number of packets per cycle
  parameter ST_MAX_PACKET_SIZE = 1; // Max number of packet size covered
  
  altera_avalon_st_if #(
    .ST_SYMBOL_W  (ST_SYMBOL_W  ),
    .ST_NUMSYMBOLS(ST_NUMSYMBOLS),
    .ST_CHANNEL_W (ST_CHANNEL_W ),
    .ST_ERROR_W   (ST_ERROR_W   ),
    .ST_EMPTY_W   (ST_EMPTY_W   ),
    .USE_PACKET   (USE_PACKET   ),
    .USE_CHANNEL  (USE_CHANNEL  ),
    .USE_ERROR    (USE_ERROR    ),
    .USE_READY    (USE_READY    ),
    .USE_VALID    (USE_VALID    ),
    .USE_EMPTY    (USE_EMPTY    ) 
  ) asi (
    .clk  (clk  ),
    .reset(reset)
  );
  
  altera_avalon_st_source_bfm #(
    .ST_SYMBOL_W     (ST_SYMBOL_W     ),
    .ST_NUMSYMBOLS   (ST_NUMSYMBOLS   ),
    .ST_CHANNEL_W    (ST_CHANNEL_W    ),
    .ST_ERROR_W      (ST_ERROR_W      ),
    .ST_EMPTY_W      (ST_EMPTY_W      ),
    .ST_MAX_CHANNELS (ST_MAX_CHANNELS ),
    .ST_READY_LATENCY(ST_READY_LATENCY),
    .USE_PACKET      (USE_PACKET      ),
    .USE_CHANNEL     (USE_CHANNEL     ),
    .USE_ERROR       (USE_ERROR       ),
    .USE_READY       (USE_READY       ),
    .USE_VALID       (USE_VALID       ),
    .USE_EMPTY       (USE_EMPTY       ) 
  ) source_bfm (
    .clk               (clk              ),
    .reset             (reset            ),
    .src_data          (asi.data         ),
    .src_channel       (asi.channel      ),
    .src_error         (asi.error        ),
    .src_empty         (asi.empty        ),
    .src_valid         (asi.valid        ),
    .src_startofpacket (asi.startofpacket),
    .src_endofpacket   (asi.endofpacket  ),
    .src_ready         (asi.ready        )
  );
  
  altera_avalon_st_monitor #(
    .ST_SYMBOL_W       (ST_SYMBOL_W       ),
    .ST_NUMSYMBOLS     (ST_NUMSYMBOLS     ),
    .ST_CHANNEL_W      (ST_CHANNEL_W      ),
    .ST_ERROR_W        (ST_ERROR_W        ),
    .ST_EMPTY_W        (ST_EMPTY_W        ),
    .ST_MAX_CHANNELS   (ST_MAX_CHANNELS   ),
    .ST_READY_LATENCY  (ST_READY_LATENCY  ),
    .USE_PACKET        (USE_PACKET        ),
    .USE_CHANNEL       (USE_CHANNEL       ),
    .USE_ERROR         (USE_ERROR         ),
    .USE_READY         (USE_READY         ),
    .USE_VALID         (USE_VALID         ),
    .USE_EMPTY         (USE_EMPTY         ),
    .ST_BEATSPERCYCLE  (ST_BEATSPERCYCLE  ),
    .ST_MAX_PACKET_SIZE(ST_MAX_PACKET_SIZE)
  ) monitor_bfm (
    .clk               (clk         	 ),
    .reset             (reset       	 ),
    .sink_data         (asi.data         ),
    .sink_channel      (asi.channel      ),
    .sink_error        (asi.error        ),
    .sink_empty        (asi.empty        ),
    .sink_valid        (asi.valid        ),
    .sink_startofpacket(asi.startofpacket),
    .sink_endofpacket  (asi.endofpacket  ),
    .sink_ready        (asi.ready        ),
    .src_data          (aso.data         ),
    .src_channel       (aso.channel      ),
    .src_error         (aso.error        ),
    .src_empty         (aso.empty        ),
    .src_valid         (aso.valid        ),
    .src_startofpacket (aso.startofpacket),
    .src_endofpacket   (aso.endofpacket	 ),
    .src_ready         (aso.ready      	 )
  );
  
  //
  // CLASS: avlst_source_adapter
  //
  // Extended class from class <avlst_adapter>
  //
  class avlst_source_adapter extends avlst_adapter;
    function new(string name="avlst_source_adapter", uvm_component parent=null);
      super.new(name, parent);
    endfunction : new
    
    task init();
      source_bfm.init();
      source_bfm.set_idle_state_output_configuration(LOW);
      @(posedge reset);
      @(negedge reset);
      -> init_done;
    endtask : init
    
    task push_transaction(ref avlst_transaction trans);
      source_bfm.set_transaction_idles(trans.idles);
      source_bfm.set_transaction_sop(trans.startofpacket);
      source_bfm.set_transaction_eop(trans.endofpacket);
      source_bfm.set_transaction_data(trans.data);
      source_bfm.push_transaction();
      @(source_bfm.signal_src_driving_transaction);
    endtask : push_transaction
    
    task pop_transaction(ref avlst_transaction trans);
      @(monitor_bfm.monitor_trans.signal_transaction_received);
      monitor_bfm.monitor_trans.pop_transaction();
      trans.idles = monitor_bfm.monitor_trans.get_transaction_idles(); 
      trans.startofpacket = monitor_bfm.monitor_trans.get_transaction_sop();
      trans.endofpacket = monitor_bfm.monitor_trans.get_transaction_eop();
      trans.data = monitor_bfm.monitor_trans.get_transaction_data();
    endtask : pop_transaction
  endclass : avlst_source_adapter
  avlst_source_adapter adapter = new($sformatf("%m.%s", "adapter"));
endmodule
