function Spar_Plot(Path,Name)
    % Spar_Plot(Path,Name)
    % Handles SnP S-Parameter Files. 
    % Dick Benson, October 2015, September 2018
    
    if strfind(upper(Name),'S1P')>0
        s1p_viewer('Load_File_Callback',{Path},{Name});
    elseif strfind(upper(Name),'S2P')>0
        s2p_viewer('Load_File_Callback',{Path},{Name});
    else
        spar_obj = sparameters([Path,Name]);
        [N,M,L]=size(spar_obj.Parameters);
        if spar_obj.Impedance ~= 50
            errordlg(' This is not a 50 ohm system.');
            return
        end
        if N>4 || M >4
            hw= warndlg('The plot axis will be small, consider pre-processing this sNp file.',...
                'WARNING: Too many S-parameters.','modal');
            uiwait(hw)
        end;
        scrsz = get(groot,'ScreenSize');
        hf=figure;
        set(hf,'Position',[0.1* scrsz(3),scrsz(4)*.05   scrsz(3)*.8 scrsz(4)*.8],...
            'Name',['File: ',[Path,Name]],'NumberTitle','off',...
            'MenuBar','none','ToolBar','figure','PaperOrientation','landscape','PaperUnits','inches','PaperSize',[11,8.5],'PaperPositionMode','auto');
        % Note the reversal of the Papersize dimensions. Sure not obvious !
        set(hf,'HandleVisibility','on');
        
        % Custom Data Tip
        dcm_obj = datacursormode(hf);
        datacursormode on;
        set(dcm_obj,'UpdateFcn', @data_tip_updatefcn )
        % This is PAINFUL!!
        % These are the only ToolBar items that make sense:
        % Data Cursor
        % Pan
        % Zoom Out
        % Zoom In
        % These need to be turned OFF:
        turn_off={'Show Plot Tools',...
            'Hide Plot Tools',...
            'Print Figure',...
            'Save Figure',...
            'Open File',...
            'New Figure',...
            'Insert Legend',...
            'Insert Colorbar',...
            'Rotate 3D',...
            'Edit Plot',...
            'Link Plot',...
            'Show Plot Tools and Dock Figure',...
            'Brush/Select Data'};
        L=length(turn_off);
        a = findall(hf);
        for k=1:L
            % Obvious to the casual observer.
            set(findall(a,'ToolTipString',turn_off{k}),'Visible','Off');
        end;
        Freq_MHz=spar_obj.Frequencies*1e-6;
        
        SP.Rvalues=[0 20 50 150];    % SP= Smith Parameters
        SP.Xvalues=[10 25 50 100 400];
        SP.Zo=50;
        SP.Nseg=360;
        SP.LW  = 1.5;  % LW= line width for Smith coordinates
        SP.swr_circles =[]; % set to [] for no SWR circles
        SP.colors.grid= [0 0 0];              % black coordinate lines
        SP.colors.fill= [1 1 1]*0.8;          % background
        SP.colors.inner_text= [0 0 1];        % inner labels
        SP.colors.outer_text= [0 0 0];        % outer labels
        SP.Q_pts         = [];                % number of points in a contour
        
        plot_num=1;
        Line_color=[1 0 0];
        LW = 1.5;
        for n=1:N
            for m=1:M
                hax = subplot(M,N,plot_num);
                if n==m
                    smith_rab_v2(hax,SP);
                    line('Xdata',real(squeeze(spar_obj.Parameters(m,n,:))),....
                        'Ydata',imag(squeeze(spar_obj.Parameters(m,n,:))),...
                        'Color',Line_color,'Linewidth',LW,'Tag','Rho');
                    set(hax,'Ylim',[-.9,.9],'Xlim',[-1.5 1.5],'Clipping','Off',...
                        'Tag','axes_smith','UserData',Freq_MHz);
                    
                else
                    set(hax,'Tag','axes_mag');
                    mag_dB=20*log10(abs(squeeze(spar_obj.Parameters(n,m,:))));
                    if mag_dB(1)==-Inf
                        title(['S',num2str(n,1),num2str(m,1),' is not defined.']);
                    else
                        line('Xdata',Freq_MHz,'Ydata',mag_dB,'Color',Line_color,'Linewidth',LW);
                        title(['S',num2str(n,1),num2str(m,1)]);
                        xlabel('MHz');ylabel('dB');
                    end
                end;
                plot_num=plot_num+1;
                drawnow;
            end;
        end;
    end;
    
function output_txt=data_tip_updatefcn(obj,event_obj)
    % This is the "custom datatip" callback that replaces the "stock" version.
    
    pos = get(event_obj,'Position'); % returns x,y coordinates
    lh=get(event_obj.Target);        % line handle
    ax=lh.Parent;                   % axis
    % fig = ax.Parent;
    switch get(ax,'Tag')
        % Which axes ?
        case 'axes_mag'
            % ud=get(obj.Parent,'UserData');
            % index =  pos(1)== Fvec;
            mag=pos(2);
            freq=pos(1);
            output_txt = {['Freq: ',num2str(freq,6),' MHz'],...
                ['Magnitude: ' ,num2str(mag,4),   ' dB']};
            
        case 'axes_smith'
            Fvec=get(obj.Parent,'UserData');
            Rho   = lh.XData+ 1i*lh.YData;
            s11=pos(1)+1i*pos(2);
            z0  = 50;
            z = z0*(1+s11)./(1-s11);
            swr=abs((1+abs(s11))./(1-abs(s11)));
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
                swr=abs((1+abs(s11))./(1-abs(s11)))
                output_txt = { ['SWR: ',  num2str(swr,2),':1'],...
                    ['Real: ', num2str(real(z),4),' Ohms'],...
                    ['Imag: ', num2str(imag(z),4),' Ohms'],...
                    };
                return; % there is no more to be done
            else
                index = (Rho==s11);
                % In the case where there is no frequency dependence,
                % the index vector is meaningless
                xx= sum(index==1);
                if xx==1
                    freq=Fvec(index);
                else
                    freq=Fvec(1);
                end;
                output_txt = {['Freq: ', num2str(freq,6),' MHz'],...
                    ['Real: ', num2str(real(z),4),' Ohms'],...
                    ['Imag: ', num2str(imag(z),4),' Ohms'],...
                    ['SWR:  ', num2str(swr,4),' :1']
                    };
            end;
            
    end  % Switch
    
