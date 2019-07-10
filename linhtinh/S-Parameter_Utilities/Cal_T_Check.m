function varargout = Cal_T_Check(varargin)
    % Direct from Rhode&Schwarz App Note 1EZ43_0E equation 10
    % Dick Benson, June 2018, September 2018
    % Last Modified by GUIDE v2.5 18-Jun-2018 12:19:54
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @Cal_T_Check_OpeningFcn, ...
        'gui_OutputFcn',  @Cal_T_Check_OutputFcn, ...
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
    
    % --- Executes just before Cal_T_Check is made visible.
function Cal_T_Check_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Cal_T_Check (see VARARGIN)
    % Choose default command line output for Cal_T_Check
    handles.output = hObject;
    
    % load('rab_color_map_1.mat')  % Just back cmap into the code.  
    
    % A custom color map spanning green (Good) to red (Bad).
    cmap = [
         0    1.0000         0
         0    1.0000         0
         0    1.0000         0
         0    1.0000         0
         0    1.0000         0
         0    1.0000         0
         0    1.0000         0
         0    1.0000         0
         0    1.0000         0
         0    1.0000         0
    0.0833    1.0000         0
    0.1667    1.0000         0
    0.2500    1.0000         0
    0.3333    1.0000         0
    0.4167    1.0000         0
    0.5000    1.0000         0
    0.5833    1.0000         0
    0.6667    1.0000         0
    0.7500    1.0000         0
    0.8333    1.0000         0
    0.9167    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    1.0000    1.0000         0
    0.9993    0.9717    0.0267
    0.9986    0.9434    0.0534
    0.9979    0.9152    0.0801
    0.9972    0.8869    0.1068
    0.9965    0.8586    0.1335
    0.9958    0.8303    0.1602
    0.9952    0.8020    0.1869
    0.9945    0.7737    0.2136
    0.9938    0.7455    0.2403
    0.9945    0.6626    0.2136
    0.9952    0.5798    0.1869
    0.9958    0.4970    0.1602
    0.9965    0.4141    0.1335
    0.9972    0.3313    0.1068
    0.9979    0.2485    0.0801
    0.9986    0.1657    0.0534
    0.9993    0.0828    0.0267
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0
    1.0000         0         0    
    ];
      
    set(handles.Cal_T_Check_Figure,'inverthardcopy','off','colormap',cmap);
    handles.L_cmap=length(cmap);
    
    % Use a non linear Y axis to expand small deviations and compress large.
    choice=2;
    switch choice
        case 1
            % More sensitivity to small deviations.
            handles.scale=0.4;
            Pcnt_max=5;
            inc=1;
        case 2
            % Less sensitivity
            handles.scale=0.1;
            Pcnt_max=20;
            inc=2;
        otherwise
            
    end;
    non_linear_y_ticks = tanh((-Pcnt_max:inc:Pcnt_max)*handles.scale);
    for k=1:inc:(2*Pcnt_max+1)
        y_tick_label{k} = num2str(k*inc-(Pcnt_max+inc),2);
    end;
    
    set(handles.axes_1,'box','on',...
        'Ylim',[-1.05,1.05],...
        'Ytick',non_linear_y_ticks,...
        'YTickLabel',y_tick_label,...
        'color',[0 0 0],...
        'fontname','Arial',...
        'fontsize',10,...
        'fontweight','bold',...
        'fontunits','points',...
        'xcolor',[0.0 0.0 0.0],...
        'ycolor',[0.0 0.0 0.0],...
        'xgrid','on','ygrid','on',...
        'GridColor',[1 1 1],'GridAlpha',.35,...
        'XminorGrid','off','YminorGrid','off');
    
    % Create a simple test plot  
    t=0:0.01:2*pi;
    y=sin(t);
    c=abs(y*handles.L_cmap);
    z=0*t;
    
    handles.hs = surface([t;t],[y;y],[z;z],[c;c],...
        'facecolor','none',...
        'edgecolor','interp',...
        'linewidth',3,'CDataMapping','direct');
    xlabel('Frequency in MHz');
    ylabel('Calibration Deviation From Ideal in Percent');
    title('Calibration Quality Assement using the "T Check" Method')
    
    % Code to activate DataTip callback on update
    handles.dcm_obj = datacursormode(handles.Cal_T_Check_Figure);
    datacursormode on;
    set(handles.dcm_obj,'UpdateFcn', @data_tip_updatefcn );
    
    % Update handles structure
    guidata(hObject, handles);
    
    % --- Outputs from this function are returned to the command line.
