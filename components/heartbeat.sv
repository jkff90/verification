//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <heartbeat.sv> is a part of <Verification> project
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
// MODULE: heartbeat
//
// + Heartbeating, display information to show that the whole environment is running.
// + Performs final checking for UVM based environment and prints out the test result.
// + Requires uvm_pkg 1.1d or higher.
//------------------------------------------------------------------------------
module heartbeat #(
    parameter time HEARTBEAT = 1_000_000
)(
);
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    uvm_event heartbeat;

    initial begin
        assert(HEARTBEAT >= 1_000_000)
        else `uvm_fatal($sformatf("%m"), $sformatf("The beat cycle is too short: cycle=%0t!", HEARTBEAT))
        heartbeat = new("heartbeat");
        uvm_config_db #(uvm_event)::set(null, "*", "heartbeat", heartbeat);
    end
    
    always #HEARTBEAT begin
        $display("@ %0t: [%m] Beating ...", $time);
        heartbeat.trigger();
    end
    
    final begin : final_block
        uvm_root root;
        uvm_report_server rsvr;
        
        rsvr = uvm_report_server::get_server();
        // Check all phases are done
        if (!$test$plusargs("heartbeat.nocheck")) begin
            root = uvm_root::get();
            if (root.m_phase_all_done != 1) begin
                `uvm_error($sformatf("%m"), "Not all of the UVM phases are done. The environment is termnitated somewhere!")
            end
        end
        // Check UVM report
        if(rsvr.get_severity_count(UVM_ERROR) || rsvr.get_severity_count(UVM_FATAL)) begin
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
endmodule : heartbeat
