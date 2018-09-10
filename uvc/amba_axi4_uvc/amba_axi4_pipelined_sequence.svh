//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_pipelined_sequence.svh> is a part of <Verification> project
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

`ifndef __AMBA_AXI4_PIPELINED_SEQUENCE_SVH__
`define __AMBA_AXI4_PIPELINED_SEQUENCE_SVH__

//------------------------------------------------------------------------------
// CLASS: amba_axi4_pipelined_sequence
//
// Basic pipelined sequence for amba_axi4 protocol
//------------------------------------------------------------------------------
class amba_axi4_pipelined_sequence extends uvm_sequence #(amba_axi4_transaction);
    //--- attributes ---
    
    // int: num
    // Number of transactions will be sent
    int num = 100;
    
    protected int pending;
    
    //--- factory registration ---
    `uvm_object_utils(amba_axi4_pipelined_sequence)
    `uvm_declare_p_sequencer(amba_axi4_sequencer)
    
    //--- methods ---
    extern function new(string name="amba_axi4_pipelined_sequence");
    extern virtual function void response_handler(uvm_sequence_item response);
    extern virtual task pre_body();
    extern virtual task body();
    extern virtual task post_body();
endclass : amba_axi4_pipelined_sequence

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_pipelined_sequence::new(string name="amba_axi4_pipelined_sequence");
    super.new(name);
    use_response_handler(1);
endfunction : new

//------------------------------------------------------------------------------
// +Function: response_handler
//------------------------------------------------------------------------------
function void amba_axi4_pipelined_sequence::response_handler(uvm_sequence_item response);
    pending--;
endfunction : response_handler

//------------------------------------------------------------------------------
// +Method: pre_body
//------------------------------------------------------------------------------
task amba_axi4_pipelined_sequence::pre_body();
    pending = 0;
endtask : pre_body

//------------------------------------------------------------------------------
// +Method: body
//------------------------------------------------------------------------------
task amba_axi4_pipelined_sequence::body();
    repeat(num) begin
        req = amba_axi4_transaction::type_id::create("req");
        start_item(req);
        `ifndef DISABLE_SV_FEATURES
        assert(req.randomize() with {
            stress == 1; // stress bus test (optional)
        });
        `endif /* DISABLE_SV_FEATURES */
        finish_item(req);
        pending++;
    end
endtask : body

//------------------------------------------------------------------------------
// +Method: post_body
//------------------------------------------------------------------------------
task amba_axi4_pipelined_sequence::post_body();
    wait(pending == 0); // block the sequence until all the pending items are completed
    `uvm_info(get_full_name(), "Sequence completed!", UVM_LOW)
endtask : post_body

`endif /* __AMBA_AXI4_SEQUENCE_SVH__ */
