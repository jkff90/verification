//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  This file <env_uvc_pkg.svh> is a part of <Verification> project
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
// PACKAGE: env_uvc_pkg
//
// Contain all environment for UVCs
//------------------------------------------------------------------------------
package env_uvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import avlst_uvc_pkg::*;
  import packet_uvc_pkg::*;
  import video_uvc_pkg::*;
  import adapter_uvc_pkg::*;
  
  `include "env_uvc/env_uvc.svh"
endpackage: env_uvc_pkg
