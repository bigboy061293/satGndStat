function varargout = Sviewer(varargin)
    % SVIEWER MATLAB code for Sviewer.fig
    %      For viewing the data in s2p and s1p files.
    %      Requires RF Toolbox
    %
    %      SVIEWER, by itself, creates a new SVIEWER or raises the existing
    %      singleton*.
    %
    %      H = SVIEWER returns the handle to a new SVIEWER or the handle to
    %      the existing singleton*.
    %
    %      SVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in SVIEWER.M with the given input arguments.
    %
    %      SVIEWER('Property','Value',...) creates a new SVIEWER or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before Sviewer_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to Sviewer_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    % Edit the above text to modify the response to help Sviewer
    % Last Modified by GUIDE v2.5 27-Aug-2018 08:34:55
    % Dick Benson, January 2018, August 2018
    
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @Sviewer_OpeningFcn, ...
        'gui_OutputFcn',  @Sviewer_OutputFcn, ...
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
    
    % --- Executes just before Sviewer is made visible.
function Sviewer_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Sviewer (see VARARGIN)
    
    % Choose default command line output for Sviewer
    handles.output = hObject;
    
    LW=2.0;         % width of plotted lines
    SWR_MAX = 10;   % Y axis upper limit for SWR
    
    
    set(handles.Figure,'CurrentAxes',handles.Axes_Smith,'PaperOrientation','landscape','PaperUnits','inches','PaperSize',[11,8.5],'PaperPositionMode','auto');
    % Note the reversal of the Papersize dimensions. Sure not obvious !
    set(handles.Axes_Smith,'Tag','Smith');
    SP.Rvalues=[0 10 25 50 100 250];    % SP= Smith Parameters
    SP.Xvalues=[10 25 50 100 200 500];
    SP.Zo=50;
    SP.Nseg=60;
    SP.LW  = 1;  % LW= line width for Smith coordinates
    SP.swr_circles =[10 5 3.0 1.5]; % set to [] for no SWR circles August 2018
    SP.LW_swr = 1;
    
    SP.colors.grid= [0 0 0];              % black coordinate lines
    SP.colors.fill= [100 100 100 ]/256;   % gray background
    SP.colors.inner_text= [1 1 0];        % inner labels
    SP.colors.outer_text= [0 0 0];        % outer labels
    SP.colors.swr = [0 1 1];              % swr circle color
    SP.colors.Q      = [0 0 1];           % Q contour color
    SP.Q_contours    = [50 20 10 5 2 1];
    SP.Q_pts         = 100;  % number of points in a contour
    SP.LW_Q          = 1;
    
    handles.smith=smith_rab_v2(handles.Axes_Smith,SP);
    handles.smith.s11_Line=line('Xdata',0,'Ydata',0,'Color',[1,0,0],'Linewidth',LW,'Visible','Off');
    handles.smith.s22_Line=line('Xdata',0,'Ydata',0,'Color',[0,1,0],'Linewidth',LW,'Visible','Off');
    set([handles.smith.lx,handles.smith.fill,handles.smith.txt,handles.smith.swr,handles.smith.Q],'Visible','off');
    
    set(handles.Figure,'CurrentAxes',handles.Axes(1));
    [handles.Axes,handles.Left_Lines(1),handles.Right_Lines(1)]=plotyy(0,0,0,0);
    set(handles.Axes(1),'Tag','Left_Axes');
    set(handles.Axes(2),'Tag','Right_Axes');
    
    left_color=get(handles.Left_Lines,'color');
    handles.Left_Lines(2)=line('Xdata',[],'Ydata',[],'color',left_color,'LineStyle','-.');
    set([handles.Left_Lines,handles.Right_Lines],'Linewidth',LW);
    
    set(handles.Figure,'CurrentAxes',handles.Axes(2));
    right_color=get(handles.Right_Lines,'color');
    handles.Right_Lines(2)=line('Xdata',[],'Ydata',[],'Linewidth',LW,'color',right_color,'LineStyle','-.');
    set([handles.Axes(2),handles.Right_Lines],'visible','Off');
    
    % Stuff to activate custom DataTip callback
    dcm_obj = datacursormode(handles.Figure);
    datacursormode on;
    set(dcm_obj,'UpdateFcn', @data_tip_updatefcn)
    
    handles.swr_max=SWR_MAX;
    % Update the handles structure
    guidata(hObject, handles);
    
    % --- Outputs from this function are returned to the command line.
