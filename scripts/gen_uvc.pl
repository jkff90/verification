#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#  This file <gen_uvc.pl> is a part of <verification> project
#  Copyright (C) 2015  An Pham (anphambk@gmail.com)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#!/usr/bin/perl -w

#===============================================================================
# FILE: gen_uvc.pl
#
# Descriptions:
#   + Generate UVC skeleton package for a layer
#   + All comments are compatible with NaturalDocs
#   + To get input options, go with "--help"
#
# Requirement:
#   + Perl program
#   + Package: Getopt, File
#===============================================================================
use strict;
use warnings;
use Getopt::Long;
use File::Path 'rmtree';
use POSIX qw(strftime);

our $protocol = "undefined";
our $type = 0;
our $author = "An Pham";
our $project = "Verification";
our $email = "anphambk\@gmail.com";
our $help = 0;

GetOptions (
    "protocol=s" => \$protocol,
    "type=i"     => \$type,
    "author=s"   => \$author,
    "project=s"  => \$project,
    "email=s"    => \$email,
    "help"       => \$help
) or die("Error in command line arguments\n");

if($help == 1) {
  print <<END;
#===============================================================================
# OPTIONS : The following options are supported:
#   -protocol <name>: name of protocol to be generated. The default value is <undefined>
#   -type <value>: 0 if interface, 1 if TLM, otherwise if adapter. The default value is <0>
#   -author <name>: name of author. The default value is <anonymous>
#   -project <name>: name of project. The default value is <test>
#   -email <name>: name of email. The default value is <anonymous\@noreply.com>
#   -help: print this message and exit
#===============================================================================
END
  exit;
}

#our $datestring = strftime "%b %e %Y - %r", localtime;
our $datestring = strftime "%Y", localtime;

our $header = <<END;
END

our $footer = <<END;
END

&gen_uvc($protocol);



#===============================================================================
# Subroutine: update_header
#
# Descriptions:                                                                
#   + Update the header
#
# Inputs:
#   + File name
#
# Outputs:
#   + None
#===============================================================================
sub update_header {
    my($file_name) = @_;
    
    $header = <<END;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <$file_name> is a part of <$project> project
//  Copyright (C) $datestring  $author ($email)
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

END
#//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#//               Copyright (C) Applied Micro Circuits Corporation               
#//                              AMCC - PROPRIETARY                              
#// Disclosure to third parties or reproduction in any form whatsoever, without  
#// prior written consent, is strictly forbidden.                                
#//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#//
#// FILE        : $file_name
#// AUTHOR      : $author | $email
#// PROJECT     : $project
#// UPDATE      : Revision 1.0 - $datestring - Initial version
#// DESCRIPTION : 
#//
#//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
}


#===============================================================================
# Subroutine: gen_uvc
#
# Descriptions:                                                                
#   + Call other subroutines to generate full package skeleton
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_uvc {
    my($iname) = @_;
    my $dir_name = $iname."_uvc";
    
    print "Make directory for package: $dir_name\n";
    if(-e $dir_name) {
    print "Removing directory $dir_name .....\n";
    rmtree($dir_name);
    }
    print "Creating directory $dir_name .....\n";
    mkdir $dir_name;
    chdir $dir_name;
    &gen_common($iname);
    &gen_transaction($iname);
    &gen_config($iname);
    &gen_adapter($iname);
    &gen_sequencer($iname);
    &gen_driver($iname, $type);
    &gen_monitor($iname, $type);
    &gen_agent($iname, $type);
    &gen_sequence($iname);
    &gen_passthru_sequence($iname);
    &gen_include($iname);
    &gen_package($iname);
    &gen_interface($iname);
}


