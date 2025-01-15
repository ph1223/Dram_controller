class FileReader;
    local logging _logger;
    string _file_directory;
    int _file;
    command_t _pattern[0:NUM_OF_PATTERNS-1];
    data_t _data[0:NUM_OF_PATTERNS-1];
    data_t _golden_data[0:NUM_OF_PATTERNS-1];

    function new(string file_directory);
        this._logger = new("FileReader");
        this._file_directory = file_directory;
    endfunction

    function void read_file_command(string command_file_directory);
        this._logger.info("Reading Command File");
        this._file = $fopen(command_file_directory,"r");
        if(this._file == 0) begin
            this._logger.error("File not found");
            return;
        end

        for(int i=0; i<NUM_OF_PATTERNS; i++) begin
            if($feof(this._file)) begin
                this._logger.error("End of file reached");
                break;
            end
            $fscanf(this._file,"%h %h %h %h %h %h %h %h %h",_pattern[i].r_w,_pattern[i].none_0,_pattern[i].row_addr,_pattern[i].none_1,_pattern[i].burst_length,_pattern[i].none_2,_pattern[i].auto_precharge,_pattern[i].col_addr,_pattern[i].bank_addr);
        end
        $fclose(this._file);
    endfunction

    function void read_file_data(string data_file_directory);
        this._logger.info("Reading Data File");
        this._file = $fopen(data_file_directory,"r");
        if(this._file == 0) begin
            this._logger.error("File not found");
            return;
        end

        for(int i=0; i<NUM_OF_PATTERNS; i++) begin
            if($feof(this._file)) begin
                this._logger.error("End of file reached");
                break;
            end
            for(int j=0; j<8; j++) begin
                $fscanf(this._file,"%h",_data[i][j]);
            end
        end
        $fclose(this._file);
    endfunction

    function void read_file_golden_data(string golden_data_file_directory);
        this._logger.info("Reading Golden Data File");
        this._file = $fopen(golden_data_file_directory,"r");
        if(this._file == 0) begin
            this._logger.error("File not found");
            return;
        end

        for(int i=0; i<NUM_OF_PATTERNS; i++) begin
            if($feof(this._file)) begin
                this._logger.error("End of file reached");
                break;
            end
            for(int j=0; j<8; j++) begin
                $fscanf(this._file,"%h",_golden_data[i][j]);
            end
        end
        $fclose(this._file);
    endfunction
endclass