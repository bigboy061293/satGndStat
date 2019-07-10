function varargout = s1p_viewer(varargin)
    % S1P_VIEWER M-file for s1p_viewer.fig
    % % Last Modified by GUIDE v2.5 17-Jun-2018 14:45:54
    % Added support for arbitrary Zo ....  May 2018    
    % Dick Benson, September 2018

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 0;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @s1p_viewer_OpeningFcn, ...
        'gui_OutputFcn',  @s1p_viewer_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
end

% --- Executes just before s1p_viewer is made visible.
function s1p_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to s1p_viewer (see VARARGIN)
    
    % Choose default command line output for s1p_viewer
    handles.output = hObject;
    LW=2.0;
    set(handles.zfig_meas,'CurrentAxes',handles.Axes_Smith,...
                          'PaperOrientation', 'landscape','PaperUnits','inches','PaperSize',[11,8.5],'PaperPositionMode','auto',...
                          'Tag','zfig_meas');
    % Note the reversal of the Papersize dimensions. Sure not obvious !
 
    
    
    handles.Zo = 50;  % a placeholder
    % The Smith Chart annotation depends on the Zo, so it is setup in the
    % Open File callback
    axes_color=[1 1 1]/1.2; % light gray
    
    set(handles.zfig_meas,'CurrentAxes',handles.axes_swr);
    handles.h_swr(1)=line('Xdata',0,'Ydata',0,'color',[1 0 0],'Tag','SWR','Linewidth',LW,'visible','off');
    handles.h_Q(1)  =line('Xdata',0,'Ydata',0,'color',[1 0 0],'Tag','Q','Linewidth',LW,'visible','off');
    set(handles.axes_swr,'Yscale','log','YGrid','on','XGrid','on','color',axes_color);
    drawnow;
    title(' SWR ','FontSize',11, 'FontWeight','Bold');
    xlabel('MHz');ylabel('VSWR');
    
    set(handles.zfig_meas,'CurrentAxes',handles.axes_real_imag);
    [handles.axes_real_imag,handles.h_real(1),handles.h_imag(1)]=plotyy(0,0,0,0);
    
    red =  [1 0 0];
    blue = [0 0 1];
    set(handles.h_real(1),'Color',red,'Linewidth',LW,'Tag','Real');
    set(handles.h_imag(1),'Color',blue,'Linewidth',LW,'Tag','Imag');
    set(handles.axes_real_imag,'XlimMode','auto','YLimMode','auto','YGrid','on','XGrid','on','YTickMode','auto','Tag','axes_real_imag');
    set(handles.axes_real_imag(1),'Ycolor',red,'Yscale','log'); set(handles.axes_real_imag(2),'Ycolor',blue);
    set(handles.axes_real_imag(2),'color',axes_color);
    set(handles.axes_real_imag(1),'color','none');
    xlabel(handles.axes_real_imag(1),'MHz');
    ylabel(handles.axes_real_imag(1),'|Real(Z)| Ohms','Color',red);
    ylabel(handles.axes_real_imag(2),'Imag(Z) Ohms','Color',blue);
    title('|Real(Z)| & Imag(Z)');
    
    set(handles.zfig_meas,'CurrentAxes',handles.axes_mag_phase);
    [handles.axes_mag_phase,handles.h_mag,handles.h_phase]=plotyy(0,0,0,0);
    set(handles.h_mag(1),'Color',red,'Linewidth',LW,'Tag','Mag');
    set(handles.h_phase(1),'Color',blue,'Linewidth',LW,'Tag','Phase');
    set(handles.axes_mag_phase,'XlimMode','auto','YLimMode','auto','YGrid','on','XGrid','on','YTickMode','auto','Tag','axes_mag_phase');
    set(handles.axes_mag_phase(1),'Ycolor',red,'Yscale','log'); set(handles.axes_mag_phase(2),'Ycolor',blue);
    set(handles.axes_mag_phase(2),'color',axes_color);
    set(handles.axes_mag_phase(1),'color','none');
    xlabel(handles.axes_mag_phase(1),'MHz');
    ylabel(handles.axes_mag_phase(1),'|Z|','Color',red);
    ylabel(handles.axes_mag_phase(2),'Phase Z in Deg.','Color',blue);
    title(' Z Magnitude and Phase')
    
    set(handles.notes,'string',{'Enter Notes Here'});
    set([handles.Q_contours,handles.SWR_circles],'visible','off');
    set([handles.add_plots,handles.erase_plots,handles.add_color,handles.Active_Plot_File],'visible','off');
    set(handles.Save_File,'enable','off'); 
    handles.nplots=1;  % number of plots
    
    % Stuff to activate DataTip callback on update
    dcm_obj = datacursormode(handles.zfig_meas);
    datacursormode on;
    set(dcm_obj,'UpdateFcn', @data_tip_updatefcn )
   
    %  Update handles structure
    guidata(hObject, handles);
    clc