#===============================================================================
# Subroutine: gen_common
#
# Descriptions:
#   + Generate protocol UVC type define file
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_common {
    my($iname) = @_;
    my $class_name = $iname."_common";
    my $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

`endif /* __\U$class_name\E_SVH__ */
END

    update_header("$class_name.svh");
    open(FILE, ">$class_name.svh");
    print "Generating $class_name.svh .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
}


#===============================================================================
# Subroutine: gen_transaction
#
# Descriptions:
#   + Generate protocol UVC transaction file
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_transaction {
    my($iname) = @_;
    my $class_name = $iname."_transaction";
    my $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Transaction type for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_sequence_item;
    //--- attributes ---
    
    //--- constraints ---
    
    //--- factory registration ---
    `uvm_object_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name");
    extern virtual function string convert2string();
    //extern virtual function void do_print(uvm_printer printer);
    //extern virtual function void do_record(uvm_recorder recorder);
    extern virtual function void do_copy(uvm_object rhs);
    extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    //extern virtual function void do_pack(uvm_packer packer);
    //extern virtual function void do_unpack(uvm_packer packer);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name");
    super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: convert2string
//------------------------------------------------------------------------------
function string $class_name\::convert2string();
    string s;
    
    return s;
endfunction : convert2string

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void $class_name\::do_copy(uvm_object rhs);
    $class_name rhs_;
    
    assert(\$cast(rhs_, rhs));
endfunction : do_copy

//------------------------------------------------------------------------------
// +Function: do_compare
//------------------------------------------------------------------------------
function bit $class_name\::do_compare(uvm_object rhs, uvm_comparer comparer);
    $class_name rhs_;
    
    assert(\$cast(rhs_, rhs));
    return 1;
endfunction : do_compare

`endif /* __\U$class_name\E_SVH__ */
END

    update_header("$class_name.svh");
    open(FILE, ">$class_name.svh");
    print "Generating $class_name.svh .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
}


#===============================================================================
# Subroutine: gen_config
#
# Descriptions:
#   + Generate protocol UVC configuration object file
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_config {
    my($iname) = @_;
    my $class_name = $iname."_config";
    my $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Configuration object for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_object;
    //--- attributes ---
    
    // enum: is_active = UVM_PASSIVE
    // Decide whether the agent has the driver path (sequencer+driver)
    uvm_active_passive_enum is_active = UVM_PASSIVE;
    
    // bit: has_upper_layer = 0
    // If the protocol has upper layers, a *put\_export* for layering will be created
    bit has_upper_layer = 0;
    
    // bit: has_monitor = 1
    // Decide whether the agent has the monitor
    bit has_monitor = 1;
    
    //--- constraints ---
    
    //--- factory registration ---
    `uvm_object_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name");
    extern virtual function void do_print(uvm_printer printer);
    extern virtual function void do_copy(uvm_object rhs);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name");
    super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Function: do_print
//------------------------------------------------------------------------------
function void $class_name\::do_print(uvm_printer printer);
    printer.print_string("Agent mode", is_active.name());
    printer.print_int("Has upper layer", has_upper_layer, 1);
    printer.print_int("Has monitor", has_monitor, 1);
endfunction : do_print

//------------------------------------------------------------------------------
// +Function: do_copy
//------------------------------------------------------------------------------
function void $class_name\::do_copy(uvm_object rhs);
    $class_name rhs_;
    
    assert(\$cast(rhs_, rhs));
    is_active = rhs_.is_active;
    has_upper_layer = rhs_.has_upper_layer;
    has_monitor = rhs_.has_monitor;
endfunction : do_copy

`endif /* __\U$class_name\E_SVH__ */
END

    update_header("$class_name.svh");
    open(FILE, ">$class_name.svh");
    print "Generating $class_name.svh .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
    close(FILE);
}


#===============================================================================
# Subroutine: gen_adapter
#
# Descriptions:
#   + Generate protocol adapter file
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_adapter {
    my($iname) = @_;
    my $class_name = $iname."_adapter";
    my $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Abstract adapter for $iname protocol
//------------------------------------------------------------------------------
virtual class $class_name extends uvm_component;
    //--- attributes ---
    protected event init_done;
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual task init();
    extern virtual task wait_init();
    
    // Method: push_transaction
    // Pure virtual method, works as a software interface. 
    // Push transaction down to lower protocol
    pure virtual task push_transaction(ref $iname\_transaction trans);
    
    // Method: pop_transaction
    // Pure virtual method, works as a software interface. 
    // Pop transaction from lower protocol
    pure virtual task pop_transaction(ref $iname\_transaction trans);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// Method: init
//------------------------------------------------------------------------------
task $class_name\::init();
    -> init_done;
endtask : init

//------------------------------------------------------------------------------
// Method: wait_init
//------------------------------------------------------------------------------
task $class_name\::wait_init();
    @(init_done);
endtask : wait_init

`endif /* __\U$class_name\E_SVH__ */
END

    update_header("$class_name.svh");
    open(FILE, ">$class_name.svh");
    print "Generating $class_name.svh .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
    close(FILE);
}


