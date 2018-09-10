//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <hvl_top.sv> is a part of <Verification> project
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

module hvl_top;
  import uvm_pkg::*;
  import uvc_pkg::*;
  import test_pkg::*;
  
  initial begin
    uvm_config_db #(avlmm_adapter)::set(null, "uvm_test_top.env.master_agent", "_adapter", hdl_top.avm_wrapper.adapter);
    uvm_config_db #(avlst_adapter)::set(null, "uvm_test_top.env.alpha_env.avlst", "_adapter", hdl_top.aso_alpha_wrapper.adapter);
    uvm_config_db #(avlst_adapter)::set(null, "uvm_test_top.env.background_env.avlst", "_adapter", hdl_top.aso_background_wrapper.adapter);
    uvm_config_db #(avlst_adapter)::set(null, "uvm_test_top.env.foreground_env.avlst", "_adapter", hdl_top.aso_foreground_wrapper.adapter);
    uvm_config_db #(avlst_adapter)::set(null, "uvm_test_top.env.sink_env.avlst", "_adapter", hdl_top.asi_wrapper.adapter);
    uvm_config_db #(avlst_adapter)::set(null, "broadcast", "backdoor", hdl_top.backdoor);
    run_test("base_test");
  end
  
  initial begin
    #100 hdl_top.st_clk.asynchronous_reset(199);
    #100 hdl_top.mm_clk.asynchronous_reset(199);
  end
  
  heartbeat i_heartbeat();
endmodule : hvl_top
