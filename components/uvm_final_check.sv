//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <uvm_final_check.svh> is a part of <Verification> project
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

//------------------------------------------------------------------------------
// MODULE: uvm_final_check
//
// Performs final checking for UVM based environment and print out the test result.
// Requires uvm_pkg 1.1d or higher.
//------------------------------------------------------------------------------
module uvm_final_check();
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    final begin : final_block
        uvm_root top;
        uvm_report_server srvr;
        
        // Check all phases are done
        top = uvm_root::get();
        if (top.m_phase_all_done != 1) begin
            `uvm_error($sformatf("%m"), "Not all of the UVM phases are done. The environment is termnitated somewhere!")
        end
        // Check UVM report
        srvr = uvm_report_server::get_server();
        if(srvr.get_severity_count(UVM_ERROR) || srvr.get_severity_count(UVM_FATAL)) begin
            $display("%c[1;31m",27);
            $display("||=====================================||");
            $display("||             TEST FAILED             ||");
            $display("||=====================================||");
            $display("%c[0m",27);
        end
        else begin
            $write("%c[1;34m",27); 
            $display("||=====================================||");
            $display("||             TEST PASSED             ||");
            $display("||=====================================||");
            $write("%c[0m",27);
        end
    end
endmodule : uvm_final_check
