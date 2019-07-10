function varargout = s2p_viewer(varargin)
    % S2P_VIEWER M-file for s2p_viewer.fig
    % NOTE: this requires RF Toolbox.
    % Last Modified by GUIDE v2.5 03-Dec-2017 17:07:46
    % Dick Benson January 2018, September 2018
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @s2p_viewer_OpeningFcn, ...
        'gui_OutputFcn',  @s2p_viewer_OutputFcn, ...
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
    
    
    % --- Executes just before s2p_viewer is made visible.
function s2p_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to s2p_viewer (see VARARGIN)
    % Choose default command line output for s2p_viewer
    handles.output = hObject;
    % setup the 4 axes for the 4 s-parameter
    LW=2;
    Line_color=[1 0 0];
    
    set(handles.s11_pb,'Visible','off');
    set(handles.s22_pb,'Visible','off');
    
    SP.Rvalues=[0 10 25 50 100 250];    % SP.xxx = Smith Parameters
    SP.Xvalues=[10 25 50 100 200 500];
    SP.Zo=50;
    SP.Nseg=61;  % Number of segments in Smith Chart line 
    SP.LW  = 1;  % LW= line width for Smith coordinates
    SP.swr_circles =[]; %[12 4 2.25 1.5]; % set to [] for no SWR circles
    %  SP.colors.swr = [0 1 1]*0.5;              % swr circle color
    %  SP.LW_swr = 1;
 
    SP.Q_pts           = []; % 100;    % number of points in a contour
    %  SP.colors.Q      = [0 0 1];    % Q contour color
    %  SP.Q_contours    = [50 20 10 5 2 1];        
    %  SP.LW_Q          = 1;
    
    
    
    SP.colors.grid= [0 0 0];                % black coordinate lines
    SP.colors.fill= [100 100 100 ]/256;     % gray background
    SP.colors.inner_text= [1 1 0];          % yellow inner labels
    SP.colors.outer_text= [0 0 0];          % black outer labels
   

    set(handles.Viewer_Figure,'CurrentAxes',handles.axes_s11,'PaperOrientation','landscape','PaperUnits','inches','PaperSize',[11,8.5],'PaperPositionMode','auto');
    % Note the reversal of the Papersize dimensions. Sure not obvious !
   
    
    
    set(handles.axes_s11,'Tag','s11_axes','UserData',[]);
    handles.s11_Smith=smith_rab_v2(handles.axes_s11,SP);
    handles.s11_l=line('Xdata',0,'Ydata',0,'Color',Line_color,'Linewidth',LW,'Tag','S11');
    
    set(handles.Viewer_Figure,'CurrentAxes',handles.axes_s22);
    set(handles.axes_s22,'Tag','s22_axes','UserData',[]);
    handles.s22_Smith=smith_rab_v2(handles.axes_s22,SP);
    handles.s22_l=line('Xdata',0,'Ydata',0,'Color',Line_color,'Linewidth',LW,'Tag','S22');
    
    set(handles.Viewer_Figure,'CurrentAxes',handles.axes_s11_RL);
    set(handles.axes_s11_RL,'Visible','off','Tag','s11_RL_axes','UserData',[],...
        'XlimMode','auto','YLimMode','auto','YGrid','on','XGrid','on','YTickMode','auto');
    handles.s11_RL=line('Xdata',0,'Ydata',0,'Color',Line_color,'Linewidth',LW,'Tag','dB','Visible','off');
    xlabel(handles.axes_s11_RL,'MHz','Color',[0 0 0]);
    ylabel(handles.axes_s11_RL,'Return Loss in dB','Color',[0 0 0]);
    
    
    set(handles.Viewer_Figure,'CurrentAxes',handles.axes_s21,'PaperOrientation', 'landscape');
    [handles.ax21,handles.p21mag,handles.p21phase]=plotyy(0,0,0,0);
    set(handles.p21mag,'Color',[1 0 0],'Linewidth',LW);
    set(handles.p21phase,'Color',[0 0 1],'Linewidth',LW);
    set(handles.ax21,'XlimMode','auto','YLimMode','auto','YGrid','on','XGrid','on','YTickMode','auto','Tag','s21_axes');
    title('S21');
    set(handles.ax21(1),'Ycolor',[1 0 0]); set(handles.ax21(2),'Ycolor',[0 0 1]);
    xlabel(handles.ax21(1),'MHz');
    ylabel(handles.ax21(1),'dB','Color',[1 0 0]); ylabel(handles.ax21(2),'Phase in Deg.','Color',[0 0 1]);
    set(handles.ADT,'Visible','off');
    
    set(handles.Viewer_Figure,'CurrentAxes',handles.axes_s12);
    set(handles.axes_s12,'Visible','off');
    [handles.ax12,handles.p12mag,handles.p12phase]=plotyy(0,0,0,0);
    set(handles.p12mag,'Color',[1 0 0],'Linewidth',LW);
    set(handles.p12phase,'Color',[0 0 1],'Linewidth',LW);
    set(handles.ax12,'XlimMode','auto','YLimMode','auto','YGrid','on','XGrid','on','YTickMode','auto','Tag','s12_axes');
    title('S12');
    set(handles.ax12(1),'Ycolor',[1 0 0]); set(handles.ax12(2),'Ycolor',[0 0 1]);
    xlabel(handles.ax12(1),'MHz');ylabel(handles.ax12(1),'dB','Color',[1 0 0]); ylabel(handles.ax12(2),'Phase in Deg.','Color',[0 0 1]);
    
    set(handles.Viewer_Figure,'CurrentAxes',handles.axes_s22_RL);
    set(handles.axes_s22_RL,'Visible','off','Tag','s22_RL_axes','UserData',[],...
        'XlimMode','auto','YLimMode','auto','YGrid','on','XGrid','on','YTickMode','auto');
    handles.s22_RL=line('Xdata',0,'Ydata',0,'Color',Line_color,'Linewidth',LW,'Tag','dB','Visible','off');
    xlabel(handles.axes_s22_RL,'MHz','Color',[0 0 0]);
    ylabel(handles.axes_s22_RL,'Return Loss in dB','Color',[0 0 0]);
      
    % prime the pump for cell array storage.
    set(handles.notes,'string',{'Enter Your Notes Here.'});
    drawnow;
   
    % Code to activate DataTip callback on update
    handles.dcm_obj = datacursormode(handles.Viewer_Figure);
    datacursormode on;
    set(handles.dcm_obj,'UpdateFcn', @data_tip_updatefcn );
    
    handles.nplots=1;
    set([handles.add_plots,handles.erase_plots,handles.add_color,handles.Active_Plot_File] ,'Visible','off'); 
    set(handles.Active_Plot_File,'BackgroundColor',get(handles.Viewer_Figure,'Color'));
    set(handles.Write_File,'Enable','off');
    
    % Update the handles structure
    guidata(hObject, handles);
    
    % --- Outputs from this function are returned to the command line.
