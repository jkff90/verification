//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <spi_if.svh> is a part of <Verification> project
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

// INTERFACE: spi_if
// Serial Peripheral Interface
// see <~HERE~ at http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus> for more detail
//
// Common SPI connection:
// (see spi_interface.png)

interface spi_if(
    input logic clk,
    input logic rst
  );
  //------------------------------------
  // SECTION: Parameters
  //------------------------------------
  
  // const: ENABLE_ASSERTION
  // Set to 1 to enable interface assertion
  parameter bit ENABLE_ASSERTION = 0;

  // const: ENABLE_COVERAGE
  // Set to 1 to enable interface coverage
  parameter bit ENABLE_COVERAGE = 0;
  
  // const: SLAVES
  // Specify the number of slaves pin
  // Default SLAVES value is 1
  parameter bit SLAVES = 1;
  
  
  //------------------------------------
  // SECTION: Properties
  //------------------------------------
  function int _linex(input int width);
    _linex = (width > 0)?(width-1):0;
  endfunction : _linex
  
  // bit: mosi
  // Master Out Slave In
  logic mosi;
  
  // bit: miso
  // Master In Slave Out
  logic miso;
  
  // bits: ss_n
  // Array of negative slave select pins
  logic [_linex(SLAVES):0] ss_n;
  
  
  //------------------------------------
  // SECTION: Assertion
  //------------------------------------
  // make sure there is only one slave is selected
  property p_ss;
    @(posedge clk) $onehot0(ss_n);
  endproperty : p_ss
  
  generate
    if(ENABLE_ASSERTION) begin
      a_ss: assert property(p_ss)
      else $fatal("%m SPI: more than one slaves are selected!");
    end
  endgenerate
  
  
  //------------------------------------
  // SECTION: Coverage
  //------------------------------------
  
  
  //------------------------------------
  // SECTION: Processes
  //------------------------------------
endinterface : spi_if