function varargout = Sviewer_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    
function output_txt=data_tip_updatefcn(obj,event_obj)
    % This is the "custom datatip" callback that replaces the "stock" version.
    pos = get(event_obj,'Position'); % returns x,y coordinates
    lh=get(event_obj.Target);       % line handle
    ax=get(obj.Parent);
    fig = ax.Parent;
    handles=guidata(fig);
    
    switch get(obj.Parent,'Tag')
        % Which axes ?
        case {'Left_Axes','Right_Axes'}
            %  get(lh,'Tag');   % this does not work
            Xlabel= [' ',handles.Axes(1).XLabel.String];
            freq=pos(1);
            level=pos(2);
            output_txt={['Freq= ',num2str(freq,6), Xlabel],...
                [lh.Tag,'= ',num2str(level,4)] };
        case 'Smith'
            Rho   = lh.XData+ 1i*lh.YData;
            s11   = pos(1)+1i*pos(2);
            z0    = 50;
            z     = z0*(1+s11)./(1-s11);
            Fvec=lh.UserData;
            swr=abs((1+abs(s11))./(1-abs(s11)));
            switch lh.Tag
                case {'S11','S22'}
                    index = (Rho==s11);
                    freq=Fvec(index);
                    output_txt = {lh.Tag,...
                        ['Real: ', num2str(real(z),4),' Ohms'],...
                        ['Imag: ', num2str(imag(z),4),' Ohms'],...
                        ['SWR:  ', num2str(swr,4),':1'],...      % August 2018
                        ['Freq: ', num2str(freq,6),' MHz'],...
                        };

%                 case 'Smith_swr'
%                      output_txt={lh.Tag,...
%                             ['SWR:',num2str(swr)],output_txt{2:4}};                          
                        
                case 'Smith_grid'
                    output_txt = { 'Smith Coordinate',...
                        ['Real: ', num2str(real(z),4),' Ohms'],...
                        ['Imag: ', num2str(imag(z),4),' Ohms'],...
                        };
                otherwise
                    % for Q and SWR lines
                    output_txt=lh.Tag;
            end
        otherwise
            output_txt=' data_tip_updatefcn is CONFUSED';
    end
    
