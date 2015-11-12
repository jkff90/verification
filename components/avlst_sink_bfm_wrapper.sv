//------------------------------------------------------------------------------
// STRUCTURE: avlst_sink_bfm_wrapper
// Wrapper for Avalon streaming sink BFM
//
// + Author: An Pham-Duc
// + Last updated: Apr 2nd, 2015
//------------------------------------------------------------------------------
module avlst_sink_bfm_wrapper (
 	input clk,
	input reset,
	altera_avalon_st_if asi
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
  ) aso (
    .clk  (clk  ),
    .reset(reset)
  );
  
  altera_avalon_st_sink_bfm #(
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
  ) sink_bfm (
    .clk               (clk              ),
    .reset             (reset            ),
    .sink_data         (aso.data         ),
    .sink_channel      (aso.channel      ),
    .sink_error        (aso.error        ),
    .sink_empty        (aso.empty        ),
    .sink_valid        (aso.valid        ),
    .sink_startofpacket(aso.startofpacket),
    .sink_endofpacket  (aso.endofpacket  ),
    .sink_ready        (aso.ready        )
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
    .clk               (clk         	    ),
    .reset             (reset       	    ),
    .sink_data         (asi.data          ),
    .sink_channel      (asi.channel       ),
    .sink_error        (asi.error         ),
    .sink_empty        (asi.empty         ),
    .sink_valid        (asi.valid         ),
    .sink_startofpacket(asi.startofpacket ),
    .sink_endofpacket  (asi.endofpacket   ),
    .sink_ready        (asi.ready         ),
    .src_data          (aso.data          ),
    .src_channel       (aso.channel       ),
    .src_error         (aso.error         ),
    .src_empty         (aso.empty         ),
    .src_valid         (aso.valid         ),
    .src_startofpacket (aso.startofpacket ),
    .src_endofpacket   (aso.endofpacket	  ),
    .src_ready         (aso.ready      	  )
  );
  
  //
  // CLASS: avlst_sink_adapter
  //
  // Extended class from class <avlst_adapter>
  //
  class avlst_sink_adapter extends avlst_adapter;
    function new(string name="avlst_sink_adapter", uvm_component parent=null);
      super.new(name, parent);
    endfunction : new
    
    task init();
      sink_bfm.init();
      @(posedge reset);
      @(negedge reset);
      -> init_done;
    endtask : init
    
    task push_transaction(ref avlst_transaction trans);
      repeat(trans.idles) begin
        @(posedge clk);
        sink_bfm.set_ready(0);
      end
      @(posedge clk);
      sink_bfm.set_ready(1);
    endtask : push_transaction
    
    task pop_transaction(ref avlst_transaction trans);
      @(monitor_bfm.monitor_trans.signal_transaction_received);
      monitor_bfm.monitor_trans.pop_transaction();
      trans.idles = monitor_bfm.monitor_trans.get_transaction_idles(); 
      trans.startofpacket = monitor_bfm.monitor_trans.get_transaction_sop();
      trans.endofpacket = monitor_bfm.monitor_trans.get_transaction_eop();
      trans.data = monitor_bfm.monitor_trans.get_transaction_data();
    endtask : pop_transaction
  endclass : avlst_sink_adapter
  avlst_sink_adapter adapter = new($sformatf("%m.%s", "adapter"));
endmodule
