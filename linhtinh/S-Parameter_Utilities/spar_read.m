function [rf_obj,Notes,State]=spar_read(path,name)
    % [rf_obj,Notes,State]=spar_read(path,name)
    % Read S-Parameters, Notes, and State text from sNp file
    % Dick Benson, October 2015, September 2018
    
    % After the "normal" s-parameter data ....
    % Two DELIMITERS define the 2 sections of extra info.
    % Example
    %   end of s-par data ....
    %
    %   !$Notes     is a DELIMITER
    %   !   This text will be from the user's notes.
    %   !   Enter more text lines
    %   !$State     another DELIMITER
    %   ! This is reserved for instrument settings info.
    %   ! enter more
    % Note that Notes and State infor must come at the END of the sNp file.
    
    rf_obj=rfdata.data;
    
    % The RF Toolbox function gets the S-Parameters
    read(rf_obj,[path,name]);
    
    
    % Now extract Notes and State text if they are present.
    FID=fopen([path,name],'rt');  % re-open sNp file as text
    
    % Cell arrays will hold the Notes and State text
    Notes = {' No Notes Found'};
    State = {' No State Found'};
    
    search=1;  % search flag
    tline = fgetl(FID); % read the 1st line in the file
    % Search file for either delimiter until EOF
    while ischar(tline) && search
        State_flag=strfind(tline,'!$State');
        Notes_flag=strfind(tline,'!$Notes');
        if ~isempty(State_flag) || ~isempty(Notes_flag)
            search=0;   % found either a !$State or !$Notes
        else
            tline = fgetl(FID); % get another line
        end;
    end % while loop
    
    % Create a buffer to hold all the text
    
    line_buffer={tline};  %  1st entry in buffer is last read.
    % Now fill the line buffer it to EOF
    while 1
        tline=fgetl(FID);
        if ischar(tline)
            line_buffer=[line_buffer;tline];% and append a new line to Cell Array
            % until EOF (tline is not a char)
        else
            break
        end;
    end;
    fclose(FID);  % Close, reading is complete.
    
    index = 0;    % index into line buffer cell array
    Lb=length(line_buffer);
    if  Notes_flag ==1
        % !$Notes must have come first, now find !$State
        
        search  = 1;
        index   = 1;
        while search
            if ~isempty(strfind(line_buffer{index},'!$State'))
                search =0; % found it
            else
                index=index+1;  % try again
                if index > Lb
                    break;
                end
            end
        end;        
        if index>=3
            Notes=line_buffer(2:(index-1)); % start at 2 to shed !$Notes
            State=line_buffer((index+1):end);
        end;
        
    elseif State_flag==1
        % !$State came first
        search     = 1;
        index      = 1;
        while search
            if ~isempty(strfind(line_buffer{index},'!$Notes'))
                search =0;
            else
                index=index+1;
                if index > Lb
                    break
                end
            end
        end;       
        if index>=3
            State=line_buffer(2:(index-1));
            Notes=line_buffer((index+1):end);
        end;
    else
        % No Notes or State info found.
        return
    end;
    
    % Strip off the 1st ! character.
    % Not pretty, not efficient, but it works.
    Ln = length(Notes);
    Temp = cell(Ln,1);
    for k =1:Ln
        a_line  = Notes{k};
        Temp{k} = a_line(2:end);
    end;
    Notes = Temp;
    
    Ls = length(State);
    Temp = cell(Ls,1);
    for k =1:Ls
        a_line  = State{k};
        Temp{k} = a_line(2:end);
    end;
    State = Temp;
    
    
