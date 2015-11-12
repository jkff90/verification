//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <gmii_if.svh> is a part of <Verification> project
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

// INTERFACE: gmii_if
// Gigabit Media-Independent Interface
//
// Note:
//   + The GMII supports only 1000 Mb/s operation and is defined within IEEE
// Standard 802.3, section 3, clause 35
//
// GMII interface:
// (see i2c_interface.png)

interface gmii_if;
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
  
  // bit: GTX_CLK
  // Transmit clock
  logic GTX_CLK;
  
  // bit: RX_CLK
  // Receive clock
  logic RX_CLK;
  
  // bit: TX_EN
  // Transmit enable
  logic TX_EN;
  
  // bit: TDX
  // Transmit data
  logic [7:0] TDX;
  
  // bit: TX_ER
  // Transmit coding error
  logic TX_ER;
  
  // bit: RX_DV
  // Receive data valid
  logic RX_DV;
  
  // bit: RXD
  // Receive data
  logic [7:0] RXD;
  
  // bit: RX_ER
  // Receive error
  logic RX_ER;
  
  // bit: CRS
  // Carrier sense
  logic CRS;
  
  // bit: COL
  // Collision detected
  logic COL;
  
  // bit: MDC
  // Management data clock
  logic MDC;
  
  // bit: MDIO
  // Management data input/output
  logic MDIO;
  
  
  //------------------------------------
  // SECTION: Assertions
  //------------------------------------
  
  
  //------------------------------------
  // SECTION: Coverages
  //------------------------------------
  
  
  //------------------------------------
  // SECTION: Processes
  //------------------------------------
endinterface : gmii_if