end

% --- Outputs from this function are returned to the command line.
function varargout = s1p_viewer_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
end
% --- Executes on button press in get_measurement.


function handles=Create_Smith_Chart(handles)
    LW=2.0;
    set(handles.zfig_meas,'CurrentAxes',handles.Axes_Smith);
    set(handles.Axes_Smith,'Tag','Smith','UserData',[]);
    SP.Zo=handles.Zo;
    SP.Rvalues=[0 10 25 50 100 250]*SP.Zo/50;    % SP= Smith Parameters
    SP.Xvalues=[10 25 50 100 200 500]*SP.Zo/50;
    
    SP.Nseg=61;
    SP.LW  = 1;  % LW= line width for Smith coordinates
    SP.swr_circles =[10 5 3 1.5]; % set to [] for no SWR circles
    SP.LW_swr = 1; % Line width for SWR circles. 
    
    SP.colors.grid= [0 0 0];              % black coordinate lines
    SP.colors.fill= [100 100 100 ]/256;   % gray background
    SP.colors.inner_text= [1 1 0];        % inner labels
    SP.colors.outer_text= [0 0 0];        % outer labels
    SP.colors.swr    = [0 1 1];           % swr circle color
    SP.colors.Q      = [0 0 1];           % Q contour color
    SP.Q_contours    = [50 20 10 5 2 1];
    SP.Q_pts         = 100;               % number of points in a contour
    SP.LW_Q          = 1;
    
    if isfield(handles,'smith')
        % wipe out all smith chart related graphical objects.
        % this is easier than selectivly editing the objects.
        h=handles.smith;
        delete(h.lx);
        delete(h.fill);
        delete(h.txt);
        delete(h.swr);
        delete(h.Q);
        delete(handles.h_smith)
    end;
    handles.smith=smith_rab_v2(handles.Axes_Smith,SP);
    handles.h_smith(1)=line('Xdata',0,'Ydata',0,'Color',[1 0 0 ],'Linewidth',LW,'Tag','Rho');
    
    if get(handles.Q_contours,'Value') ==1
        set(handles.smith.Q,'Visible','On');
    else
        set(handles.smith.Q,'Visible','Off');
    end
    
    if get(handles.SWR_circles,'Value')==1
        set(handles.smith.swr,'Visible','On');
    else
        set(handles.smith.swr,'Visible','Off');
    end
    hObject=handles.zfig_meas;
    guidata(hObject, handles);
end

