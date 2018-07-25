//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <rcc_if.sv> is a part of <Verification> project
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
// INTERFACE: rcc_config
//
// RCC interface
//------------------------------------------------------------------------------
interface rcc_if #(parameter NRESET = 1);
    logic clk;
    logic rst  [NRESET];
    logic rstn [NRESET];
    
    genvar i;
    generate
        for (i = 0; i < NRESET; i = i+1) begin : per_reset
            assign rstn[i] = ~rst[i];
        end
    endgenerate
endinterface : rcc_if
