//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <backdoor_if.sv> is a part of <Verification> project
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
// INTERFACE: backdoor_if
//
// Backdoor interface baseline file (no APIs). It provides a handle from top to
// the test instances. This file must be included to the top file in order to
// get the global vision of the test. You must defines the APIs in side this
// interface to directly access the HDL path. Nevertheless, it is recommended
// to use UVM DPI for backdoor accessing instead.
//
// To use backdoor interface, put these lines in the top file:
//> backdoor_if backdoor();
//> initial begin
//>     uvm_config_db #(virtual backdoor_if)::set(null, "*", "backdoor", backdoor);
//> end
//------------------------------------------------------------------------------
interface backdoor_if;
    // define your APIs here
    //
    // ex: define a function to force a value to "top.dut.csr.reg1"
    //
    // function void force_hdl_reg1(int value);
    //     force top.dut.csr.reg1 = value;
    //     release dut.csr.reg1; // also OK
    // endfunction : force_hdl_reg1
    
    //----------------------------------
    // Common APIs
    //----------------------------------
    
    //----------------------------------
    // Specific APIs
    //----------------------------------
endinterface : backdoor_if
