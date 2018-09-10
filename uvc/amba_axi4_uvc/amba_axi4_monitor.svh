//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_monitor.svh> is a part of <Verification> project
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

`ifndef __AMBA_AXI4_MONITOR_SVH__
`define __AMBA_AXI4_MONITOR_SVH__

//------------------------------------------------------------------------------
// CLASS: amba_axi4_monitor
//
// Monitor for amba_axi4 protocol
//------------------------------------------------------------------------------
class amba_axi4_monitor extends uvm_component;
    //--- attributes ---
    protected int size;
    protected amba_axi4_config cfg;  // protect configuration objects from external access
    protected amba_axi4_adapter adapter; // protect adapter from external access
    
    // Pending transactions over the channels
    protected amba_axi4_transaction pending_ar [int];
    protected amba_axi4_transaction pending_aw [int];
    protected amba_axi4_transaction pending_w [int];
    
    // Pending IDs
    protected int q_wid [$];
    
    //--- TLM ports/exports ---
    
    // object: analysis_port
    // Analysis port that sends monitored transactions to upper layers
    uvm_analysis_port #(amba_axi4_transaction) analysis_port;
    
    //--- factory registration ---
    `uvm_component_utils(amba_axi4_monitor)
    
    //--- methods ---
    extern function new(string name="amba_axi4_monitor", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task monitor_reset();
    extern virtual task monitor_archannel();
    extern virtual task monitor_rchannel();
    extern virtual task monitor_awchannel();
    extern virtual task monitor_wchannel();
    extern virtual task monitor_bchannel();
endclass : amba_axi4_monitor

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_monitor::new(string name="amba_axi4_monitor", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void amba_axi4_monitor::build_phase(uvm_phase phase);
    assert(uvm_config_db #(amba_axi4_config)::get(this, "", "cfg", cfg));
    assert(uvm_config_db #(amba_axi4_adapter)::get(this, "", "adapter", adapter));
    analysis_port = new("analysis_port", this);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: start_of_simulation_phase
//------------------------------------------------------------------------------
function void amba_axi4_monitor::start_of_simulation_phase(uvm_phase phase);
    size = 1 << cfg.burst_size;
endfunction : start_of_simulation_phase
//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task amba_axi4_monitor::run_phase(uvm_phase phase);
    monitor_reset();
    fork
        monitor_archannel();
        monitor_rchannel();
        monitor_awchannel();
        monitor_wchannel();
        monitor_bchannel();
    join
endtask : run_phase

//------------------------------------------------------------------------------
// Method: monitor_reset
//------------------------------------------------------------------------------
task amba_axi4_monitor::monitor_reset();
    adapter.wait_reset_lo();
    adapter.wait_reset_hi();
endtask : monitor_reset

//------------------------------------------------------------------------------
// Method: monitor_archannel
//------------------------------------------------------------------------------
task amba_axi4_monitor::monitor_archannel();
    amba_axi4_transaction trans;
    int id;
    
    forever begin
        adapter.wait_aravail();
        trans = amba_axi4_transaction::type_id::create("trans");
        id = adapter.get_arid();
        trans.rw = AMBA_AXI4_RW_READ;
        trans.addr = adapter.get_araddr();
        trans.burst = amba_axi4_burst_t'(adapter.get_arburst());
        trans.cache = adapter.get_arcache();
        trans.qos = adapter.get_arqos();
        trans.region = adapter.get_arregion();
        trans.prot = adapter.get_arprot();
        trans.exclusive = adapter.get_arlock();
        trans.aruser = adapter.get_aruser();
        assert (!pending_ar.exists(id)) pending_ar[id] = trans;
        else `uvm_fatal(get_full_name(), $sformatf("AR[id=%0d] request has the same ID with another pending AR request", id))
    end
endtask : monitor_archannel

