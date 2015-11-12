//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <hdl_top.sv> is a part of <Verification> project
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

module hdl_top;
  //--- IMPORTS ---
  
  //--- INTERFACES ---
  clk_if #(10) mm_clk();

  clk_if #(6) st_clk();
  
  altera_avalon_mm_if #(
    .AV_ADDRESS_W             (6),
    .AV_SYMBOL_W              (8),
    .AV_NUMSYMBOLS            (2),
    .AV_BURSTCOUNT_W          (0),
    .AV_READRESPONSE_W        (0),
    .AV_WRITERESPONSE_W       (0),
    
    .USE_READ                 (1),
    .USE_WRITE                (1),
    .USE_ADDRESS              (1),
    .USE_BYTE_ENABLE          (0),
    .USE_BURSTCOUNT           (0),
    .USE_READ_DATA            (1),
    .USE_READ_DATA_VALID      (0),
    .USE_WRITE_DATA           (1),
    .USE_BEGIN_TRANSFER       (0),
    .USE_BEGIN_BURST_TRANSFER (0),
    .USE_WAIT_REQUEST         (0),
    .USE_ARBITERLOCK          (0),
    .USE_LOCK                 (0),
    .USE_DEBUGACCESS          (0),
    .USE_TRANSACTIONID        (0),
    .USE_WRITERESPONSE        (0),
    .USE_READRESPONSE         (0),
    .USE_CLKEN                (0)
   ) avm (
    .clk  (st_clk.clk),
    .reset(st_clk.rst)
  );
  
  altera_avalon_st_if #(
    .ST_SYMBOL_W  (8),
    .ST_NUMSYMBOLS(1),
    .ST_CHANNEL_W (0),
    .ST_ERROR_W   (0),
    .ST_EMPTY_W   (0),
    .USE_PACKET   (1),
    .USE_CHANNEL  (0),
    .USE_ERROR    (0),
    .USE_READY    (1),
    .USE_VALID    (1),
    .USE_EMPTY    (0) 
  ) aso_alpha (
    .clk  (st_clk.clk),
    .reset(st_clk.rst)
  );
  
  altera_avalon_st_if #(
    .ST_SYMBOL_W  (8),
    .ST_NUMSYMBOLS(3),
    .ST_CHANNEL_W (0),
    .ST_ERROR_W   (0),
    .ST_EMPTY_W   (0),
    .USE_PACKET   (1),
    .USE_CHANNEL  (0),
    .USE_ERROR    (0),
    .USE_READY    (1),
    .USE_VALID    (1),
    .USE_EMPTY    (0) 
  ) aso_background (
    .clk  (st_clk.clk),
    .reset(st_clk.rst)
  );
  
  altera_avalon_st_if #(
    .ST_SYMBOL_W  (8),
    .ST_NUMSYMBOLS(3),
    .ST_CHANNEL_W (0),
    .ST_ERROR_W   (0),
    .ST_EMPTY_W   (0),
    .USE_PACKET   (1),
    .USE_CHANNEL  (0),
    .USE_ERROR    (0),
    .USE_READY    (1),
    .USE_VALID    (1),
    .USE_EMPTY    (0) 
  ) aso_foreground (
    .clk  (st_clk.clk),
    .reset(st_clk.rst)
  );
  
  altera_avalon_st_if #(
    .ST_SYMBOL_W  (8),
    .ST_NUMSYMBOLS(3),
    .ST_CHANNEL_W (0),
    .ST_ERROR_W   (0),
    .ST_EMPTY_W   (0),
    .USE_PACKET   (1),
    .USE_CHANNEL  (0),
    .USE_ERROR    (0),
    .USE_READY    (1),
    .USE_VALID    (1),
    .USE_EMPTY    (0) 
  ) asi (
    .clk  (st_clk.clk),
    .reset(st_clk.rst)
  );
  
  
  //--- BFMS ---
  avlmm_master_bfm_wrapper #(
    .AV_ADDRESS_W             (6),
    .AV_SYMBOL_W              (8),
    .AV_NUMSYMBOLS            (2),
    .AV_BURSTCOUNT_W          (0),
    .AV_READRESPONSE_W        (0),
    .AV_WRITERESPONSE_W       (0),
    
    .USE_READ                 (1),
    .USE_WRITE                (1),
    .USE_ADDRESS              (1),
    .USE_BYTE_ENABLE          (0),
    .USE_BURSTCOUNT           (0),
    .USE_READ_DATA            (1),
    .USE_READ_DATA_VALID      (0),
    .USE_WRITE_DATA           (1),
    .USE_BEGIN_TRANSFER       (0),
    .USE_BEGIN_BURST_TRANSFER (0),
    .USE_WAIT_REQUEST         (0),
    .USE_ARBITERLOCK          (0),
    .USE_LOCK                 (0),
    .USE_DEBUGACCESS          (0),
    .USE_TRANSACTIONID        (0),
    .USE_WRITERESPONSE        (0),
    .USE_READRESPONSE         (0),
    .USE_CLKEN                (0)
  ) avm_wrapper (
    .clk  (st_clk.clk),
    .reset(st_clk.rst),
    .avm  (avm       )
  );
  
  avlst_source_bfm_wrapper #(
    .ST_SYMBOL_W       (8),
    .ST_NUMSYMBOLS     (1),
    .ST_CHANNEL_W      (0),
    .ST_ERROR_W        (0),
    .ST_EMPTY_W        (0),
    .ST_MAX_CHANNELS   (1),
    .ST_READY_LATENCY  (1),
    .USE_PACKET        (1),
    .USE_CHANNEL       (0),
    .USE_ERROR         (0),
    .USE_READY         (1),
    .USE_VALID         (1),
    .USE_EMPTY         (0),
    .ST_BEATSPERCYCLE  (1),
    .ST_MAX_PACKET_SIZE(1)
  ) aso_alpha_wrapper (
    .clk  (st_clk.clk),
    .reset(st_clk.rst),
    .aso  (aso_alpha )
  );
  
  avlst_source_bfm_wrapper #(
    .ST_SYMBOL_W       (8),
    .ST_NUMSYMBOLS     (3),
    .ST_CHANNEL_W      (0),
    .ST_ERROR_W        (0),
    .ST_EMPTY_W        (0),
    .ST_MAX_CHANNELS   (1),
    .ST_READY_LATENCY  (1),
    .USE_PACKET        (1),
    .USE_CHANNEL       (0),
    .USE_ERROR         (0),
    .USE_READY         (1),
    .USE_VALID         (1),
    .USE_EMPTY         (0),
    .ST_BEATSPERCYCLE  (1),
    .ST_MAX_PACKET_SIZE(1)
  ) aso_background_wrapper (
    .clk  (st_clk.clk    ),
    .reset(st_clk.rst    ),
    .aso  (aso_background)
  );
  
  avlst_source_bfm_wrapper #(
    .ST_SYMBOL_W       (8),
    .ST_NUMSYMBOLS     (3),
    .ST_CHANNEL_W      (0),
    .ST_ERROR_W        (0),
    .ST_EMPTY_W        (0),
    .ST_MAX_CHANNELS   (1),
    .ST_READY_LATENCY  (1),
    .USE_PACKET        (1),
    .USE_CHANNEL       (0),
    .USE_ERROR         (0),
    .USE_READY         (1),
    .USE_VALID         (1),
    .USE_EMPTY         (0),
    .ST_BEATSPERCYCLE  (1),
    .ST_MAX_PACKET_SIZE(1)
  ) aso_foreground_wrapper (
    .clk  (st_clk.clk    ),
    .reset(st_clk.rst    ),
    .aso  (aso_foreground)
  );
  
  avlst_sink_bfm_wrapper #(
    .ST_SYMBOL_W       (8),
    .ST_NUMSYMBOLS     (3),
    .ST_CHANNEL_W      (0),
    .ST_ERROR_W        (0),
    .ST_EMPTY_W        (0),
    .ST_MAX_CHANNELS   (1),
    .ST_READY_LATENCY  (1),
    .USE_PACKET        (1),
    .USE_CHANNEL       (0),
    .USE_ERROR         (0),
    .USE_READY         (1),
    .USE_VALID         (1),
    .USE_EMPTY         (0),
    .ST_BEATSPERCYCLE  (1),
    .ST_MAX_PACKET_SIZE(1)
  ) asi_wrapper (
    .clk  (st_clk.clk),
    .reset(st_clk.rst),
    .asi  (asi       )
  );
  
  
  //--- DUT ---
  alpha_mixer dut (
    .clock(st_clk.clk),
    .reset(st_clk.rst),
    .control_av_address   (avm.address   ),
    .control_av_chipselect(1'b1          ),
    .control_av_readdata  (avm.readdata  ),
    .control_av_write     (avm.write     ),
    .control_av_writedata (avm.writedata ),
    .alpha_in_0_data         (),
    .alpha_in_0_endofpacket  (),
    .alpha_in_0_ready        (),
    .alpha_in_0_startofpacket(),
    .alpha_in_0_valid        (),
    .alpha_in_1_data         (aso_alpha.data         ),
    .alpha_in_1_endofpacket  (aso_alpha.endofpacket  ),
    .alpha_in_1_ready        (aso_alpha.ready        ),
    .alpha_in_1_startofpacket(aso_alpha.startofpacket),
    .alpha_in_1_valid        (aso_alpha.valid        ),
    .din_0_data         (aso_background.data         ),
    .din_0_endofpacket  (aso_background.endofpacket  ),
    .din_0_ready        (aso_background.ready        ),
    .din_0_startofpacket(aso_background.startofpacket),
    .din_0_valid        (aso_background.valid        ),
    .din_1_data         (aso_foreground.data         ),
    .din_1_endofpacket  (aso_foreground.endofpacket  ),
    .din_1_ready        (aso_foreground.ready        ),
    .din_1_startofpacket(aso_foreground.startofpacket),
    .din_1_valid        (aso_foreground.valid        ),
    .dout_data         (asi.data         ),
    .dout_endofpacket  (asi.endofpacket  ),
    .dout_ready        (asi.ready        ),
    .dout_startofpacket(asi.startofpacket),
    .dout_valid        (asi.valid        )
  );
endmodule : hdl_top
