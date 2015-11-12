//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <amba_atb_if.svh> is a part of <Verification> project
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

interface amba_atb_if;
  //------------------------------------
  // SECTION: Parameters
  //------------------------------------
  
  // const: ENABLE_ASSERTION
  // Set to 1 to enable interface assertion
  parameter bit ENABLE_ASSERTION = 0;

  // const: ENABLE_COVERAGE
  // Set to 1 to enable interface coverage
  parameter bit ENABLE_COVERAGE = 0;
  
  //------------------------------------
  // SECTION: Properties
  //------------------------------------
  logic        ATCLK    ;
  logic        ATCLKEN  ;
  logic        ATRESETn ;
  logic        ATREADY  ;
  logic        ATVALID  ;
  logic [1:0]  ATID     ;
  logic [31:0] ATDATA   ;
  logic [6:0]  ATBYTES  ;
  logic        AFREADY  ;
  logic        AFVALID  ;
  
  //------------------------------------
  // SECTION: Clocking
  //------------------------------------
  int input_skew;
  int output_skew;
  
  default clocking mon_cb @(posedge ATCLK);
    default input #(input_skew) output #(output_skew);
    input  ATCLK;
    input  ATCLKEN;
    input  ATRESETn;
    input  ATREADY;
    input  ATVALID;
    input  ATID;
    input  ATDATA;
    input  ATBYTES;
    input  AFREADY;
    input  AFVALID;
  endclocking : mon_cb
  
  clocking mst_cb @(posedge ATCLK);
    input   ATCLK;
    input   ATCLKEN;
    input   ATRESETn;
    input   ATREADY;
    output  ATVALID;
    output  ATID;
    output  ATDATA;
    output  ATBYTES;
    output  AFREADY;
    input   AFVALID;
  endclocking : mst_cb

  clocking slv_cb @(posedge ATCLK);
    default input #(input_skew) output #(output_skew);
    input   ATCLK;
    input   ATCLKEN;
    input   ATRESETn;
    output  ATREADY;
    input   ATVALID;
    input   ATID;
    input   ATDATA;
    input   ATBYTES;
    output  AFVALID;
    input   AFREADY;
  endclocking : slv_cb
  
  //------------------------------------
  // SECTION: Functions
  //------------------------------------
  function int data_w(int byte_w);
    case(byte_w)
      0      : return   8;
      1      : return  16;
      2      : return  32;
      3      : return  64;
      4      : return 128;
      default: return   0; 
    endcase
  endfunction : data_w

  //------------------------------------
  // SECTION: Properties
  //------------------------------------
  property p_reset;
    @(posedge ATCLK)
    (ATVALID === 1'b1) |-> (ATRESETn === 1'b1);
  endproperty

  property p_unknown;
    @(posedge ATCLK) disable iff(ATRESETn === 1'b0 || ATVALID !== 1'b1)
    !($isunknown(ATID) || $isunknown(ATDATA) || $isunknown(ATBYTES));
  endproperty

  property p_retain;
    @(posedge ATCLK) disable iff(ATRESETn === 1'b0)
    ($rose(ATVALID) |=> $stable(ATID && ATDATA && ATBYTES) throughout ((ATVALID !== 1'b1 && ATREADY !== 1'b0)[->1]));
  endproperty

  property p_atdata_atbytes;
    @(posedge ATCLK)
    ($bits(ATDATA) == data_w($bits(ATBYTES)));
  endproperty

  property p_keep_afvalid;
    @(posedge ATCLK) disable iff(ATRESETn === 1'b0)
    ($rose(AFVALID) |=> (AFVALID === 1'b1) throughout (AFREADY[->1]));
  endproperty

  property p_afvalid_afready;
    @(posedge ATCLK) disable iff(ATRESETn === 1'b0)
    (AFREADY === 1'b1 |=> (AFVALID === 1'b0 && AFREADY === 1'b0));
  endproperty

  //------------------------------------
  // SECTION: Assertions
  //------------------------------------
  generate
    if(ENABLE_ASSERTION == 1'b1) begin
      a_reset: assert property (p_reset)
      else $fatal("ATVALID is only drived HIGH after ATRESETn has been HIGH at a rising edge of ATCLK");

      a_unknown: assert property (p_unknown)
      else $fatal("ATID, ATDATA and ATBYTES must be known value while ATVALID is HIGH");

      a_retain: assert property (p_retain)
      else $fatal("ATID, ATDATA and ATBYTES must retained their value while ATVALID HIGH and ATREADY LOW");

      a_atdata_atbytes: assert property (p_atdata_atbytes)
      else $fatal("The bit width of ATDATA and ATBYTES are unmatched");

      a_keep_afvalid: assert property (p_keep_afvalid)
      else $fatal("AFVALID must remains asserted until AFREADY is asserted");

      a_afvalid_afready: assert property (p_afvalid_afready)
      else $fatal("AFVALID and AFREADY must be desasserted one cycle after AFREADY has been asserted");
    end
  endgenerate

  //--------------------
  // SECTION: Coverage
  //--------------------
  covergroup cg_if() @(posedge ATCLK);
    option.per_instance = 1;

    cp_at_states: coverpoint {ATVALID, ATREADY} {
      bins idle     = {2'b00};
      bins invalid  = {2'b01};
      bins notready = {2'b10};
      bins working  = {2'b11};
    }
    cp_slave_flush: coverpoint {ATREADY, AFVALID} {
      bins incapable_of_responding = {2'b10};
    }
    cp_master_flush: coverpoint {AFREADY, ATVALID} {
      bins incapable_of_responding = {2'b10};
    }
    cp_id: coverpoint ATID iff(ATVALID === 1'b1){
      illegal_bins illegal = {'h0, ['h70:'h7C], 'h7E, 'h7F};
    }
    cp_bytes: coverpoint ATBYTES iff(ATVALID === 1'b1);
  endgroup

  generate
    if(ENABLE_COVERAGE == 1'b1) begin
      cg_if cg = new();
    end
  endgenerate
endinterface : amba_atb_if