function varargout = s2p_viewer_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    
    % --------------------------------------------------------------------
function Write_File_ClickedCallback(hObject, eventdata, handles)
    % hObject    handle to Write_File (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % SAVE to a file
    p = mfilename('fullpath');  % returns where this mcode lives.
    % But it also returns the function name which needs to be stripped off.
    k=strfind(p,'\');
    home_path=p(1:k(end));
    f_name='Last_s2p_Viewer_Path.mat';
    if exist(f_name,'file')
        last_path   = load(f_name);
        if ~exist(last_path.path,'dir')
            last_path.path='';
        end;
    else
        last_path.path='';
    end;
    
    filter_spec = [last_path.path,'*.s2p'];
    [FileName,path] = uiputfile(filter_spec,'Write s2p file');
    if FileName ~=0
        meas=get(handles.Viewer_Figure,'UserData');
        if ~isempty(meas)
            %xxx rf_obj=rfdata.data;
            %xxx rf_obj.Freq=meas.Fvec;
            %xxx rf_obj.S_Parameters=meas.s;
            rf_obj=meas.rf_obj;
            State=get(handles.status,'string');
            Notes_mat=get(handles.notes,'string');
            % convert to cell array if it is not already one.
            if iscell(Notes_mat)
                Notes=Notes_mat;
            else
                disp('Not sure why it got here! Search NOTCELL')
                [r,c]=size(Notes_mat);
                Notes=[];
                for k=1:r
                    Notes{k}=Notes_mat(k,:);
                end;
                Notes=Notes';
            end
            spar_write(path,FileName,rf_obj,Notes,State);
            set(handles.Viewer_Figure,'Name',[path,FileName]);
            save([home_path,f_name],'path')
        else
            warndlg('No Measurement Data to Save');
        end;
    end
    
function Load_File_Callback(Path,FileName)
    hf=findobj('Tag','Viewer_Figure');
    if isempty(hf)
        s2p_viewer; % launch this gui
    end;
    hf=findobj('Tag','Viewer_Figure');
    handles=guidata(hf);
    Read_File_ClickedCallback([],[],handles,{Path},{FileName});
    
    % --- Executes on button press in erase_plots.
function erase_plots_Callback(hObject, eventdata, handles)
    % hObject    handle to erase_plots (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if isfield(handles,'hl');
        set(handles.hl,'visible','off');
        handles=rmfield(handles,'hl');
        guidata(handles.Viewer_Figure,handles);
        set(handles.s11_select,'Value',1);
        set(handles.s22_select,'Value',1);
        s11_select_Callback(hObject, eventdata, handles);
        s22_select_Callback(hObject, eventdata, handles);
     end;
     
     x = get(handles.status,'userdata');
     state_store{1} = x{1};
     set(handles.status,'string',x{1},'userdata',state_store,'ForegroundColor',[0 0 0]);
     
     x = get(handles.notes,'userdata');
     notes_store{1} =x{1};    
     set(handles.notes,'string',x{1},'userdata',notes_store,'ForegroundColor',[0 0 0]);
   
     x = get(handles.Active_Plot_File,'Userdata');
     list{1} = x{1};
     set(handles.Active_Plot_File,'string',x{1},'Userdata',list,'ForegroundColor',[0 0 0]);
      
     handles.nplots=1;
     guidata(handles.Viewer_Figure, handles);    
    
     set(handles.add_plots,'Value',0)
     set([handles.erase_plots,handles.add_color] ,'Visible','off'); 
     
     set(handles.Write_File,'Enable','on');
      
    % --- Executes on selection change in s11_select.
function s11_select_Callback(hObject, eventdata, handles)
    h=handles.s11_Smith;
    switch get(handles.s11_select,'Value')
        case 1
            set(h.lx,'Visible','on')
            set(h.fill,'Visible','on')
            set(h.txt,'Visible','on')
            if ~isempty(h.swr)
                set([h.swr,h.Q],'Visible','on');
            end;
            set(handles.s11_l,'Visible','on');
            set(handles.axes_s11,'Visible','off');
            set(handles.axes_s11_RL,'Visible','off');
            set(handles.s11_RL,'Visible','off');
            % This magic takes care of the "added" plots.
            if isfield(handles, 'hl');
                Ld8 = (length(handles.hl)/8);
                for k=0:(Ld8-1)
                    set(handles.hl(1+8*k),'Visible','on');
                    set(handles.hl(7+8*k),'Visible','off');
                end;
            end;
            
        case 2
            set(h.lx,'Visible','off')
            set(h.fill,'Visible','off')
            set(h.txt,'Visible','off')
            if ~isempty(h.swr)
                set([h.swr,h.Q],'Visible','off');
            end;
            set(handles.axes_s11_RL,'Visible','on')
            set(handles.s11_l,'Visible','off');
            set(handles.s11_RL,'Visible','on');
            % This magic takes care of the "added" plots.
            if isfield(handles, 'hl');
                Ld8 = (length(handles.hl)/8);
                for k=0:(Ld8-1)
                    set(handles.hl(1+8*k),'Visible','off');
                    set(handles.hl(7+8*k),'Visible','on');
                end;
            end;
            
    end;
    
    % --- Executes on selection change in s22_select.
function s22_select_Callback(hObject, eventdata, handles)
    h=handles.s22_Smith;
    switch get(handles.s22_select,'Value')
        case 1
            set(h.lx,'Visible','on')
            set(h.fill,'Visible','on')
            set(h.txt,'Visible','on')
            if ~isempty(h.swr)
                set([h.swr,h.Q],'Visible','on');
            end;
            set(handles.s22_l,'Visible','on');
            set(handles.axes_s22,'Visible','off');
            set(handles.axes_s22_RL,'Visible','off');
            set(handles.s22_RL,'Visible','off');
            % This magic takes care of the "added" plots.
            if isfield(handles, 'hl');
                Ld8 = (length(handles.hl)/8);
                for k=0:(Ld8-1)
                    set(handles.hl(6+8*k),'Visible','on');
                    set(handles.hl(8+8*k),'Visible','off');
                end;
            end;
            
        case 2
            set(h.lx,'Visible','off')
            set(h.fill,'Visible','off')
            set(h.txt,'Visible','off')
            if ~isempty(h.swr)
                set([h.swr,h.Q],'Visible','off');
            end;
            set(handles.s22_l,'Visible','off');
            set(handles.axes_s22_RL,'Visible','on')
            set(handles.s22_RL,'Visible','on');
            % This magic takes care of the "added" plots.
            if isfield(handles, 'hl');
                Ld8 = (length(handles.hl)/8);
                for k=0:(Ld8-1)
                    set(handles.hl(6+8*k),'Visible','off');
                    set(handles.hl(8+8*k),'Visible','on');
                end;
            end;
    end;
       
    % --------------------------------------------------------------------
function Read_File_ClickedCallback(hObject, eventdata, handles,varargin)
    % hObject    handle to Read_File (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    p = mfilename('fullpath');  % returns where this mcode lives.
    % But it also returns the function name which needs to be stripped off.
    k=strfind(p,'\');
    home_path=p(1:k(end));
    f_name='Last_s2p_Viewer_Path.mat';
    if exist(f_name,'file')
        last_path   = load(f_name);
        if ~exist(last_path.path,'dir')
            last_path.path='';
        end;
    else
        last_path.path='';
    end;
    
    if isempty(varargin)
        filter_spec = [last_path.path,'*.s2p'];
        [name,path,filter]=uigetfile(filter_spec,'Read s2p file');
        if name==0;
            return
        end;
        [rf_obj,Notes,State]=spar_read(path,name);
    else
        % Magic to convert from cell to strings.
        path=varargin{1};
        path=char(path{1});
        name=(varargin{2});
        name=char(name{1});
        [rf_obj,Notes,State]=spar_read(path,name);
    end;
    
    if rf_obj.Z0 ~=50
        errordlg(' This is not a 50 ohm system.');
        return
    end;
    
    s= rf_obj.S_Parameters;
    Fvec=rf_obj.Freq;
    
    if  get(handles.add_plots,'Value')==0
        % A "normal" single plot
     
        meas.s=s;
        meas.Fvec=Fvec;
        meas.rf_obj=rf_obj;
        meas.index = 1;
        meas.Name = name;
        
        handles.nplots=1;     
        list{1}=name;
        set(handles.Active_Plot_File,'string',name,'Userdata',list,'Visible','on','ForegroundColor',[0 0 0]);
        state_store{1} = State;
        set(handles.status,'string',State,'userdata',state_store);
        notes_store{1} = Notes;
        set(handles.notes,'string',Notes,'userdata',notes_store);  
        
        set(handles.Viewer_Figure,'UserData',meas,'Name',[path,name]);
        set(handles.s11_l,'Xdata',real(s(1,1,:)),'Ydata',imag(s(1,1,:)));
        
        % Return loss should be a positive number for passive devices.
        RL_11=-20*log10(abs(s(1,1,:)));
        set(handles.s11_RL,'Xdata',Fvec*1e-6,'Ydata',RL_11);
        set(handles.ax21,'NextPlot','replace');
        set(handles.p21mag,'Xdata',Fvec*1e-6,'Ydata',20*log10(abs(s(2,1,:))));
        set(handles.p21phase,'Xdata',Fvec*1e-6 ,'Ydata', (180/pi)*unwrap(atan2( imag(s(2,1,:)), real(s(2,1,:)))));
        set(handles.ax12,'NextPlot','replace');
        set(handles.p12mag,'Xdata',Fvec*1e-6,'Ydata',20*log10(abs(s(1,2,:))));
        set(handles.p12phase,'Xdata', Fvec*1e-6 ,'Ydata', (180/pi)*unwrap(atan2( imag( s(1,2,:)), real(s(1,2,:))) ));
        set(handles.s22_l,'Xdata',real(s(2,2,:)),'Ydata',imag(s(2,2,:)));
        
        RL_22=-20*log10(abs(s(2,2,:)));
        set(handles.s22_RL,'Xdata',Fvec*1e-6,'Ydata',RL_22);
        
        set([handles.add_plots] ,'Visible','on'); 
        set(handles.Write_File,'Enable','on');
         
         
        if isfield(handles, 'hl');
            % strip all ancillary plot line handles.
            delete(handles.hl);
            handles=rmfield(handles,'hl');
            guidata(handles.Viewer_Figure, handles);
        end;
    else
        % Add plots
        % Get selected color
        c_index = get(handles.add_color,'Value');         
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
        LW=1.5;  % line weight
        % Why this "squeeze" is required for the plot() is another enigma.
        s11= squeeze(rf_obj.S_Parameters(1,1,:));
        s21= squeeze(rf_obj.S_Parameters(2,1,:));
        s12= squeeze(rf_obj.S_Parameters(1,2,:));
        s22= squeeze(rf_obj.S_Parameters(2,2,:));
        
        %ss= get(handles.status,'String');
        %sn= get(handles.notes,'String');
        
        nplot  = handles.nplots;
        Obj_ID.Name=name;    % Work around for comparing data with unequal
        Obj_ID.Fvec=Fvec;    % frequency vectors.
        Obj_ID.s = rf_obj.S_Parameters;
        Obj_ID.index = nplot+1;  
        
        
        list = get(handles.Active_Plot_File,'Userdata');
        list{nplot+1}=name;
        set(handles.Active_Plot_File,'string',name,'Userdata',list,'ForegroundColor',add_color);   
        state_store = get(handles.status,'userdata');
        state_store{nplot+1} = State;
        set(handles.status,'string',State,'userdata',state_store,'ForegroundColor',add_color);
        notes_store = get(handles.notes,'userdata');
        notes_store{nplot+1} = Notes;
        set(handles.notes,'string',Notes,'userdata',notes_store,'ForegroundColor',add_color);  
        
       
        
        hl(1)=plot(handles.axes_s11,real(s11),imag(s11),'Color',add_color,'Linewidth',LW,'UserData',Obj_ID,'Tag','S11');
        set(handles.ax21,'NextPlot','add');
        hl(2)=plot(handles.ax21(1),Fvec*1e-6,20*log10(abs(s21)),'Color',add_color,'Linewidth',LW,'Tag','dB','UserData',Obj_ID);
        hl(3)=plot(handles.ax21(2),Fvec*1e-6 ,(180/pi)*unwrap(atan2( imag(s21), real(s21))),'Color',add_color,'Linewidth',LW,'LineStyle','--','Tag','Degrees','UserData',Obj_ID);
        set(handles.ax12,'NextPlot','add');
        hl(4)=plot(handles.ax12(1),Fvec*1e-6,20*log10(abs(s12)),'Color',add_color,'Linewidth',LW,'Tag','dB','UserData',Obj_ID);
        hl(5)=plot(handles.ax12(2),Fvec*1e-6 ,(180/pi)*unwrap(atan2( imag(s12),real(s12))),'Color',add_color,'Linewidth',LW,'LineStyle','--','Tag','Degrees','UserData',Obj_ID);
        hl(6)=plot(handles.axes_s22,real(s22),imag(s22),'Color',add_color,'Linewidth',LW,'UserData',Obj_ID,'Tag','S22');
        
        RL_11=-20*log10(abs(s11));
        set(handles.axes_s11_RL,'NextPlot','add');
        hl(7)= plot(handles.axes_s11_RL,Fvec*1e-6,RL_11,'Color',add_color,'Linewidth',LW,'Tag','dB','UserData',Obj_ID);
        
        RL_22=-20*log10(abs(s22));
        set(handles.axes_s22_RL,'NextPlot','add');
        hl(8)= plot(handles.axes_s22_RL,Fvec*1e-6,RL_22,'Color',add_color,'Linewidth',LW,'Tag','dB','UserData',Obj_ID);
        set(hl([7,8]),'Visible','off');
        
        % Update the handles structure with these added line objects
        if isfield(handles, 'hl');
            hl_exist=handles.hl;
            hl_now=[hl_exist,hl];
        else
            hl_now=hl;
        end;
        handles.hl=hl_now; 
   
        %  update handles 
        handles.nplots=nplot+1;
        guidata(handles.Viewer_Figure, handles);
        
        set(handles.s11_select,'Value',1);
        set(handles.s22_select,'Value',1);
        s11_select_Callback(hObject, eventdata, handles);
        s22_select_Callback(hObject, eventdata, handles);
        
        set(handles.erase_plots,'Enable','on','visible','on');
        % Don't allow the writing of files when multiple plots are active
        % This will hopefully prevent confusion.
      
        set(handles.Write_File,'Enable','off');
    end;
    
    % see if these m files exist b4 enabling the button
    if exist('AmplifierDesignTool.m','file')==2
        set(handles.ADT,'Visible','on');
    end
    if exist('s1p_viewer.m','file')==2
        set([handles.s11_pb,handles.s22_pb],'Visible','on');
    end;
      
    save([home_path,f_name],'path')
    
function output_txt=data_tip_updatefcn(obj,event_obj)
    % This code implements the "custom datatip".
    % It appears to be called TWICE per "click", which is one of many mysteries.
    ax      = get(obj.Parent);  % axis that triggered this callback
    fig     = ax.Parent;        % main figure window
    handles = guidata(fig);     % all the object handles
    
    lh      = get(event_obj.Target); % line handle that triggered this callback
    color   = lh.Color;  
    % lh.UserData has the file name for the plot files that were
    % added after the primary data file.
    % alldatacursors = findall(handles.Viewer_Figure,'type','hggroup');
    
    
    %   info_struct = getCursorInfo(handles.dcm_obj);
    %   index =  info_struct.DataIndex; % this is the best way to get the index.
    %   BUT IT IS NOT RELIABLE when >1
    %   
    pos    = get(event_obj,'Position');
    z0     = 50;
    Obj_ID = lh.UserData;
    if ~isempty(Obj_ID)
        Fvec = Obj_ID.Fvec;
        name = Obj_ID.Name;
        s    = Obj_ID.s;
        index = Obj_ID.index; 
    
    else
        meas        = get(handles.Viewer_Figure,'UserData');
        s           = meas.s;
        Fvec        = meas.Fvec;
        name        = meas.Name;
        index       = 1; 
    end;
   
    if handles.nplots ==1
       color=[0 0 0];    
    end;
    state_store = get(handles.status,'userdata');
    set(handles.status,'string',state_store{index},'ForegroundColor',color);
    notes_store = get(handles.notes,'userdata');
    nx = {'File:';name;''};
    ns = notes_store{index};
    nstr = vertcat(nx,ns);  % vertcat took some "discovery". 
    set(handles.notes,'string',nstr,'ForegroundColor',color);        
    set(handles.Active_Plot_File,'string',name,'ForegroundColor',color);  
    
    
    switch get(obj.Parent,'Tag')
        case 's11_axes'
            s11=pos(1)+1i*pos(2);
            index = find((s11==s(1,1,:)));
            freq = Fvec(index);
            z = z0*(1+s11)./(1-s11);
            swr=abs((1+abs(s11))./(1-abs(s11)));
            return_loss=20*log10(abs(s11));
            
            switch lh.Tag
                case {'S11'}
                    
                    output_txt = {['Real: ', num2str(real(z),4),' Ohms'],...
                        ['Imag: ', num2str(imag(z),4),' Ohms'],...
                        ['SWR:',num2str(swr,3),':1'],...
                        ['RetLoss:',num2str(return_loss,5),' dB'],...
                        ['Freq: ', num2str(freq*1e-6,6),' MHz'],...
                        };
                case 'Smith_grid'
                    output_txt = { 'Smith Coordinate',...
                        ['Real: ', num2str(real(z),4),' Ohms'],...
                        ['Imag: ', num2str(imag(z),4),' Ohms'],...
                        };
                otherwise
                    % for Q and SWR lines
                    output_txt=lh.Tag;
            end
            
      
        case 's22_axes'
            s22=pos(1)+1i*pos(2);
            index = find((s22==s(2,2,:)));
            freq = Fvec(index);
            z = z0*(1+s22)./(1-s22);
            swr=abs((1+abs(s22))./(1-abs(s22)));
            return_loss=20*log10(abs(s22));
            switch lh.Tag
                case {'S22'}
                    
                    output_txt = {['Real: ', num2str(real(z),4),' Ohms'],...
                        ['Imag: ', num2str(imag(z),4),' Ohms'],...
                        ['SWR:',num2str(swr,3),':1'],...
                        ['RetLoss:',num2str(return_loss,5),' dB'],...
                        ['Freq: ', num2str(freq*1e-6,6),' MHz'],...
                        };
                case 'Smith_grid'
                    output_txt = { 'Smith Coordinate',...
                        ['Real: ', num2str(real(z),4),' Ohms'],...
                        ['Imag: ', num2str(imag(z),4),' Ohms'],...
                        };
                otherwise
                    % for Q and SWR lines
                    output_txt=lh.Tag;
            end
   
           
        case 's21_axes'
            if strcmp(lh.Tag,'dB')
                output_txt={['Freq:   ' num2str(pos(1),6),' MHz'],...
                    [' Mag:   ' num2str(pos(2),4),' ',lh.Tag]};
            elseif strcmp(lh.Tag,'Degrees')
                output_txt={['Freq:   ' num2str(pos(1),6),' MHz'],...
                    ['Phase:  ' num2str(pos(2),4),' ',lh.Tag]};
            else
                index = (pos(1)== (Fvec*1e-6));
                s21=s(2,1,index);
                output_txt = {['Freq:  ',num2str(pos(1),6),' MHz'],...
                    ['Mag:   ',num2str(20*log10(abs(s21)),6),' dB'],...
                    ['Phase: ',num2str((180/pi*atan2(imag(s21),real(s21))),4),' Deg.'],...
                    };
            end;
            
        case 's12_axes'
            if strcmp(lh.Tag,'dB')
                output_txt={['Freq:   ' num2str(pos(1),6),' MHz'],...
                    [' Mag:   ' num2str(pos(2),4),' ',lh.Tag]};
            elseif strcmp(lh.Tag,'Degrees')
                output_txt={['Freq:   ' num2str(pos(1),6),' MHz'],...
                    ['Phase:  ' num2str(pos(2),4),' ',lh.Tag]};
            else
                index = (pos(1)== (Fvec*1e-6));
                s12=s(1,2,index);
                output_txt = {['Freq:  ',num2str(pos(1),6),' MHz'],...
                    ['Mag:   ',num2str(20*log10(abs(s12)),6),' dB'],...
                    ['Phase: ',num2str((180/pi*atan2(imag(s12),real(s12))),4),' Deg.'],...
                    };
            end;
            
        case {'s11_RL_axes','s22_RL_axes'}
            RL=pos(2);
            SWR=(10^(RL/20) + 1)/( 10^(RL/20) - 1);
            output_txt={['Freq:    ',num2str(pos(1),6),' MHz'],...
                ['Rtn Loss:',num2str(RL,4),' ',lh.Tag],...
                ['SWR:    :',num2str(SWR,3),':1']};
           
        otherwise
            output_txt='Confusion in data_tip_updatefcn().';
    end  %% Switch
    
    
    
    % --- Executes on button press in s11_pb.
function s11_pb_Callback(hObject, eventdata, handles)
    meas=get(handles.Viewer_Figure,'UserData');
    s_meas.sxx    = meas.s(1,1,:);
    s_meas.Fvec   = meas.Fvec;
    s_meas.Label  = [get(handles.Viewer_Figure,'Name'),' S11'];
    s_meas.State  = get(handles.status,'string');
    s_meas.Notes  = get(handles.notes,'string');
    %  path_name   = get(handles.Viewer_Figure,'Name');
    %  bk_slash=strfind(path_name,'\');
    %  k_last=bk_slash(end)+1;
    %  name=path_name(k_last:end);
    %  s_meas.name=name;
    s1p_viewer;
    s1p_viewer('Load_Data_Callback',{s_meas});
    
    % --- Executes on button press in s22_pb.
function s22_pb_Callback(hObject, eventdata, handles)
    meas=get(handles.Viewer_Figure,'UserData');
    s_meas.sxx= meas.s(2,2,:);
    s_meas.Fvec=meas.Fvec;
    s_meas.Label=[get(handles.Viewer_Figure,'Name'),' S22'];
    s_meas.State  = get(handles.status,'string');
    s_meas.Notes  = get(handles.notes,'string');
    %  path_name   = get(handles.Viewer_Figure,'Name');
    %  bk_slash=strfind(path_name,'\');
    %  k_last=bk_slash(end)+1;
    %  name=path_name(k_last:end);
    %  s_meas.name=name;
    s1p_viewer;
    s1p_viewer('Load_Data_Callback',{s_meas});
    
    
    % --- Executes on button press in Amplifier Design Tool.
function ADT_Callback(hObject, eventdata, handles)
    % hObject    handle to ADT (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    meas=get(handles.Viewer_Figure,'UserData');
    s_meas.rf_obj=meas.rf_obj;
    s_meas.Label=get(handles.Viewer_Figure,'Name');
    s_meas.State  = get(handles.status,'string');
    s_meas.Notes  = get(handles.notes,'string');
    AmplifierDesignTool('Load_Data_Callback',{s_meas});
    
    
    % --- Executes on button press in add_plots.
function add_plots_Callback(hObject, eventdata, handles)
    
    if get(handles.add_plots,'value') ==1 
       set(handles.add_color ,'Visible','on');  
    else
      set(handles.add_color ,'Visible','off');  
    end;
    
function add_color_Callback(hObject, eventdata, handles)
    
function notes_Callback(hObject, eventdata, handles)
    
    
    % --- Executes during object creation, after setting all properties.
function add_color_CreateFcn(hObject, eventdata, handles)
    
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
function notes_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    % --- Executes during object creation, after setting all properties.
function s11_select_CreateFcn(hObject, eventdata, handles)
    
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    % --- Executes during object creation, after setting all properties.
function s22_select_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
