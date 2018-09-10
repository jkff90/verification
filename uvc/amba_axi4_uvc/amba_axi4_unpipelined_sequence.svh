//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_unpipelined_sequence.svh> is a part of <Verification> project
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

`ifndef __AMBA_AXI4_UNPIPELINED_SEQUENCE_SVH__
`define __AMBA_AXI4_UNPIPELINED_SEQUENCE_SVH__

//------------------------------------------------------------------------------
// CLASS: amba_axi4_unpipelined_sequence
//
// Basic unpipilined sequence for amba_axi4 protocol
//------------------------------------------------------------------------------
class amba_axi4_unpipelined_sequence extends uvm_sequence #(amba_axi4_transaction);
    //--- attributes ---
    
    // int: num
    // Number of transactions will be sent
    int num = 100;
    
    //--- factory registration ---
    `uvm_object_utils(amba_axi4_unpipelined_sequence)
    `uvm_declare_p_sequencer(amba_axi4_sequencer)
    
    //--- methods ---
    extern function new(string name="amba_axi4_unpipelined_sequence");
    extern virtual task body();
endclass : amba_axi4_unpipelined_sequence

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_unpipelined_sequence::new(string name="amba_axi4_unpipelined_sequence");
    super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Method: body
//------------------------------------------------------------------------------
task amba_axi4_unpipelined_sequence::body();
    repeat(num) begin
        req = amba_axi4_transaction::type_id::create("req");
        start_item(req);
        `ifndef DISABLE_SV_FEATURES
        assert(req.randomize() with {
        });
        `endif /* DISABLE_SV_FEATURES */
        finish_item(req);
        get_response(req);
    end
    `uvm_info(get_full_name(), "Sequence completed!", UVM_LOW)
endtask : body

`endif /* __AMBA_AXI4_SEQUENCE_SVH__ */
