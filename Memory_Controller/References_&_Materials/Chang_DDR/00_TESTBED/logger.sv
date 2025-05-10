
package logger_pkg;
//======================================
// LOGGERS
//======================================
class logging;
    function new(string step);
        _step = step;
    endfunction

    function void info(string meesage);
        $display("[Info] %s - %s", this._step, meesage);
    endfunction

    function void error(string meesage);
        $display("[Error] %s - %s", this._step, meesage);
        $finish;
    endfunction
    string _step;
endclass

endpackage
