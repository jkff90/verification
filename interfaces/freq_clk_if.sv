//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <freq_clk_if.svh> is a part of <Verification> project
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

// Note:
//   + The frequency is independent to time scale directivity
//   + The maximum valid frequency is depended on time scale set to this
// interface. Therefore, the maximum supported frequency is 1PHz (petahertz)
// due to the minimum time unit in SystemVerilog is 1fs (femtosecond)
//   + The clock cycle value is calculated from frequency value and it will be
// rounded down. While generating clock, it will be divided by two and rounded
// down
//   + This interface does not work with old version simulators. It does not
// work with Cadence IUS 8.2 but Cadence IUS 12.2

interface freq_clk_if;
  //------------------------------------
  // SECTION: Parameters
  //------------------------------------
  
  // const: ENABLE_ASSERTION
  // Set to 1 to enable interface assertion
  parameter bit ENABLE_ASSERTION = 0;

  // const: ENABLE_COVERAGE
  // Set to 1 to enable interface coverage
  parameter bit ENABLE_COVERAGE = 0;
  
  // const: FREQUENCY
  // Parameter, default value for frequency.
  // The default FREQUENCY value is 1e8 (100Mhz)
  parameter int unsigned FREQUENCY = 1e8;
  
  
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
  int unsigned _frequency = FREQUENCY;
  longint _scale;
  int unsigned _clock_cycle;
  int unsigned _half_clock_cycle;
  string _time_format;
  
  
  //------------------------------------
  // SECTION: Functions
  //------------------------------------
  
  // function: set_frequency
  // Set clock cycle.
  // _f_ must not be zero
  function void set_frequency(int unsigned f=FREQUENCY);
    if(f != 0) begin
      _frequency = f;
      _clock_cycle = _scale/_frequency;
      _half_clock_cycle = _clock_cycle/2;
      if(_clock_cycle%2 != 0) begin
        assert(0) $warning("%m WARNING: clock_cycle=%0d is not divisible by 2, it will be modified", _clock_cycle);
        _clock_cycle = _half_clock_cycle*2;
        _frequency = _scale/_clock_cycle;
      end
    end
  endfunction : set_frequency
  
  // function: get_frequency
  // Get the clock cycle value
  function int unsigned get_frequency();
    return _frequency;
  endfunction : get_frequency
  
  // method: asynchronous_reset
  // Invoke asynchronous reset for a period of time.
  // _t_ must not be zero
  task asynchronous_reset(time t);
    if(t != 0) begin
      rst <= 1;
      #t rst <= 0;
    end
  endtask : asynchronous_reset
  
  // method: synchronous_reset
  // Invoke synchronous reset for a number of clock cycle.
  // _c_ must not be zero
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
    $display("%m frequency = %0d Hz", _frequency);
    $display("%m clock_cycle = %0d %s", _clock_cycle, _time_format);
  endfunction : print
  
  
  //------------------------------------
  // SECTION: Processes
  // (see clk_rst_interface.png)
  //------------------------------------
  
  // Calculate the scale of time unit in compare with femtosecond
  initial begin
    _scale = 1/1fs;
    case(_scale)
      1   ,1e1 ,1e2 : _time_format = "fs";
      1e3 ,1e4 ,1e5 : _time_format = "ps";
      1e6 ,1e7 ,1e8 : _time_format = "ns";
      1e9 ,1e10,1e11: _time_format = "us";
      1e12,1e13,1e14: _time_format = "ms";
      1e15,1e16,1e17: _time_format = "s" ;
      default       : _time_format = "s" ;
    endcase
    _scale = 1e15/_scale;
    _clock_cycle = _scale/_frequency;
    _half_clock_cycle = _clock_cycle/2;
    if(_clock_cycle%2 != 0) begin
      assert(0) $warning("%m WARNING: clock_cycle=%0d is not divisible by 2, it will be modified", _clock_cycle);
      _clock_cycle = _half_clock_cycle*2;
      _frequency = _scale/_clock_cycle;
    end
  end
  
  // Drive signals
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
endinterface : freq_clk_if
