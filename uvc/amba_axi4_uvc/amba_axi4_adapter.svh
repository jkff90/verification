//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_adapter.svh> is a part of <Verification> project
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

`ifndef __AMBA_AXI4_ADAPTER_SVH__
`define __AMBA_AXI4_ADAPTER_SVH__

//------------------------------------------------------------------------------
// CLASS: amba_axi4_adapter
//
// Abstract adapter for amba_axi4 protocol
//------------------------------------------------------------------------------
virtual class amba_axi4_adapter extends uvm_component;
    //--- attributes ---
    
    //--- methods ---
    extern function new(string name="amba_axi4_adapter", uvm_component parent=null);
    
    //---
    // EVENT CONROL
    //---
    pure virtual task posedge_clock  ();
    pure virtual task wait_reset_lo  ();
    pure virtual task wait_reset_hi  ();
    pure virtual task wait_areset_lo ();
    pure virtual task wait_areset_hi ();
    
    pure virtual task wait_arvalid ();
    pure virtual task wait_arready ();
    pure virtual task wait_aravail ();
    pure virtual task wait_rvalid  ();
    pure virtual task wait_rready  ();
    pure virtual task wait_ravail  ();
    pure virtual task wait_awvalid ();
    pure virtual task wait_awready ();
    pure virtual task wait_awavail ();
    pure virtual task wait_wvalid  ();
    pure virtual task wait_wready  ();
    pure virtual task wait_wavail  ();
    pure virtual task wait_bvalid  ();
    pure virtual task wait_bready  ();
    pure virtual task wait_bavail  ();
    
    //---
    // SET
    //---
    
    // INDEX:        - Write Address Channel
    // =====
    pure virtual function void set_awid     (bit [`AMBA_AXI4_IDW  -1:0] awid    );
    pure virtual function void set_awaddr   (bit [`AMBA_AXI4_ADDRW-1:0] awaddr  );
    pure virtual function void set_awlen    (bit [7                 :0] awlen   );
    pure virtual function void set_awsize   (bit [2                 :0] awsize  );
    pure virtual function void set_awburst  (bit [1                 :0] awburst );
    pure virtual function void set_awcache  (bit [3                 :0] awcache );
    pure virtual function void set_awprot   (bit [2                 :0] awprot  );
    pure virtual function void set_awqos    (bit [3                 :0] awqos   );
    pure virtual function void set_awregion (bit [3                 :0] awregion);
    pure virtual function void set_awlock   (bit                        awlock  );
    pure virtual function void set_awuser   (bit [`AMBA_AXI4_USERW-1:0] awuser  );
    pure virtual function void set_awvalid  (bit                        awvalid );
    pure virtual function void set_awready  (bit                        awready );
    
    // INDEX:        - Write Data Channel
    // =====
    pure virtual function void set_wdata  (bit [`AMBA_AXI4_DATAW-1:0] wdata );
    pure virtual function void set_wstrb  (bit [`AMBA_AXI4_STRBW-1:0] wstrb );
    pure virtual function void set_wuser  (bit [`AMBA_AXI4_USERW-1:0] wuser );
    pure virtual function void set_wlast  (bit                        wlast );
    pure virtual function void set_wvalid (bit                        wvalid);
    pure virtual function void set_wready (bit                        wready);
    
    // INDEX:        - Write Response Channel
    // =====
    pure virtual function void set_bid    (bit [`AMBA_AXI4_IDW  -1:0] bid   );
    pure virtual function void set_bresp  (bit [1                 :0] bresp );
    pure virtual function void set_buser  (bit [`AMBA_AXI4_USERW-1:0] buser );
    pure virtual function void set_bvalid (bit                        bvalid);
    pure virtual function void set_bready (bit                        bready);
    
    // INDEX:        - Read Address Channel
    // =====
    pure virtual function void set_arid     (bit [`AMBA_AXI4_IDW  -1:0] arid    );
    pure virtual function void set_araddr   (bit [`AMBA_AXI4_ADDRW-1:0] araddr  );
    pure virtual function void set_arlen    (bit [7                 :0] arlen   );
    pure virtual function void set_arsize   (bit [2                 :0] arsize  );
    pure virtual function void set_arburst  (bit [1                 :0] arburst );
    pure virtual function void set_arcache  (bit [3                 :0] arcache );
    pure virtual function void set_arprot   (bit [2                 :0] arprot  );
    pure virtual function void set_arqos    (bit [3                 :0] arqos   );
    pure virtual function void set_arregion (bit [3                 :0] arregion);
    pure virtual function void set_arlock   (bit                        arlock  );
    pure virtual function void set_aruser   (bit [`AMBA_AXI4_USERW-1:0] aruser  );
    pure virtual function void set_arvalid  (bit                        arvalid );
    pure virtual function void set_arready  (bit                        arready );
    
    // INDEX:        - Read Data Channel
    // =====
    pure virtual function void set_rid    (bit [`AMBA_AXI4_IDW  -1:0] rid   );
    pure virtual function void set_rdata  (bit [`AMBA_AXI4_DATAW-1:0] rdata );
    pure virtual function void set_rresp  (bit [1                 :0] rresp );
    pure virtual function void set_ruser  (bit [`AMBA_AXI4_USERW-1:0] ruser );
    pure virtual function void set_rlast  (bit                        rlast );
    pure virtual function void set_rvalid (bit                        rvalid);
    pure virtual function void set_rready (bit                        rready);
    
    // INDEX:        - Low Power Interface
    // =====
    pure virtual function void set_cactive (bit cactive);
    pure virtual function void set_csysreq (bit csysreq);
    pure virtual function void set_csysack (bit csysack);
    
    // INDEX:        - Write Address Channel
    // =====
    pure virtual function bit [`AMBA_AXI4_IDW  -1:0] get_awid     ();
    pure virtual function bit [`AMBA_AXI4_ADDRW-1:0] get_awaddr   ();
    pure virtual function bit [7                 :0] get_awlen    ();
    pure virtual function bit [2                 :0] get_awsize   ();
    pure virtual function bit [1                 :0] get_awburst  ();
    pure virtual function bit [3                 :0] get_awcache  ();
    pure virtual function bit [2                 :0] get_awprot   ();
    pure virtual function bit [3                 :0] get_awqos    ();
    pure virtual function bit [3                 :0] get_awregion ();
    pure virtual function bit                        get_awlock   ();
    pure virtual function bit [`AMBA_AXI4_USERW-1:0] get_awuser   ();
    pure virtual function bit                        get_awvalid  ();
    pure virtual function bit                        get_awready  ();
    
    // INDEX:        - Write Data Channel
    // =====
    pure virtual function bit [`AMBA_AXI4_DATAW-1:0] get_wdata  ();
    pure virtual function bit [`AMBA_AXI4_STRBW-1:0] get_wstrb  ();
    pure virtual function bit [`AMBA_AXI4_USERW-1:0] get_wuser  ();
    pure virtual function bit                        get_wlast  ();
    pure virtual function bit                        get_wvalid ();
    pure virtual function bit                        get_wready ();
    
    // INDEX:        - Write Response Channel
    // =====
    pure virtual function bit [`AMBA_AXI4_IDW  -1:0] get_bid    ();
    pure virtual function bit [1                 :0] get_bresp  ();
    pure virtual function bit [`AMBA_AXI4_USERW-1:0] get_buser  ();
    pure virtual function bit                        get_bvalid ();
    pure virtual function bit                        get_bready ();
    
    // INDEX:        - Read Address Channel
    // =====
    pure virtual function bit [`AMBA_AXI4_IDW  -1:0] get_arid     ();
    pure virtual function bit [`AMBA_AXI4_ADDRW-1:0] get_araddr   ();
    pure virtual function bit [7                 :0] get_arlen    ();
    pure virtual function bit [2                 :0] get_arsize   ();
    pure virtual function bit [1                 :0] get_arburst  ();
    pure virtual function bit [3                 :0] get_arcache  ();
    pure virtual function bit [2                 :0] get_arprot   ();
    pure virtual function bit [3                 :0] get_arqos    ();
    pure virtual function bit [3                 :0] get_arregion ();
    pure virtual function bit                        get_arlock   ();
    pure virtual function bit [`AMBA_AXI4_USERW-1:0] get_aruser   ();
    pure virtual function bit                        get_arvalid  ();
    pure virtual function bit                        get_arready  ();
    
    // INDEX:        - Read Data Channel
    // =====
    pure virtual function bit [`AMBA_AXI4_IDW  -1:0] get_rid    ();
    pure virtual function bit [`AMBA_AXI4_DATAW-1:0] get_rdata  ();
    pure virtual function bit [1                 :0] get_rresp  ();
    pure virtual function bit [`AMBA_AXI4_USERW-1:0] get_ruser  ();
    pure virtual function bit                        get_rlast  ();
    pure virtual function bit                        get_rvalid ();
    pure virtual function bit                        get_rready ();
    
    // INDEX:        - Low Power Interface
    // =====
    pure virtual function bit get_cactive ();
    pure virtual function bit get_csysreq ();
    pure virtual function bit get_csysack ();
endclass : amba_axi4_adapter

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function amba_axi4_adapter::new(string name="amba_axi4_adapter", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

`endif /* __AMBA_AXI4_ADAPTER_SVH__ */