function plot_s11(handles,s11_meas)
    n_line=handles.nplots;
    Fvec=s11_meas.Fvec;
    s11 =s11_meas.s11;
    Fstart=Fvec(1);
    Fstop=Fvec(end);
    z0=handles.Zo;
    z= squeeze(z0*(1+s11)./(1-s11));
    
    set(handles.zfig_meas,'CurrentAxes',handles.Axes_Smith);
    % Adding userdata to every line is hideously inefficient but it sure
    % simplifies the cursor stuff.  Memory is cheap these days.
    set(handles.h_smith(n_line),'Xdata',real(s11),'Ydata',imag(s11),'visible','on','Userdata',s11_meas);
    set(handles.Axes_Smith,'Tag','Smith');
    set(handles.zfig_meas,'CurrentAxes',handles.axes_swr);
    
    % The SWR axis will do double duty.
    % The Q will be plotted if the SWR is ridiculous.
    % This probably turns out not to be a great idea since management of two lines is
    % more difficult than one.
    swr=abs((1+abs(s11))./(1-abs(s11)));
    min_swr=min(swr);
    swr_threshold=10;
    if n_line>1
        % use whatever was previously selected
        s=handles.axes_swr.Title.String;
        if strcmp(s,'SWR')
            min_swr=10; % force SWR
        else
            min_swr=11; % force Q
        end;
        
    end;
    set(handles.zfig_meas,'CurrentAxes',handles.axes_swr);
    list = get(handles.Active_Plot_File,'Userdata')';
    if min_swr <= swr_threshold
        % plot SWR
        set(handles.h_Q(n_line),'visible','off');
        set(handles.axes_swr,'Ylim',[1 swr_threshold],'Xlim',[Fstart,Fstop]*1e-6);
        set(handles.h_swr(n_line),'Xdata',Fvec*1e-6,'Ydata',swr,'Tag','SWR','visible','on','UserData',s11_meas);
        title('SWR');
        ylabel('VSWR');
        if length(list)==n_line
            hl=legend(handles.h_swr(1:n_line),list);
            set(hl,'Interpreter','none');
        end;
    else
        % plot Q
        set(handles.h_swr(n_line),'visible','off');
        Q=abs(imag(z)./real(z));
        set(handles.h_Q(n_line),'Xdata',Fvec*1e-6,'Ydata',Q,'Tag','Q','visible','on','UserData',s11_meas);
        set(handles.axes_swr,'Ylim',[0 1.1*max(Q)],'Xlim',[Fstart,Fstop]*1e-6);
        title('Q vs Freq');
        ylabel('Q');
        if length(list)==n_line
            hl=legend(handles.h_Q(1:n_line),list);
            set(hl,'Interpreter','none');
        end;
    end;
    set(handles.zfig_meas,'CurrentAxes',handles.axes_real_imag);
    set(handles.axes_real_imag,'UserData',[Fvec,z]);
    set(handles.h_real(n_line),'Xdata',Fvec*1e-6,'Ydata',abs(real(z)),'UserData',s11_meas);
    set(handles.h_imag(n_line),'Xdata',Fvec*1e-6,'Ydata',imag(z),'UserData',s11_meas);
    if n_line==1
        legend('|Real(Z)| Ohms','Imag(Z) Ohms');
    end;
    set(handles.zfig_meas,'CurrentAxes',handles.axes_mag_phase);
    mag_phase=[abs(z),(180/pi)*atan2(imag(z),real(z))];
    set(handles.h_mag(n_line),'Xdata',Fvec*1e-6,'Ydata',abs(z),'UserData',s11_meas);
    set(handles.h_phase(n_line),'Xdata',Fvec*1e-6,'Ydata',(180/pi)*atan2(imag(z),real(z)),'UserData',s11_meas);
    set(handles.axes_mag_phase,'UserData',[Fvec,mag_phase]);
    if n_line==1
        legend('|Z| Ohms','Phase Deg.');
    end;
end


