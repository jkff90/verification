//------------------------------------------------------------------------------
// STRUCTURE: wishbone_master_bfm
// Wishbone master BFM
//
// + Author: An Pham-Duc
// + Last updated: Apr 2nd, 2015
//------------------------------------------------------------------------------
module wishbone_master_bfm (
    wishbone_if vif
  );
  //------------------------------------
  // SECTION: Parameter
  //------------------------------------
  
  // const: WB_ENABLE_ASSERTION
  // Set to 1 to enable Wishbone interface assertion
  parameter bit WB_ENABLE_ASSERTION = 1'b0;
  
  // const: WB_ENABLE_COVERAGE
  // Set to 1 to enable Wishbone interface coverage
  parameter bit WB_ENABLE_COVERAGE = 1'b0;
  
  // const: WB_USE_CYCLE
  // Set to 1 to use _cycle_ pin in Wishbone interface
  parameter bit WB_USE_CYCLE = 1'b0;
  
  parameter bit WB_USE_STALL       = 1'b0;
  parameter bit WB_USE_ERROR       = 1'b0;
  parameter bit WB_USE_LOCK        = 1'b0;
  parameter bit WB_USE_RETRY       = 1'b0;
  parameter bit WB_USE_SELECT      = 1'b0;
  parameter bit WB_USE_DATA_TAG    = 1'b0;
  parameter bit WB_USE_ADDRESS_TAG = 1'b0;
  parameter bit WB_USE_CYCLE_TAG   = 1'b0;
  
  // const: WB_ADDRESS_W
  // Wishbone address width
  parameter int WB_ADDRESS_W = 8;
  
  // const: WB_WORD_W
  // Wishbone word width
  parameter int WB_WORD_W = 8;
  
  parameter int WB_SEL_W          = 1;
  parameter int WB_DATA_TAG_W     = 1;
  parameter int WB_ADDRESS_TAG_W  = 1;
  parameter int WB_CYCLE_TAG_W    = 1;
  
  //--- local ---
  localparam WB_DATA_W = WB_WORD_W*WB_SEL_W;
  
  
  //------------------------------------
  // SECTION: Properties
  //------------------------------------
  int unsigned _time_out;
  
  
  //------------------------------------
  // SECTION: Assertion
  // Controlled by *WB_ENABLE_ASSERTION* parameter
  //
  // Note:
  //   + Asynchronous assertion
  //   + Can not detect reset glitch by assertion?
  //------------------------------------
  
  // property: p_positive_reset
  // Ensure reset is held across positive clock edge
  generate
    if(WB_ENABLE_ASSERTION) begin
      bit reset_half_cycle_flag;
      int reset_counter;
      
      always@(vif.clk) begin
        if(vif.rst) begin
          reset_counter++;
          if(reset_counter%2) reset_half_cycle_flag = 1;
          else                reset_half_cycle_flag = 0;
        end else begin
          reset_counter = 0;
          reset_half_cycle_flag = 0;
        end
      end
  
      sequence s_reset_half_cycle;
        reset_half_cycle_flag ##0 $rose(vif.clk);
      endsequence

      sequence s_reset_non_half_cycle;
        reset_half_cycle_flag && vif.rst ##1 reset_counter > 1;
      endsequence

      property p_positive_reset;
        @(vif.clk) reset_half_cycle_flag |-> s_reset_half_cycle or s_reset_non_half_cycle;
      endproperty
      
      assert property(p_positive_reset)
      else $error("Reset must be held across positive clock edge");
    end
  endgenerate
  
  // property: p_hold_reset
  // Ensure reset must be hold at least 1 clock cycle
  generate
    if(WB_ENABLE_ASSERTION) begin
      property p_hold_reset;
        @(vif.clk) $rose(vif.rst) |-> vif.rst[*3:$];
      endproperty
      
      assert property(p_hold_reset)
      else $error("Reset must be hold at least 1 clock cycle");
    end
  endgenerate
  
  // property: p_ack
  // Ensure _ack_ signal is asserted only when _stb_ signal is asserted
  generate
    if(WB_ENABLE_ASSERTION) begin
      property p_ack;
        @(posedge vif.clk) disable iff(vif.rst) vif.ack |-> vif.stb;
      endproperty
      
      assert property(p_ack)
      else $error("Acknowledge is only asserted when Strobe signal is asserted");
    end
  endgenerate
  
  // property: p_cyc
  // Ensure _cyc_ signal is asserted when _stb_ signal is asserted
  generate
    if(WB_ENABLE_ASSERTION) begin
      property p_cyc;
        @(posedge vif.clk && WB_USE_CYCLE) disable iff(vif.rst) vif.stb |-> vif.cyc;
      endproperty
      
      assert property(p_cyc)
      else $error("Cycle signal must be asserted when Strobe signal is asserted");
    end
  endgenerate
  
  
  //------------------------------------
  // SECTION: Coverage
  // Controlled by *WB_ENABLE_COVERAGE* parameter
  //
  // Note:
  //   + Array of covergroup inside interface is not supported by Cadence IUS
  //------------------------------------
  
  // delegate: cg_address
  // Coverage address
  covergroup cg_address @(posedge vif.clk);
    option.per_instance = 1;
    cp_address: coverpoint vif.adr iff(vif.stb){
      bins zero    = {0};
      bins all_one = {2**WB_ADDRESS_W-1};
      bins rest    = default;
    }
  endgroup
  cg_address c_address;
  initial begin
    if(WB_ENABLE_COVERAGE) begin
      c_address = new();
    end
  end
  
  // delegate: cg_data
  // Coverage data
  covergroup cg_data @(posedge vif.clk);
    option.per_instance = 1;
    cp_data_i: coverpoint vif.dat_i iff(vif.ack && ~vif.we){
      bins zero    = {0};
      bins all_one = {2**WB_DATA_W-1};
      bins rest    = default;
    }
    cp_data_o: coverpoint vif.dat_o iff(vif.stb && vif.we){
      bins zero    = {0};
      bins all_one = {2**WB_DATA_W-1};
      bins rest    = default;
    }
  endgroup
  cg_data c_data;
  initial begin
    if(WB_ENABLE_COVERAGE) begin
      c_data = new();
    end
  end
  
  // delegate: cg_rw
  // Coverage for read/write operation
  covergroup gc_rw @(posedge vif.clk);
    option.per_instance = 1;
    cp_rw: coverpoint vif.we iff(vif.stb);
  endgroup
  
  
  //------------------------------------
  // SECTION: API
  //------------------------------------
  
  // function: set_time_out
  function void set_time_out(int unsigned t=0);
    _time_out = t;
  endfunction : set_time_out
  
  // function: get_time_out
  function int unsigned get_time_out();
    return _time_out;
  endfunction : get_time_out
  
  
  //------------------------------------
  // SECTION: Main
  //------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import uvc_pkg::*;
  
  class wishbone_master_adapter extends wishbone_adapter;
    function new(string name="", uvm_component parent=null);
      super.new(name, parent);
    endfunction : new
    //---
    virtual task init();
      @(posedge vif.rst);
      vif.adr   <= 0;
      vif.dat_o <= 0;
      vif.stb   <= 0;
      vif.we    <= 0;
      vif.cyc   <= 0;
      vif.sel   <= 0;
      vif.err   <= 0;
      vif.lock  <= 0;
      vif.tga   <= 0;
      vif.tgd_o <= 0;
      vif.tgc   <= 0;
      @(negedge vif.rst);
      -> init_done;
    endtask : init
    //---
    virtual task push_transaction(ref wishbone_transaction trans);
      @(posedge vif.clk);
      case(trans.command_e)
        WISHBONE_COMMAND_READ: begin
          vif.adr <= trans.addr;
          vif.stb <= 1'b1;
          if(WB_USE_CYCLE) vif.cyc <= 1'b1;
          vif.we <= 1'b0;
        end
        WISHBONE_COMMAND_WRITE: begin
          vif.adr <= trans.addr;
          vif.stb <= 1'b1;
          if(WB_USE_CYCLE) vif.cyc <= 1'b1;
          vif.we <= 1'b1;
          vif.dat_o <= trans.data;
        end
        default: ;
      endcase
      if(_time_out == 0) begin
        forever begin
          @(posedge vif.clk);
          if(vif.ack === 1'b1) begin
            if(trans.command_e == WISHBONE_COMMAND_READ) trans.data = vif.dat_i;
            vif.stb <= 1'b0;
            if(WB_USE_CYCLE) vif.cyc <= 1'b0;
            break;
          end
        end
      end else begin
        repeat(_time_out) begin
          @(posedge vif.clk);
          if(vif.ack === 1'b1) begin
            if(trans.command_e == WISHBONE_COMMAND_READ) trans.data = vif.dat_i;
            vif.stb <= 1'b0;
            if(WB_USE_CYCLE) vif.cyc <= 1'b0;
            break;
          end
        end
        `uvm_error(get_full_name(), "TIME OUT!")
      end
    endtask : push_transaction
    //---
    virtual task pop_transaction(ref wishbone_transaction trans);
      @(posedge vif.clk iff(vif.stb === 1'b1)) begin
        trans.addr = vif.adr;
        case(vif.we)
          1'b0: begin
            trans.command_e = WISHBONE_COMMAND_READ;
          end
          1'b1: begin
            trans.command_e = WISHBONE_COMMAND_WRITE;
            trans.data = vif.dat_o;
          end
          default: `uvm_fatal(get_full_name(), "INCOMPATIBLE INTERFACE!")
        endcase
        if(_time_out == 0) begin
          forever begin
            @(posedge vif.clk);
            if(vif.ack === 1'b1) begin
              if(trans.command_e == WISHBONE_COMMAND_READ) trans.data = vif.dat_i;
              break;
            end
          end
        end else begin
          repeat(_time_out) begin
            @(posedge vif.clk);
            if(vif.ack === 1'b1) begin
              if(trans.command_e == WISHBONE_COMMAND_READ) trans.data = vif.dat_i;
              break;
            end
          end
          `uvm_error(get_full_name(), "TIME OUT!")
        end
      end
    endtask : pop_transaction
  endclass : wishbone_master_adapter
  wishbone_master_adapter adapter = new("adapter", null);
endmodule : wishbone_master_bfm
