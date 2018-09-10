//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <rcc_config.svh> is a part of <Verification> project
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

`ifndef __RCC_CONFIG_SVH__
`define __RCC_CONFIG_SVH__

//------------------------------------------------------------------------------
// CLASS: rcc_config
//
// Configuration object for RCC. Currently support:
// + Set/Get frequency/clock cycle
// + Reset with delay and hold time
// + The half cycle of the clock are equal, different half cycle is currently unsupported
//------------------------------------------------------------------------------
class rcc_config #(int NRESET = 1) extends uvm_object;
    //--- attributes ---
    
    // bit: auto_reset
    // Automatically reset at the start of the simulation, per reset
    rand bit auto_reset [NRESET];
    
    // bit: sync_reset
    // Synchronous reset with the associated clock, per reset
    rand bit sync_reset [NRESET];
    
    // int: reset_delay
    // Delay time for reset issuing, per reset
    rand time reset_delay [NRESET];
    
    // int: reset_hold
    // Hold time for reset, per reset
    rand time reset_hold [NRESET];
    
    // obj: reset_e
    // Reset event, per reset
    event reset_e [NRESET];
    
    protected rand real freq;
    protected rand time cycle = 10;
    protected real max_freq;
    
    //--- factory registration ---
    `uvm_object_param_utils(rcc_config #(NRESET))
    
    //--- methods ---
    extern function new(string name="rcc_config");
    extern virtual function void do_copy(uvm_object rhs);
    extern virtual function void do_print(uvm_printer printer);
    extern protected virtual function void init();
    extern virtual function void set_frequency(real freq);
    extern virtual function real get_frequency();
    extern virtual function void set_clock_cycle(time cycle);
    extern virtual function time get_clock_cycle();
    extern virtual function void set_auto_reset(bit b);
    extern virtual function void set_sync_reset(bit b);
    extern virtual function void set_reset_delay(time t);
    extern virtual function void set_reset_hold(time t);
    extern virtual function void trigger_reset(int id = 0);
endclass : rcc_config

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function rcc_config::new(string name="rcc_config");
    super.new(name);
    init();
endfunction : new

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void rcc_config::do_copy(uvm_object rhs);
    rcc_config rhs_;
    
    assert($cast(rhs_, rhs));
    foreach (auto_reset[i]) auto_reset[i] = rhs_.auto_reset[i];
    foreach (sync_reset[i]) sync_reset[i] = rhs_.sync_reset[i];
    foreach (reset_delay[i]) reset_delay[i] = rhs_.reset_delay[i];
    foreach (reset_hold[i]) reset_hold[i] = rhs_.reset_hold[i];
    freq = rhs_.freq;
    cycle = rhs_.cycle;
    max_freq = rhs_.max_freq;
endfunction : do_copy

//------------------------------------------------------------------------------
// +Function: do_print
//------------------------------------------------------------------------------
function void rcc_config::do_print(uvm_printer printer);
    printer.print_field("Frequency", freq, 64);
    printer.print_field("Clock cycle", cycle, 64);
    printer.print_field("Max frequency", max_freq, 64);
endfunction : do_print

//------------------------------------------------------------------------------
// +Function: init
//------------------------------------------------------------------------------
function void rcc_config::init();
    max_freq = 1s/1;
    //typedef enum {
    //      RCC_TIME_S
    //    , RCC_TIME_MS
    //    , RCC_TIME_US
    //    , RCC_TIME_NS
    //    , RCC_TIME_PS
    //    , RCC_TIME_FS
    //} rcc_time_e;
    //rcc_time_e time_unit
    //case(max_freq)
    //    1               : begin time_unit = RCC_TIME_S ; end
    //    10              : begin time_unit = RCC_TIME_MS; end
    //    100             : begin time_unit = RCC_TIME_MS; end
    //    1000            : begin time_unit = RCC_TIME_MS; end
    //    10000           : begin time_unit = RCC_TIME_US; end
    //    100000          : begin time_unit = RCC_TIME_US; end
    //    1000000         : begin time_unit = RCC_TIME_US; end
    //    10000000        : begin time_unit = RCC_TIME_NS; end
    //    100000000       : begin time_unit = RCC_TIME_NS; end
    //    1000000000      : begin time_unit = RCC_TIME_NS; end
    //    10000000000     : begin time_unit = RCC_TIME_PS; end
    //    100000000000    : begin time_unit = RCC_TIME_PS; end
    //    1000000000000   : begin time_unit = RCC_TIME_PS; end
    //    10000000000000  : begin time_unit = RCC_TIME_FS; end
    //    100000000000000 : begin time_unit = RCC_TIME_FS; end
    //    1000000000000000: begin time_unit = RCC_TIME_FS; end
    //endcase
    foreach (auto_reset[i]) auto_reset[i] = 0;
    foreach (sync_reset[i]) sync_reset[i] = 0;
    foreach (reset_delay[i]) reset_delay[i] = 0;
    foreach (reset_hold[i]) reset_hold[i] = 100;
endfunction : init

//------------------------------------------------------------------------------
// Function: set_frequency
//------------------------------------------------------------------------------
function void rcc_config::set_frequency(real freq);
    real c;
    
    assert(freq <= max_freq);
    c = 1s/freq; // real cycle
    this.freq = freq;
    this.cycle = c;
endfunction : set_frequency

//------------------------------------------------------------------------------
// Function: get_frequency
//------------------------------------------------------------------------------
function real rcc_config::get_frequency();
    return freq;
endfunction : get_frequency

//------------------------------------------------------------------------------
// Function: set_clock_cycle
//------------------------------------------------------------------------------
function void rcc_config::set_clock_cycle(time cycle);
    real c;
    
    assert(cycle != 0);
    c = cycle; // must convert to real first
    this.cycle = cycle;
    this.freq = 1s/c;
endfunction : set_clock_cycle

//------------------------------------------------------------------------------
// Function: get_clock_cycle
//------------------------------------------------------------------------------
function time rcc_config::get_clock_cycle();
    return cycle;
endfunction : get_clock_cycle

//------------------------------------------------------------------------------
// Function: set_auto_reset
// Set the auto_reset values (all)
//------------------------------------------------------------------------------
function void rcc_config::set_auto_reset(bit b);
    foreach (auto_reset[i]) auto_reset[i] = b;
endfunction : set_auto_reset

//------------------------------------------------------------------------------
// Function: set_sync_reset
// Set the sync_reset values (all)
//------------------------------------------------------------------------------
function void rcc_config::set_sync_reset(bit b);
    foreach (sync_reset[i]) sync_reset[i] = b;
endfunction : set_sync_reset

//------------------------------------------------------------------------------
// Function: set_reset_delay
// Set the reset_delay values (all)
//------------------------------------------------------------------------------
function void rcc_config::set_reset_delay(time t);
    foreach (reset_delay[i]) reset_delay[i] = t;
endfunction : set_reset_delay

//------------------------------------------------------------------------------
// Function: set_reset_hold
// Set the reset_hold values (all)
//------------------------------------------------------------------------------
function void rcc_config::set_reset_hold(time t);
    foreach (reset_hold[i]) reset_hold[i] = t;
endfunction : set_reset_hold

//------------------------------------------------------------------------------
// Function: trigger_reset
// Trigger the reset
//------------------------------------------------------------------------------
function void rcc_config::trigger_reset(int id = 0);
    if (id < NRESET) begin
        `uvm_info(get_full_name(), $sformatf("Triggering reset[%0d] ...", id), UVM_LOW)
        -> reset_e[id];
    end
    else `uvm_warning(get_full_name(), $sformatf("Invalid reset ID: %0d", id))
endfunction : trigger_reset

`endif /* __RCC_CONFIG_SVH__ */
