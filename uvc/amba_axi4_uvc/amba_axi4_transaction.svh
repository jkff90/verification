//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_transaction.svh> is a part of <Verification> project
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

`ifndef __AMBA_AXI4_TRANSACTION_SVH__
`define __AMBA_AXI4_TRANSACTION_SVH__

//------------------------------------------------------------------------------
// CLASS: amba_axi4_transaction
//
// Transaction type for amba_axi4 protocol. Narrow transfer is not supported
//------------------------------------------------------------------------------
class amba_axi4_transaction extends uvm_sequence_item;
    //--- attributes ---
    
    // enum: rw
    // AXI4 read/write
    rand amba_axi4_rw_t rw;
    
    // int: addr
    // Target address
    rand bit [`AMBA_AXI4_ADDRW-1:0] addr;
    
    // array: data
    // Data to be sent/received
    rand bit [7:0] data []; // *byte* will cause signed data
    
    // enum: resp
    // AXI4 response, represents for the whole transaction.
    // If there is a SLVERR, the reponsed for the whole transaction is SLVERR.
    // TODO: DECERR
    /*rand*/ amba_axi4_resp_t resp;
    
    // enum: burst
    // AXI4 burst type
    rand amba_axi4_burst_t burst;
    
    // int: cache
    // AXI4 cache
    rand bit [3:0] cache;
    
    // int: qos
    // AXI4 QoS
    rand bit [3:0] qos;
    
    // int: region
    // Axi4 region
    rand bit [3:0] region;
    
    // struct: prot
    // AXI4 protection
    rand amba_axi4_prot_t prot;
    
    // bit: exclusive
    // Exclusive access (locked access)
    rand bit exclusive;
    
    // int: awuser
    // Sideband data for AW channel, set by user.
    /*rand*/ bit [`AMBA_AXI4_USERW-1:0] awuser;
    
    // array: wuser
    // Sideband data for W channel, set by user.
    /*rand*/ bit [`AMBA_AXI4_USERW-1:0] wuser [];
    
    // int: buser
    // Sideband data for B channel, set by user.
    /*rand*/ bit [`AMBA_AXI4_USERW-1:0] buser;
    
    // int: aruser
    // Sideband data for AR channel, set by user.
    /*rand*/ bit [`AMBA_AXI4_USERW-1:0] aruser;
    
    // array: ruser
    // Sideband data for R channel, set by user.
    /*rand*/ bit [`AMBA_AXI4_USERW-1:0] ruser [];
    
    // Test control
    
    // bit: stress
    // Stress the bus, the trasaction will drive the signals without waiting the clock.
    // Driver will ignore this bit for the first transaction after a bus idle period since it may cause race condition.
    rand bit stress;
    
    //--- constraints ---
    constraint c_4k_boundary {
        addr[11:0] + data.size() <= 4096;
    }
    constraint c_burst {
        soft burst == AMBA_AXI4_BURST_INCR;
    }
    constraint c_nz_length {
        data.size() > 0;
    }
    constraint c_cache {
        soft cache == 0;
    }
    constraint c_qos {
        soft qos == 0;
    }
    constraint c_region {
        soft region == 0;
    }
    constraint c_prot {
        soft prot == 3'b000;
    }
    constraint c_lock {
        soft exclusive == 0;
    }
    constraint c_stress {
        soft stress == 0;
    }
    
    //--- factory registration ---
    `uvm_object_utils(amba_axi4_transaction)
    
    //--- methods ---
    extern function new(string name="amba_axi4_transaction");
    extern virtual function string convert2string();
    //extern virtual function void do_print(uvm_printer printer);
    //extern virtual function void do_record(uvm_recorder recorder);
    extern virtual function void do_copy(uvm_object rhs);
    extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    //extern virtual function void do_pack(uvm_packer packer);
    //extern virtual function void do_unpack(uvm_packer packer);
endclass : amba_axi4_transaction

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_transaction::new(string name="amba_axi4_transaction");
    super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: convert2string
//------------------------------------------------------------------------------
function string amba_axi4_transaction::convert2string();
    string s;
    
    s = $sformatf("RW=%s, ADDR=0x%X, LEN=%0d, RESP=%s, QOS=%0d, DATA=0x",
        rw.name(), addr, data.size(), resp.name(), qos);
    foreach (data[i]) begin
        if (i >= 20) begin
            s = {s, ".........."};
            break;
        end
        if ((i % 4 == 0) && (i != 0)) s = {s, "_"};
        s = $sformatf("%s%X", s, data[i]);
    end
    return s;
endfunction : convert2string

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void amba_axi4_transaction::do_copy(uvm_object rhs);
    amba_axi4_transaction rhs_;
    
    assert($cast(rhs_, rhs));
    rw = rhs_.rw;
    addr = rhs_.addr;
    data = new[rhs_.data.size()];
    foreach(data[i]) data[i] = rhs_.data[i];
    resp = rhs_.resp;
    burst = rhs_.burst;
    cache = rhs_.cache;
    qos = rhs_.qos;
    region = rhs_.region;
    prot = rhs_.prot;
    exclusive = rhs_.exclusive;
    awuser = rhs_.awuser;
    wuser = new[rhs_.wuser.size()];
    foreach (wuser[i]) wuser[i] = rhs_.wuser[i];
    buser = rhs_.buser;
    aruser = rhs_.aruser;
    ruser = new[rhs_.ruser.size()];
    foreach (ruser[i]) ruser[i] = rhs_.ruser[i];
endfunction : do_copy

//------------------------------------------------------------------------------
// +Function: do_compare
//------------------------------------------------------------------------------
function bit amba_axi4_transaction::do_compare(uvm_object rhs, uvm_comparer comparer);
    amba_axi4_transaction rhs_;
    
    assert($cast(rhs_, rhs));
    if (rw != rhs_.rw) return 0;
    if (addr != rhs_.addr) return 0;
    if (data.size() > rhs_.data.size()) return 0; // there are unused data for read
    foreach (data[i]) if (data[i] != rhs_.data[i]) return 0;
    if (resp != rhs_.resp) return 0;
    if (burst != rhs_.burst) return 0;
    if (cache != rhs_.cache) return 0;
    if (qos != rhs_.qos) return 0;
    if (region != rhs_.region) return 0;
    if (prot != rhs_.prot) return 0;
    if (exclusive != rhs_.exclusive) return 0;
    return 1;
endfunction : do_compare

`endif /* __AMBA_AXI4_TRANSACTION_SVH__ */
