//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <fsdb_dump.svh> is a part of <Verification> project
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

`ifndef __FSDB_DUMP_SVH__
`define __FSDB_DUMP_SVH__

//------------------------------------------------------------------------------
// FILE: fsdb_dump.svh
//
// Including file for FSDB dumping
//------------------------------------------------------------------------------

import sknobs::*;

`ifndef FSDB_TOP
`define FSDB_TOP top
`endif /* FSDB_TOP */

initial begin
    bit     fsdb_enable;
    int     fsdb_depth;
    string  fsdb_name;
    string  fsdb_start;
    string  fsdb_length;
    
    time    fsdb_start_time;
    string  fsdb_start_unit;
    time    fsdb_length_time;
    string  fsdb_length_unit;
    int     cnt;
    
    if ($test$plusargs("fsdb.enable"))
        fsdb_enable = 1;
    else
        fsdb_enable = sknobs::get_value("fsdb.enable", 0);
    if ($test$plusargs("+testgrp"))
        fsdb_enable = 0; // disable fsdb dumping for group test
    if (fsdb_enable) begin
        fsdb_depth  = sknobs::get_value("fsdb.depth", 0);
        fsdb_name   = sknobs::get_string("fsdb.name", "top");
        fsdb_start  = sknobs::get_string("fsdb.start", "0s");
        fsdb_length = sknobs::get_string("fsdb.length", "0s");
        
        cnt = $sscanf(fsdb_start, "%d%s", fsdb_start_time, fsdb_start_unit);
        assert(cnt == 2);
        case(fsdb_start_unit)
            "s" : fsdb_start_time *= 1s ;
            "ms": fsdb_start_time *= 1ms;
            "us": fsdb_start_time *= 1us;
            "ns": fsdb_start_time *= 1ns;
            "ps": fsdb_start_time *= 1ps;
            "fs": fsdb_start_time *= 1fs;
            default: ;
        endcase
        $display("[FSDB DUMP] fsdb.start=%0t", fsdb_start_time);
        
        cnt = $sscanf(fsdb_length, "%d%s", fsdb_length_time, fsdb_length_unit);
        assert(cnt == 2);
        case(fsdb_length_unit)
            "s" : fsdb_length_time *= 1s ;
            "ms": fsdb_length_time *= 1ms;
            "us": fsdb_length_time *= 1us;
            "ns": fsdb_length_time *= 1ns;
            "ps": fsdb_length_time *= 1ps;
            "fs": fsdb_length_time *= 1fs;
            default: ;
        endcase
        $display("[FSDB DUMP] fsdb.length=%0t", fsdb_length_time);
        
        $fsdbDumpfile({fsdb_name, ".fsdb"});
        $fsdbDumpvars(fsdb_depth, `FSDB_TOP, "+mda");
        #(fsdb_start_time);
        $display("@ %0t: [FSDB DUMP] START .....", $time);
        $fsdbDumpon;
        if (fsdb_length_time != 0) begin
            #(fsdb_length_time);
            $display("@ %0t: [FSDB DUMP] END .....", $time);
            $fsdbDumpoff;
        end
    end
end

`endif /* __FSDB_DUMP_SVH__ */