#===============================================================================
# Subroutine: gen_sequencer
#
# Descriptions:
#   + Generate protocol UVC sequencer file #
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_sequencer {
    my($iname) = @_;
    my $class_name = $iname."_sequencer";
    my $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Sequencer for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_sequencer #($iname\_transaction);
    //--- attributes ---
    
    // obj: cfg
    // Make this visible for accessing from sequences
    $iname\_config cfg;
    
    //--- factory registration ---
    `uvm_component_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void $class_name\::build_phase(uvm_phase phase);
    assert(uvm_config_db #($iname\_config)::get(this, "", "cfg", cfg));
    super.build_phase(phase);
endfunction : build_phase

`endif /* __\U$class_name\E_SVH__ */
END

  update_header("$class_name.svh");
  open(FILE, ">$class_name.svh");
  print "Generating $class_name.svh .....\n";
  print(FILE $header);
  print(FILE $body);
  print(FILE $footer);
  close(FILE);
}


#===============================================================================
# Subroutine: gen_driver
#
# Descriptions:
#   + Generate protocol UVC driver file
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_driver {
    my($iname, $type) = @_;
    my $class_name = $iname."_driver";
    my $body;
    
    if($type == 0) {
        $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Driver for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_driver #($iname\_transaction);
    //--- attributes ---
    protected $iname\_config cfg;  // protect configuration objects from external access
    protected virtual $iname\_if vif; // protect interface from external access
    
    //--- factory registration ---
    `uvm_component_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void $class_name\::build_phase(uvm_phase phase);
    assert(uvm_config_db #($iname\_config)::get(this, "", "cfg", cfg));
    assert(uvm_config_db #(virtual $iname\_if)::get(this, "", "vif", vif));
    super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task $class_name\::run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        seq_item_port.get_next_item(req);
        // Drive signals
        `uvm_info(get_full_name(), {"Sent transaction: ", req.convert2string()}, UVM_HIGH)
        seq_item_port.item_done();
    end
endtask : run_phase

`endif /* __\U$class_name\E_SVH__ */
END
    }
    elsif($type == 1) {
        $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Driver for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_driver #($iname\_transaction);
    //--- attributes ---
    protected $iname\_config cfg; // protect configuration objects from external access
    
    //--- TLM ports/exports ---
    
    // object: put_port
    // Blocking put port to send transactions to one lower layers. Please take a
    // note that a TLM *put\_port* is only able to connect with one *put\_export*
    uvm_blocking_put_port #($iname\_transaction) put_port;
    
    //--- factory registration ---
    `uvm_component_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void $class_name\::build_phase(uvm_phase phase);
    assert(uvm_config_db #($iname\_config)::get(this, "", "cfg", cfg));
    put_port = new("put_port", this);
    super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task $class_name\::run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        seq_item_port.get_next_item(req);
        put_port.put(req);
        `uvm_info(get_full_name(), {"Sent transaction: ", req.convert2string()}, UVM_HIGH)
        seq_item_port.item_done();
    end
endtask : run_phase

`endif /* __\U$class_name\E_SVH__ */
END
    }
    else {
        $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Driver for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_driver #($iname\_transaction);
    //--- attributes ---
    protected $iname\_config cfg;   // protect configuration objects from external access
    protected $iname\_adapter adapter; // protect adapter from external access
    
    //--- factory registration ---
    `uvm_component_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void $class_name\::build_phase(uvm_phase phase);
    assert(uvm_config_db #($iname\_config)::get(this, "", "cfg", cfg));
    assert(uvm_config_db #($iname\_adapter)::get(this, "", "adapter", adapter));
    super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task $class_name\::run_phase(uvm_phase phase);
    super.run_phase(phase);
    adapter.init();
    forever begin
        seq_item_port.get_next_item(req);
        adapter.push_transaction(req);
        `uvm_info(get_full_name(), {"Sent transaction: ", req.convert2string()}, UVM_HIGH)
        seq_item_port.item_done();
    end
endtask : run_phase

`endif /* __\U$class_name\E_SVH__ */
END
  }

    update_header("$class_name.svh");
    open(FILE, ">$class_name.svh");
    print "Generating $class_name.svh .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
    close(FILE);
}


#===============================================================================
# Subroutine: gen_monitor
#
# Descriptions:
#   + Generate protocol UVC monitor file
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_monitor {
    my($iname, $type) = @_;
    my $class_name = $iname."_monitor";
    my $body;
    my $declaration;
    my $instantiation;
    my $imp_declaration;
    my $implementation;
    
    if($type == 0) {
        $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Monitor for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_component;
    //--- attributes ---
    protected $iname\_config cfg;  // protect configuration objects from external access
    protected virtual $iname\_if vif; // protect interface from external access
    
    //--- TLM ports/exports ---
    
    // object: analysis_port
    // Analysis port that sends monitored transactions to upper layers
    uvm_analysis_port #($iname\_transaction) analysis_port;
    
    //--- factory registration ---
    `uvm_component_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void $class_name\::build_phase(uvm_phase phase);
    assert(uvm_config_db #($iname\_config)::get(this, "", "cfg", cfg));
    assert(uvm_config_db #(virtual $iname\_if)::get(this, "", "vif", vif));
    analysis_port = new(\"analysis_port\", this);
    super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task $class_name\::run_phase(uvm_phase phase);
    $iname\_transaction trans;
    
    super.run_phase(phase);
    forever begin
        trans = $iname\_transaction::type_id::create("trans");
        // Monitor signals
        `uvm_info(get_full_name(), {"Received transaction: ", trans.convert2string()}, UVM_HIGH)
        analysis_port.write(trans);
    end
endtask : run_phase

`endif /* __\U$class_name\E_SVH__ */
END
    }
    elsif($type == 1) {
        $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Monitor for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_component;
    //--- attributes ---
    protected $iname\_config cfg;  // protect configuration objects from external access
    
    //--- TLM ports/exports ---
    
    // object: analysis_port
    // Analysis port that sends monitored transactions to upper layers
    uvm_analysis_port #($iname\_transaction) analysis_port;
    
    // object: analysis_export
    // Analysis port that receives transactions from lower layers
    uvm_analysis_imp #($iname\_transaction, $class_name) analysis_export;
    
    //--- factory registration ---
    `uvm_component_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void write($iname\_transaction trans);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void $class_name\::build_phase(uvm_phase phase);
    assert(uvm_config_db #($iname\_config)::get(this, "", "cfg", cfg));
    analysis_port = new("analysis_port", this);
    analysis_export = new("analysis_export", this);
    super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: write
//------------------------------------------------------------------------------
function void $class_name\::write($iname\_transaction trans);
    // Protocol check
    `uvm_info(get_full_name(), {"Received transaction: ", trans.convert2string()}, UVM_HIGH)
    analysis_port.write(trans);
endfunction : write

`endif /* __\U$class_name\E_SVH__ */
END
    }
    else {
        $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Monitor for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_component;
    //--- attributes ---
    protected $iname\_config cfg;   // protect configuration objects from external access
    protected $iname\_adapter adapter; // protect adapter from external access
    
    //--- TLM ports/exports ---
    
    // object: analysis_port
    // Analysis port that sends monitored transactions to upper layers
    uvm_analysis_port #($iname\_transaction) analysis_port;
    
    //--- factory registration ---
    `uvm_component_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void $class_name\::build_phase(uvm_phase phase);
    assert(uvm_config_db #($iname\_config)::get(this, "", "cfg", cfg));
    assert(uvm_config_db #($iname\_adapter)::get(this, "", "adapter", adapter));
    analysis_port = new("analysis_port", this);
    super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
// +Method: run_phase
//------------------------------------------------------------------------------
task $class_name\::run_phase(uvm_phase phase);
    $iname\_transaction trans;
    
    super.run_phase(phase);
    adapter.wait_init();
    forever begin
        trans = $iname\_transaction::type_id::create("trans");
        adapter.pop_transaction(trans);
        `uvm_info(get_full_name(), {"Received transaction: ", trans.convert2string()}, UVM_HIGH)
        analysis_port.write(trans);
    end
endtask : run_phase

`endif /* __\U$class_name\E_SVH__ */
END
    }
    
    update_header("$class_name.svh");
    open(FILE, ">$class_name.svh");
    print "Generating $class_name.svh .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
    close(FILE);
}


#===============================================================================
# Subroutine: gen_agent
#
# Descriptions:
#   + Generate protocol UVC agent file
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_agent {
    my($iname, $type) = @_;
    my $class_name = $iname."_agent";
    my $body;
    
    if($type == 0) {
        $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Agent for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_agent;
    //--- attributes ---
    
    // object: cfg
    // Configuration object for this agent
    $iname\_config cfg;
    
    // object: vif
    // Virtual interface for this protocol
    virtual $iname\_if vif;
    
    //--- TLM ports/exports ---
    
    // object: put_export
    // Blocking put export to one upper layer. If you want to connect to multiple
    // upper layers, please define a new TLM type.
    uvm_blocking_put_imp #($iname\_transaction, $class_name) put_export;
    
    // object: analysis_port
    // Analysis port to upper layers
    uvm_analysis_port #($iname\_transaction) analysis_port;
    
    //--- children ---
    protected $iname\_driver driver;   // user should not access to driver directly
    protected $iname\_monitor monitor; // user should not access to monitor directly
    
    // object: sequencer
    // UVM sequencer for <$iname\_transaction> type
    $iname\_sequencer sequencer;
    
    //--- factory registration ---
    `uvm_component_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task put($iname\_transaction t);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void $class_name\::build_phase(uvm_phase phase);
    // Get configurations
    if(cfg == null) begin
        if(!uvm_config_db #($iname\_config)::get(this, "", "cfg", cfg)) begin
            `uvm_warning(get_full_name(), "Configuration object is not set to this agent, creating one with default fields.")
            cfg = $iname\_config::type_id::create("cfg");
        end
    end
    if(vif == null) begin
        if(!uvm_config_db #(virtual $iname\_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_full_name(), "Virtual interface is not assigned to this agent.")
        end
    end
    // Start building
    if(cfg.is_active == UVM_ACTIVE) begin
        sequencer = $iname\_sequencer::type_id::create("sequencer", this);
        driver = $iname\_driver::type_id::create("driver", this);
    end
    if(cfg.has_monitor == 1'b1) begin
        monitor = $iname\_monitor::type_id::create("monitor", this);
    end
    if(cfg.has_upper_layer == 1'b1) begin
        put_export = new("put_export", this);
    end
    analysis_port = new("analysis_port", this);
    super.build_phase(phase);
    // Set configurations
    if(cfg.is_active == UVM_ACTIVE) begin
        uvm_config_db #($iname\_config)::set(this, "sequencer", "cfg", cfg);
        uvm_config_db #($iname\_config)::set(this, "driver", "cfg", cfg);
        uvm_config_db #(virtual $iname\_if)::set(this, "driver", "vif", vif);
    end
    if(cfg.has_monitor == 1'b1) begin
        uvm_config_db #($iname\_config)::set(this, "monitor", "cfg", cfg);
        uvm_config_db #(virtual $iname\_if)::set(this, "monitor", "vif", vif);
    end
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void $class_name\::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(cfg.is_active == UVM_ACTIVE) begin
        driver.seq_item_port.connect(sequencer.seq_item_export);
    end
    if(cfg.has_monitor == 1'b1) begin
        monitor.analysis_port.connect(analysis_port);
    end
endfunction : connect_phase

//------------------------------------------------------------------------------
// +Method: put
//------------------------------------------------------------------------------
task $class_name\::put($iname\_transaction t);
    sequencer.execute_item(t);
endtask : put

`endif /* __\U$class_name\E_SVH__ */
END
    }
    elsif($type == 1) {
        $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Agent for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_agent;
    //--- attributes ---
    
    // object: cfg
    // Configuration object for this agent
    $iname\_config cfg;
    
    //--- TLM ports/exports ---
    
    // object: put_export
    // Blocking put export to one upper layer. If you want to connect to multiple
    // upper layers, please define a new TLM type.
    uvm_blocking_put_imp #($iname\_transaction, $class_name) put_export;
    
    // object: analysis_port
    // Analysis port to upper layers
    uvm_analysis_port #($iname\_transaction) analysis_port;
    
    // object: put_port
    // Blocking put port to a lower layer. If you want to connect to multiple
    // lower layers, please define a new TLM type.
    uvm_blocking_put_port #($iname\_transaction) put_port;
    
    // object: analysis_export
    // Analysis export to lower layers
    uvm_analysis_export #($iname\_transaction) analysis_export;
    
    //--- children ---
    protected $iname\_driver driver;   // user should not access to driver directly
    protected $iname\_monitor monitor; // user should not access to monitor directly
    
    // object: sequencer
    // UVM sequencer for <$iname\_transaction> type
    $iname\_sequencer sequencer;
    
    //--- factory registration ---
    `uvm_component_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task put($iname\_transaction t);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void $class_name\::build_phase(uvm_phase phase);
    // Get configurations
    if(cfg == null) begin
        if(!uvm_config_db #($iname\_config)::get(this, "", "cfg", cfg)) begin
            `uvm_warning(get_full_name(), "Configuration object is not set to this agent, creating one with default fields.")
            cfg = $iname\_config::type_id::create("cfg");
        end
    end
    // Start building
    if(cfg.is_active == UVM_ACTIVE) begin
        sequencer = $iname\_sequencer::type_id::create("sequencer", this);
        driver = $iname\_driver::type_id::create("driver", this);
        put_port = new("put_port", this);
    end
    if(cfg.has_monitor == 1'b1) begin
        monitor = $iname\_monitor::type_id::create("monitor", this);
        analysis_export = new("analysis_export", this);
    end
    if(cfg.has_upper_layer == 1'b1) begin
        put_export = new("put_export", this);
    end
    analysis_port = new("analysis_port", this);
    super.build_phase(phase);
    // Set configurations
    if(cfg.is_active == UVM_ACTIVE) begin
        uvm_config_db #($iname\_config)::set(this, "sequencer", "cfg", cfg);
        uvm_config_db #($iname\_config)::set(this, "driver", "cfg", cfg);
    end
    if(cfg.has_monitor == 1'b1) begin
        uvm_config_db #($iname\_config)::set(this, "monitor", "cfg", cfg);
    end
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void $class_name\::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(cfg.is_active == UVM_ACTIVE) begin
        driver.seq_item_port.connect(sequencer.seq_item_export);
        driver.put_port.connect(put_port);
    end
    if(cfg.has_monitor == 1'b1) begin
        analysis_export.connect(monitor.analysis_export);
        monitor.analysis_port.connect(analysis_port);
    end
endfunction : connect_phase

//------------------------------------------------------------------------------
// +Method: put
//------------------------------------------------------------------------------
task $class_name\::put($iname\_transaction t);
    sequencer.execute_item(t);
endtask : put

`endif /* __\U$class_name\E_SVH__ */
END
    }
    else {
        $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Agent for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_agent;
    //--- attributes ---
    
    // object: cfg
    // Configuration object for this agent
    $iname\_config cfg;
    
    // object: adapter
    // Adapter to lower protocols
    $iname\_adapter adapter;
    
    //--- TLM ports/exports ---
    // object: put_export
    // Blocking put export to one upper layer. If you want to connect to multiple
    // upper layers, please define a new TLM type.
    uvm_blocking_put_imp #($iname\_transaction, $class_name) put_export;
    
    // object: analysis_port
    // Analysis port to upper layers
    uvm_analysis_port #($iname\_transaction) analysis_port;
    
    //--- children ---
    protected $iname\_driver driver;   // user should not access to driver directly
    protected $iname\_monitor monitor; // user should not access to monitor directly
    
    // object: sequencer
    // UVM sequencer for <$iname\_transaction> type
    $iname\_sequencer sequencer;
    
    //--- factory registration ---
    `uvm_component_utils($class_name)
    
    //--- methods ---
    extern function new(string name="$class_name", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task put($iname\_transaction t);
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
// +Function: build_phase
//------------------------------------------------------------------------------
function void $class_name\::build_phase(uvm_phase phase);
    // Get configurations
    if(cfg == null) begin
        if(!uvm_config_db #($iname\_config)::get(this, "", "cfg", cfg)) begin
            `uvm_warning(get_full_name(), "Configuration object is not set to this agent, creating one with default fields.")
            cfg = $iname\_config::type_id::create("cfg");
        end
    end
    if(adapter == null) begin
        if(!uvm_config_db #($iname\_adapter)::get(this, "", "adapter", adapter)) begin
            `uvm_fatal(get_full_name(), "Adapter is not assigned to this agent.")
        end
    end
    // Start building
    if(cfg.is_active == UVM_ACTIVE) begin
        sequencer = $iname\_sequencer::type_id::create("sequencer", this);
        driver = $iname\_driver::type_id::create("driver", this);
    end
    if(cfg.has_monitor == 1'b1) begin
        monitor = $iname\_monitor::type_id::create("monitor", this);
    end
    if(cfg.has_upper_layer == 1'b1) begin
        put_export = new("put_export", this);
    end
    analysis_port = new("analysis_port", this);
    super.build_phase(phase);
    // Set configurations
    if(cfg.is_active == UVM_ACTIVE) begin
        uvm_config_db #($iname\_config)::set(this, "sequencer", "cfg", cfg);
        uvm_config_db #($iname\_config)::set(this, "driver", "cfg", cfg);
        uvm_config_db #($iname\_adapter)::set(this, "driver", "adapter", adapter);
    end
    if(cfg.has_monitor == 1'b1) begin
        uvm_config_db #($iname\_config)::set(this, "monitor", "cfg", cfg);
        uvm_config_db #($iname\_adapter)::set(this, "monitor", "adapter", adapter);
    end
endfunction : build_phase

//------------------------------------------------------------------------------
// +Function: connect_phase
//------------------------------------------------------------------------------
function void $class_name\::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(cfg.is_active == UVM_ACTIVE) begin
        driver.seq_item_port.connect(sequencer.seq_item_export);
    end
    if(cfg.has_monitor == 1'b1) begin
        monitor.analysis_port.connect(analysis_port);
    end
endfunction : connect_phase

//------------------------------------------------------------------------------
// +Method: put
//------------------------------------------------------------------------------
task $class_name\::put($iname\_transaction t);
    sequencer.execute_item(t);
endtask : put

`endif /* __\U$class_name\E_SVH__ */
END
    }
    
    update_header("$class_name.svh");
    open(FILE, ">$class_name.svh");
    print "Generating $class_name.svh .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
    close(FILE);
}


#===============================================================================
# Subroutine: gen_sequence
#
# Descriptions:
#   + Generate protocol UVC basic sequence
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_sequence {
    my($iname) = @_;
    my $class_name = $iname."_sequence";
    my $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Basic sequence for $iname protocol
//------------------------------------------------------------------------------
class $class_name extends uvm_sequence #($iname\_transaction);
    //--- attributes ---
    
    //--- factory registration ---
    `uvm_object_utils($class_name)
    `uvm_declare_p_sequencer($iname\_sequencer)
    
    //--- methods ---
    extern function new(string name="$class_name");
    extern virtual task body();
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name");
    super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// +Method: body
//------------------------------------------------------------------------------
task $class_name\::body();
    req = $iname\_transaction::type_id::create("req");
    start_item(req);
    `ifndef DISABLE_SV_FEATURES
    assert(req.randomize() with {
    });
    `endif /* DISABLE_SV_FEATURES */
    finish_item(req);
endtask : body

`endif /* __\U$class_name\E_SVH__ */
END

    update_header("$class_name.svh");
    open(FILE, ">$class_name.svh");
    print "Generating $class_name.svh .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
    close(FILE);
}


#===============================================================================
# Subroutine: gen_passthru_sequence
#
# Descriptions:
#   + Generate protocol UVC pass-through sequence
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_passthru_sequence {
    my($iname) = @_;
    my $class_name = $iname."_passthru_sequence";
    my $body = <<END;
`ifndef __\U$class_name\E_SVH__
`define __\U$class_name\E_SVH__

//------------------------------------------------------------------------------
// CLASS: $class_name
//
// Pass through sequence for $iname protocol. For more information, please refer
// to the paper <"Beyond UVM: Creating Truly Reusable Protocol Layering"
// at http://www.verilog.org/mantis/file_download.php?file_id=5903&type=bug>
//------------------------------------------------------------------------------
class $class_name extends uvm_sequence #($iname\_transaction);
    //--- attributes ---
    
    // variable: sequence_started
    // This event indicates that the sequence has started
    event sequence_started;
    
    // variable: start_transaction
    // Trigger this event to start sending the transaction
    event start_transaction;
    
    // variable: finish_transaction
    // This event indicates that the transaction has been sent
    event finish_transaction;
    
    protected $iname\_transaction trans;
    
    //--- factory registration ---
    `uvm_object_utils($class_name)
    `uvm_declare_p_sequencer($iname\_sequencer)
    
    //--- methods ---
    extern function new(string name="$class_name");
    extern virtual task body();
endclass : $class_name

//------------------------------------------------------------------------------
// +Constructor: new
//------------------------------------------------------------------------------
function $class_name\::new(string name="$class_name");
    super.new(name);
    trans = $iname\_transaction::type_id::create("trans");
endfunction : new

//------------------------------------------------------------------------------
// +Method: body
//------------------------------------------------------------------------------
task $class_name\::body();
    -> sequence_started;
    forever begin
        @(start_transaction);
        req = $iname\_transaction::type_id::create("req");
        start_item(req);
        req.copy(trans);
        finish_item(req);
        -> finish_transaction;
    end
endtask : body

`endif /* __\U$class_name\E_SVH__ */
END

    update_header("$class_name.svh");
    open(FILE, ">$class_name.svh");
    print "Generating $class_name.svh .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
    close(FILE);
}


#===============================================================================
# Subroutine: gen_include
#
# Descriptions:
#   + Generate protocol UVC include file
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_include {
    my($iname) = @_;
    my $include_name = $iname."_uvc";
    my $body = <<END;
typedef class $iname\_transaction;
typedef class $iname\_config;
typedef class $iname\_adapter;
typedef class $iname\_sequencer;
typedef class $iname\_driver;
typedef class $iname\_monitor;
typedef class $iname\_agent;
typedef class $iname\_sequence;
typedef class $iname\_passthru_sequence;

`include "$include_name/$iname\_common.svh"
`include "$include_name/$iname\_transaction.svh"
`include "$include_name/$iname\_config.svh"
`include "$include_name/$iname\_adapter.svh"
`include "$include_name/$iname\_sequencer.svh"
`include "$include_name/$iname\_driver.svh"
`include "$include_name/$iname\_monitor.svh"
`include "$include_name/$iname\_agent.svh"
`include "$include_name/$iname\_sequence.svh"
`include "$include_name/$iname\_passthru_sequence.svh"
END

    #update_header("$include_name.svh");
    open(FILE, ">$include_name.svh");
    print "Generating include file $include_name.sv .....\n";
    #print(FILE $header);
    print(FILE $body);
    #print(FILE $footer);
    close(FILE);
}


#===============================================================================
# Subroutine: gen_package
#
# Descriptions:
#   + Generate protocol UVC package
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_package {
    my($iname) = @_;
    my $package_name = $iname."_uvc_pkg";
    my $body = <<END;
//------------------------------------------------------------------------------
// PACKAGE: $package_name
//
// Package for $iname protocol
//------------------------------------------------------------------------------
package $package_name;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    
    `include "$iname\_uvc/$iname\_uvc.svh"
endpackage : $package_name
END

    update_header("$package_name.sv");
    open(FILE, ">$package_name.sv");
    print "Packing all files in package $package_name.sv .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
    close(FILE);
}


#===============================================================================
# Subroutine: gen_interface
#
# Descriptions:
#   + Generate protocol interface
#
# Inputs:
#   + Name of the protocol
#
# Outputs:
#   + None
#===============================================================================
sub gen_interface {
    my($iname) = @_;
    my $interface_name = $iname."_if";
    my $body = <<END;
//------------------------------------------------------------------------------
// INTERFACE: $interface_name
//
// Interface for $iname protocol
//------------------------------------------------------------------------------
interface $interface_name;
endinterface : $interface_name
END

    update_header("$interface_name.sv");
    open(FILE, ">$interface_name.sv");
    print "Generating interface $interface_name.sv .....\n";
    print(FILE $header);
    print(FILE $body);
    print(FILE $footer);
    close(FILE);
}
