//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <avlmm_master_bfm_wrapper.svh> is a part of <Verification> project
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

module avlmm_master_bfm_wrapper (
  input clk,
  input reset,  
  altera_avalon_mm_if avm
);
  import avalon_mm_pkg::*;
  import avalon_utilities_pkg::*;
  import uvm_pkg::*;
  import uvc_pkg::*;
  
  parameter AV_ADDRESS_W               = 32;
  parameter AV_SYMBOL_W                = 8;
  parameter AV_NUMSYMBOLS              = 4;
  parameter AV_BURSTCOUNT_W            = 3;
  parameter AV_READRESPONSE_W          = 8;
  parameter AV_WRITERESPONSE_W         = 8;
  
  parameter AV_CONSTANT_BURST_BEHAVIOR = 1;
  parameter AV_BURST_LINEWRAP          = 0;
  parameter AV_BURST_BNDR_ONLY         = 0;
  parameter REGISTER_WAITREQUEST       = 0;
  parameter AV_MAX_PENDING_READS       = 1;
  parameter AV_MAX_PENDING_WRITES      = 0;
  parameter AV_FIX_READ_LATENCY        = 0;
  
  parameter USE_READ                   = 1;
  parameter USE_WRITE                  = 1;
  parameter USE_ADDRESS                = 1;
  parameter USE_BYTE_ENABLE            = 1;
  parameter USE_BURSTCOUNT             = 0;
  parameter USE_READ_DATA              = 1;
  parameter USE_READ_DATA_VALID        = 1;
  parameter USE_WRITE_DATA             = 1;
  parameter USE_BEGIN_TRANSFER         = 0;
  parameter USE_BEGIN_BURST_TRANSFER   = 0;
  parameter USE_WAIT_REQUEST           = 1;
  
  parameter AV_READ_TIMEOUT            = 100;
  parameter AV_WRITE_TIMEOUT           = 100;
  parameter AV_WAITREQUEST_TIMEOUT     = 1024;
  parameter AV_MAX_READ_LATENCY        = 100;
  parameter AV_MAX_WAITREQUESTED_READ  = 100;
  parameter AV_MAX_WAITREQUESTED_WRITE = 100;
  parameter AV_MAX_CONTINUOUS_READ          = 5;
  parameter AV_MAX_CONTINUOUS_WRITE         = 5;
  parameter AV_MAX_CONTINUOUS_WAITREQUEST   = 5;
  parameter AV_MAX_CONTINUOUS_READDATAVALID = 5;
   
  parameter USE_ARBITERLOCK            = 0;    // Use arbiterlock pin on interface
  parameter USE_LOCK                   = 0;    // Use lock pin on interface
  parameter USE_DEBUGACCESS            = 0;    // Use debugaccess pin on interface 
  parameter USE_TRANSACTIONID          = 0;    // Use transactionid interface pin
  parameter USE_WRITERESPONSE          = 0;    // Use write response interface pins
  parameter USE_READRESPONSE           = 0;    // Use read response interface pins
  parameter USE_CLKEN                  = 0;    // Use NTCM interface pins  
  parameter AV_REGISTERINCOMINGSIGNALS = 0;    // Indicate that waitrequest is come from register 
  
  parameter AV_READ_WAIT_TIME         = 0;     // Fixed wait time cycles when
  parameter AV_WRITE_WAIT_TIME        = 0;     // USE_WAIT_REQUEST is 0
  
  parameter SLAVE_ADDRESS_TYPE = "SYMBOLS";   // Set slave interface address type, {SYMBOLS, WORDS}
  parameter MASTER_ADDRESS_TYPE = "SYMBOLS";  // Set master interface address type, {SYMBOLS, WORDS}
  
  altera_avalon_mm_if #(
    .AV_ADDRESS_W             (AV_ADDRESS_W             ),
    .AV_SYMBOL_W              (AV_SYMBOL_W              ),
    .AV_NUMSYMBOLS            (AV_NUMSYMBOLS            ),
    .AV_BURSTCOUNT_W          (AV_BURSTCOUNT_W          ),  
    .AV_READRESPONSE_W        (AV_READRESPONSE_W        ),
    .AV_WRITERESPONSE_W       (AV_WRITERESPONSE_W       ),
    
    .USE_READ                 (USE_READ                 ),  
    .USE_WRITE                (USE_WRITE                ),  
    .USE_ADDRESS              (USE_ADDRESS              ),  
    .USE_BYTE_ENABLE          (USE_BYTE_ENABLE          ),   
    .USE_BURSTCOUNT           (USE_BURSTCOUNT           ),  
    .USE_READ_DATA            (USE_READ_DATA            ),  
    .USE_READ_DATA_VALID      (USE_READ_DATA_VALID      ),  
    .USE_WRITE_DATA           (USE_WRITE_DATA           ),  
    .USE_BEGIN_TRANSFER       (USE_BEGIN_TRANSFER       ),  
    .USE_BEGIN_BURST_TRANSFER (USE_BEGIN_BURST_TRANSFER ),  
    .USE_WAIT_REQUEST         (USE_WAIT_REQUEST         ),
    .USE_ARBITERLOCK          (USE_ARBITERLOCK          ),
    .USE_LOCK                 (USE_LOCK                 ),
    .USE_DEBUGACCESS          (USE_DEBUGACCESS          ),
    .USE_TRANSACTIONID        (USE_TRANSACTIONID        ),
    .USE_WRITERESPONSE        (USE_WRITERESPONSE        ),
    .USE_READRESPONSE         (USE_READRESPONSE         ),
    .USE_CLKEN                (USE_CLKEN                )
   ) avs (
    .clk  (clk  ),
    .reset(reset)
  );
  
  altera_avalon_mm_master_bfm #(
    .AV_ADDRESS_W                (AV_ADDRESS_W               ),
    .AV_SYMBOL_W                 (AV_SYMBOL_W                ),
    .AV_NUMSYMBOLS               (AV_NUMSYMBOLS              ),
    .AV_BURSTCOUNT_W             (AV_BURSTCOUNT_W            ),
    .AV_READRESPONSE_W           (AV_READRESPONSE_W          ),
    .AV_WRITERESPONSE_W          (AV_WRITERESPONSE_W         ),
    
    .USE_READ                    (USE_READ                   ),
    .USE_WRITE                   (USE_WRITE                  ),
    .USE_ADDRESS                 (USE_ADDRESS                ),
    .USE_BYTE_ENABLE             (USE_BYTE_ENABLE            ),
    .USE_BURSTCOUNT              (USE_BURSTCOUNT             ),
    .USE_READ_DATA               (USE_READ_DATA              ),
    .USE_READ_DATA_VALID         (USE_READ_DATA_VALID        ),
    .USE_WRITE_DATA              (USE_WRITE_DATA             ),
    .USE_BEGIN_TRANSFER          (USE_BEGIN_TRANSFER         ),
    .USE_BEGIN_BURST_TRANSFER    (USE_BEGIN_BURST_TRANSFER   ),
    .USE_WAIT_REQUEST            (USE_WAIT_REQUEST           ),
    .USE_ARBITERLOCK             (USE_ARBITERLOCK            ),
    .USE_LOCK                    (USE_LOCK                   ),
    .USE_TRANSACTIONID           (USE_TRANSACTIONID          ),
    .USE_WRITERESPONSE           (USE_WRITERESPONSE          ),
    .USE_READRESPONSE            (USE_READRESPONSE           ),
    .USE_CLKEN                   (USE_CLKEN                  ),
    
    .AV_FIX_READ_LATENCY         (AV_FIX_READ_LATENCY        ),
    .AV_MAX_PENDING_READS        (AV_MAX_PENDING_READS       ),
    .AV_MAX_PENDING_WRITES       (AV_MAX_PENDING_WRITES      ),
    .AV_READ_WAIT_TIME           (AV_READ_WAIT_TIME          ),
    .AV_WRITE_WAIT_TIME          (AV_WRITE_WAIT_TIME         ),
    
    .AV_CONSTANT_BURST_BEHAVIOR  (AV_CONSTANT_BURST_BEHAVIOR ),
    .AV_BURST_LINEWRAP           (AV_BURST_LINEWRAP          ),
    .AV_BURST_BNDR_ONLY          (AV_BURST_BNDR_ONLY         ),
    .USE_DEBUGACCESS             (USE_DEBUGACCESS            ),
    .AV_REGISTERINCOMINGSIGNALS  (AV_REGISTERINCOMINGSIGNALS ),
    .REGISTER_WAITREQUEST        (REGISTER_WAITREQUEST       )
  ) master_bfm (
    .clk                      (clk                     ),
    .reset                    (reset                   ),
    
    .avm_clken                (avs.clken               ),
    
    .avm_waitrequest          (avs.waitrequest         ),
    .avm_write                (avs.write               ),
    .avm_read                 (avs.read                ),
    .avm_address              (avs.address             ),
    .avm_byteenable           (avs.byteenable          ),
    .avm_writedata            (avs.writedata           ),
    .avm_burstcount           (avs.burstcount          ),
    .avm_beginbursttransfer   (avs.beginbursttransfer  ),
    .avm_begintransfer        (avs.begintransfer       ),
    .avm_readdata             (avs.readdata            ),
    .avm_readdatavalid        (avs.readdatavalid       ),
    .avm_arbiterlock          (avs.arbiterlock         ),
    .avm_lock                 (avs.lock                ),
    .avm_debugaccess          (avs.debugaccess         ),
    
    .avm_transactionid        (avs.transactionid       ),
    .avm_readresponse         (avs.readresponse        ),
    .avm_readid               (avs.readid              ),
    .avm_writeresponserequest (avs.writeresponserequest),
    .avm_writeresponsevalid   (avs.writeresponsevalid  ),
    .avm_writeresponse        (avs.writeresponse       ),
    .avm_writeid              (avs.writeid             ),
    .avm_response             (avs.response            )
  );
  
  altera_avalon_mm_monitor #(
    .AV_ADDRESS_W                      (AV_ADDRESS_W               ),
    .AV_SYMBOL_W                       (AV_SYMBOL_W                ),
    .AV_NUMSYMBOLS                     (AV_NUMSYMBOLS              ),
    .AV_BURSTCOUNT_W                   (AV_BURSTCOUNT_W            ),
    .AV_CONSTANT_BURST_BEHAVIOR        (AV_CONSTANT_BURST_BEHAVIOR ),
    .AV_BURST_LINEWRAP                 (AV_BURST_LINEWRAP          ),
    .AV_BURST_BNDR_ONLY                (AV_BURST_BNDR_ONLY         ),
    .AV_MAX_PENDING_READS              (AV_MAX_PENDING_READS       ),
    .AV_MAX_PENDING_WRITES             (AV_MAX_PENDING_WRITES      ),
    .AV_FIX_READ_LATENCY               (AV_FIX_READ_LATENCY        ),
    
    .REGISTER_WAITREQUEST              (REGISTER_WAITREQUEST       ),
    .AV_READRESPONSE_W                 (AV_READRESPONSE_W          ),
    .AV_WRITERESPONSE_W                (AV_WRITERESPONSE_W         ),
    
    .USE_READ                          (USE_READ                   ),
    .USE_WRITE                         (USE_WRITE                  ),
    .USE_ADDRESS                       (USE_ADDRESS                ),
    .USE_BYTE_ENABLE                   (USE_BYTE_ENABLE            ),
    .USE_BURSTCOUNT                    (USE_BURSTCOUNT             ),
    .USE_READ_DATA                     (USE_READ_DATA              ),
    .USE_READ_DATA_VALID               (USE_READ_DATA_VALID        ),
    .USE_WRITE_DATA                    (USE_WRITE_DATA             ),
    .USE_BEGIN_TRANSFER                (USE_BEGIN_TRANSFER         ),
    .USE_BEGIN_BURST_TRANSFER          (USE_BEGIN_BURST_TRANSFER   ),
    .USE_WAIT_REQUEST                  (USE_WAIT_REQUEST           ),
    .USE_ARBITERLOCK                   (USE_ARBITERLOCK            ),
    .USE_LOCK                          (USE_LOCK                   ),
    .USE_DEBUGACCESS                   (USE_DEBUGACCESS            ),
    .USE_TRANSACTIONID                 (USE_TRANSACTIONID          ),
    .USE_WRITERESPONSE                 (USE_WRITERESPONSE          ),
    .USE_READRESPONSE                  (USE_READRESPONSE           ),
    .USE_CLKEN                         (USE_CLKEN                  ),
    .AV_REGISTERINCOMINGSIGNALS        (AV_REGISTERINCOMINGSIGNALS ),
    
    .AV_READ_WAIT_TIME                 (AV_READ_WAIT_TIME          ),
    .AV_WRITE_WAIT_TIME                (AV_WRITE_WAIT_TIME         ),
    
    .AV_READ_TIMEOUT                   (AV_READ_TIMEOUT            ),
    .AV_WRITE_TIMEOUT                  (AV_WRITE_TIMEOUT           ),
    .AV_WAITREQUEST_TIMEOUT            (AV_WAITREQUEST_TIMEOUT     ),
    .AV_MAX_READ_LATENCY               (AV_MAX_READ_LATENCY        ),
    .AV_MAX_WAITREQUESTED_READ         (AV_MAX_WAITREQUESTED_READ  ),
    .AV_MAX_WAITREQUESTED_WRITE        (AV_MAX_WAITREQUESTED_WRITE ),
    .AV_MAX_CONTINUOUS_READ            (AV_MAX_CONTINUOUS_READ     ),
    .AV_MAX_CONTINUOUS_WRITE           (AV_MAX_CONTINUOUS_WRITE    ),
    .AV_MAX_CONTINUOUS_WAITREQUEST     (AV_MAX_CONTINUOUS_WAITREQUEST),
    .AV_MAX_CONTINUOUS_READDATAVALID   (AV_MAX_CONTINUOUS_READDATAVALID),
    .SLAVE_ADDRESS_TYPE                (SLAVE_ADDRESS_TYPE         ),
    .MASTER_ADDRESS_TYPE               (MASTER_ADDRESS_TYPE        )
  ) monitor_bfm (
    .clk                       (clk                       ),
    .reset                     (reset                     ),
    
    .avm_clken                 (avm.clken                 ),
    .avs_clken                 (avs.clken                 ),
    
    .avs_waitrequest           (avs.waitrequest           ),
    .avs_write                 (avs.write                 ),
    .avs_read                  (avs.read                  ),
    .avs_address               (avs.address               ),
    .avs_byteenable            (avs.byteenable            ),
    .avs_writedata             (avs.writedata             ),
    .avs_burstcount            (avs.burstcount            ),
    .avs_beginbursttransfer    (avs.beginbursttransfer    ),
    .avs_begintransfer         (avs.begintransfer         ),
    .avs_readdata              (avs.readdata              ),
    .avs_readdatavalid         (avs.readdatavalid         ),
    .avs_arbiterlock           (avs.arbiterlock           ),
    .avs_lock                  (avs.lock                  ),
    .avs_debugaccess           (avs.debugaccess           ),
    .avs_transactionid         (avs.transactionid         ),
    .avs_readresponse          (avs.readresponse          ),
    .avs_readid                (avs.readid                ),
    .avs_writeresponserequest  (avs.writeresponserequest  ),
    .avs_writeresponsevalid    (avs.writeresponsevalid    ),
    .avs_writeresponse         (avs.writeresponse         ),
    .avs_writeid               (avs.writeid               ),
    .avs_response              (avs.response              ),
    
    .avm_waitrequest           (avm.waitrequest           ),
    .avm_write                 (avm.write                 ),
    .avm_read                  (avm.read                  ),
    .avm_address               (avm.address               ),
    .avm_byteenable            (avm.byteenable            ),
    .avm_writedata             (avm.writedata             ),
    .avm_burstcount            (avm.burstcount            ),
    .avm_beginbursttransfer    (avm.beginbursttransfer    ),
    .avm_begintransfer         (avm.begintransfer         ),
    .avm_readdata              (avm.readdata              ),
    .avm_readdatavalid         (avm.readdatavalid         ),
    .avm_arbiterlock           (avm.arbiterlock           ),
    .avm_lock                  (avm.lock                ),
    .avm_debugaccess           (avm.debugaccess           ),
    .avm_transactionid         (avm.transactionid         ),
    .avm_readresponse          (avm.readresponse          ),
    .avm_readid                (avm.readid                ),
    .avm_writeresponserequest  (avm.writeresponserequest  ),
    .avm_writeresponsevalid    (avm.writeresponsevalid    ),
    .avm_writeresponse         (avm.writeresponse         ),
    .avm_writeid               (avm.writeid               ),
    .avm_response              (avm.response              )
  );
  
  //
  // CLASS: avlmm_master_adapter
  //
  // Extended class from class <avlmm_adapter>
  //
  class avlmm_master_adapter extends avlmm_adapter;
    function new(string name="avlmm_master_adapter", uvm_component parent=null);
      super.new(name, parent);
    endfunction : new
    
    task init();
      master_bfm.init();
      master_bfm.set_command_timeout(200);
      master_bfm.set_response_timeout(200);
      master_bfm.set_idle_state_output_configuration(LOW);
      @(posedge reset);
      @(negedge reset);
      -> init_done;
    endtask : init
    
    task push_transaction(ref avlmm_transaction trans);
      master_bfm.set_command_address(trans.address);
      master_bfm.set_command_request(Request_t'(trans.request));
      if(USE_BURSTCOUNT) begin
        master_bfm.set_command_burst_count(trans.data.size());
        master_bfm.set_command_burst_size(trans.data.size());
      end
      if(trans.request == AVLMM_WRITE_REQUEST) begin
        if(USE_BURSTCOUNT) begin
          foreach(trans.data[i]) begin
            master_bfm.set_command_data(trans.data[i], i);
          end
        end
        else begin
          master_bfm.set_command_data(trans.data[0], 0);
        end
      end
      master_bfm.push_command();
      @(master_bfm.signal_response_complete);
      master_bfm.pop_response();
      if(trans.request == AVLMM_READ_REQUEST) begin
        trans.data = new[master_bfm.get_response_burst_size()];
        foreach(trans.data[i]) begin
          trans.data[i] = master_bfm.get_response_data(i);
        end
      end
    endtask : push_transaction
    
    task pop_transaction(ref avlmm_transaction trans);
      @(monitor_bfm.monitor_trans.signal_command_received);
      monitor_bfm.monitor_trans.pop_command();
      //trans.address = monitor_bfm.monitor_trans.get_transaction_address();
      //trans.data = monitor_bfm.monitor_trans.get_command_data();
      //trans.request = avlmm_request_t'(monitor_bfm.monitor_trans.get_command_request());
      @(monitor_bfm.monitor_trans.signal_response_complete);
      monitor_bfm.monitor_trans.pop_response();
      trans.address = monitor_bfm.monitor_trans.get_response_address();
      trans.request = avlmm_request_t'(monitor_bfm.monitor_trans.get_response_request());
      trans.data = new[monitor_bfm.monitor_trans.get_response_burst_size()];
      foreach(trans.data[i]) begin
        trans.data[i] = monitor_bfm.monitor_trans.get_response_data(i);
      end
    endtask : pop_transaction
  endclass : avlmm_master_adapter
  avlmm_master_adapter adapter = new($sformatf("%m.%s", "adapter"));
endmodule
