function RT_analyse_gui_v1
% SIMPLE_GUI2 Select a data set from the pop-up menu, then
% click one of the plot-type push buttons. Clicking the button
% plots the selected data in the axes.

% Monitor 24"=60.96cm
% 16:9
% Breite:   53cm
% Höhe:     37cm
%
%ppc=1920/((60.96/sqrt(16^2+9^2))*16);
ppm=0.1*1920/((60.96/sqrt(16^2+9^2))*16);

deltaVert=-12;
DimFigure=[0 5 42 23]*10;
WX=DimFigure(3);
WY=DimFigure(4);
DimAxis=[15, 15 , 120, 100];


% markSize=7;
% hpl=[];
% hplMa=[];

% pol=char(zeros(1,10));
% ns=char(zeros(1,10));
% pol=[];
% ns=[];

str=@(x) get(x,'String');
getWrap=@(x,y) get(x,y);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Only for development purposes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evalin('base',['RANGES=struct( ''rlocus'',    [1 1 1 1],''pzmap'',    [1 1 1 1],''nyquist'',  [1 1 1 1],''step'',     [1 1 1 1]);']);
evalin('base',['handles.md=struct(  ''auto'',1,''hold'',0,''num'',[],''den'',[],''zeros'',[],''poles'',[],''gain'',[],''ranges'', RANGES,''lineWidth'', 1,''markerSize'',10);']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    currPlant=zpk([2],[-2 -1-1j -1+1j],1);        
    [tfN tfD]=zp2tf([2],[-2 -1-1j -1+1j],1);
    initsym=tf2sym(tf(tfN,tfD));
    initSym={'(s+2)','(s+1)*(s+3)*(s+3+4*j)*(s+3-4*j)'};

    
% ns= currPlant.z{:};
% pol=currPlant.p{:};
    Initstr={ 's-2';'s^3+4*s^2+6*s+4';
              's-2';'s^2+2*s+1';
              's-2';'s+5*s^2+3*s^3+s^4-10';
              '(s+2)';'(s+1)*(s+3)*(s+3+4*j)*(s+3-4*j)'};
 
    na={'wok' 'pzmap' 'bode' 'nyquist' 'step'};

    pos=struct('wok',1,'pzmap',2,'bode',3,'nyquist',4,'step',5)
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%      Constructed and the main GUI 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


f = figure('Visible','on','Position',DimFigure*ppm);
    set(f,'Units','Centimeters');

    handles = guihandles(f); 
    
    % Create the button group.
    hui = uipanel('visible','on','Position',[0 0 15 15]*ppm);
    set(hui,'units','pixels')

                    
    htfnum = uicontrol('Style','edit','String', Initstr{7},...
                        'Tag','numerator','Units', 'pixel',...
                        'BackgroundColor',[1 1 1],...
                        'Position',[10, 85, 70, 8]*ppm,...
                        'parent',hui,...
                        'Callback',{@tfeditbox_Callback}); 

    htfden = uicontrol('Style','edit','String',Initstr{8},...
                        'Tag','denominator','Units', 'pixel',...
                        'BackgroundColor',[1 1 1],...
                        'Position',[10, 77, 70, 8]*ppm,...
                        'parent',hui,...
                        'Callback',{@tfeditbox_Callback});

	htfronum = uicontrol('Style','edit',...
                        'Tag','num RO','Units', 'pixel',...
                        'Position',[10, 64, 70, 8]*ppm,...
                        'parent',hui,...
                        'Enable','off',...
                        'Backgroundcolor',[0.7 0.7 0.7]*1.1);

    htfroden = uicontrol('Style','edit',...
                        'Tag','den RO','Units', 'pixel',...
                        'Position',[10, 56, 70, 8]*ppm,...
                        'parent',hui,...
                        'Enable','off',...
                        'Backgroundcolor',[0.7 0.7 0.7]*1.1);
       
    for i=1:3
        pb(i) = uicontrol(...  
                'Style','pushbutton','String','plot',...
                'parent',hui,'Position',[7 7 35 10]*ppm);
    end
    
    rb(1) = uicontrol( 'Style', 'radiobutton', ...
                        'Callback', {@radio_Callback},...
                        'Units',    'pixels', ...
                        'String',   'Hold', ...
                        'Tag',      'hold',...
                        'parent',hui,...
                        'Value',    0);
    rb(2) = uicontrol( 'Style', 'radiobutton', ...
                        'Callback', {@radio_Callback},...
                        'Units',    'pixels', ...
                        'String',   'empty', ...
                        'Tag',      'empty',...
                        'parent',hui,...
                        'Value',    0);            
    rb(3) = uicontrol( 'Style', 'radiobutton', ...
                        'Callback', {@radio_Callback},...
                        'Units',    'pixels', ...
                        'String',   'Autoscale', ...
                        'Tag',      'autosc',...
                        'parent',hui,...
                        'Value',    1);
     % Create the button group.
    hgr = uibuttongroup('visible','on','Position',[0 0 15 15]*ppm);
    set(hgr,'units','pixels')
    uitext={'WOK','Nyquist','Step'};

    for i=1:3
        ub(i) = uicontrol(  'Style','radiobutton',...
                            'String',uitext{i},...
                            'parent',hgr,...
                            'HandleVisibility','on');
    end



	set(hgr,'SelectionChangeFcn',@selcbk);
    set(hgr,'SelectedObject',[]);  % No selection


    set(rb,'pos',[7 7 28 8]*ppm); 
    align([rb htfnum htfden htfronum htfroden],'left','Vertical')
    align([rb],'Horizontal','fixed',1*ppm)

    set(pb,'pos',[7+28 7 25 8]*ppm);
    align([pb],'Horizontal','fixed',1*ppm)

    set(ub,'pos',[5 7 25 6]*ppm);
    align([ub],'Vertical','middle')
    align([ub(3) ub(2) ub(1)],'Horizontal','fixed',1*ppm)

    
    % Create figure to use as GUI in your main function or a local function
%    figure_handle = figure('Toolbar','none');
    % create structure of handles
    
    na={'wok' 'pzmap' 'bode' 'nyquist' 'step'};
    
    axpos={ '15.0000  124.8052  120  100'
            '144.805  124.8052  120  100'
            '274.6102 124.8052  120  100'
            '15       15        120  100'
            '144.8052 15        120  100'};    
        
    for i=1:5
        handles.ha(i)= axes('Units','Pixels','Position',DimAxis*ppm, 'Tag',na{i});
        text(0.5,0.5, na(i))
        set(handles.ha(i),'Position',str2num(axpos{i})*ppm);
    end
%     i=4;
% %    handles.ha(i)=BodePaper(1e-3,1e3,-200,10,-180,90);
%     handles.ha(i)semilogx(wout,20*log10(mag))
%     i=5;
%     handles.ha(i)= axes('Units','Pixels','Position',DimAxis*ppm, 'Tag',na{i});
%     text(0.5,0.5, na(i))
    
    
    set(handles.ha(i),'Position',str2num(axpos{i})*ppm);
        
    
    slidertext={'Re','Im'};
    sliderCallbacks={   {@surfxlim, handles.ha(1)},...
                        {@surfylim, handles.ha(1)} };
    for i=1:2
        sli(i)= uicontrol('Style', 'slider',...
                         'Min',0.1,'Max',10,'Value',5,...
                         'units','pixel',...
                         'parent',hgr,...
                         'Position', [10 10 10 10]*ppm,...
                         'String', [slidertext(i) 'Axis'],...
                         'Callback', sliderCallbacks{i});                 
%                         'Callback', {@surfxlim, handles.ha(1)});                 

        slit(i)= uicontrol('Style', 'text',...
                         'units','pixel',...
                         'parent',hgr,...
                         'Position', [10 10 10 10]*ppm,...
                         'string',slidertext(i));                 
    end
    
    set(sli,'pos',[5 30 6 48]*ppm);
    align([htfnum sli],'Horizontal','top')
    align([sli],'fixed',1*ppm,'Vertical')
    
    ysl=get(sli(1),'Position');
    set(slit,'pos',[5 ysl(2)/ppm-7 6 5]*ppm);
    align([slit],'fixed',1*ppm,'Vertical')
    

    
    
    posui=[get(handles.ha(pos.bode),'Position') get(handles.ha(pos.nyquist),'Position')]/ppm;
    set(hui,'position',[posui(1) posui(6) DimAxis(3:4)]*ppm)

    set(hgr,'Units','pixels','Position',[posui(1)+85 posui(6) 35 100]*ppm,...
            'BackgroundColor',[1 1 1]*0.55)

    RANGES=struct( 'rlocus',    [1 1 1 1],...
                    'pzmap',    [1 1 1 1],...
                    'nyquist',  [1 1 1 1],...
                    'step',     [1 1 1 1]);

    md=struct(  'auto',1,...
                'hold',0,...
                'num',[],...
                'den',[],...
                'zeros',[1],...
                'poles',[1 1 1],...
                'gain',[],...
                'ranges', RANGES,...
                'lineWidth',1,...
                'markerSize',10);    
        
    md.num=tfN;
    md.den=tfD;
    md.num=[1 -3];
    md.den=[1 2 1];
    
    handles.md = md;
