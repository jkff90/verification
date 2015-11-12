//------------------------------------------------------------------------------
// Class: video_file_sequence
//------------------------------------------------------------------------------
class video_file_sequence extends uvm_sequence #(video_transaction);
  //--- properties ---
  
  //--- factory registration ---
  `uvm_object_utils(video_file_sequence)
  `uvm_declare_p_sequencer(video_sequencer)
  
  //--- methods ---
  extern function new(string name="video_file_sequence");
  extern virtual task body();
endclass : video_file_sequence

//------------------------------------------------------------------------------
// Constructor: new
//------------------------------------------------------------------------------
function video_file_sequence::new(string name="video_file_sequence");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
// Method: body
//------------------------------------------------------------------------------
task video_file_sequence::body();
  int fhandle;
  bit eof;
  
  fhandle = video_open_data({p_sequencer._config.data_name, ".raw"});
  while(1) begin
    req = video_transaction::type_id::create("req");
    start_item(req);
    req.width = p_sequencer._config.width;
    req.height = p_sequencer._config.height;
    req.interlaced = p_sequencer._config.interlaced;
    req.synchronization = p_sequencer._config.synchronization;
    req.pixels = new[req.width*req.height];
    eof = video_read_data(fhandle, req.pixels, p_sequencer._config.pixels_per_word);
    if(eof) break;
    finish_item(req);
  end
endtask : body