function varargout = Cal_T_Check_OutputFcn(hObject, eventdata, handles)
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
function plot_cal_error(hObject,eventdata,handles,Data)
    S     = Data.S_Parameters;
    F_MHz = Data.Freq*1e-6;
    a = abs(S(1,1,:).*conj(S(2,1,:)) + S(1,2,:).*conj(S(2,2,:)));
    b =  1 - abs(S(1,1,:)).^2  - abs(S(1,2,:)).^2;
    c =  1 - abs(S(2,1,:)).^2  - abs(S(2,2,:)).^2;
    Cal_Deviation_Percent  =  100*(squeeze(a./sqrt(b.*c))-1);
    scale = handles.scale;
    non_linear_y = tanh(Cal_Deviation_Percent*scale);
    if isreal(non_linear_y)
        x=F_MHz';
        y=non_linear_y';
        z=0*x;
        c=abs(y*handles.L_cmap);
        set(handles.hs,'XData',[x;x],'YData',[y;y],'ZData',[z;z],'CData',[c;c]);
    else
        errordlg('Did you measure a T with 50 ohms on one port?')
    end;
    
function output_txt=data_tip_updatefcn(obj,event_obj)
    % This code implements the "custom datatip".
    % It appears to be called TWICE per "click", which is one of many mysteries.
    ax      = get(obj.Parent);  % axis that triggered this callback
    fig     = ax.Parent;        % main figure window
    handles = guidata(fig);     % all the object handles
    % lh      = get(event_obj.Target); % line handle that triggered this callback
    pos     = get(event_obj,'Position');
    linear_cal_error = atanh(pos(2))/handles.scale; % inverse of the tanh
    
    output_txt={['Freq: ',num2str(pos(1),6),' MHz'],...
        ['Cal Deviation:',num2str(linear_cal_error),' %']};
    
    % --------------------------------------------------------------------
function Read_File_ClickedCallback(hObject, eventdata, handles,varargin)
    p = mfilename('fullpath');  % returns where this mcode lives.
    % But it also returns the function name which needs to be stripped off.
    k=strfind(p,'\');
    home_path=p(1:k(end));
    f_name='Last_Cal_T_Check_Path.mat';
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
        [Data,Notes,State]=spar_read(path,name);
    else
        % Magic to convert from cell to strings.
        path=varargin{1};
        path=char(path{1});
        name=(varargin{2});
        name=char(name{1});
        [Data,Notes,State]=spar_read(path,name);
    end;
    plot_cal_error(hObject,eventdata,handles,Data);
    set(handles.Cal_T_Check_Figure,'Name',['Cal_T_Check.m     File: ',name]);
    save([home_path,f_name],'path')
    
    
function Load_File(Path,FileName)
    hf=findobj('Tag','Cal_T_Check_Figure');
    if isempty(hf)
        Cal_T_Check; % launch this gui
        hf=findobj('Tag','Cal_T_Check_Figure');
    end;
    handles=guidata(hf);
    Read_File_ClickedCallback([],[],handles,{Path},{FileName});
    
function Load_Data(Data)
    hf=findobj('Tag','Cal_T_Check_Figure');
    if isempty(hf)
        Cal_T_Check; % launch this gui
        hf=findobj('Tag','Cal_T_Check_Figure');
    end;
    % For the above to work, one needs to activate the
    % Command Line Accesibility On option under GUI Options in the GUIDE editor.
    handles=guidata(hf);
    set(handles.Cal_T_Check_Figure,'Name',['Cal_T_Check.m     File: ',Data.File]);
    plot_cal_error([],[],handles,Data);

