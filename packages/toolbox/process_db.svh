
//------------------------------------------------------------------------------
// CLASS: process_db
//
// Process ID (PID) database, it could be used to mapping between PIDs and class handles
//
// *Note*: Currently, Cadence IUS (12.2) is not support associate array of process
//------------------------------------------------------------------------------
class process_db #(type T=int);
  static protected T _db [process];
  
  // Function: store
  // Store the value to database
  static function void store(T handle);
    process pid;
    
    pid = process::self();
    _db[pid] = handle;
  endfunction : store
  
  // Function: load
  // Load the value from database (preserve the entry)
  static function T load();
    process pid;
    
    pid = process::self();
    if(_db.exists(pid))
      return _db[pid];
    else
      assert(0) else $fatal("@%0t %m [PID DB] No value is matched for this process", $time);
  endfunction : load
  
  // Function: get
  // Load and remove the value from database
  static function T get();
    T t;
    process pid;
    
    pid = process::self();
    if(_db.exists(pid)) begin
      t = _db[pid];
      _db.delete(pid);
      return t;
    end
    else
      assert(0) else $fatal("@%0t %m [PID DB] No value is matched for this process", $time);
  endfunction : get
  
  // Function: delete
  // Delete the value from database
  static function void delete();
    process pid;
    
    pid = process::self();
    if(_db.exists(pid))
      _db.delete(pid);
    else
      assert(0) else $error("@%0t %m [PID DB] No value is matched for this process", $time);
  endfunction : get
endclass : process_db
