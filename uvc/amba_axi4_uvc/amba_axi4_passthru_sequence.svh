//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_passthru_sequence.svh> is a part of <Verification> project
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

`ifndef __AMBA_AXI4_PASSTHRU_SEQUENCE_SVH__
`define __AMBA_AXI4_PASSTHRU_SEQUENCE_SVH__

//------------------------------------------------------------------------------
// CLASS: amba_axi4_passthru_sequence
//
// Pass through sequence for amba_axi4 protocol. For more information, please refer
// to the paper <"Beyond UVM: Creating Truly Reusable Protocol Layering"
// at http://www.verilog.org/mantis/file_download.php?file_id=5903&type=bug>
//------------------------------------------------------------------------------
class amba_axi4_passthru_sequence extends uvm_sequence #(amba_axi4_transaction);
    //--- attributes ---
    
    // variable: sequence_started
    // This event indicates that the sequence has started
    event sequence_started;
    
    // variable: start_transaction
    // Trigger this event to start sending the transaction
    event start_transaction;
    
    // variable: finish_transaction
    // This event indicates that the transaction has been sent
    event finish_transaction;
    
    protected amba_axi4_transaction trans;
    
    //--- factory registration ---
    `uvm_object_utils(amba_axi4_passthru_sequence)
    `uvm_declare_p_sequencer(amba_axi4_sequencer)
    
    //--- methods ---
    extern function new(string name="amba_axi4_passthru_sequence");
    extern virtual task body();
endclass : amba_axi4_passthru_sequence

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_passthru_sequence::new(string name="amba_axi4_passthru_sequence");
    super.new(name);
    trans = amba_axi4_transaction::type_id::create("trans");
endfunction : new

//------------------------------------------------------------------------------
// +Method: body
//------------------------------------------------------------------------------
task amba_axi4_passthru_sequence::body();
    -> sequence_started;
    forever begin
        @(start_transaction);
        req = amba_axi4_transaction::type_id::create("req");
        start_item(req);
        req.copy(trans);
        finish_item(req);
        -> finish_transaction;
    end
endtask : body

`endif /* __AMBA_AXI4_PASSTHRU_SEQUENCE_SVH__ */
