function spar_write(path,name,rf_obj,Notes,State)
    % spar_write(path,name,rf_obj,Notes,State)
    % Write S-Parameters to a file. 
    % Add Notes and Status text as comments to sNp file 
    % The RF TB functions:
    %    write(rf_obj,[path,name]);  % write s-par data (obj) to sNp file
    %    rfwrite(rf_obj.S_Parameters, rf_obj.Freq,[path,name] )
    % are used for N >2. 
    % The dialog that advises the existance of the file is VERY annoying!
    % There does not appear to be a way to suppress it.
    %
    % Therefore, neither the write(rf_obj,...) nor rfwrite() will be used 
    % for N = 1  or N = 2. 
    % It is easy to code either of these.
    % Added Zo flexibility May 2018
    % Dick Benson, October 2015, September 2018 
 
    xx=size(rf_obj.S_Parameters); % get dimensions of data
    Zo_str = num2str(rf_obj.Z0);
    if (xx(1)==1) & (xx(2)==1)
        FID=fopen([path,name],'wt');   % 'at' is append, 'wt' is WRITE
        
        fprintf(FID,['# MHz S RI R ',Zo_str,' \n']);
        fprintf(FID,'! S-Parameters data \n');
        fprintf(FID,'! Freq   reS11   imS11  \n');
        
        for k=1:length(rf_obj.Freq)
            fprintf(FID,'%-22.10f %-22.10f %-22.10f \n',...
                rf_obj.Freq(k)*1e-6,...
                real(rf_obj.S_Parameters(1,1,k)),imag(rf_obj.S_Parameters(1,1,k)));
        end;
        
    elseif (xx(1)==2) & (xx(2)==2)
        FID=fopen([path,name],'wt');   % 'at' is append, 'wt' is WRITE
        fprintf(FID,['# MHz S RI R ',Zo_str,' \n']);
        fprintf(FID,'! S-Parameters data \n');
        fprintf(FID,'! Freq   reS11   imS11   reS21   imS21   reS12   imS12   reS22   imS22 \n');
        
        for k=1:length(rf_obj.Freq)
            fprintf(FID,'%-22.10f %-22.10f %-22.10f %-22.10f %-22.10f %-22.10f %-22.10f %-22.10f %-22.10f \n',...
                rf_obj.Freq(k)*1e-6,...
                real(rf_obj.S_Parameters(1,1,k)),imag(rf_obj.S_Parameters(1,1,k)),...
                real(rf_obj.S_Parameters(2,1,k)),imag(rf_obj.S_Parameters(2,1,k)),...
                real(rf_obj.S_Parameters(1,2,k)),imag(rf_obj.S_Parameters(1,2,k)),...
                real(rf_obj.S_Parameters(2,2,k)),imag(rf_obj.S_Parameters(2,2,k)));
        end; % k loop
    else
        % Use RF TB
        write(rf_obj,[path,name]);    % write s-par data (obj) to sNp file
        FID=fopen([path,name],'at');  % open file in APPPEND mode
    end;
    
    % Then add Notes and Status text to the end of sNp file
    
    if ~isempty(Notes)
        str=[{'$Notes'};Notes];
        for k=1:length(str)
            s=str{k};
            fprintf(FID,['!',s,'\n']);
        end;
    end;
    
    if ~isempty(State)
        str=[{'$State'};State];
        for k=1:length(str)
            s=str{k};
            fprintf(FID,['!',s,'\n']);
        end;
    end;
    fclose(FID);
    
