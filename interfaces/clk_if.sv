//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <clk_if.svh> is a part of <Verification> project
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

interface clk_if;
  //------------------------------------
  // SECTION: Parameters
  //------------------------------------
  
  // const: ENABLE_ASSERTION
  // Set to 1 to enable interface assertion
  parameter bit ENABLE_ASSERTION = 0;

  // const: ENABLE_COVERAGE
  // Set to 1 to enable interface coverage
  parameter bit ENABLE_COVERAGE = 0;
  
  // const: CLOCK_CYCLE
  // Parameter, default value for clock cycle.
  // Default CLOCK_CYCLE value is 10 (depend on time scale)
  parameter time CLOCK_CYCLE = 10;
 

  //------------------------------------
  // SECTION: Properties
  //------------------------------------
  
  // bit: clk
  // Clock pin
  logic clk;
  
  // bit: rst
  // Reset pin
  logic rst;
  
  // bit: rst_
  // Negative reset pin
  logic rst_;
  
  //------ local ------
  time _clock_cycle = CLOCK_CYCLE;
  time _half_clock_cycle = CLOCK_CYCLE/2;
  
  
  //------------------------------------
  // SECTION: API
  //------------------------------------
  
  // function: set_clock_cycle
  // Set clock cycle, _c_ must not be zero
  function void set_clock_cycle(time c=CLOCK_CYCLE);
    if(c != 0) begin
      _clock_cycle = c;
      _half_clock_cycle = _clock_cycle/2;
      if(_clock_cycle%2 != 0) begin
        assert(0) $warning("%m WARNING: clock_cycle=%0d is not divisible by 2, it will be modified", _clock_cycle);
        _clock_cycle = _half_clock_cycle*2;
      end
    end
  endfunction : set_clock_cycle
  
  // function: get_clock_cycle
  // Get the clock cycle value
  function time get_clock_cycle();
    return _clock_cycle;
  endfunction : get_clock_cycle
  
  // method: asynchronous_reset
  // Invoke asynchronous reset for a period of time, _t_ must not be zero
  task asynchronous_reset(time t);
    if(t != 0) begin
      rst <= 1;
      #t rst <= 0;
    end
  endtask : asynchronous_reset
  
  // method: synchronous_reset
  // Invoke synchronous reset for a number of clock cycle, _c_ must not be zero
  task synchronous_reset(int c);
    if(c != 0) begin
      @(posedge clk) rst <= 1;
      repeat(c) @(posedge clk);
      rst <= 0;
    end
  endtask : synchronous_reset
  
  // function: print
  // Print the current value of frequency and its respective clock cycle value
  function void print();
    $display("%m clock_cycle=%0d", _clock_cycle);
  endfunction : print
  
  
  //------------------------------------
  // SECTION: Processes
  // (see clk_rst_interface.png)
  //------------------------------------
  
  //------ local ------
  initial begin
    clk <= 0;
    rst <= 0;
  end
  always #(_half_clock_cycle) clk <= ~clk;
  assign rst_ = ~rst;
  

  //------------------------------------
  // SECTION: Assetion
  //------------------------------------
  property p_check(int period);
    time current_time;
    @(posedge clk) disable iff(rst === 1'b1)
      (('1, current_time=$time) |=> (period == $time-current_time));
  endproperty : p_check

  generate
    if(ENABLE_ASSERTION) begin
      a_check: assert property(p_check(_clock_cycle))
      else $fatal("%m Clock cycle is mismatched!");
    end
  endgenerate
endinterface : clk_if
