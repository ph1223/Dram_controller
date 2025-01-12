`include "define.sv"

import user_types::*;
class ScoreBoard();
    local logging _logger;
    // Scoreboard now is a memory for read write
    // We need to store the data and the address of the data
    data_t _memory[0:NO_OF_ROWS-1][0:NO_OF_COLS-1];

    function new();
        this._logger = new("Scoreboard");
        // Initialize the memory
        for(int i=0; i<NO_OF_ROWS; i++) begin
            for(int j=0; j<NO_OF_COLS; j++) begin
                this._memory[i][j] = 0;
            end
        end
    endfunction

    function void write_data(data_t data, int row, int col);
        this._memory[row][col] = data;
    endfunction

    function data_t read_data(int row, int col);
        return this._memory[row][col];
    endfunction
endclass