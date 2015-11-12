//------------------------------------------------------------------------------
// Author: anonymous
// Email: anonymous@noreply.com
// Last updated: May 13 2015 - 10:31:40 AM
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// PACKAGE: adapter_uvc_pkg
//
// Contain all adapters for UVCs
//------------------------------------------------------------------------------
package adapter_uvc_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import avlst_uvc_pkg::*;
  import packet_uvc_pkg::*;
  import video_uvc_pkg::*;
  
  `include "adapter_uvc/adapter_uvc.svh"
endpackage : adapter_uvc_pkg
