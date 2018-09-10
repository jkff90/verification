//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_passive_device.svh> is a part of <Verification> project
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

`ifndef __AMBA_AXI4_PASSIVE_DEVICE_SVH__
`define __AMBA_AXI4_PASSIVE_DEVICE_SVH__

typedef struct {
    bit [`AMBA_AXI4_ADDRW-1:0] addr;
    int                        size;
    int                        len;
} amba_axi4_header_t;

//------------------------------------------------------------------------------
// CLASS: amba_axi4_passive_device
//
// Passive device (slave) for AXI4 protocol
//------------------------------------------------------------------------------
class amba_axi4_passive_device extends uvm_component;
    //--- attributes ---
    protected amba_axi4_config cfg;  // protect configuration objects from external access
    protected amba_axi4_adapter adapter; // protect adapter from external access
    
    // Memory
    protected byte memory [bit [`AMBA_AXI4_ADDRW-1:0]];
    
    // Outstanding counters
    protected int rid_cnt;
    protected int wid_cnt;
    
    // Queues: store pending IDs
    protected int q_arid [$];
    protected int q_awid [$];
    protected int q_wid [$];
    
    // Pending requests
    amba_axi4_header_t pending_rd [int];
    amba_axi4_header_t pending_wr [int];
    
    //--- TLM ports/exports
    
    //--- factory registration ---
    `uvm_component_utils(amba_axi4_passive_device)
    
    //--- methods ---
    extern function new(string name="amba_axi4_passive_device", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual function int get_arid();
    extern virtual function int get_wid();
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task drive_reset();
    extern virtual task drive_archannel();
    extern virtual task drive_rchannel();
    extern virtual task drive_awchannel();
    extern virtual task drive_wchannel();
    extern virtual task drive_bchannel();
    extern virtual task monitor_archannel();
    extern virtual task monitor_awchannel();
    extern virtual task monitor_wchannel();
endclass : amba_axi4_passive_device

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_passive_device::new(string name="amba_axi4_passive_device", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void amba_axi4_passive_device::build_phase(uvm_phase phase);
    if(cfg == null) begin
        if(!uvm_config_db #(amba_axi4_config)::get(this, "", "cfg", cfg)) begin
            `uvm_warning(get_full_name(), "Configuration object is not set to this device, creating one with default fields.")
            cfg = amba_axi4_config::type_id::create("cfg");
        end
    end
    if (adapter == null) begin
        if (!uvm_config_db #(amba_axi4_adapter)::get(this, "", "adapter", adapter)) begin
            `uvm_fatal(get_full_name(), "Adapter to interface is not assigned to this device.")
        end
    end
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: start_of_simulation_phase
//------------------------------------------------------------------------------
function void amba_axi4_passive_device::start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf("Printing configuration:\n%s", cfg.sprint()), UVM_LOW)
    rid_cnt = cfg.outstanding_rd;
    wid_cnt = cfg.outstanding_wr;
endfunction : start_of_simulation_phase

//------------------------------------------------------------------------------
// Function: get_arid
//------------------------------------------------------------------------------
function int amba_axi4_passive_device::get_arid();
    int id;
    int idx;
    
    if (cfg.out_of_order) begin
        idx = $urandom_range(0,q_arid.size()-1);
        id = q_arid[idx];
        q_arid.delete(idx);
    end
    else begin
        id = q_arid.pop_front();
    end
    return id;
endfunction : get_arid

//------------------------------------------------------------------------------
// Function: get_wid
//------------------------------------------------------------------------------
function int amba_axi4_passive_device::get_wid();
    int id;
    int idx;
    
    if (cfg.out_of_order) begin
        idx = $urandom_range(0,q_wid.size()-1);
        id = q_wid[idx];
        q_wid.delete(idx);
    end
    else begin
        id = q_wid.pop_front();
    end
    return id;
endfunction : get_wid

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task amba_axi4_passive_device::run_phase(uvm_phase phase);
    drive_reset();
    fork
        drive_archannel();
        drive_rchannel();
        drive_awchannel();
        drive_wchannel();
        drive_bchannel();
        monitor_archannel();
        monitor_awchannel();
        monitor_wchannel();
    join
endtask : run_phase

//------------------------------------------------------------------------------
// Method: drive_reset
//------------------------------------------------------------------------------
task amba_axi4_passive_device::drive_reset();
    adapter.wait_reset_lo();
    fork
        // INDEX:        - Write Address Channel
        // =====
        //adapter.set_awid     (0);
        //adapter.set_awaddr   (0);
        //adapter.set_awlen    (0);
        //adapter.set_awsize   (0);
        //adapter.set_awburst  (0);
        //adapter.set_awcache  (0);
        //adapter.set_awprot   (0);
        //adapter.set_awqos    (0);
        //adapter.set_awregion (0);
        //adapter.set_awlock   (0);
        //adapter.set_awuser   (0);
        //adapter.set_awvalid  (0);
        adapter.set_awready  (0);
        
        // INDEX:        - Write Data Channel
        // =====
        //adapter.set_wdata  (0);
        //adapter.set_wstrb  (0);
        //adapter.set_wuser  (0);
        //adapter.set_wlast  (0);
        //adapter.set_wvalid (0);
        adapter.set_wready (0);
        
        // INDEX:        - Write Response Channel
        // =====
        adapter.set_bid    (0);
        adapter.set_bresp  (0);
        adapter.set_buser  (0);
        adapter.set_bvalid (0);
        //adapter.set_bready (0);
        
        // INDEX:        - Read Address Channel
        // =====
        //adapter.set_arid     (0);
        //adapter.set_araddr   (0);
        //adapter.set_arlen    (0);
        //adapter.set_arsize   (0);
        //adapter.set_arburst  (0);
        //adapter.set_arcache  (0);
        //adapter.set_arprot   (0);
        //adapter.set_arqos    (0);
        //adapter.set_arregion (0);
        //adapter.set_arlock   (0);
        //adapter.set_aruser   (0);
        //adapter.set_arvalid  (0);
        adapter.set_arready  (0);
        
        // INDEX:        - Read Data Channel
        // =====
        adapter.set_rid    (0);
        adapter.set_rdata  (0);
        adapter.set_rresp  (0);
        adapter.set_ruser  (0);
        adapter.set_rlast  (0);
        adapter.set_rvalid (0);
        //adapter.set_rready (0);
        
        // INDEX:        - Low Power Interface
        // =====
        //adapter.set_cactive (0);
        //adapter.set_csysreq (0);
        //adapter.set_csysack (0);
    join
    adapter.wait_reset_hi();
endtask : drive_reset

//------------------------------------------------------------------------------
// Method: drive_archannel
//------------------------------------------------------------------------------
task amba_axi4_passive_device::drive_archannel();
    forever begin
        adapter.posedge_clock();
        if (adapter.get_arvalid() == 1'b1 && adapter.get_arready() == 1'b1) rid_cnt--;
        assert (rid_cnt >= 0)
        else `uvm_fatal(get_full_name(), $sformatf("Outstanding read overflow!"))
        adapter.set_arready(rid_cnt != 0);
    end
endtask : drive_archannel

//------------------------------------------------------------------------------
// Method: drive_rchannel
//------------------------------------------------------------------------------
task amba_axi4_passive_device::drive_rchannel();
    amba_axi4_header_t header;
    int id;
    int len;
    int size;
    int low_addr;
    int byte_cnt;
    bit [`AMBA_AXI4_ADDRW-1:0] addr;
    bit [`AMBA_AXI4_DATAW-1:0] data [];
    bit [7:0] q_data [$];
    bit [`AMBA_AXI4_DATAW-1:0] tdata;
    
    forever begin
        wait(q_arid.size() > 0);
        id = get_arid();
        header = pending_rd[id];
        //---
        // Prepare data
        //---
        addr = header.addr;
        size = header.size;
        len = header.len;
        low_addr = addr & (size - 1);
        byte_cnt = size * len - low_addr;
        for (int i = 0; i < byte_cnt; i++) begin
            if (memory.exists(addr)) q_data.push_back(memory[addr++]);
            else q_data.push_back($urandom);
        end
        repeat (low_addr) q_data.push_front(0);
        data = new[len];
        foreach (data[i]) begin
            //repeat (size) begin
            //    data[i] <<= 8;
            //    data[i] |= q_data.pop_front();
            //end
            tdata = 0;
            for (int j = 0; j < size; j++) begin
                tdata |= q_data.pop_front() << 8*j;
            end
            data[i] = tdata;
        end
        //---
        // Drives signals
        //---
        //adapter.posedge_clock(); // synch with clock
        for (int i = 0; i < len; i++) begin
            fork
                adapter.set_rid(id);
                adapter.set_rvalid(1'b1);
                adapter.set_rdata(data[i]);
                adapter.set_rresp(2'b00);
                if (i == len-1) adapter.set_rlast(1'b1);
                else adapter.set_rlast(1'b0);
            join
            adapter.wait_ravail();
        end
        fork
            adapter.set_rvalid(1'b0);
            adapter.set_rlast(1'b0);
        join
        //
        `uvm_info(get_full_name(), $sformatf("Sent rrsp[id=%0d]", id), UVM_FULL)
        pending_rd.delete(id);
        rid_cnt++;
    end
endtask : drive_rchannel

//------------------------------------------------------------------------------
// Method: drive_awchannel
//------------------------------------------------------------------------------
task amba_axi4_passive_device::drive_awchannel();
    forever begin
        adapter.posedge_clock();
        if (adapter.get_awvalid() == 1'b1 && adapter.get_awready() == 1'b1) wid_cnt--;
        assert (wid_cnt >= 0)
        else `uvm_fatal(get_full_name(), $sformatf("Outstanding write overflow!"))
        adapter.set_awready(wid_cnt != 0);
    end
endtask : drive_awchannel

//------------------------------------------------------------------------------
// Method: drive_wchannel
//------------------------------------------------------------------------------
task amba_axi4_passive_device::drive_wchannel();
    forever begin
        adapter.posedge_clock();
        adapter.set_wready(1'b1);
    end
endtask : drive_wchannel

//------------------------------------------------------------------------------
// Method: drive_bchannel
//------------------------------------------------------------------------------
task amba_axi4_passive_device::drive_bchannel();
    int id;
    
    forever begin
        wait(q_wid.size() > 0);
        id = get_wid();
        //---
        // Drives signals
        //---
        //adapter.posedge_clock(); // synch with clock
        fork
            adapter.set_bid(id);
            adapter.set_bvalid(1'b1);
            adapter.set_bresp(2'b00);
        join
        adapter.wait_bavail();
        adapter.set_bvalid(1'b0);
        //
        `uvm_info(get_full_name(), $sformatf("Sent brsp[id=%0d]", id), UVM_FULL)
        pending_wr.delete(id);
        wid_cnt++;
    end
endtask : drive_bchannel

//------------------------------------------------------------------------------
// Method: monitor_archannel
//------------------------------------------------------------------------------
task amba_axi4_passive_device::monitor_archannel();
    int id;
    amba_axi4_header_t header;
    
    forever begin
        adapter.wait_aravail();
        id = adapter.get_arid();
        header.size = 1 << adapter.get_arsize();
        header.len = adapter.get_arlen() + 1;
        header.addr = adapter.get_araddr();
        //
        `uvm_info(get_full_name(), $sformatf("Got arreq[id=%0d]", id), UVM_FULL)
        pending_rd[id] = header;
        q_arid.push_back(id);
    end
endtask : monitor_archannel

//------------------------------------------------------------------------------
// Method: monitor_awchannel
//------------------------------------------------------------------------------
task amba_axi4_passive_device::monitor_awchannel();
    int id;
    amba_axi4_header_t header;
    
    forever begin
        adapter.wait_awavail();
        id = adapter.get_awid();
        header.size = 1 << adapter.get_awsize();
        header.len = adapter.get_awlen() + 1;
        header.addr = adapter.get_awaddr();
        //
        `uvm_info(get_full_name(), $sformatf("Got awreq[id=%0d]", id), UVM_FULL)
        pending_wr[id] = header;
        q_awid.push_back(id);
    end
endtask : monitor_awchannel

//------------------------------------------------------------------------------
// Method: monitor_wchannel
// For some designs that issue AW and W simultaneously:
//   + Get W data first then wait for the corresponding AW request
//   + Must wait for AW request to prevent race-condition with single beat transfer
//------------------------------------------------------------------------------
task amba_axi4_passive_device::monitor_wchannel();
    int id;
    amba_axi4_header_t header;
    int size;
    bit [`AMBA_AXI4_ADDRW-1:0] addr;
    bit [`AMBA_AXI4_DATAW-1:0] data [$];
    bit [`AMBA_AXI4_STRBW-1:0] strb [$];
    bit [`AMBA_AXI4_DATAW-1:0] tdata;
    bit [`AMBA_AXI4_STRBW-1:0] tstrb;
    bit [7:0] bdata;
    bit bstrb;
    
    forever begin
        do begin
            adapter.wait_wavail();
            data.push_back(adapter.get_wdata());
            strb.push_back(adapter.get_wstrb());
        end while (adapter.get_wlast() == 1'b0);
        //
        wait(q_awid.size() > 0);
        id = q_awid.pop_front();
        header = pending_wr[id];
        size = header.size;
        addr = header.addr;
        //
        foreach(data[i]) begin
            tdata = data[i];
            tstrb = strb[i];
            repeat(size) begin
                bdata = tdata;
                bstrb = tstrb;
                if (bstrb) begin
                    memory[addr++] = bdata;
                end
                tdata >>= 8;
                tstrb >>= 1;
            end
        end
        data = '{};
        strb = '{};
        //
        `uvm_info(get_full_name(), $sformatf("Got wreq[id=%0d]", id), UVM_FULL)
        q_wid.push_back(id);
    end
endtask : monitor_wchannel

`endif /* __AMBA_AXI4_PASSIVE_DEVICE_SVH__ */