function Read_File_ClickedCallback(hObject,eventdata,handles);
    p = mfilename('fullpath');  % returns where this mcode lives.
    % But it also returns the function name which needs to be stripped off.
    k=strfind(p,'\');
    home_path=p(1:k(end));
    
    if exist('Last_Sviewer_Path.mat','file')
        last_path   = load('Last_Sviewer_Path');
        if ~exist(last_path.path,'dir')
            last_path.path='';
        end;
    else
        last_path.path='';
    end;
    
    filter_spec = [last_path.path,'*.s?p'];
    [name,path,filter]=uigetfile(filter_spec,'Read s1p or s2p file');
    if name==0;
        return
    end;
    x1=isempty(strfind(name,'s1p'));
    x2=isempty(strfind(name,'s2p'));
    if x1&&x2
        errordlg('Please choose an s1p or s2p file.')
        return
    end;
    
    [rf_obj,Notes,State]=spar_read(path,name);
    RC = size(rf_obj.S_Parameters(:,:,1));
    if RC(1)==1
        % Fudge a 1 port into a two port.
        L=length(rf_obj.Freq);
        temp=rf_obj.S_Parameters;
        rf_obj.S_Parameters= complex(zeros(2,2,L));
        rf_obj.S_Parameters(1,1,:)=temp;
        LEFT_SMITH=7;
        RIGHT_NONE=1;
        set(handles.Left_Flavor,'value',LEFT_SMITH);  % Select Smith Chart
        set(handles.Right_Flavor,'value',RIGHT_NONE); % Select None
    end;
    set(handles.Figure,'Userdata',rf_obj);
    set(handles.Fstart,'string',num2str(rf_obj.Freq(1)*1e-6,5));
    set(handles.Fstop,'string',num2str(rf_obj.Freq(end)*1e-6,5));
    
    if isempty(Notes)
        set(handles.notes,'visible','off');
    else
        set(handles.notes,'string',Notes,'visible','on');
    end;
    
    if isempty(State)
        set(handles.status,'visible','off');
    else
        set(handles.status,'string',State,'visible','on');
    end
    save([home_path,'Last_Sviewer_Path'],'path')
    set(handles.dut_file,'string',['File:  ',name]);
    Left_Flavor_Callback(handles.Left_Flavor, eventdata, handles);
    Right_Flavor_Callback(handles.Right_Flavor, eventdata, handles);
    
    % --- Executes on selection change in Left_Flavor.
function Left_Flavor_Callback(hObject, eventdata, handles)
    LEFT_SMITH=7;
    RIGHT_NONE=1;
    contents  = cellstr(get(handles.Left_Flavor,'String'));
    sel_value = get(handles.Left_Flavor,'Value');
    % Check for s1p file, force to a legal Left Flavor selection
    if ~isempty(strfind(upper(get(handles.dut_file,'string')),'S1P'))
        % s1p file ... lock out invalid selections
        if (sel_value == 4) || (sel_value==7)
            % legal for s1p, do nothing
        else
            if sel_value==LEFT_SMITH+1 || sel_value==LEFT_SMITH+2
                sel_value =LEFT_SMITH;
            elseif sel_value==5 || sel_value==6 || sel_value<4
                sel_value=4;
            end;
            set(handles.Left_Flavor,'Value',sel_value);
        end;
    end;
    sel_str   = contents{sel_value};
    
    % Smith Chart format must be at the END of the Left Flavor list for this
    % to work.
    xx= strfind(contents,'Smith');
    p=1;
    while isempty(xx{p})
        p=p+1;      % Crude but it works.
    end;
    smith_boundary=p;
    
    
    rf_obj=get(handles.Figure,'Userdata');
    
    if isempty(rf_obj);
        errordlg('You must load an s1p or s2p file.','PLEASE LOAD A FILE');
        return
    end;
    
    
    Fmax=max(rf_obj.Freq);
    F_MHz=rf_obj.Freq*1e-6;
    if Fmax <= 1e9
        Freq =F_MHz;
        x_label='MHz';
    else
        Freq=rf_obj.Freq*1e-9;
        x_label='GHz';
    end;
    
    S = rf_obj.S_Parameters;
    h_to_zoom=zoom;   % handle to the zoom controls.  OK, pretty arcane!
    
    if sel_value < smith_boundary
        % Cartesian Axes Format
        set([handles.smith.lx,handles.smith.fill,handles.smith.txt,handles.smith.swr,handles.smith.Q],'Visible','off');
        set([handles.smith.s11_Line,handles.smith.s22_Line,handles.Fstart,handles.Fstop,handles.Freq_Label],'visible','off');
        set(handles.Axes(1),'XlimMode','auto','XtickMode','auto', 'YTickMode','auto','YLimMode','auto','YGrid','on','XGrid','on','XAxisLocation','bottom');
        set(handles.Figure,'CurrentAxes',handles.Axes(1));
        set(handles.Axes(1),'visible','on');
        ylabel(sel_str)
        xlabel(x_label);
        
        setAllowAxesZoom(h_to_zoom,handles.Axes(1:2),true);    % WOW!!!
        setAllowAxesZoom(h_to_zoom,handles.Axes_Smith,false);
        set([handles.Q_checkbox,handles.SWR_checkbox],'visible','off');
        set(handles.Right_Flavor,'visible','on');
    else
        % Smith Chart Axes Format
        set([handles.Axes(1:2),handles.Left_Lines,handles.Right_Lines],'visible','off');
        set(handles.Figure,'CurrentAxes',handles.Axes_Smith);
        set(handles.Axes_Smith,'XlimMode','auto','YLimMode','auto');
        set([handles.smith.lx,handles.smith.fill,handles.smith.txt,handles.Fstart,handles.Fstop,handles.Freq_Label],'Visible','on');
        
        if get(handles.SWR_checkbox,'value')
            set(handles.smith.swr,'visible','on');
        else
            set(handles.smith.swr,'visible','off');
        end
        
        if get(handles.Q_checkbox,'value')
            set(handles.smith.Q,'visible','on');
        else
            set(handles.smith.Q,'visible','off');
        end
        setAllowAxesZoom(h_to_zoom,handles.Axes(1:2),false);    % WOW!!!
        setAllowAxesZoom(h_to_zoom,handles.Axes_Smith,true);
        set(handles.Right_Flavor,'value',1);             % 1==set to None
        set([handles.Q_checkbox,handles.SWR_checkbox],'visible','on');
        set(handles.Right_Flavor,'visible','off');
        
        
        F1= str2num(get(handles.Fstart,'string'));
        if isempty(F1)
            errordlg('Please enter a numeric value.' )
            return;
        end;
        
        F2= str2num(get(handles.Fstop,'string'));
        if isempty(F2)
            errordlg('Please enter a numeric value.' )
            return;
        end;
        
        
        if F1>=F_MHz(1) && F1<F_MHz(end)
            [m,Istart]=min(abs(F_MHz-F1));
            set(handles.Fstart,'string',num2str(F_MHz(Istart)));
        else
            set(handles.Fstart,'string',num2str(F_MHz(1)));
            Istart=1;
        end;
        
        if F2>=F_MHz(1) && F2<F_MHz(end)
            [m,Istop]=min(abs(F_MHz-F2));
            set(handles.Fstop,'string',num2str(F_MHz(Istop)));
        else
            set(handles.Fstop,'string',num2str(F_MHz(end)));
            Istop=length(F_MHz);
        end;
        I_Range=Istart:Istop;
    end;
    
    
    
    switch sel_value
        case 1
            % s21 mag db
            mag_dB=20*log10(abs(squeeze(S(2,1,:))));
            set(handles.Left_Lines(1),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','|S21| dB');
            set(handles.Left_Lines(2),'visible','Off');
        case 2
            % s12 mag dB
            mag_dB=20*log10(abs(squeeze(S(1,2,:))));
            set(handles.Left_Lines(2),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','|S12| dB');
            set(handles.Left_Lines(1),'visible','Off');
            
        case 3
            % s21 and s12
            mag_dB=20*log10(abs(squeeze(S(2,1,:))));
            set(handles.Left_Lines(1),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','|S21| dB');
            mag_dB=20*log10(abs(squeeze(S(1,2,:))));
            set(handles.Left_Lines(2),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','|S12| dB');
            
        case 4
            % Port 1 SWR
            swr=vswr(squeeze(S(1,1,:)));
            set(handles.Left_Lines(1),'Xdata',Freq,'Ydata',swr,'visible','On','Tag','Port 1 SWR');
            set(handles.Left_Lines(2),'visible','Off');
            xlim=get(handles.Axes(1),'Xlim'); drawnow;
            min_swr=min(swr);
            if min_swr>handles.swr_max
                warndlg(['All SWR values are above the display maximum of ',num2str(handles.swr_max)]);
            end;
            set(handles.Axes(1),'Ylim',[0,handles.swr_max],'Xlim',xlim);
        case 5
            % port 2 SWR
            swr=vswr(squeeze(S(2,2,:)));
            set(handles.Left_Lines(2),'Xdata',Freq,'Ydata',swr,'visible','On','Tag','Port 2 SWR');
            set(handles.Left_Lines(1),'visible','Off');
            xlim=get(handles.Axes(1),'Xlim'); drawnow;
            min_swr=min(swr);
            if min_swr>handles.swr_max
                warndlg(['All SWR values are above the display maximum of ',num2str(handles.swr_max)]);
            end;
            set(handles.Axes(1),'Ylim',[0,handles.swr_max],'Xlim',xlim);
            
        case 6
            % Port 1&2 SWR
            swr=vswr(squeeze(S(1,1,:)));
            set(handles.Left_Lines(1),'Xdata',Freq,'Ydata',swr,'visible','On','Tag','Port 1 SWR');
            min_swr=min(swr);
            if min_swr>handles.swr_max
                warndlg(['All SWR values are above the display maximum of ',num2str(handles.swr_max)]);
            end;
            swr=vswr(squeeze(S(2,2,:)));
            set(handles.Left_Lines(2),'Xdata',Freq,'Ydata',swr,'visible','On','Tag','Port 2 SWR');
            min_swr=min(swr);
            if min_swr>handles.swr_max
                warndlg(['All SWR values are above the display maximum of ',num2str(handles.swr_max)]);
            end;
            xlim=get(handles.Axes(1),'Xlim'); drawnow;
            set(handles.Axes(1),'Ylim',[0,handles.swr_max],'Xlim',xlim);
            
        case LEFT_SMITH
            % s11 Smith
            set(handles.smith.s11_Line,'Xdata',real(S(1,1,I_Range)),'Ydata',imag(S(1,1,I_Range)),'visible','on','Tag','S11','Userdata',F_MHz(I_Range));
            set(handles.smith.s22_Line,'visible','off');
            axis square % Aug 2018
        case LEFT_SMITH+1
            % s22 Smith
            set(handles.smith.s22_Line,'Xdata',real(S(2,2,I_Range)),'Ydata',imag(S(2,2,I_Range)),'visible','on','Tag','S22','Userdata',F_MHz(I_Range));
            set(handles.smith.s11_Line,'visible','off');
            axis square % Aug 2018
        case LEFT_SMITH+2
            % s11 and s22 Smith
            set(handles.smith.s11_Line,'Xdata',real(S(1,1,I_Range)),'Ydata',imag(S(1,1,I_Range)),'visible','on','Tag','S11','Userdata',F_MHz(I_Range));
            set(handles.smith.s22_Line,'Xdata',real(S(2,2,I_Range)),'Ydata',imag(S(2,2,I_Range)),'visible','on','Tag','S22','Userdata',F_MHz(I_Range));
            axis square % Aug 2018
        otherwise
            disp('Error in Left_Flavor_Callback')
    end
    Right_Flavor_Callback(hObject, eventdata, handles);
    
    
    
    
    % --- Executes on selection change in Right_Flavor.
function Right_Flavor_Callback(hObject, eventdata, handles)
    % see if Smith Chart is activated
    contents  = cellstr(get(handles.Left_Flavor,'String'));
    % Smith Chart format must be at the END of the Left Flavor list for this
    % to work.
    xx= strfind(contents,'Smith');
    p=1;
    while isempty(xx{p})
        p=p+1;    % crude but it works.
    end;
    smith_boundary=p;
    
    sel_value = get(handles.Right_Flavor,'Value');
    
    % Check for s1p file, force to a legal Right Flavor selection
    if ~isempty(strfind(upper(get(handles.dut_file,'string')),'S1P'))
        % s1p file ... lock out invalid selections
        if (sel_value == 1) || (sel_value==2)
            % legal for s1p, do nothing
        else
            sel_value=1;
            set(handles.Right_Flavor,'Value',sel_value);
        end;
    end;
    
    
    if get(handles.Left_Flavor,'value') < smith_boundary
        % A regular Cartesian plot
        set(handles.Figure,'CurrentAxes',handles.Axes(2));
        set(handles.Axes(2),'visible','on');
        set(handles.Axes(2),'XlimMode','auto','XtickMode','auto', 'YTickMode','auto','YLimMode','auto','YGrid','on','XGrid','on','XAxisLocation','bottom');
        contents = cellstr(get(handles.Right_Flavor,'String'));
        %  sel_value = get(handles.Right_Flavor,'Value');
        sel_str=contents{sel_value};
        ylabel(sel_str);
    else
        % Smith Chart is active, no action on the Right Axes.
        set(handles.Right_Flavor,'value',1); % set to None
        set( [handles.Axes(2),handles.Right_Lines],'visible','off');
        return;
    end;
    
    rf_obj=get(handles.Figure,'Userdata');
    if isempty(rf_obj);
        errordlg('You must load an s1p or s2p file.','PLEASE LOAD A FILE');
        return
    end;
    
    Freq=get(handles.Left_Lines(1),'Xdata'); % use scaled Freq from Left Flavor
    
    S = rf_obj.S_Parameters;
    switch sel_value
        case 1
            % None
            set([handles.Axes(2),handles.Right_Lines],'visible','off');
        case 2
            % Port 1 Return Loss
            % Return Loss should be a positive # for passive devices.
            mag_dB =-20*log10(abs(squeeze(S(1,1,:))));
            set(handles.Right_Lines(1),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','Port 1 RL dB');
            set(handles.Right_Lines(2),'visible','Off');
        case 3
            % Port 2 Return Loss
            mag_dB =-20*log10(abs(squeeze(S(2,2,:))));
            set(handles.Right_Lines(2),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','Port 2 RL dB' );
            set(handles.Right_Lines(1),'visible','Off');
            
        case 4
            % Port 1 and 2 RL
            mag_dB =-20*log10(abs(squeeze(S(1,1,:))));
            set(handles.Right_Lines(1),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','Port 1 RL dB');
            mag_dB =-20*log10(abs(squeeze(S(2,2,:))));
            set(handles.Right_Lines(2),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','Port 2 RL dB');
            
        case 5
            % S21 mag db
            mag_dB=20*log10(abs(squeeze(S(2,1,:))));
            set(handles.Right_Lines(1),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','|S21| dB');
            set(handles.Right_Lines(2),'visible','Off');
        case 6
            % S12 mag dB
            mag_dB=20*log10(abs(squeeze(S(1,2,:))));
            set(handles.Right_Lines(2),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','|S12| dB');
            set(handles.Right_Lines(1),'visible','Off');
            
        case 7
            % S21 and S12
            mag_dB=20*log10(abs(squeeze(S(2,1,:))));
            set(handles.Right_Lines(1),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','|S21| dB');
            mag_dB=20*log10(abs(squeeze(S(1,2,:))));
            set(handles.Right_Lines(2),'Xdata',Freq,'Ydata',mag_dB,'visible','On','Tag','|S12| dB');
        case 8
            % S21 Phase
            Phase_deg= (180/pi)*atan2(   squeeze( imag(S(2,1,:)) )   ,    squeeze(  real(S(2,1,:))  ));
            set(handles.Right_Lines(1),'Xdata',Freq,'Ydata',Phase_deg,'visible','On','Tag','S21 Deg');
            set(handles.Right_Lines(2),'visible','Off');
            
        case 9
            % S12 Phase
            Phase_deg= (180/pi)*atan2(   squeeze( imag(S(1,2,:)) )   ,    squeeze(  real(S(1,2,:))  ));
            set(handles.Right_Lines(2),'Xdata',Freq,'Ydata',Phase_deg,'visible','On','Tag','S12 Deg');
            set(handles.Right_Lines(1),'visible','Off');
            
        case 10
            % S21 and S12 Phase
            Phase_deg= (180/pi)*atan2(   squeeze( imag(S(2,1,:)) )   ,    squeeze(  real(S(2,1,:))  ));
            set(handles.Right_Lines(1),'Xdata',Freq,'Ydata',Phase_deg,'visible','On','Tag','S21 Deg');
            Phase_deg= (180/pi)*atan2(   squeeze( imag(S(1,2,:)) )   ,    squeeze(  real(S(1,2,:))  ));
            set(handles.Right_Lines(2),'Xdata',Freq,'Ydata',Phase_deg,'visible','On','Tag','S12 Deg');
        otherwise
            disp('Error in Right Flavor Callback')
    end
    % the Right_Flavor X axis is slaved to the Left_Flavor X axis
    xlim=get(handles.Axes(1),'Xlim'); drawnow;  % get the Left Flavor limits
    set(handles.Axes(2),'Xlim',xlim);           % set the Right Flavor limits
    
function Fstart_Callback(hObject, eventdata, handles)
    Left_Flavor_Callback(hObject, eventdata, handles)
    
function Fstop_Callback(hObject, eventdata, handles)
    Left_Flavor_Callback(hObject, eventdata, handles)
    
    % --- Executes on button press in Q_checkbox.
function Q_checkbox_Callback(hObject, eventdata, handles)
    if get(hObject,'value')
        set(handles.smith.Q,'visible','on');
    else
        set(handles.smith.Q,'visible','off');
    end
    
    % --- Executes on button press in SWR_checkbox.
function SWR_checkbox_Callback(hObject, eventdata, handles)
    if get(hObject,'value')
        set(handles.smith.swr,'visible','on');
    else
        set(handles.smith.swr,'visible','off');
    end
    
function notes_Callback(hObject, eventdata, handles)
    % nop
    
function Left_Flavor_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function Right_Flavor_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function notes_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function Fstart_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function Fstop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
