%#####################################################################
function h = smith_rab_v2(hax,SP)
    % hax=handle to the axis object that this chart will live in
    % SP.Rvalues a vector of Real(z) coordinate curves eg [0 10 25 50 100 250];
    % SP.Xvalues a vector of Imag(z) coordinate curves eg [10 25 50 100 200 500];
    % SP.Zo, typically 50 but sometimes 75 ohms.
    % SP.Nseg = number of line segments in the coordinate curves eg 61
    % SP.LW     linewidth.
    % SP.Colors is a structure with four fields eg:
    %    colors.grid= [0 0 0];
    %    colors.fill= [ 1 .9 .2]*0.8;
    %    colors.text= [0 0 1];
    %    colors.swr = [0 1 1];
    %    colors.Q   = [0 0 1];
    
    % optional SP.swr_circles, []=none 
    %    and this defines 4 circles:   swr_circles = [10 5 3 1.5]
    %    SP.LW_swr  swr line width 
    
    % optional Consatnt Q contours
    %   SP.Q_pts  []=none, number of line segments in a contour
    %   SP.Q_contours  eq Qs of [50 20 10 5 2 1];
    %   SP.LW_Q  countours line width
    
    % Handles are returned in a structure (h) to all objects.
    %      h.lx are all line objects
    %      h.txt is all text objects
    %      h.swr are line objects for swr circles
    %      h.Q  are the constant Q lines
    %      h.fill is a fill object for background color
    % This allows control of their visibility.
    % The swr circles have tags set to 'SWR=xx' xx is the swr. 
    % The Q contours have tags set to 'Q=xx' xx is the Q
    % Regular coordinate lines have tags set to 'Smith_grid'.
    % Tags are useful for custom datatip callbacks.
    % Dick Benson, January 2018, September 2018
    
    axes(hax);
    set(hax,'box','off','xgrid','off','ygrid','off','zgrid','off',...
        'color','none','nextplot','add','visible','off');
    set(hax,'xlim',[-1.1 1.1],'ylim',[-1.1,1.1]);
    xlabel(''); ylabel('');
    theta = linspace(0, -2*pi, SP.Nseg);
    % draw unit circle , and imag==0 line
    z = exp(1i*theta);
    p=1;
    t=1;
    h.lx(p)=line('xdata',real(z),'ydata',imag(z),'color',SP.colors.grid,'Tag','Smith_grid','Linewidth',SP.LW);
    p=p+1;
    h.lx(p)=line('xdata',[-1 1],'ydata',[0 0],'color',SP.colors.grid,'Tag','Smith_grid','Linewidth',SP.LW);
    % fill in background color
    h.fill=fill(real(z),imag(z),SP.colors.fill);
    p=p+1;
    for r=SP.Rvalues/SP.Zo
        z     =((r/(r+1) + 1/(r+1)*exp(1i*theta)));
        h.lx(p)=line('xdata',real(z),'ydata',imag(z),'color',SP.colors.grid,'Tag','Smith_grid','Linewidth',SP.LW);
        p=p+1;
        xpos = (r-1)/(r+1);
        if xpos ~= -1
            ht=text(xpos, 0,num2str(r*SP.Zo,3));
            set(ht, 'VerticalAlignment', 'bottom', 'HorizontalAlignment',...
                'left','color',SP.colors.inner_text,'Rotation',90,'Clipping','on');
        else
            % place the 0
            ht=text(1.15*xpos, 0,'0.0');
            set(ht, 'VerticalAlignment', 'middle', 'HorizontalAlignment',...
                'left','color',SP.colors.inner_text,'Rotation',0,'Clipping','on');
        end;
        h.txt(t)=ht;
        t=t+1;
    end;
    v = linspace(0,10,SP.Nseg);
    r = [ 0 v.^2];
    for x = SP.Xvalues/SP.Zo
        z = r+1i*x*ones(1,SP.Nseg+1);
        g = (z-1)./(z+1);
        h.lx(p)=line('xdata',real(g),'ydata', imag(g), 'color',SP.colors.grid,'Tag','Smith_grid','Linewidth',SP.LW);
        p=p+1;
        h.lx(p)=line('xdata',real(g),'ydata',-imag(g), 'color',SP.colors.grid,'Tag','Smith_grid','Linewidth',SP.LW);
        p=p+1;
        g= ((1i*x-1)/(1i*x+1));
        xpos = real(g);
        ypos = imag(g);
        s = num2str(SP.Zo*x,3);
        ht=text([xpos xpos], [ypos -ypos], [' j' s ; '-j' s]);
        set(ht(1),'VerticalAlignment', 'bottom','color',SP.colors.outer_text,'Clipping','on');
        set(ht(2),'VerticalAlignment', 'top','color',SP.colors.outer_text,'Clipping','on');
        if xpos == 0
            set(ht, 'Horizontalalignment', 'center');
        elseif xpos < 0
            set(ht, 'Horizontalalignment', 'right');
        end
        h.txt(t)=ht(1);
        t=t+1;
        h.txt(t)=ht(2);
        t=t+1;
    end;
    rmin = min(SP.Rvalues)/SP.Zo;
    rmax = max(SP.Rvalues)/SP.Zo;
    h.lx(p) = line('xdata',[(rmin-1)/(rmin+1),(rmax-1)/(rmax+1)],'ydata',[0 0],'color',SP.colors.grid,'Tag','Smith_grid','Linewidth',SP.LW);
    
    
    % If swr circles are spec'd draw them.
    if ~isempty(SP.swr_circles)
        z = exp(1i*theta);
        for k=1:length(SP.swr_circles)
            r=(SP.swr_circles(k)-1)/(SP.swr_circles(k)+1);
            s=['SWR=',num2str(SP.swr_circles(k))];
            h_swr(k)=line('xdata',real(z)*r,'ydata',imag(z)*r,'color',SP.colors.swr,'Tag',s,'Linewidth',SP.LW_swr);
        end;
    else
        h_swr=[];
    end;
    h.swr=h_swr;
    % Create constant Q contours if spec'd
    if ~isempty(SP.Q_pts)
        R = logspace(-2,4,SP.Q_pts); % vary the resistive component logarithmically
        p=1;
        for k=1:length(SP.Q_contours)
            s=['Q=',num2str(SP.Q_contours(k))];
            z= R*(1+1i*SP.Q_contours(k));
            rho=(z-SP.Zo)./(z+SP.Zo);
            h_Qlines(p)=line('Xdata',real(rho),'Ydata',imag(rho),'Color',SP.colors.Q,'Tag',s,'Linewidth',SP.LW_Q,'Visible','On');
            z= R*(1-1i*SP.Q_contours(k));
            rho=(z-SP.Zo)./(z+SP.Zo);
            p=p+1;
            h_Qlines(p)=line('Xdata',real(rho),'Ydata',imag(rho),'Color',SP.colors.Q,'Tag',s,'Linewidth',SP.LW_Q,'Visible','On');
            p=p+1;
        end;
    else
        h_Qlines=[];
    end;
    h.Q=h_Qlines;
    