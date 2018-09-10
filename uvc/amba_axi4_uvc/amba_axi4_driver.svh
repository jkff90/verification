//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_driver.svh> is a part of <Verification> project
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

`ifndef __AMBA_AXI4_DRIVER_SVH__
`define __AMBA_AXI4_DRIVER_SVH__

//------------------------------------------------------------------------------
// CLASS: amba_axi4_driver
//
// Driver for amba_axi4 protocol
//------------------------------------------------------------------------------
class amba_axi4_driver extends uvm_driver #(amba_axi4_transaction);
    //--- attributes ---
    
    protected int size;
    protected amba_axi4_config cfg;  // protect configuration objects from external access
    protected amba_axi4_adapter adapter; // protect adapter from external access
    
    // Read/Write semaphores
    protected semaphore arsmp;
    protected semaphore awsmp;
    
    // Read/Write fifos
    protected mailbox #(amba_axi4_transaction) rd_fifo;
    protected mailbox #(amba_axi4_transaction) wr_fifo;
    
    // Write channel mailbox. It is used to maintain the WriteData channel ordering
    protected mailbox #(amba_axi4_transaction) wtrans_mb;
    
    //--- factory registration ---
    `uvm_component_utils(amba_axi4_driver)
    
    //--- methods ---
    extern function new(string name="amba_axi4_driver", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task drive_reset();
    extern virtual task drive_archannel(int id);
    extern virtual task drive_rchannel();
    extern virtual task drive_awchannel(int id);
    extern virtual task drive_wchannel();
    extern virtual task drive_bchannel();
endclass : amba_axi4_driver

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_driver::new(string name="amba_axi4_driver", uvm_component parent=null);
    super.new(name, parent);
    arsmp = new(1);
    awsmp = new(1);
    rd_fifo = new();
    wr_fifo = new();
    wtrans_mb = new();
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void amba_axi4_driver::build_phase(uvm_phase phase);
    assert(uvm_config_db #(amba_axi4_config)::get(this, "", "cfg", cfg));
    assert(uvm_config_db #(amba_axi4_adapter)::get(this, "", "adapter", adapter));
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: start_of_simulation_phase
//------------------------------------------------------------------------------
function void amba_axi4_driver::start_of_simulation_phase(uvm_phase phase);
    size = 1 << cfg.burst_size;
endfunction : start_of_simulation_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task amba_axi4_driver::run_phase(uvm_phase phase);
    // Reset
    drive_reset();
    // Ready
    fork
        drive_rchannel();
        drive_bchannel();
        drive_wchannel();
    join_none
    // Read
    for (int i = cfg.outstanding_rd - 1; i >= 0; i--) begin
        automatic int id = i;
        fork
            drive_archannel(id);
        join_none
    end
    // Write
    for (int i = cfg.outstanding_wr - 1; i >= 0; i--) begin
        automatic int id = i;
        fork
            drive_awchannel(id);
        join_none
    end
    // Main
    forever begin
        seq_item_port.get(req);
        `uvm_info(get_full_name(), {"seq_item_port got transaction: ", req.convert2string()}, UVM_FULL)
        if (req.rw == AMBA_AXI4_RW_READ)
            rd_fifo.put(req);
        else
            wr_fifo.put(req);
    end
endtask : run_phase

