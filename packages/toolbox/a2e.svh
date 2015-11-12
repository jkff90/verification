
//------------------------------------------------------------------------------
// CLASS: a2e
//
// Convert string to enum
//------------------------------------------------------------------------------
class a2e #(type T=int);
  T lookup [string];
  
  function new();
    T e;
    
    e = e.first;
    repeat(e.num) begin
        lookup[e.name] = e;
        e = e.next;
    end
  endfunction : new
  
  // Function: convert
  // Convert input string to enum
  function T convert(string s);
    if(lookup.exists(s))
      convert = lookup[s];
    else
      assert(0) else $error("Identifier '%s' is not in the enum", s);
  endfunction : convert
endclass : a2e
