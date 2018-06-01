//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <uvm_phase_check.svh> is a part of <Verification> project
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

module uvm_phase_check();
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    final begin : final_block
        uvm_root top;
        
        top = uvm_root::get();
        if (top.m_phase_all_done != 1) begin
            `uvm_fatal($sformatf("%m"), "Not all of the UVM phases are done. The environment is termnitated somewhere!")
        end
    end
endmodule : uvm_phase_check