% --------------------------------------------------------------------
function Save_File_ClickedCallback(hObject, eventdata, handles)
    % hObject    handle to Save_File (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    p = mfilename('fullpath');  % returns where this mcode lives.
    % But it also returns the function name which needs to be stripped off.
    k=strfind(p,'\');
    home_path=p(1:k(end));
    f_name='Last_s1p_Viewer_Path.mat';
    if exist(f_name,'file')
        last_path   = load(f_name);
        if ~exist(last_path.path,'dir')
            last_path.path='';
        end;
    else
        last_path.path='';
    end;
    filter_spec = [last_path.path,'*.s1p'];
    [FileName,path] = uiputfile(filter_spec,'Write s1p file');
    if FileName ~=0
        s11_meas=get(handles.h_smith(1),'Userdata');
        rf_obj=rfdata.data;
        rf_obj.Freq=s11_meas.Fvec;
        rf_obj.S_Parameters(1,1,:)=s11_meas.s11;
        rf_obj.Z0= handles.Zo;
        State=get(handles.status,'string');
        Notes_mat=get(handles.notes,'string');
        % convert to cell array if it is not already one.
        if iscell(Notes_mat)
            Notes=Notes_mat;
        else
            disp('Not sure why it got here! Search NOTACELL')
            [r,c]=size(Notes_mat);
            Notes=[];
            for k=1:r
                Notes{k}=Notes_mat(k,:);
            end;
            Notes=Notes';
        end
        spar_write(path,FileName,rf_obj,Notes,State);
        set(handles.zfig_meas,'Name',['File: ',path,FileName]);
        save([home_path,f_name],'path')
    end
end

function Load_File_Callback(Path,FileName)
    %  disp(['FileName ',FileName]);
    hf=findobj('Tag','zfig_meas');
    % For the above to work, one needs to activate the
    % Command Line Accesibility On option under GUI Options in the GUIDE editor.
    if isempty(hf)
        s1p_viewer; % launch this gui
    end;
    hf=findobj('Tag','zfig_meas');
    handles=guidata(hf);
    Open_File_ClickedCallback([],[],handles,{Path},{FileName});
end

function Load_New_File_Callback(Path,FileName)
    %  disp(['FileName ',FileName]);
    hf=findobj('Tag','zfig_meas');
    % For the above to work, one needs to activate the
    % Command Line Accesibility On option under GUI Options in the GUIDE editor.
    if isempty(hf)
        s1p_viewer; % launch this gui
    end;
    hf=findobj('Tag','zfig_meas');
    handles=guidata(hf(1));
    erase_plots_Callback([], [], handles);
    set(handles.add_plots,'value',0);
    add_plots_Callback([], [], handles);
    Open_File_ClickedCallback([],[],handles,{Path},{FileName});
end

function Load_Data_Callback(meas);
    hf=findobj('Tag','zfig_meas');
    % For the above to work, one needs to activate the
    % Command Line Accesibility On option under GUI Options in the GUIDE editor.
    handles=guidata(hf(1));   % hf(1) in case there is more than one 
    handles=Create_Smith_Chart(handles);
    sxx_meas.s11=meas{1,1}.sxx;
    sxx_meas.Fvec=meas{1,1}.Fvec;
    
    path_name   = meas{1,1}.Label;
    bk_slash=strfind(path_name,'\');
    if ~isempty(bk_slash)
        k_last=bk_slash(end)+1;
        name=path_name(k_last:end);
        sxx_meas.name=name;
    else
        sxx_meas.name=path_name;
    end
    
    set(handles.zfig_meas,'Name',meas{1,1}.Label);
    set(handles.status,'string',meas{1,1}.State);
    set(handles.notes,'string',meas{1,1}.Notes);
    handles.nplots=1;
    set(handles.Active_Plot_File,'string',sxx_meas.name);
    set(handles.add_plots,'visible','on','value',0);
    plot_s11(handles,sxx_meas)
    guidata(handles.zfig_meas, handles);
    set([handles.Q_contours,handles.SWR_circles],'visible','on');
end

% --------------------------------------------------------------------
function Open_File_ClickedCallback(hObject, eventdata, handles,varargin)
    % hObject    handle to Open_File (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    p = mfilename('fullpath');  % returns where this mcode lives.
    % But it also returns the function name which needs to be stripped off.
    k=strfind(p,'\');
    home_path=p(1:k(end));
    f_name='Last_s1p_Viewer_Path.mat';
    if exist(f_name,'file')
        last_path   = load(f_name);
        if ~exist(last_path.path,'dir')
            last_path.path='';
        end;
    else
        last_path.path='';
    end;
    
    if isempty(varargin)
        filter_spec = [last_path.path,'*.s1p'];
        [name,path,filter]=uigetfile(filter_spec,'Read s1p file');
        if name ~=0
            [rf_obj,Notes,State]=spar_read(path,name);
        else
            return
        end;
    else
        % Magic to convert from cell to strings.
        path=varargin{1};
        path=char(path{1});
        name=(varargin{2});
        name=char(name{1});
        [rf_obj,Notes,State]=spar_read(path,name);
    end;
    
    s11_meas.Fvec = rf_obj.Freq;
    s11_meas.s11  = squeeze(rf_obj.S_Parameters(1,1,:));
    s11_meas.name = name;
    
    
    if  get(handles.add_plots,'Value')==0
        % A "normal" single plot
        handles.Zo = rf_obj.Z0;  % The s1p_viewer now supports arbitrary Zo
        handles=Create_Smith_Chart(handles);
        set([handles.Q_contours,handles.SWR_circles],'visible','on');
        set(handles.zfig_meas,'Name',['File: ',path,name]);
       
        handles.nplots=1;
        s11_meas.color=[0 0 0];
        s11_meas.index = 1;   
        
        list{1}=name;
        set(handles.Active_Plot_File,'string',name,'Userdata',list,'Visible','on','ForegroundColor',[0 0 0]);
        state_store{1} = State;
        set(handles.status,'string',State,'userdata',state_store);
        notes_store{1} = Notes;
        set(handles.notes,'string',Notes,'userdata',notes_store);
        
       
        plot_s11(handles,s11_meas);      
        save([home_path,f_name],'path');
        set([handles.add_plots],'visible','on','value',0);
        set(handles.Save_File,'enable','on'); 
        hObject=handles.zfig_meas;
        guidata(hObject, handles);
  
        
    else
        % Add a plot.
        if rf_obj.Z0 ~= handles.Zo
            % It MUST have the same Zo as the first s1p file.
            % Yes, one can convert to another Zo, but save that for later.
            errordlg('Incompatible Zo with the current S11 plot. ')
            return
        end;
        
        nplot  = handles.nplots;
       
                         
        c_sel      =  get(handles.add_color,'Value');  % current selected color
        % this facilitates automatic color sequencing.
        if nplot==1
            c_index=c_sel;
        elseif c_sel+1 ~= nplot;
            c_index=c_sel;
        else
            c_index    =  mod(nplot-1,7)+1;  % not well tested
        end;
        set(handles.add_color,'Value',c_index)
        nplot=nplot+1;
        handles.nplots=nplot;
        
        % c_list= [0 1 0; 0 0 1; 1 0 0; 1 0 1; 0 1 1 ; 0 0 0];
        % MATLAB sequence of colors for multi line plots.        
        c_list= [
            0         0.4470    0.7410;   % blue
            0.8500    0.3250    0.0980;   % orange
            0.9290    0.6940    0.1250;   % tan
            0.4940    0.1840    0.5560;   % violet
            0.4660    0.6740    0.1880;   % green
            0.3010    0.7450    0.9330;   % cyan
            0.6350    0.0780    0.1840;   % rust
            0           0        0    ;]; % black 
        
        add_color=c_list(c_index,:);
        s11_meas.color=add_color;
        s11_meas.index = nplot;  
        
        % Update Active Plot, Notes and State storage.
        list = get(handles.Active_Plot_File,'Userdata');
        list{nplot}=name;
        set(handles.Active_Plot_File,'string',name,'Userdata',list,'Visible','on','ForegroundColor',add_color );
        state_store = get(handles.status,'userdata');
        state_store{nplot} = State;
        notes_store = get(handles.notes,'userdata');
        notes_store{nplot} = Notes; 
        set(handles.status,'string',State,'userdata',state_store,'ForegroundColor',add_color );
        set(handles.notes, 'string',Notes,'userdata',notes_store,'ForegroundColor',add_color );   
        
        
        LW=1.5;  % line weight
        
        set(handles.zfig_meas,'CurrentAxes',handles.axes_swr);
        handles.h_swr(nplot)=line('Xdata',0,'Ydata',0,'color',add_color,'Tag','SWR','Linewidth',LW);
        handles.h_Q(nplot)  =line('Xdata',0,'Ydata',0,'color',add_color,'Tag','Q','Linewidth',LW,'LineStyle','--');
        
        set(handles.zfig_meas,'CurrentAxes',handles.axes_real_imag(1));
        handles.h_real(nplot)=line('Xdata',0,'Ydata',0,'Color',add_color,'Linewidth',LW,'Tag','Real');
        set(handles.zfig_meas,'CurrentAxes',handles.axes_real_imag(2));
        handles.h_imag(nplot)=line('Xdata',0,'Ydata',0,'Color',add_color,'Linewidth',LW,'Tag','Imag','LineStyle','--');
        
        set(handles.zfig_meas,'CurrentAxes',handles.axes_mag_phase(1));
        handles.h_mag(nplot)  =line('Xdata',0,'Ydata',0,'Color',add_color,'Linewidth',LW,'Tag','Mag');
        set(handles.zfig_meas,'CurrentAxes',handles.axes_mag_phase(2));
        handles.h_phase(nplot)=line('Xdata',0,'Ydata',0,'Color',add_color,'Linewidth',LW,'Tag','Phase','LineStyle','--');
        
        set(handles.zfig_meas,'CurrentAxes',handles.Axes_Smith);
        handles.h_smith(nplot)= line('Xdata',0,'Ydata',0,'Color',add_color,'Linewidth',LW,'Tag','Smith' );
        plot_s11(handles,s11_meas)
        save([home_path,f_name],'path');
        set(handles.erase_plots,'visible','on');
        set(handles.Save_File,'enable','off');   
        guidata(handles.zfig_meas, handles);
        
    end;
end

function output_txt=data_tip_updatefcn(obj,event_obj)
    % This is the "custom datatip" callback that replaces the "stock" version.
    pos = get(event_obj,'Position'); % returns x,y coordinates
    lh=get(event_obj.Target);        % line handle
    color=lh.Color;
    ax=get(obj.Parent);
    fig = ax.Parent;
    handles=guidata(fig);
    s11_meas=lh.UserData;
    if ~isempty(s11_meas)
        if handles.nplots > 1
            set(handles.Active_Plot_File,'string',s11_meas.name,'ForegroundColor',color,'Visible','On');
            set([handles.notes,handles.status],'ForegroundColor',color);
            state_store = get(handles.status,'userdata');
            set(handles.status,'string',state_store{s11_meas.index});
            notes_store = get(handles.notes,'userdata'); 
            set(handles.notes,'string',notes_store{s11_meas.index});      
        end
        Fvec=s11_meas.Fvec;
    else
        output_txt='No s11_meas data found.';
    end;
    
    switch get(obj.Parent,'Tag')
        % Which axes ?
        case 'axes_real_imag'
            clc
            ud=get(obj.Parent,'UserData');
            %Fvec=ud(:,1);
            index = pos(1)== (Fvec*1e-6);
            z=ud(index,2);
            freq=pos(1);
            output_txt = {['Freq: ',num2str(freq,6),' MHz'],...
                ['|Real|: ' ,num2str(real(z),4), ' Ohms'],...
                [' Imag: '  ,num2str(imag(z),4), ' Ohms']};
            
        case 'axes_mag_phase'
            ud=get(obj.Parent,'UserData');
            % Fvec=ud(:,1);
            index = pos(1)== (Fvec*1e-6);
            z_mag=ud(index,2);
            z_phase=ud(index,3);
            freq=pos(1);
            output_txt = {['Freq: ',num2str(freq,6),' MHz'],...
                ['Mag: ' ,num2str(z_mag,4),   ' Ohms'],...
                ['Phase: '     ,num2str(z_phase,4), ' Degrees']};
            
        case 'axes_swr'
            freq=pos(1);
            output_txt = {['Freq: ',num2str(freq,6),' MHz'],...
                [[lh.Tag,': '] ,num2str(pos(2),4)]};
            
        case 'Smith'
            Rho   = lh.XData+ 1i*lh.YData;
            s11  =pos(1)+1i*pos(2);
            z0   = handles.Zo;
            z = z0*(1+s11)./(1-s11);
            tag=lh.Tag; % which line caused this call back?
            % grid lines have no associated frequency vector
            % so they are treated differently than a line associated with
            % data.
            if strcmp(tag,'Smith_grid');
                output_txt = { ['Real: ', num2str(real(z),4),' Ohms'],...
                    ['Imag: ', num2str(imag(z),4),' Ohms'],...
                    };
                return;  % there is no more to be done
                
            elseif strcmp(tag,'Smith_SWR');
                swr=abs((1+abs(s11))./(1-abs(s11)));
                output_txt = { ['SWR: ',  num2str(swr,2),':1'],...
                    ['Real: ', num2str(real(z),4),' Ohms'],...
                    ['Imag: ', num2str(imag(z),4),' Ohms'],...
                    };
                return; % there is no more to be done
                
            elseif strcmp(tag(1:2),'Q=') || strcmp(tag(1:3),'SWR')
                % constant Q contours
                output_txt=tag;  % the line tag has the Q value
                return; % there is no more to be done
            else
                index = (Rho==s11);
                xx= sum(index==1);
                if xx==1
                    freq=Fvec(index);
                else
                    freq=Fvec(1);
                end;
                freq=Fvec(index)*1e-6;
                output_txt = {['Freq: ', num2str(freq,6),' MHz'],...
                    ['Real: ', num2str(real(z),4),' Ohms'],...
                    ['Imag: ', num2str(imag(z),4),' Ohms'],...
                    };
            end;
    end  %% Switch
    
    alldatacursors = findall(handles.zfig_meas,'type','hggroup');
    set(alldatacursors,'FontSize',8,'FontName', 'Arial') % was Helvetica
    index = (freq==s11_meas.Fvec*1e-6);
    s11=s11_meas.s11(index);
    swr=abs((1+abs(s11))./(1-abs(s11)));
    
    z0  = handles.Zo;
    z = z0*(1+s11)./(1-s11);
    w=2*pi*freq*1e6;
    Ls = imag(z)/w * 1e6; % Series L in uH
    
    y=1/z;
    Cp=imag(y)/w *1e12;  % parallel C in pF
    Gp=real(y);
    Q   = imag(z)/real(z);
    D   = real(y)/imag(y);
    % This is tricky!
    % Check the title of the SWR axes.
    ax_title = get(get(handles.axes_swr,'Title'),'String');
    
    if strcmp(ax_title,'SWR')
        
        text=   {...
            [' Freq:   ', num2str(freq,7),' MHz'],...
            ' ',...
            [' Z Real: ', num2str(real(z),4),' Ohms'],...
            [' Z Imag: ', num2str(imag(z),4),' Ohms'],...
            ' ',...
            [' Z Mag:  ', num2str(abs(z),4),' Ohms'],...
            [' Z Phase:', num2str((180/pi)*atan2(imag(z),real(z)),3),' Deg.'],...
            ' ',...
            [' Rho Mag:  ', num2str(abs(s11),5)],...
            [' Rho Phase:', num2str((180/pi)*atan2(imag(s11),real(s11)),3),' Deg.'],...
            [' Ret Loss:  ', num2str(-20*log10(abs(s11)),4),' dB'],...
            ' ',...
            [' Ls:     ', num2str(Ls,4), ' uH'],...
            [' Rs:     ', num2str(real(z),4) ' Ohms'],...
            [' Q:      ', num2str(Q,4)],...
            ' ',...
            [' Cp:     ', num2str(Cp,4), ' pF'],...
            [' Gp:     ', num2str(Gp,4), ' S'],...
            [' Rp:     ', num2str(1/Gp,4), ' Ohms'],...
            [' D:      ', num2str(D,4)],...
            ' ',...
            [' SWR:    ', num2str(swr,4)],...
            };
        
    else
        % it must be in Q mode
        text= {...
            [' Freq:   ', num2str(freq,7),' MHz'],...
            ' ',...
            [' Z Real: ', num2str(real(z),4),' Ohms'],...
            [' Z Imag: ', num2str(imag(z),4),' Ohms'],...
            ' ',...
            [' Z Mag:  ', num2str(abs(z),4),' Ohms'],...
            [' Z Phase:', num2str((180/pi)*atan2(imag(z),real(z)),3),' Deg.'],...
            ' ',...
            [' Rho Mag:  ', num2str(abs(s11),5)],...
            [' Rho Phase:', num2str((180/pi)*atan2(imag(s11),real(s11)),3),' Deg.'],...
            [' Ret Loss: ', num2str(-20*log10(abs(s11)),4),' dB'],...
            [' SWR:      ', num2str(swr,4)],...
            ' ',...
            [' Ls:     ', num2str(Ls,4), ' uH'],...
            [' Rs:     ', num2str(real(z),4) ' Ohms'],...
            [' Q:      ', num2str(Q,4)],...
            ' ',...
            [' Cp:     ', num2str(Cp,4), ' pF'],...
            [' Gp:     ', num2str(Gp,4), ' S'],...
            [' Rp:     ', num2str(1/Gp,4), ' Ohms'],...
            [' D:      ', num2str(D,4)],...
            };
    end;
    
    set(handles.Z_Text,'String',text);
end

function notes_Callback(hObject, eventdata, handles)
    
end

% --- Executes on button press in Q_contours.
function Q_contours_Callback(hObject, eventdata, handles)
    if get(hObject,'Value') ==1
        set(handles.smith.Q,'Visible','On');
    else
        set(handles.smith.Q,'Visible','Off');
    end
end

% --- Executes on button press in SWR_circles.
function SWR_circles_Callback(hObject, eventdata, handles)
    
    if  get(hObject,'Value')==1
        set(handles.smith.swr,'Visible','On');
    else
        set(handles.smith.swr,'Visible','Off');
    end
end

% --- Executes on button press in add_plots.
function add_plots_Callback(hObject, eventdata, handles)
    % hObject    handle to add_plots (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)    
    % Hint: get(hObject,'Value') returns toggle state of add_plots
    if get(handles.add_plots,'value')==1
        set(handles.add_color,'visible','on');
    else
        set(handles.add_color,'visible','off');
    end
end

% --- Executes on button press in erase_plots.
function erase_plots_Callback(hObject, eventdata, handles)
    if handles.nplots>1
        for k=2:handles.nplots
            set([handles.Active_Plot_File],'visible','off');
            delete([handles.h_swr(k),handles.h_Q(k),handles.h_real(k),handles.h_imag(k),...
                handles.h_mag(k),handles.h_phase(k),handles.h_smith(k)]);
        end;
        handles.nplots=1;
        set(handles.add_color,'value',1);
        x = get(handles.Active_Plot_File,'Userdata');
        list{1}=x{1};
        set(handles.Active_Plot_File,'Userdata',list);
        
        x = get(handles.status,'userdata');
        state_store{1} = x{1};
        set(handles.status,'string',x{1},'userdata',state_store,'ForegroundColor',[0 0 0]);
        x = get(handles.notes,'userdata');
        notes_store{1} =x{1};
        set(handles.notes,'string',x{1},'userdata',notes_store,'ForegroundColor',[0 0 0]);
        set(handles.zfig_meas,'CurrentAxes',handles.axes_swr);
        swr_on=handles.h_swr(1).Visible;
        Q_on = handles.h_Q(1).Visible;
        if strcmp(swr_on,'on')
            hl=legend(handles.h_swr(1),list);
        end;
        
        if strcmp(Q_on,'on')
            hl=legend(handles.h_Q(1),list);
        end;
        set(hl,'Interpreter','none');
    end;
    set(handles.erase_plots,'visible','off');
    set(handles.Save_File,'enable','on');  
    guidata(handles.zfig_meas, handles);
end

% --- Executes on selection change in add_color.
function add_color_Callback(hObject, eventdata, handles)
    
end

% --- Executes during object creation, after setting all properties.
function Q_contours_CreateFcn(hObject, eventdata, handles)
    
end

% --- Executes during object creation, after setting all properties.
function add_color_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
% --- Executes during object creation, after setting all properties.
function notes_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
