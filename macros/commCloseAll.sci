function commCloseAll()
    TCL_EvalStr('foreach chan [file channels] {close $chan}');
endfunction
