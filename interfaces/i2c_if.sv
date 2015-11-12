//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <i2c_if.svh> is a part of <Verification> project
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

// INTERFACE: i2c_if
// Inter-Integrated-Circuit interface from Philips
//
// Note:
//   + Due to the special requirements of I2C pins (open drain, pull up resistor),
// this interface must have 6 instead of 2 pins
//   + The two input pins must be pulled up
//
// Common I2C connection:
// (see i2c_interface.png)

interface i2c_if (
    input logic scl,
    input logic sda
  );
  //------------------------------------
  // SECTION: Properties
  //------------------------------------
  
  // bit: scl_in
  // I2C SCL input pin
  logic scl_in;
  
  // bit: scl_out
  // I2C SCL output pin
  logic scl_out;
  
  // bit: scl_oen
  // I2C SCL output enable pin
  logic scl_oen;
  
  // bit: sda_in
  // I2C SDA input pin
  logic sda_in;
  
  // bit: sda_out
  // I2C SDA output pin
  logic sda_out;
  
  // bit: sda_oen
  // I2C SDA output enable pin
  logic sda_oen;
  
  
  //------------------------------------
  // SECTION: Processes
  //
  // Note:
  //  + bufif0/bufif1 is not available in interface
  //  + beware of "unknown" state of output enable pins
  //------------------------------------
  assign scl = (scl_oen === 1'b1) ? scl_out : 1'bz; // avoid "unknown" state
  //bufif1(scl, scl_out, scl_oen);
  assign sda = (sda_oen === 1'b1) ? sda_out : 1'bz; // avoid "unknown" state
  //bufif1(sda, sda_out, sda_oen);
  assign scl_in = scl;
  assign sda_in = sda;
endinterface : i2c_if