//------------------------------------------------------------------------------
// Method: monitor_rchannel
//------------------------------------------------------------------------------
task amba_axi4_monitor::monitor_rchannel();
    amba_axi4_transaction trans;
    int id;
    int low_addr;
    bit [`AMBA_AXI4_DATAW-1:0] data [$];
    bit [`AMBA_AXI4_USERW-1:0] user [$];
    bit [`AMBA_AXI4_DATAW-1:0] tdata;
    bit [7:0] q_data [$];
    bit [7:0] dump;
    
    forever begin
        adapter.wait_ravail();
        data.push_back(adapter.get_rdata());
        user.push_back(adapter.get_ruser());
        while (adapter.get_rlast() == 0) begin
            adapter.wait_ravail();
            data.push_back(adapter.get_rdata());
            user.push_back(adapter.get_ruser());
        end
        id = adapter.get_rid();
        assert (pending_ar.exists(id)) trans = pending_ar[id];
        else `uvm_fatal(get_full_name(), $sformatf("R[id=%0d] response has no corresponding AR request", id))
        trans.resp = amba_axi4_resp_t'(adapter.get_rresp()); // TODO: AXI4 requires seperated responses for each read data
        // Convert BEAT -> BYTEs
        foreach (data[i]) begin
            tdata = data[i];
            repeat (size) begin
                q_data.push_back(tdata);
                tdata >>= 8;
            end
        end
        // Remove unused data
        low_addr = trans.addr & (size - 1);
        repeat (low_addr) dump = q_data.pop_front();
        trans.data = new[q_data.size()];
        foreach (trans.data[i]) trans.data[i] = q_data[i];
        trans.ruser = new[user.size()];
        foreach (trans.ruser[i]) trans.ruser[i] = user[i];
        // Done
        data = '{};
        user = '{};
        q_data = '{};
        pending_ar.delete(id);
        `uvm_info(get_full_name(), $sformatf("Received transaction[ID=%0d]: %s", id, trans.convert2string()), UVM_MEDIUM)
        analysis_port.write(trans);
    end
endtask : monitor_rchannel

//------------------------------------------------------------------------------
// Method: monitor_awchannel
//------------------------------------------------------------------------------
task amba_axi4_monitor::monitor_awchannel();
    amba_axi4_transaction trans;
    int id;
    
    forever begin
        adapter.wait_awavail();
        trans = amba_axi4_transaction::type_id::create("trans");
        id = adapter.get_awid();
        trans.rw = AMBA_AXI4_RW_WRITE;
        trans.addr = adapter.get_awaddr();
        trans.burst = amba_axi4_burst_t'(adapter.get_awburst());
        trans.cache = adapter.get_awcache();
        trans.qos = adapter.get_awqos();
        trans.region = adapter.get_awregion();
        trans.prot = adapter.get_awprot();
        trans.exclusive = adapter.get_awlock();
        trans.awuser = adapter.get_awuser();
        assert (!pending_aw.exists(id)) pending_aw[id] = trans;
        else `uvm_fatal(get_full_name(), $sformatf("AW[id=%0d] request has the same ID with another pending AW request", id))
        q_wid.push_back(id); // store id for write data
    end
endtask : monitor_awchannel

//------------------------------------------------------------------------------
// Method: monitor_wchannel
//------------------------------------------------------------------------------
task amba_axi4_monitor::monitor_wchannel();
    amba_axi4_transaction trans;
    int id;
    int pad;
    bit [`AMBA_AXI4_DATAW-1:0] data [$];
    bit [`AMBA_AXI4_USERW-1:0] user [$];
    bit [`AMBA_AXI4_STRBW-1:0] strb [$];
    bit [`AMBA_AXI4_DATAW-1:0] tdata;
    bit [`AMBA_AXI4_STRBW-1:0] tstrb;
    bit [7:0] q_data [$];
    bit [7:0] dump;
    
    forever begin
        adapter.wait_wavail();
        data.push_back(adapter.get_wdata());
        user.push_back(adapter.get_wuser());
        strb.push_back(adapter.get_wstrb());
        while (adapter.get_wlast() == 0) begin
            adapter.wait_wavail();
            data.push_back(adapter.get_wdata());
            user.push_back(adapter.get_wuser());
            strb.push_back(adapter.get_wstrb());
        end
        id = q_wid.pop_front();
        assert (pending_aw.exists(id)) trans = pending_aw[id];
        else `uvm_fatal(get_full_name(), $sformatf("W[id=%0d] request has no corresponding AW request", id))
        // Convert BEAT -> BYTEs
        foreach (data[i]) begin
            tdata = data[i];
            repeat (size) begin
                q_data.push_back(tdata);
                tdata >>= 8;
            end
        end
        // Remove unused data
        tstrb = strb.pop_front(); // first strobe
        pad = 0;
        repeat (size) begin //while (tstrb[0] == 0) begin // can make simulation hang
            if (tstrb[0] == 1) break;
            dump = q_data.pop_front();
            pad++; // cnt0s
            tstrb >>= 1;
        end
        if (data.size() > 1) begin // multiple beats transfer
            tstrb = strb.pop_back(); // last strobe
            pad = 0;
        end
        while (tstrb[0] == 1) begin
            pad++; // cnt1s
            tstrb >>= 1;
        end
        pad = size - pad;
        repeat (pad) dump = q_data.pop_back();
        trans.data = new[q_data.size()];
        foreach (trans.data[i]) trans.data[i] = q_data[i];
        trans.wuser = new[user.size()];
        foreach (trans.wuser[i]) trans.wuser[i] = user[i];
        // Done
        data = '{};
        user = '{};
        strb = '{};
        q_data = '{};
        pending_w[id] = trans;
    end
endtask : monitor_wchannel

//------------------------------------------------------------------------------
// Method: monitor_bchannel
//------------------------------------------------------------------------------
task amba_axi4_monitor::monitor_bchannel();
    amba_axi4_transaction trans;
    int id;
    
    forever begin
        adapter.wait_bavail();
        id = adapter.get_bid();
        assert (pending_aw.exists(id) && pending_w.exists(id)) trans = pending_w[id]; // both point to a same object
        else `uvm_fatal(get_full_name(), $sformatf("B[id=%0d] response has no corresponding AW or W request", id))
        trans.resp = amba_axi4_resp_t'(adapter.get_bresp());
        trans.buser = adapter.get_buser();
        pending_aw.delete(id);
        pending_w.delete(id);
        `uvm_info(get_full_name(), $sformatf("Received transaction[ID=%0d]: %s", id, trans.convert2string()), UVM_MEDIUM)
        analysis_port.write(trans);
    end
endtask : monitor_bchannel

`endif /* __AMBA_AXI4_MONITOR_SVH__ */