%    handles.ha = ha;
    handles.htfden = htfden;
    handles.htfnum = htfnum;
    handles.htfroden = htfroden;
    handles.htfronum = htfronum;
    
    handles.P=nyquistoptions;
    handles.P.ShowFullContour='off';

    % Save the structure
    guidata(f, handles) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       str2num(axpos{i})
%       newPlot(0,0);
%       hObject
%       tfeditbox_Callback{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  Callback für den tf- Parser  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function tfeditbox_Callback(hObject, eventdata, handles)
        callertag=get(hObject,'Tag');
        callerstr=get(hObject,'String');
        handles = guidata(f);
        
        p=sym('p');
        s=sym('s');

        if isempty(callerstr) % lehres polynom
            disp('Faktor 0 ist zu wenig!')
            set(hObject,'String',num2str(1))
        end
        
        den = get(handles.htfden,'String');
        num = get(handles.htfnum,'String');

%        if (strcmp(symvar(den),'s') & strcmp(symvar(num),'s')) 
        ch1=(strcmp(symvar(den),'s') & strcmp(symvar(num),'s')) 
        ch2=(strcmp(symvar(den),'s') )
         if ch2 
            di={sym(num); sym(den)};
            solc=cellfun(@solve,di(:),'UniformOutput',false);
            if isempty(solc{1})
                solc{1}='1';
                sold=cellfun(@eval,solc,'UniformOutput',false);
                imInNum=[];
                imInDen=find( imag(cell2mat(sold(2))) );
            else
                sold=cellfun(@eval,solc,'UniformOutput',false);
                imInNum=find( imag(cell2mat(sold(1))) );
                imInDen=find( imag(cell2mat(sold(2))) );
            end
%            sole=cellfun(@imag, sold, 'UniformOutput',false);
%            reInd=~find(arrayfun(@imag, sole));
            SOL=[];
            clear i;
            try
                if ~isempty(imInNum) | strcmp(symvar(num),'s')
                    cplxpair(sold{1}); 
                    handles.md.num  = sym2poly(eval(num)); 
                    handles.md.zeros = eval(solve(eval(num)==0,s)).';
                else
                    handles.md.num  = str2double(num);
                    handles.md.zeros = [];
                end
                set(handles.htfnum, 'BackgroundColor','white');
            catch err
                SOL=1;
                disp('Nicht alle pole/NS sind konjugiert komplex! --> Komplexwertiges Zeitsignal')
                set(handles.htfnum, 'BackgroundColor','red');
            end
            
            
            try
                if ~isempty(imInDen)
                    cplxpair(sold{2});
                    handles.md.den  = sym2poly(eval(den));
                    handles.md.poles = eval(solve(eval(den)==0,s)).';
                else
                    disp('Nennergrad: 0')
                    SOL=1;
                end
                set(handles.htfden, 'BackgroundColor','white');
            catch err
                SOL=1;
                disp('Nicht alle pole/NS sind konjugiert komplex! --> Komplexwertiges Zeitsignal')
                set(handles.htfden, 'BackgroundColor','red');
            end
            
            if SOL~=0
                return
            end
            
            spowN=s.^[length(handles.md.num)-1:-1:0];
            spowD=s.^[length(handles.md.den)-1:-1:0];
            
            set(handles.htfronum, 'string',char(handles.md.num*spowN.'));
            set(handles.htfroden, 'string',char(handles.md.den*spowD.'));

            guidata(f,handles);
            
            refresh_Callback(hObject, eventdata, handles);
            
            abc=[];
        end   
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  Button Group selection change callback %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function selcbk(source,eventdata)
%        disp(source);
%        get(source)
        disp([eventdata.EventName,'  ',... 
        get(eventdata.OldValue,'String'),'  ', ...
        get(eventdata.NewValue,'String')]);
        disp(get(get(source,'SelectedObject'),'String'));

        handles = guidata(f);
        handles.md
        
        guidata(f,handles);
    end


    function surfxlim(hObj,event,ax) %#ok<INUSL>
        val = 11 - get(hObj,'Value');
        xlim(ax,[-val val]);
    end

    function surfylim(hObj,event,ax) %#ok<INUSL>
        val = 11 - get(hObj,'Value');
        ylim(ax,[-val val]);
    end



    function buttonZPK_Callback(hObject, eventdata, handles)
        
%         [polyZ, kz] = parsePoly(hzoedit(1:5));
%         [polyP, kp] = parsePoly(hpoedit(1:5));
        
        handles.md.zeros=[polyZ];
        handles.md.poles=[polyP];
        handles.md.gain=kz/kp;
        
    %    newPlot(handles.md.num, handles.md.den);
        
%         handles.md.zeros
%         handles.md.poles
%         md
%        save('uiout','di','sold','sole');
    end



    function markerin_Callback(hObject, eventdata, handles)
        str = get(hObject,'String');
        handles = guidata(f);

        handles.md.markerSize=abs(str2num(str));
        for i=1:4
            set(handles.hplMa(i,:),'MarkerSize',handles.md.markerSize);
        end
        
        guidata(f,handles) 
    end



    function radio_Callback(hObject, eventdata, handles)
        val = get(hObject,'Value');
        callTag=get(hObject,'Tag');
        handles = guidata(f);

        switch callTag
            case 'hold'    
                handles.md.hold=val;
            case 'autosc'  
                handles.md.auto=val;
                ;
            otherwise
                disp('unknown radiobutton tag!')
        end
%         if md.auto == 0
%             md.
        guidata(f,handles) 
    end





    function refresh_Callback(hObject, eventdata, handles)
        handles = guidata(f);
        
        handles.md
        sys=tf(handles.md.num, handles.md.den);
%        sys=tf(handles.md.num, handles.md.den);

        [gPoles, gZeros]=pzmap(sys);

        DI=sys;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % zähler/nennergrade, rel. systemgrade, wurzelschwerpunkte,
        % asymptotenwinkel, xrange min/max  für alle G0's in 
        % vektoren schreiben
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        rang=@(x)[min(x) max(x)];

        nrel=length(gPoles) - length(gZeros);
        dw=1/nrel*( sum(real(gPoles) )-( sum(real(gZeros)) ));
        asym=round( (2*[0:1:nrel-1]+1)*pi/nrel*180/pi);
%        lo=min(min(min(real(gPoles),dw)) , min(min(real(gZeros),dw)) );
%        up=max(max(max(real(gPoles),dw)) , max(max(real(gZeros),dw)) );
        TMP=[   min(real(gPoles)),...
                min(imag(gPoles)),...
                min(real(gZeros)),...
                min(imag(gZeros)),...
                max(real(gPoles)),...
                max(imag(gPoles)),...
                max(real(gZeros)),...
                max(imag(gZeros))];

        xRan=rang(TMP);

        up=max(max(imag(gPoles)),max(imag(gZeros)));
        if up==0
            up=0.5*sum(abs(xRan));
        end
        yRan=[-up up];
        yRan=[-5 5];
        
        handles.md.ranges.pzmap=[xRan*1.2, yRan*2.2];
        handles.md.ranges.rlocus=handles.md.ranges.pzmap;
        handles.md.ranges.nyquist=handles.md.ranges.pzmap;
        handles.md.ranges

        [re,im,w,~,~] = nyquist(DI);
        nyq(1,:)=squeeze(re);
        nyq(2,:)=squeeze(im);

        handles.md.ranges.nyquist=[min(re) max(re) min(im) max(im)]*1.2;
        
%         r1=@(x) round(10*x)/10;
%         handles.md.ranges.nyquist=r1(handles.md.ranges.nyquist);
%         handles.md.ranges.pzmap=r1(handles.md.ranges.pzmap);
%         handles.md.ranges.rlocus=r1(handles.md.ranges.rlocus);
%         handles.md.ranges.rlocus=r1(handles.md.ranges.rlocus);

        if handles.md.hold == 0
            delete(findall(handles.ha,'type','line'));
        end
%        cla reset;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % alle subplots formatieren
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if handles.md.auto == 1  
            xx= @(x) line(get(gca,'xlim') ,[0 0], 'LineStyle','-','Color',[1 1 1]*0.5,'LineWidth',1);
            yy= @(x) line([0 0],get(gca,'ylim'), 'LineStyle','-','Color',[1 1 1]*0.5,'LineWidth',1);
            setRng=@(h,x) set(h, 'XLim',x(1,:),'YLim',x(2,:));
%            setRng=@(h,x) set(h, 'XLim',x(1,:));

            %zcross={'LineStyle','-.','Color',[1 1 1]*0.7,'LineWidth',0.2};
            set(handles.ha([1,2,4,5]),'XLimMode','manual','YLimMode','manual');

            
            axes(handles.ha(1));
            if handles.md.hold == 0
                for i=1:length(handles.ha)  %%% Reset color
                    hold off;
                    plot(handles.ha(i),0);
                    hold all;
                end
            else
                axes(handles.ha(1));
                hold all;
            end
            
            RR=[handles.md.ranges.rlocus([1,2]); handles.md.ranges.rlocus([3,4])];
            setRng(handles.ha( pos.wok ),RR); 
            axes(handles.ha( pos.wok )); xx(0); yy(0);

            RR=[handles.md.ranges.pzmap([1,2]); handles.md.ranges.pzmap([3,4])];
            setRng(handles.ha( pos.pzmap ),RR);
            axes(handles.ha( pos.pzmap )); xx(0); yy(0);

            RR=[handles.md.ranges.nyquist([1,2]); handles.md.ranges.nyquist([3,4])];
            setRng(handles.ha( pos.nyquist ),RR);
            axes(handles.ha( pos.nyquist )); xx(0); yy(0);
        end
tic        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % wok zeichnen
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        lightGray=[1 1 1]*0.6;

        rloc=rlocus(DI);
        [arms ~]=size(rloc);

        axes(handles.ha( pos.wok ))
        hold all;
        grid on;
        
        %%%% Asymptoten
        for i=1:length(asym)
            lh(i,:)=line([dw 10],[0 0],'LineStyle','-.',...
            'Color',lightGray,'LineWidth',0.2);
            rotate(lh(i),[0 0 1],asym(i),[dw 0 0]);
        end
   
        for i=1:arms
            handles.hpl(i,:)=plot(real(rloc(i,:)),imag(rloc(i,:)),'LineWidth',handles.md.lineWidth);
        end
        
        handles.hplMa=[];
        if handles.md.zeros ~= 0
            handles.hplMa(end+1)=plot(real(gZeros),imag(gZeros),'o','Color','black');
        end
        handles.hplMa(end+1)=plot(real(gPoles),imag(gPoles),'X','Color','black');
        hold off;
toc
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % pz- map zeichnen
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        axes(handles.ha( pos.pzmap ));
        hold on;
        if handles.md.zeros ~= 0
            handles.hplMa(end+1)=plot(real(gZeros),imag(gZeros),'o');
        end
        handles.hplMa(end+1)=plot(real(gPoles),imag(gPoles),'X');
        grid on;
        hold off;

        set(handles.hplMa,'MarkerSize',handles.md.markerSize);
toc
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Nyquistkurve zeichnen
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        axes(handles.ha( pos.nyquist ))
        [Gm,Pm,Wgm,Wpm]=margin(DI); 

        %%%% margins
        lh(1,:)=line([0 10],[0 0],'LineStyle','-.',...
        'Color',lightGray,'LineWidth',handles.md.lineWidth);
        rotate(lh(1),[0 0 1],(180+Pm),[0 0 0]);

        lh(2,:)=line([-1 (1-10^(Pm/10))],[0 0],'LineStyle','-.',...
        'Color',[1 1 1]*0.9,'LineWidth',handles.md.lineWidth);

        hold all;
        handles.hplNyq(5)=plot(nyq(1,:), nyq(2,:));
        hold off;
        grid on;
toc        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % nyquistplot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        axes(handles.ha( pos.step ))
        hold on
        nyquist(DI,handles.P)
        hold off
toc
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Bode
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        axes(handles.ha( pos.bode ))
        hold on;
%         hbode=bodeplot(DI)
        hold off;
        grid on;
toc
%         hold on
%         bpl=bodeplot(DI)
%         hold off;
%         te=getWrap(findall(f,'type','text'),'String')        
%         strfind(
%         AxGr=get(bpl,'AxesGrid')
%         set(AxGr,'String','')
%        set(get(bpl,'AxesGrid'),'XLabel','');

        guidata(f,handles) 

    end
end

%  Pop-up menu callback. Read the pop-up menu Value property
%  to determine which item is currently displayed and make it
%  the current data.
%       function popup_menu_Callback(source,eventdata) 
%          % Determine the selected data set.
%          str = get(source, 'String');
%          val = get(source,'Value');
%          % Set current data to the selected data set.
%          switch str{val};
%          case 'Peaks' % User selects Peaks.
%             CD = peaks_data;
%          case 'Membrane' % User selects Membrane.
%             CD = membrane_data;
%          case 'Sinc' % User selects Sinc.
%             CD = sinc_data;
%              otherwise
%                  ;
%          end
%       end
  
  
  
%    function zedit_Callback(hObject, eventdata, handles)
%         id=get(hObject,'Tag');
%         idNr=str2num(id(4:end))
% 
%         %        g0=syms2tf(strtrm(ge)
%         if isempty(ge)
%             ns(idNr)=NaN;
%         else
%             ns(idNr)=get(hObject,'String');
%         end
%         newPlot(ns,pol,currPlant);
%    end


%     function [SOL, kp] = parsePoly(hfactPoly)
%         a.string=@(x) get(x,'String');
%         a.tag=@(x) get(x,'tag');
%         s=sym('s');
% 
%         handles = guidata(f);
%    
%         clear i;
%         di=a.string(hfactPoly)';
% 
%         ind1=cellfun(@symvar,di,'UniformOutput',false);   % Test cell di including pole symbolic 
%         ind2a=~cellfun(@isempty,ind1); % pole ohne symvar müssen bei sol extra behandelt werden
%         ind2b=~cellfun(@isempty,di);
% 
% %        kp=cell2mat( di(~ind2a & ind2b) );
%         kp=cell2mat( di(~ind2a & ind2b) );
%         if isempty(kp)
%             kp=1;
%         else
%             kp=str2num(kp);
%         end
%         
%         solc=cellfun(@solve,di(ind2a),'UniformOutput',false);
%         sold=cellfun(@eval,solc,'UniformOutput',false);
%         sole=cell2mat(sold);
%         cmpxInd=(arrayfun(@imag, sole));
%         reInd=(~arrayfun(@imag, sole));
%         try
%             SOL=[cplxpair(sole(cmpxInd)) sort(sole(reInd))]; 
%         catch err
%             SOL=[];
%             disp('Nicht alle pole/NS sind konjugiert komplex! --> Komplexwertiges Zeitsignal')
%         end        
%         
%         handles.stateStruct=md;
%         guidata(f,handles) 
%     end



%     function radio_Callback(hObject, eventdata, handles)
%         val = get(hObject,'Value');
%         callTag=get(hObject,'String');
% 
%         handles = guidata(f);
%         
%         switch callTag
%             case 'hold' 
%                 handles.md.hold=val;
%             case 'Hold' 
%                 handles.md.hold=val;
%             case 'autoscale'  
%                 handles.md.auto=val;
%             case 'Autoscale'  
%                 handles.md.auto=val;
%             otherwise
%                 disp('unknown radiobutton tag!')
%                 ;
%         end
% %         if handles.md.auto == 0
% %             handles.md.
%         guidata(f,handles) 
% 
%     end