//------------------------------------------------------------------------------
// Method: drive_reset
//------------------------------------------------------------------------------
task amba_axi4_driver::drive_reset();
    adapter.wait_reset_lo();
    `uvm_info(get_full_name(), "Reset signal asserted, reset the bus", UVM_LOW)
    fork
        // INDEX:        - Write Address Channel
        // =====
        adapter.set_awid     (0);
        adapter.set_awaddr   (0);
        adapter.set_awlen    (0);
        adapter.set_awsize   (0);
        adapter.set_awburst  (0);
        adapter.set_awcache  (0);
        adapter.set_awprot   (0);
        adapter.set_awqos    (0);
        adapter.set_awregion (0);
        adapter.set_awlock   (0);
        adapter.set_awuser   (0);
        adapter.set_awvalid  (0);
        //adapter.set_awready  (0);
        
        // INDEX:        - Write Data Channel
        // =====
        adapter.set_wdata  (0);
        adapter.set_wstrb  (0);
        adapter.set_wuser  (0);
        adapter.set_wlast  (0);
        adapter.set_wvalid (0);
        //adapter.set_wready (0);
        
        // INDEX:        - Write Response Channel
        // =====
        //adapter.set_bid    (0);
        //adapter.set_bresp  (0);
        //adapter.set_buser  (0);
        //adapter.set_bvalid (0);
        adapter.set_bready (0);
        
        // INDEX:        - Read Address Channel
        // =====
        adapter.set_arid     (0);
        adapter.set_araddr   (0);
        adapter.set_arlen    (0);
        adapter.set_arsize   (0);
        adapter.set_arburst  (0);
        adapter.set_arcache  (0);
        adapter.set_arprot   (0);
        adapter.set_arqos    (0);
        adapter.set_arregion (0);
        adapter.set_arlock   (0);
        adapter.set_aruser   (0);
        adapter.set_arvalid  (0);
        //adapter.set_arready  (0);
        
        // INDEX:        - Read Data Channel
        // =====
        //adapter.set_rid    (0);
        //adapter.set_rdata  (0);
        //adapter.set_rresp  (0);
        //adapter.set_ruser  (0);
        //adapter.set_rlast  (0);
        //adapter.set_rvalid (0);
        adapter.set_rready (0);
        
        // INDEX:        - Low Power Interface
        // =====
        adapter.set_cactive (0);
        adapter.set_csysreq (0);
        adapter.set_csysack (0);
    join
    adapter.wait_reset_hi();
    `uvm_info(get_full_name(), "Reset signal deasserted, release the bus", UVM_LOW)
endtask : drive_reset

