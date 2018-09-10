//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_axi4_if.sv> is a part of <Verification> project
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

//------------------------------------------------------------------------------
// INTERFACE: amba_axi4_if
//
// AMBA AXI protocol
// Version: 4.0
//------------------------------------------------------------------------------
interface amba_axi4_if (
      input logic ACLK
    , input logic ARESETn
);
    // INDEX:        - Paremeters
    // =====
    // Parameters below can be set by the user.
    
    // Set ADDR_WIDTH to the address-bus width required
    parameter ADDR_WIDTH = 32;  // address bus width, default = 32-bit
    
    // Set DATA_WIDTH to the data-bus width required
    parameter DATA_WIDTH = 64;  // data bus width, default = 64-bit

    // Select the number of channel ID bits required
    parameter WID_WIDTH = 4;    // (A|W|R|B)ID width
    parameter RID_WIDTH = 4;    // (A|W|R|B)ID width

    // Select the size of the USER buses, default = 32-bit
    parameter AWUSER_WIDTH = 32;    // width of the user AW sideband field
    parameter WUSER_WIDTH  = 32;    // width of the user W  sideband field
    parameter BUSER_WIDTH  = 32;    // width of the user B  sideband field
    parameter ARUSER_WIDTH = 32;    // width of the user AR sideband field
    parameter RUSER_WIDTH  = 32;    // width of the user R  sideband field
    
    // INDEX:        - Local parameters
    // =====
    // Do not override the following parameters: they must be calculated exactly
    // as shown below
    
    localparam DATA_MAX   = DATA_WIDTH-1;               // data max index
    localparam ADDR_MAX   = ADDR_WIDTH-1;               // address max index
    localparam STRB_WIDTH = DATA_WIDTH/8;               // WSTRB width
    localparam STRB_MAX   = STRB_WIDTH-1;               // WSTRB max index
    localparam ID_MAX_R   = RID_WIDTH? RID_WIDTH-1:0;   // ID max index
    localparam ID_MAX_W   = WID_WIDTH? WID_WIDTH-1:0;   // ID max index

    localparam AWUSER_MAX = AWUSER_WIDTH ? AWUSER_WIDTH-1:0;    // AWUSER max index
    localparam WUSER_MAX  = WUSER_WIDTH ? WUSER_WIDTH-1:0;      // WUSER  max index
    localparam BUSER_MAX  = BUSER_WIDTH ? BUSER_WIDTH-1:0;      // BUSER  max index
    localparam ARUSER_MAX = ARUSER_WIDTH ? ARUSER_WIDTH-1:0;    // ARUSER max index
    localparam RUSER_MAX  = RUSER_WIDTH ? RUSER_WIDTH-1:0;      // RUSER  max index
    
    // INDEX:        - Write Address Channel
    // =====
    wire   [ID_MAX_W:0] AWID;
    wire   [ADDR_MAX:0] AWADDR;
    wire          [7:0] AWLEN;
    wire          [2:0] AWSIZE;
    wire          [1:0] AWBURST;
    wire          [3:0] AWCACHE;
    wire          [2:0] AWPROT;
    wire          [3:0] AWQOS;
    wire          [3:0] AWREGION;
    wire                AWLOCK;
    wire [AWUSER_MAX:0] AWUSER;
    wire                AWVALID;
    wire                AWREADY;
    
    // INDEX:        - Write Data Channel
    // =====
    wire   [DATA_MAX:0] WDATA;
    wire   [STRB_MAX:0] WSTRB;
    wire  [WUSER_MAX:0] WUSER;
    wire                WLAST;
    wire                WVALID;
    wire                WREADY;
    
    // INDEX:        - Write Response Channel
    // =====
    wire   [ID_MAX_W:0] BID;
    wire          [1:0] BRESP;
    wire  [BUSER_MAX:0] BUSER;
    wire                BVALID;
    wire                BREADY;
    
    // INDEX:        - Read Address Channel
    // =====
    wire   [ID_MAX_R:0] ARID;
    wire   [ADDR_MAX:0] ARADDR;
    wire          [7:0] ARLEN;
    wire          [2:0] ARSIZE;
    wire          [1:0] ARBURST;
    wire          [3:0] ARCACHE;
    wire          [2:0] ARPROT;
    wire          [3:0] ARQOS;
    wire          [3:0] ARREGION;
    wire                ARLOCK;
    wire [ARUSER_MAX:0] ARUSER;
    wire                ARVALID;
    wire                ARREADY;
    
    // INDEX:        - Read Data Channel
    // =====
    wire   [ID_MAX_R:0] RID;
    wire   [DATA_MAX:0] RDATA;
    wire          [1:0] RRESP;
    wire  [RUSER_MAX:0] RUSER;
    wire                RLAST;
    wire                RVALID;
    wire                RREADY;
    
    // INDEX:        - Low Power Interface
    // =====
    wire                CACTIVE;
    wire                CSYSREQ;
    wire                CSYSACK;
    
    
    // Clocking block
    clocking cb @(posedge ACLK);
        inout AWID;
        inout AWADDR;
        inout AWLEN;
        inout AWSIZE;
        inout AWBURST;
        inout AWCACHE;
        inout AWPROT;
        inout AWQOS;
        inout AWREGION;
        inout AWLOCK;
        inout AWUSER;
        inout AWVALID;
        inout AWREADY;
        inout WDATA;
        inout WSTRB;
        inout WUSER;
        inout WLAST;
        inout WVALID;
        inout WREADY;
        inout BID;
        inout BRESP;
        inout BUSER;
        inout BVALID;
        inout BREADY;
        inout ARID;
        inout ARADDR;
        inout ARLEN;
        inout ARSIZE;
        inout ARBURST;
        inout ARCACHE;
        inout ARPROT;
        inout ARQOS;
        inout ARREGION;
        inout ARLOCK;
        inout ARUSER;
        inout ARVALID;
        inout ARREADY;
        inout RID;
        inout RDATA;
        inout RRESP;
        inout RUSER;
        inout RLAST;
        inout RVALID;
        inout RREADY;
        inout CACTIVE;
        inout CSYSREQ;
        inout CSYSACK;
    endclocking
    
    //--------------------------------------------------------------------------
    // Abstract class (Adapter)
    //--------------------------------------------------------------------------
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import amba_axi4_uvc_pkg::*;
    
    initial begin : bit_width_check
        assert(`AMBA_AXI4_IDW >= WID_WIDTH)
        else $fatal("[%m] bit width: testbench [AMBA_AXI4_IDW=%0d] must be larger than interface [WID_WIDTH=%0d]", `AMBA_AXI4_IDW, WID_WIDTH);
        
        assert(`AMBA_AXI4_IDW >= RID_WIDTH)
        else $fatal("[%m] bit width: testbench [AMBA_AXI4_IDW=%0d] must be larger than interface [RID_WIDTH=%0d]", `AMBA_AXI4_IDW, RID_WIDTH);
        
        assert(`AMBA_AXI4_ADDRW >= ADDR_WIDTH)
        else $fatal("[%m] bit width: testbench [AMBA_AXI4_ADDRW=%0d] must be larger than interface [ADDR_WIDTH=%0d]", `AMBA_AXI4_ADDRW, ADDR_WIDTH);
        
        assert(`AMBA_AXI4_DATAW >= DATA_WIDTH)
        else $fatal("[%m] bit width: testbench [AMBA_AXI4_DATAW=%0d] must be larger than interface [DATA_WIDTH=%0d]", `AMBA_AXI4_DATAW, DATA_WIDTH);
        
        assert(`AMBA_AXI4_USERW >= AWUSER_WIDTH)
        else $fatal("[%m] bit width: testbench [AMBA_AXI4_USERW=%0d] must be larger than interface [AWUSER_WIDTH=%0d]", `AMBA_AXI4_USERW, AWUSER_WIDTH);
        
        assert(`AMBA_AXI4_USERW >= WUSER_WIDTH)
        else $fatal("[%m] bit width: testbench [AMBA_AXI4_USERW=%0d] must be larger than interface [WUSER_WIDTH=%0d]", `AMBA_AXI4_USERW, WUSER_WIDTH);
        
        assert(`AMBA_AXI4_USERW >= BUSER_WIDTH)
        else $fatal("[%m] bit width: testbench [AMBA_AXI4_USERW=%0d] must be larger than interface [BUSER_WIDTH=%0d]", `AMBA_AXI4_USERW, BUSER_WIDTH);
        
        assert(`AMBA_AXI4_USERW >= ARUSER_WIDTH)
        else $fatal("[%m] bit width: testbench [AMBA_AXI4_USERW=%0d] must be larger than interface [ARUSER_WIDTH=%0d]", `AMBA_AXI4_USERW, ARUSER_WIDTH);
        
        assert(`AMBA_AXI4_USERW >= RUSER_WIDTH)
        else $fatal("[%m] bit width: testbench [AMBA_AXI4_USERW=%0d] must be larger than interface [RUSER_WIDTH=%0d]", `AMBA_AXI4_USERW, RUSER_WIDTH);
    end
    
    class amba_axi4_if_adapter extends amba_axi4_adapter;
        // +Constructor: new
        function new(string name="", uvm_component parent=null);
            super.new(name, parent);
        endfunction : new
        
        //------------------------------
        // EVENT CONTROL
        //------------------------------
        
        task posedge_clock  (); @(cb); endtask
        task wait_reset_lo  (); @(cb iff(ARESETn === 1'b0)); endtask
        task wait_reset_hi  (); @(cb iff(ARESETn === 1'b1)); endtask
        task wait_areset_lo (); @(negedge ARESETn); endtask
        task wait_areset_hi (); @(posedge ARESETn); endtask
        
        task wait_arvalid (); @(cb iff(cb.ARVALID === 1'b1                       )); endtask
        task wait_arready (); @(cb iff(cb.ARREADY === 1'b1                       )); endtask
        task wait_aravail (); @(cb iff(cb.ARVALID === 1'b1 && cb.ARREADY === 1'b1)); endtask
        task wait_rvalid  (); @(cb iff(cb.RVALID  === 1'b1                       )); endtask
        task wait_rready  (); @(cb iff(cb.RREADY  === 1'b1                       )); endtask
        task wait_ravail  (); @(cb iff(cb.RVALID  === 1'b1 && cb.RREADY  === 1'b1)); endtask
        task wait_awvalid (); @(cb iff(cb.AWVALID === 1'b1                       )); endtask
        task wait_awready (); @(cb iff(cb.AWREADY === 1'b1                       )); endtask
        task wait_awavail (); @(cb iff(cb.AWVALID === 1'b1 && cb.AWREADY === 1'b1)); endtask
        task wait_wvalid  (); @(cb iff(cb.WVALID  === 1'b1                       )); endtask
        task wait_wready  (); @(cb iff(cb.WREADY  === 1'b1                       )); endtask
        task wait_wavail  (); @(cb iff(cb.WVALID  === 1'b1 && cb.WREADY  === 1'b1)); endtask
        task wait_bvalid  (); @(cb iff(cb.BVALID  === 1'b1                       )); endtask
        task wait_bready  (); @(cb iff(cb.BREADY  === 1'b1                       )); endtask
        task wait_bavail  (); @(cb iff(cb.BVALID  === 1'b1 && cb.BREADY  === 1'b1)); endtask
        
        //------------------------------
        // SET
        //------------------------------
        
        // INDEX:        - Write Address Channel
        // =====
        function void set_awid     (bit [`AMBA_AXI4_IDW  -1:0] awid    ); cb.AWID     <= awid    ; endfunction
        function void set_awaddr   (bit [`AMBA_AXI4_ADDRW-1:0] awaddr  ); cb.AWADDR   <= awaddr  ; endfunction
        function void set_awlen    (bit [7                 :0] awlen   ); cb.AWLEN    <= awlen   ; endfunction
        function void set_awsize   (bit [2                 :0] awsize  ); cb.AWSIZE   <= awsize  ; endfunction
        function void set_awburst  (bit [1                 :0] awburst ); cb.AWBURST  <= awburst ; endfunction
        function void set_awcache  (bit [3                 :0] awcache ); cb.AWCACHE  <= awcache ; endfunction
        function void set_awprot   (bit [2                 :0] awprot  ); cb.AWPROT   <= awprot  ; endfunction
        function void set_awqos    (bit [3                 :0] awqos   ); cb.AWQOS    <= awqos   ; endfunction
        function void set_awregion (bit [3                 :0] awregion); cb.AWREGION <= awregion; endfunction
        function void set_awlock   (bit                        awlock  ); cb.AWLOCK   <= awlock  ; endfunction
        function void set_awuser   (bit [`AMBA_AXI4_USERW-1:0] awuser  ); cb.AWUSER   <= awuser  ; endfunction
        function void set_awvalid  (bit                        awvalid ); cb.AWVALID  <= awvalid ; endfunction
        function void set_awready  (bit                        awready ); cb.AWREADY  <= awready ; endfunction
        
        // INDEX:        - Write Data Channel
        // =====
        function void set_wdata  (bit [`AMBA_AXI4_DATAW-1:0] wdata ); cb.WDATA  <= wdata ; endfunction
        function void set_wstrb  (bit [`AMBA_AXI4_STRBW-1:0] wstrb ); cb.WSTRB  <= wstrb ; endfunction
        function void set_wuser  (bit [`AMBA_AXI4_USERW-1:0] wuser ); cb.WUSER  <= wuser ; endfunction
        function void set_wlast  (bit                        wlast ); cb.WLAST  <= wlast ; endfunction
        function void set_wvalid (bit                        wvalid); cb.WVALID <= wvalid; endfunction
        function void set_wready (bit                        wready); cb.WREADY <= wready; endfunction
        
        // INDEX:        - Write Response Channel
        // =====
        function void set_bid    (bit [`AMBA_AXI4_IDW  -1:0] bid   ); cb.BID    <= bid   ; endfunction
        function void set_bresp  (bit [1                 :0] bresp ); cb.BRESP  <= bresp ; endfunction
        function void set_buser  (bit [`AMBA_AXI4_USERW-1:0] buser ); cb.BUSER  <= buser ; endfunction
        function void set_bvalid (bit                        bvalid); cb.BVALID <= bvalid; endfunction
        function void set_bready (bit                        bready); cb.BREADY <= bready; endfunction
        
        // INDEX:        - Read Address Channel
        // =====
        function void set_arid     (bit [`AMBA_AXI4_IDW  -1:0] arid    ); cb.ARID     <= arid    ; endfunction
        function void set_araddr   (bit [`AMBA_AXI4_ADDRW-1:0] araddr  ); cb.ARADDR   <= araddr  ; endfunction
        function void set_arlen    (bit [7                 :0] arlen   ); cb.ARLEN    <= arlen   ; endfunction
        function void set_arsize   (bit [2                 :0] arsize  ); cb.ARSIZE   <= arsize  ; endfunction
        function void set_arburst  (bit [1                 :0] arburst ); cb.ARBURST  <= arburst ; endfunction
        function void set_arcache  (bit [3                 :0] arcache ); cb.ARCACHE  <= arcache ; endfunction
        function void set_arprot   (bit [2                 :0] arprot  ); cb.ARPROT   <= arprot  ; endfunction
        function void set_arqos    (bit [3                 :0] arqos   ); cb.ARQOS    <= arqos   ; endfunction
        function void set_arregion (bit [3                 :0] arregion); cb.ARREGION <= arregion; endfunction
        function void set_arlock   (bit                        arlock  ); cb.ARLOCK   <= arlock  ; endfunction
        function void set_aruser   (bit [`AMBA_AXI4_USERW-1:0] aruser  ); cb.ARUSER   <= aruser  ; endfunction
        function void set_arvalid  (bit                        arvalid ); cb.ARVALID  <= arvalid ; endfunction
        function void set_arready  (bit                        arready ); cb.ARREADY  <= arready ; endfunction
        
        // INDEX:        - Read Data Channel
        // =====
        function void set_rid    (bit [`AMBA_AXI4_IDW  -1:0] rid   ); cb.RID    <= rid   ; endfunction
        function void set_rdata  (bit [`AMBA_AXI4_DATAW-1:0] rdata ); cb.RDATA  <= rdata ; endfunction
        function void set_rresp  (bit [1                 :0] rresp ); cb.RRESP  <= rresp ; endfunction
        function void set_ruser  (bit [`AMBA_AXI4_USERW-1:0] ruser ); cb.RUSER  <= ruser ; endfunction
        function void set_rlast  (bit                        rlast ); cb.RLAST  <= rlast ; endfunction
        function void set_rvalid (bit                        rvalid); cb.RVALID <= rvalid; endfunction
        function void set_rready (bit                        rready); cb.RREADY <= rready; endfunction
        
        // INDEX:        - Low Power Interface
        // =====
        function void set_cactive (bit cactive); cb.CACTIVE <= cactive; endfunction
        function void set_csysreq (bit csysreq); cb.CSYSREQ <= csysreq; endfunction
        function void set_csysack (bit csysack); cb.CSYSACK <= csysack; endfunction
        
        //------------------------------
        // GET
        //------------------------------
        
        // INDEX:        - Write Address Channel
        // =====
        function bit [`AMBA_AXI4_IDW  -1:0] get_awid     (); return cb.AWID    ; endfunction
        function bit [`AMBA_AXI4_ADDRW-1:0] get_awaddr   (); return cb.AWADDR  ; endfunction
        function bit [7                 :0] get_awlen    (); return cb.AWLEN   ; endfunction
        function bit [2                 :0] get_awsize   (); return cb.AWSIZE  ; endfunction
        function bit [1                 :0] get_awburst  (); return cb.AWBURST ; endfunction
        function bit [3                 :0] get_awcache  (); return cb.AWCACHE ; endfunction
        function bit [2                 :0] get_awprot   (); return cb.AWPROT  ; endfunction
        function bit [3                 :0] get_awqos    (); return cb.AWQOS   ; endfunction
        function bit [3                 :0] get_awregion (); return cb.AWREGION; endfunction
        function bit                        get_awlock   (); return cb.AWLOCK  ; endfunction
        function bit [`AMBA_AXI4_USERW-1:0] get_awuser   (); return cb.AWUSER  ; endfunction
        function bit                        get_awvalid  (); return cb.AWVALID ; endfunction
        function bit                        get_awready  (); return cb.AWREADY ; endfunction
        
        // INDEX:        - Write Data Channel
        // =====
        function bit [`AMBA_AXI4_DATAW-1:0] get_wdata  (); return cb.WDATA ; endfunction
        function bit [`AMBA_AXI4_STRBW-1:0] get_wstrb  (); return cb.WSTRB ; endfunction
        function bit [`AMBA_AXI4_USERW-1:0] get_wuser  (); return cb.WUSER ; endfunction
        function bit                        get_wlast  (); return cb.WLAST ; endfunction
        function bit                        get_wvalid (); return cb.WVALID; endfunction
        function bit                        get_wready (); return cb.WREADY; endfunction
        
        // INDEX:        - Write Response Channel
        // =====
        function bit [`AMBA_AXI4_IDW  -1:0] get_bid    (); return cb.BID   ; endfunction
        function bit [1                 :0] get_bresp  (); return cb.BRESP ; endfunction
        function bit [`AMBA_AXI4_USERW-1:0] get_buser  (); return cb.BUSER ; endfunction
        function bit                        get_bvalid (); return cb.BVALID; endfunction
        function bit                        get_bready (); return cb.BREADY; endfunction
        
        // INDEX:        - Read Address Channel
        // =====
        function bit [`AMBA_AXI4_IDW  -1:0] get_arid     (); return cb.ARID    ; endfunction
        function bit [`AMBA_AXI4_ADDRW-1:0] get_araddr   (); return cb.ARADDR  ; endfunction
        function bit [7                 :0] get_arlen    (); return cb.ARLEN   ; endfunction
        function bit [2                 :0] get_arsize   (); return cb.ARSIZE  ; endfunction
        function bit [1                 :0] get_arburst  (); return cb.ARBURST ; endfunction
        function bit [3                 :0] get_arcache  (); return cb.ARCACHE ; endfunction
        function bit [2                 :0] get_arprot   (); return cb.ARPROT  ; endfunction
        function bit [3                 :0] get_arqos    (); return cb.ARQOS   ; endfunction
        function bit [3                 :0] get_arregion (); return cb.ARREGION; endfunction
        function bit                        get_arlock   (); return cb.ARLOCK  ; endfunction
        function bit [`AMBA_AXI4_USERW-1:0] get_aruser   (); return cb.ARUSER  ; endfunction
        function bit                        get_arvalid  (); return cb.ARVALID ; endfunction
        function bit                        get_arready  (); return cb.ARREADY ; endfunction
        
        // INDEX:        - Read Data Channel
        // =====
        function bit [`AMBA_AXI4_IDW  -1:0] get_rid    (); return cb.RID   ; endfunction
        function bit [`AMBA_AXI4_DATAW-1:0] get_rdata  (); return cb.RDATA ; endfunction
        function bit [1                 :0] get_rresp  (); return cb.RRESP ; endfunction
        function bit [`AMBA_AXI4_USERW-1:0] get_ruser  (); return cb.RUSER ; endfunction
        function bit                        get_rlast  (); return cb.RLAST ; endfunction
        function bit                        get_rvalid (); return cb.RVALID; endfunction
        function bit                        get_rready (); return cb.RREADY; endfunction
        
        // INDEX:        - Low Power Interface
        // =====
        function bit get_cactive (); return cb.CACTIVE; endfunction
        function bit get_csysreq (); return cb.CSYSREQ; endfunction
        function bit get_csysack (); return cb.CSYSACK; endfunction
    endclass : amba_axi4_if_adapter
    
    amba_axi4_if_adapter adapter = new($sformatf("%m.adapter"));
endinterface : amba_axi4_if