//------------------------------------------------------------------------------
// Method: drive_archannel
//------------------------------------------------------------------------------
task amba_axi4_driver::drive_archannel(int id);
    amba_axi4_transaction arreq;
    int arlen;
    int low_addr;
    
    forever begin
        arsmp.get();
        rd_fifo.get(arreq);
        //---
        // Prepare request
        //---
        low_addr = arreq.addr & (size - 1);
        arlen = arreq.data.size() + low_addr;
        arlen = (arlen % size) ? (arlen / size + 1) : (arlen / size);
        //---
        // Send request
        //---
        if (arreq.stress == 0 || adapter.get_arvalid() == 1'b0) adapter.posedge_clock(); // synch with clock
        fork
            adapter.set_arid(id);
            adapter.set_araddr(arreq.addr);
            adapter.set_arlen(arlen-1);
            adapter.set_arsize(cfg.burst_size);
            adapter.set_arburst(arreq.burst);
            adapter.set_arcache(arreq.cache);
            adapter.set_arprot(arreq.prot);
            adapter.set_arqos(arreq.qos);
            adapter.set_arregion(arreq.region);
            adapter.set_arlock(arreq.exclusive);
            adapter.set_aruser(arreq.aruser);
            adapter.set_arvalid(1'b1);
        join
        adapter.wait_aravail();
        adapter.set_arvalid(1'b0);
        arsmp.put();
        //---
        // Wait response
        //---
        do begin
            adapter.wait_ravail();
        end while(adapter.get_rid() != id || adapter.get_rlast() == 1'b0);
        // Finish req
        `uvm_info(get_full_name(), $sformatf("Sent transaction[ID=%0d]: %s", id, arreq.convert2string()), UVM_HIGH)
        seq_item_port.put(arreq);
    end
endtask : drive_archannel

//------------------------------------------------------------------------------
// Method: drive_rchannel
//------------------------------------------------------------------------------
task amba_axi4_driver::drive_rchannel();
    forever begin
        adapter.posedge_clock();
        adapter.set_rready(1'b1);
    end
endtask : drive_rchannel

//------------------------------------------------------------------------------
// Method: drive_awchannel
// Current behaviour:
//   + Data phase starts after the address phase (it could be changed if neccessary)
//   + Move the line #305 (wtrans_mb.put(awreq)) to before sending the request (line #285) to change the behaviour
//------------------------------------------------------------------------------
task amba_axi4_driver::drive_awchannel(int id);
    amba_axi4_transaction awreq;
    int awlen;
    amba_axi4_transaction rsp;
    int low_addr;
    
    forever begin
        awsmp.get();
        wr_fifo.get(awreq);
        //---
        // Prepare request
        //---
        low_addr = awreq.addr & (size - 1);
        awlen = awreq.data.size() + low_addr;
        awlen = (awlen % size) ? (awlen / size + 1) : (awlen / size);
        //---
        // Send request
        //---
        if (awreq.stress == 0 || adapter.get_awvalid() == 1'b0) adapter.posedge_clock(); // synch with clock
        fork
            adapter.set_awid(id);
            adapter.set_awaddr(awreq.addr);
            adapter.set_awlen(awlen-1);
            adapter.set_awsize(cfg.burst_size);
            adapter.set_awburst(awreq.burst);
            adapter.set_awcache(awreq.cache);
            adapter.set_awprot(awreq.prot);
            adapter.set_awqos(awreq.qos);
            adapter.set_awregion(awreq.region);
            adapter.set_awlock(awreq.exclusive);
            adapter.set_awuser(awreq.awuser);
            adapter.set_awvalid(1'b1);
        join
        adapter.wait_awavail();
        adapter.set_awvalid(1'b0);
        //
        $cast(rsp, awreq.clone()); // copy req due to it will be removed later
        rsp.set_id_info(awreq);
        wtrans_mb.put(awreq);
        awsmp.put();
        //---
        // Wait response
        //---
        do begin
            adapter.wait_bavail();
        end while(adapter.get_bid() != id);
        //rsp.resp = amba_axi4_resp_t'(adapter.get_bresp());
        //rsp.buser = adapter.get_buser();
        // Finish req
        `uvm_info(get_full_name(), $sformatf("Sent transaction[ID=%0d]: %s", id, rsp.convert2string()), UVM_HIGH)
        seq_item_port.put(rsp);
    end
endtask : drive_awchannel

//------------------------------------------------------------------------------
// Method: drive_wchannel
//------------------------------------------------------------------------------
task amba_axi4_driver::drive_wchannel();
    amba_axi4_transaction wreq;
    int wlen;
    bit [`AMBA_AXI4_DATAW-1:0] wdata [];
    bit [`AMBA_AXI4_STRBW-1:0] wstrb [];
    bit [`AMBA_AXI4_USERW-1:0] wuser [];
    int low_addr;
    int pad;
    bit [7:0] q_data [$];
    bit q_strb [$];
    bit [`AMBA_AXI4_DATAW-1:0] tdata;
    bit [`AMBA_AXI4_STRBW-1:0] tstrb;
    
    forever begin
        wtrans_mb.get(wreq);
        //---
        // Prepare request
        //---
        low_addr = wreq.addr & (size - 1);
        wlen = wreq.data.size() + low_addr;
        pad = (wlen % size) ? (size - wlen % size) : 0;
        wlen = (wlen + pad) / size;
        wdata = new[wlen];
        wstrb = new[wlen];
        wuser = new[wlen];
        //
        foreach (wreq.data[i]) begin
            q_data.push_back(wreq.data[i]);
            q_strb.push_back(1'b1);
        end
        repeat (low_addr) begin // pad zeros front
            q_data.push_front(0);
            q_strb.push_front(0);
        end
        repeat (pad) begin // pad zeros back
            q_data.push_back(0);
            q_strb.push_back(0);
        end
        //
        foreach (wdata[i]) begin
            //repeat(size) begin
            //    data[i] <<= 8;
            //    data[i] |= q_data.pop_front();
            //    wstrb[i] <<= 1;
            //    wstrb[i] |= q_strb.pop_front();
            //end
            tdata = 0;
            tstrb = 0;
            for (int j = 0; j < size; j++) begin
                tdata |= q_data.pop_front() << 8*j;
                tstrb |= q_strb.pop_front() << j;
            end
            wdata[i] = tdata;
            wstrb[i] = tstrb;
        end
        //
        foreach (wreq.wuser[i]) begin
            wuser[i] = wreq.wuser[i]; // the rest will be filled by zeros
        end
        //---
        // Send request
        //---
        if (wreq.stress == 1'b0 || adapter.get_wvalid() == 1'b0) adapter.posedge_clock(); // synch with clock
        foreach(wdata[i]) begin
            fork
                adapter.set_wdata(wdata[i]);
                adapter.set_wstrb(wstrb[i]);
                adapter.set_wuser(wuser[i]);
                if (i == wlen-1) adapter.set_wlast(1'b1);
                else adapter.set_wlast(1'b0);
                adapter.set_wvalid(1'b1);
            join
            adapter.wait_wavail();
        end
        adapter.set_wvalid(1'b0);
        adapter.set_wlast(1'b0);
    end
endtask : drive_wchannel

//------------------------------------------------------------------------------
// Method: drive_bchannel
//------------------------------------------------------------------------------
task amba_axi4_driver::drive_bchannel();
    forever begin
        adapter.posedge_clock;
        adapter.set_bready(1'b1);
    end
endtask : drive_bchannel

`endif /* __AMBA_AXI4_DRIVER_SVH__ */
