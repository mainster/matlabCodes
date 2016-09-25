function RT_analyse_gui_v1a
% GUI zur grafischen Analyse von Laplace- Übertragungsfunktionen 
%
% Version:          v1 alpha
% Author:           Manuel Del Basso
% Projektstart:     12.07.2014
%

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

str=@(x) get(x,'String');
getWrap=@(x,y) get(x,y);

global ERR
ERR=-1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Only for development purposes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evalin('base',['RANGES=struct( ''rlocus'',    [1 1 1 1],''pzmap'',    [1 1 1 1],''nyquist'',  [1 1 1 1],''step'',     [1 1 1 1]);']);
evalin('base',['h.md=struct(  ''auto'',1,''hold'',0,''num'',[],''den'',[],''zeros'',[],''poles'',[],''gain'',[],''ranges'', RANGES,''lineWidth'', 1,''markerSize'',10,''parserError'',1);']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    [tfN tfD]=zp2tf([2],[-2 -1-1j -1+1j],1);
    
    Initstr={ 's-2';'s^3+4*s^2+6*s+4';
              's-2';'s^2+2*s+1';
              's-2';'s+5*s^2+3*s^3+s^4-10';
              '(s+2)';'(s+1)*(s+3)*(s+3+4*j)*(s+3-4*j)';
              '(s+4)';'(s+3)*(s+7)*(s+1+5*j)*(s+1-5*j)'};
 
    pos=struct('wok',1,'pzmap',2,'bodeMag',3,'bodePhase',4,'nyquist',5,'step',6);
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%      Main GUI construction  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = figure('Visible','on','Position',DimFigure*ppm);
    set(f,'Units','Centimeters');

    h = guihandles(f); 
    
    hui = uipanel('visible','on','Position',[0 0 15 15]*ppm);
    set(hui,'units','pixels')

                    
    htfnum = uicontrol('Style','edit','String', Initstr{9},...
                        'Tag','numerator','Units', 'pixel',...
                        'BackgroundColor',[1 1 1],...
                        'Position',[10, 85, 70, 8]*ppm,...
                        'parent',hui,...
                        'Callback',{@tfeditbox_Callback}); 

    htfden = uicontrol('Style','edit','String',Initstr{10},...
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
                    
    hsweep  = uicontrol('Style','edit','String', 'a=[1:2:5]',...
                        'Tag','sweepVarEdit','Units', 'pixel',...
                        'BackgroundColor',[1 1 1],...
                        'Position',[10, 85, 70, 8]*ppm,...
                        'parent',hui,...
                        'Callback',{@tfeditbox_Callback});       

	pb(1) = uicontrol(  'Style','pushbutton',...
                        'String','Clear','Tag','Clear',...
                        'parent',hui,'Position',[7 7 35 10]*ppm,...
                        'Callback',{@button_Callback});       

	pb(2) = uicontrol(  'Style','pushbutton',...
                        'String','Stop','Tag','Stop',...
                        'parent',hui,'Position',[7 7 35 10]*ppm,...
                        'Callback',{@button_Callback});       
                    
    rb(1) = uicontrol( 'Style', 'radiobutton', ...
                        'Callback', {@radio_Callback},...
                        'Units',    'pixels', ...
                        'String',   'sweep', ...
                        'Tag',      'sweep',...
                        'parent',hui,...
                        'Value',    0);            
    rb(2) = uicontrol( 'Style', 'radiobutton', ...
                        'Callback', {@radio_Callback},...
                        'Units',    'pixels', ...
                        'String',   'Hold', ...
                        'Tag',      'hold',...
                        'parent',hui,...
                        'Value',    0);
    rb(3) = uicontrol( 'Style', 'radiobutton', ...
                        'Callback', {@radio_Callback},...
                        'Units',    'pixels', ...
                        'String',   'Autoscale', ...
                        'Tag',      'autosc',...
                        'parent',hui,...
                        'Value',    1);

                    
% 	pbDEBUG = uicontrol(  'Style','pushbutton',...
%                         'String','Stop','Tag','Stop',...
%                         'parent',hui,'Position',[50 50 35 10]*ppm,...
%                         'Callback',{@DEBUG_button_Callback});       

    hgr = uibuttongroup('visible','on','Position',[0 0 15 15]*ppm);
    set(hgr,'units','pixels')
    uiinit={'wok',1; 'nyquist',0; 'step',0};

    for i=1:3
        ub(i) = uicontrol(  'Style','radiobutton',...
                            'String',uiinit{i,1},...
                            'Value',uiinit{i,2},...
                            'parent',hgr,...
                            'HandleVisibility','on');
    end
    
    pbres = uicontrol(  'Style','pushbutton',...
                        'String','Reset','Tag','Reset',...
                        'parent',hgr,'Position',[7 7 35 10]*ppm,...
                        'Callback',{@button_Callback});       


	set(hgr,'SelectionChangeFcn',@selcbk);
%    set(hgr,'SelectedObject',[]);  % No selection

    set(rb,'pos',[7 7 28 8]*ppm); 
    align([rb htfnum htfden htfronum htfroden],'left','Ver%tical')
    align([rb],'Horizontal','fixed',1*ppm)

    set([pb hsweep],'pos',[7+28 7 25 8]*ppm);
    align([hsweep pb],'Horizontal','fixed',1*ppm)

    set(ub,'pos',[5 7 25 6]*ppm);
    align([ub],'Ver%tical','middle')
    align([ub(3) ub(2) ub(1)],'Horizontal','fixed',1*ppm)

    na={'wok' 'pzmap' 'bodeMag' 'bodePhase' 'nyquist' 'step'};
    
    axpos={ '15.0000  124.8052  120  100'
            '144.805  124.8052  120  100'
            '274.6102 124.8052  120  100'
            '15       15        120  100'
            '144.8052 15        120  100'};    
    axpos2={ '15.0000  124.8052  120  100'
            '144.805  124.8052  120  100'
            '274.6102 124.8052+50  120  48'
            '274.6102 124.8052  120  48'
            '15       15        120  100'
            '144.8052 15        120  100'};   
        
    for i=1:6
        h.ha(i)= axes(  'Units','Pixels','Position',DimAxis*ppm,'Tag',na{i});
        text(0.5,0.5, na(i))
        set(h.ha(i),'Position',str2num(axpos2{i})*ppm);
    end
    set(h.ha([1,5:6]),'ButtonDownFcn', @AxisClick_Callback);
    
    set(h.ha([3:4]),'XScale','log');
    set(h.ha(i),'Position',str2num(axpos2{i})*ppm);
        
    slidertext={'Re','Im','offset','offset'};
    sliderCallbacks={   {@surfxlim, h.ha( pos.wok )},...
                        {@surfylim, h.ha( pos.wok )},...
                        {@surfxoff, h.ha( pos.wok )},...
                        {@surfyoff, h.ha( pos.wok )} };
                    
    for i=1:4
%                         'Min',0.1,'Max',10,'Value',5,...
        sli(i)= uicontrol('Style', 'slider',...
                         'units','pixel',...
                         'parent',hgr,...
                         'Position', [10 10 10 10]*ppm,...
                         'String', [slidertext(i) 'Axis'],...
                         'Tag','wok',...
                         'Callback', sliderCallbacks{i});                 
%                         'Callback', {@surfxlim, h.ha( pos.wok )});                 

        slit(i)= uicontrol('Style', 'text',...
                         'units','pixel',...
                         'parent',hgr,...
                         'Position', [10 10 10 10]*ppm,...
                         'string',slidertext(i));                 
    end
    
%%%%%%%          Slider Init           %%%%%%%%%%%%%
%%%%%%%          Slider Init           %%%%%%%%%%%%%
    set(sli(1:2),'Min',0.2,'Max',5,'Value',1);
    set(sli(3:4),'Min',-0.5,'Max',0.5,'Value',0);
    
    
    set(pbres,'pos',[5 30 25 5]*ppm);
    align([htfnum pbres],'Horizontal','top')
    yp=get(pbres,'Position')/ppm;
    set(sli,'pos',[5 yp(2)-45-1 5.5 45]*ppm);
    align([sli],'fixed',0.8*ppm,'Ver%tical')
%     set(sli,'pos',[5 30 5.5 48]*ppm);
%     align([htfnum sli],'Horizontal','top')
%     align([sli],'fixed',0.8*ppm,'Ver%tical')
    
    ysl=get(sli(1),'Position')/ppm;
    set(slit,'pos',[ysl(1) ysl(2)-7 ysl(3) 5]*ppm);
    align([slit],'fixed',0.8*ppm,'Ver%tical')
    
    posui=[get(h.ha(pos.bodeMag),'Position') get(h.ha(pos.nyquist),'Position')]/ppm;
    set(hui,'position',[posui(1) posui(6) DimAxis(3:4)]*ppm)

    align([h.ha(pos.pzmap) h.ha(pos.bodeMag)],'Ver%tical','top')
    
    set(hgr,'Units','pixels','Position',[posui(1)+85 posui(6) 35 100]*ppm,...
            'BackgroundColor',[1 1 1]*0.55)

%%%%%%%%%%%%%%%%%%%%%%%  constructed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    RANGES=struct(      'rlocus',   [1 1 1 1],...
                        'pzmap',    [1 1 1 1],...
                        'nyquist',  [1 1 1 1],...
                        'bode',     [1 1 1 1],...
                        'step',     [1 1 1 1]);
    AXSET(1:5)=struct(  'sliderVal',[1 1 0 0],...
                        'ratios',   [1 1 1],...
                        'limOrig',  [0 0 0 0]);
 	SCALING=struct(     'wok',      AXSET(1),...
                        'pzmap',    AXSET(2),...
                        'nyquist',  AXSET(3),...
                        'bode',     AXSET(4),...
                        'step',     AXSET(5));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  Public masterhandler         %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    md=struct(          'auto',1,...
                        'hold',0,...
                        'num',[],...
                        'den',[],...
                        'zeros',[1],...
                        'poles',[1 1 1],...
                        'gain',[],...
                        'ranges', RANGES,...
                        'scaling', SCALING,...
                        'lineWidth',1,...
                        'parserError',1,...
                        'sweep',0,...
                        'markerSize',10);  
                
    md.num=tfN;
    md.den=tfD;
    md.num=[1 -3];
    md.den=[1 2 1];
    
    h.defColOrder = get(gcf,'DefaultAxesColorOrder');
    h.hgr = hgr;
    h.ub = ub;
    h.sli =sli;
    h.rb = rb;
    h.md = md;
%    h.ha = ha;
    h.htfden = htfden;
    h.htfnum = htfnum;
    h.hsweep = hsweep;
    
    h.htfroden = htfroden;
    h.htfronum = htfronum;
    
    h.P=nyquistoptions;
    h.P.ShowFullContour='off';
    h.md.sweepVal=[];
    
    % Save the structure
    guidata(f, h) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       str2num(axpos2{i})
%       newPlot(0,0);
%       hObject
%       tfeditbox_Callback{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  Callback für tf- Parser  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ret = tfeditbox_Callback(hObject, eventdata, h)
        h = guidata(f);
        callertag=get(hObject,'Tag');
        callerstr=get(hObject,'String');
        
        % -----------------------------------------------------
        % Parser
        % -----------------------------------------------------
        if strcmp(callertag, 'sweepVarEdit') %&& h.md.sweep ~= 0
            % -----------------------------------------------------
            % auf leere Eingabe prüfen
            % -----------------------------------------------------
            if isempty(callerstr) 
                disp(['input a sweep parameter in the form x=[1:2:10]'])
                set(h.htfnum, 'BackgroundColor','red');
                return
            end
            set(h.rb(1),'Value',1);
            h.md.sweep=1;
        end

        % -----------------------------------------------------
        % Sweep eingeschaltet
        % -----------------------------------------------------
        if  h.md.sweep==1
            sweepParam=symvar(callerstr);
            if length(sweepParam) > 1
                disp(['input a sweep parameter in the form x=[1:2:10]'])
                set(h.htfnum, 'BackgroundColor','red');
                return
            end
            sweepParam='a';
            
            search={'[';']'};
            sweepStr=get(h.hsweep,'String');
            
            for k=1:length(search)
                is(k,:)=strfind(sweepStr,search{k});
            end
            
            if length(is) ~= 2
                disp(['input a sweep parameter in the form x=[1:2:10]'])
                set(h.htfnum, 'BackgroundColor','red');
                return
            end
            
            h.md.sweepVal=eval(sweepStr(is(1):is(2)))
        else
            h.md.sweepVal=[1:1];
            sweepParam='_';
        end
        
%        guidata(f, h); !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%            h.md.swTop=sweepVal;

        for L=h.md.sweepVal
%            h = guidata(f);
            eventdata.swParam=sweepParam;
            h.md.swVal=L;
            
            guidata(f, h);
            rval=tfeditbox_parser(hObject, eventdata, h);
            if rval ~= 0
                set(h.htfnum, 'BackgroundColor','red');
                set(h.htfden, 'BackgroundColor','red');
            else
                refresh_Callback(hObject, eventdata, h);
                h = guidata(f);
            end
            
            if get(h.rb(1),'Value')==0
                return
            end
        end
        
        guidata(f, h); 
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  tf- Parser  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ret = tfeditbox_parser(hObject, eventdata, h)
        callertag=get(hObject,'Tag');
        callerstr=get(hObject,'String');
        h = guidata(f);
        h.md.parserError=1;     % Reset errorflag
        ret=ERR;

        % -----------------------------------------------------
        % auf leeres polynom prüfen
        % -----------------------------------------------------
        if isempty(callerstr) 
            disp(['Faktor 0 im ' callertag ' ist zu wenig!'])
            return;
        end
        syms s p;
        num = get(h.htfnum,'String');
        den = get(h.htfden,'String');

        % -----------------------------------------------------
        % sweep parameter durch aktuellen Wert ersetzen
        % -----------------------------------------------------
        if ~isempty(strfind(num,eventdata.swParam))
            num=subs(num, eventdata.swParam, h.md.swVal);
        end
        if ~isempty(strfind(den,eventdata.swParam))
            den=subs(den, eventdata.swParam, h.md.swVal);
        end
        % -----------------------------------------------------
        % andere symbols wie 's' oder 'p'?
        % -----------------------------------------------------
        nude={char(num); char(den)};
        search={'s';'p';'i';'j'};
        
        for k=1:length(search)
            is=strfind(nude,search{k});
            nude{1}([is{1,:}])=[];    
            nude{2}([is{2,:}])=[];    
        end
        
        if (isempty(isstrprop(nude{1},'alpha')) || isempty(isstrprop(nude{2},'alpha')) )
            disp('unknown non- numeric den')
            return;
        end
        
        % -----------------------------------------------------
        % Nullstellen und Pole berechnen
        % -----------------------------------------------------
        p=sym('p');
        s=sym('s');

        di={num,den};
        if isempty(symvar(di{1}))
            disp('no ')
        end
        
        solc=cellfun(@solve,di(:),'UniformOutput',false);
        if ~isempty(solc{1})
            solZ=eval(solc{1,1});
        else
            solZ=0;
        end
        if ~isempty(solc{2})
            solP=eval(solc{2,1});
        else
            disp('denominator order 0?')
            return
        end

        % -----------------------------------------------------
        % Koeffizienten von Zähler- und Nennerpolynom
        % -----------------------------------------------------
        solNum=1; solDen=1;
        if ~isempty(symvar(num))
            solNum=sym2poly(eval(num));
        end
        if ~isempty(symvar(den))
            solDen=sym2poly(eval(den));
        end
        if length(solNum) > length(solDen)
            disp('numerator has higher order')
            return
        end
        % -----------------------------------------------------
        % bleiben komplexe Koeffizienten übrig:
        % --> keine konjugiert komplexen pole vorhanen!
        % -----------------------------------------------------
        if ~isempty(find(imag(solNum))) || ~isempty(find(imag(solDen)))
            disp('complex transfer function, conjugate poles/zeros')
            return;
        end        

        % -----------------------------------------------------
        % Eingabe i.o.
        % -----------------------------------------------------
        h.md.parserError = 0;
        set(h.htfnum, 'BackgroundColor','white');
        set(h.htfden, 'BackgroundColor','white');
        h.md.num = solNum;
        h.md.den = solDen;
        h.md.zeros = solZ;
        h.md.poles = solP;
        
        % -----------------------------------------------------
        % Ausgabe der ausmultiplizierten tf  
        % -----------------------------------------------------
        spowN=s.^[length(h.md.num)-1:-1:0];
        spowD=s.^[length(h.md.den)-1:-1:0];

        set(h.htfronum, 'string',char(h.md.num*spowN.'));
        set(h.htfroden, 'string',char(h.md.den*spowD.'));

        guidata(f,h);
        
        ret=0;
        return
    end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  Plot  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function refresh_Callback(hObject, eventdata, h)
        h = guidata(f);
        
        sys=tf(h.md.num, h.md.den);
        [gPoles, gZeros]=pzmap(sys);

        DI=sys;

        %------------------------------------------------------------
        % zähler/nennergrade, rel. systemgrade, wurzelschwerpunkte,
        % asymptotenwinkel, xrange min/max  für alle G0's in 
        % vektoren schreiben
        %------------------------------------------------------------
        rang=@(x)[min(x) max(x)];

        nrel=length(gPoles) - length(gZeros);                   % rel. Grad
        dw=1/nrel*( sum(real(gPoles) )-( sum(real(gZeros)) ));  % Schwerpunkt
        asym=round( (2*[0:1:nrel-1]+1)*pi/nrel*180/pi);         % Asymptotenwinkel
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
        
        h.md.ranges.pzmap=[xRan*1.2, yRan*2.2];
        h.md.ranges.rlocus=h.md.ranges.pzmap;
        h.md.ranges.nyquist=h.md.ranges.pzmap;

%         phiMax=round(0.1*max(phase))*10;
%         phiMin=round(0.1*min(phase))*10;
%        wUp=wout(max(find(abs(phase)<abs(phiMin)/nrel)))
%        wDown=wout(max(find(abs(phase)<abs(2*phiMin)/nrel)))

%         h.md.ranges.bode=[min(wout) max(wout)*10];
%         h.md.ranges

        [re,im,w,~,~] = nyquist(DI);
        nyq(1,:)=squeeze(re);
        nyq(2,:)=squeeze(im);
        nyFact=1.4;
        h.md.ranges.nyquist=[ min(re)*nyFact max(re)*nyFact,...
                                    min(im)*nyFact max(im)]*nyFact;
        
%         r1=@(x) round(10*x)/10;
%         h.md.ranges.nyquist=r1(h.md.ranges.nyquist);
%         h.md.ranges.pzmap=r1(h.md.ranges.pzmap);
%         h.md.ranges.rlocus=r1(h.md.ranges.rlocus);
%         h.md.ranges.rlocus=r1(h.md.ranges.rlocus);

        if h.md.hold == 0
            delete(findall(h.ha,'type','line'));
        end
%        cla reset;

        %------------------------------------------------------------
        % alle subplots formatieren
        %------------------------------------------------------------
       
        if h.md.auto == 1  
            xx= @(x) line(get(gca,'xlim') ,[0 0], 'LineStyle','-','Color',[1 1 1]*0.5,'LineWidth',1);
            yy= @(x) line([0 0],get(gca,'ylim'), 'LineStyle','-','Color',[1 1 1]*0.5,'LineWidth',1);
            setRng=@(h,x) set(h, 'XLim',x(1,:),'YLim',x(2,:));
%            setRng=@(h,x) set(h, 'XLim',x(1,:));

            %zcross={'LineStyle','-.','Color',[1 1 1]*0.7,'LineWidth',0.2};
            set(h.ha([pos.wok, pos.nyquist, pos.pzmap]),'XLimMode','manual','YLimMode','manual');
            set(h.ha([pos.bodeMag, pos.bodePhase]),'XLimMode','manual','YLimMode','auto');
            set(h.ha([pos.step]),'XLimMode','auto','YLimMode','auto');
            set(h.ha([1, 3:end]),'Box','on','SelectionHighlight','on');

            axes(h.ha( 1 ));
            if h.md.hold == 0
                for i=1:length(h.ha)  %%% Reset color
                    hold off;
                    plot(h.ha(i),NaN,NaN);
                    hold all;
                end
                
                for i=1:6
                    set(h.ha(i),'Tag',na{i});
                end
                set(h.ha([1,5:6]),'ButtonDownFcn', @AxisClick_Callback);


            else
                axes(h.ha( pos.wok ));
                hold all;
            end
            
            RR=[h.md.ranges.rlocus([1,2]); h.md.ranges.rlocus([3,4])];
            setRng(h.ha( pos.wok ),RR); 
            axes(h.ha( pos.wok )); xx(0); yy(0);

            RR=[h.md.ranges.pzmap([1,2]); h.md.ranges.pzmap([3,4])];
            setRng(h.ha( pos.pzmap ),RR);
            axes(h.ha( pos.pzmap )); xx(0); yy(0);

            RR=[h.md.ranges.nyquist([1,2]); h.md.ranges.nyquist([3,4])];
            setRng(h.ha( pos.nyquist ),RR);
            axes(h.ha( pos.nyquist )); xx(0); yy(0);
            
        end
%tic        
        %------------------------------------------------------------
        % wok zeichnen
        %------------------------------------------------------------
        lightGray=[1 1 1]*0.6;

        rloc=rlocus(DI);
        [arms ~]=size(rloc);

        axes(h.ha( pos.wok ));
        hold all;
        grid on;
        
        %%%% Asymptoten
        for i=1:length(asym)
            lh(i,:)=line([dw 10],[0 0],'LineStyle','-.',...
            'Color',lightGray,'LineWidth',0.2);
            rotate(lh(i),[0 0 1],asym(i),[dw 0 0]);
        end
   
        for i=1:arms
            h.hpl(i,:)=plot(real(rloc(i,:)),imag(rloc(i,:)),'LineWidth',h.md.lineWidth);
        end
        
        h.hplMa=[];
        if h.md.zeros ~= 0
            h.hplMa(end+1)=plot(real(gZeros),imag(gZeros),'o','Color','black');
        end
        h.hplMa(end+1)=plot(real(gPoles),imag(gPoles),'X','Color','black');
        hold off;
        h.md.scaling.wok.limOrig= [ get(h.ha( pos.wok ),'XLim'),...
                                    get(h.ha( pos.wok ),'YLim') ];

        
%toc
        %------------------------------------------------------------
        % pz- map zeichnen
        %------------------------------------------------------------
        axes(h.ha( pos.pzmap ));
        hold on;
        if h.md.zeros ~= 0
            h.hplMa(end+1)=plot(real(gZeros),imag(gZeros),'o');
        end
        h.hplMa(end+1)=plot(real(gPoles),imag(gPoles),'X');
        grid on;
        hold off;

        set(h.hplMa,'MarkerSize',h.md.markerSize);
        h.md.scaling.pzmap.limOrig= [ get(h.ha( pos.pzmap ),'XLim'),...
                                      get(h.ha( pos.pzmap ),'YLim') ];
%toc
        %------------------------------------------------------------
        % Nyquistkurve zeichnen
        %------------------------------------------------------------
        axes(h.ha( pos.nyquist ));
        [Gm,Pm,Wgm,Wpm]=margin(DI); 

        %%%% margins
        lh(1,:)=line([0 10],[0 0],'LineStyle','-.',...
        'Color',lightGray,'LineWidth',h.md.lineWidth);
        rotate(lh(1),[0 0 1],(180+Pm),[0 0 0]);

        lh(2,:)=line([-1 (1-10^(Pm/10))],[0 0],'LineStyle','-.',...
        'Color',[1 1 1]*0.9,'LineWidth',h.md.lineWidth);

        hold all;
        h.hplNyq(5)=plot(nyq(1,:), nyq(2,:));
        hold off;
        grid on;
 
        h.md.scaling.nyquist.ratios=get(h.ha( pos.nyquist ),'DataAspectRatio');
        h.md.scaling.nyquist.limOrig= [ get(h.ha( pos.nyquist ),'XLim'),...
                                        get(h.ha( pos.nyquist ),'YLim') ];
        
%toc        
        %------------------------------------------------------------
        % Sprungantwort
        %------------------------------------------------------------
        axes(h.ha( pos.step ));
%        nyquist(DI,h.P)
        [ystep,tout]=step(DI);
        hold all;
        h.step=plot(tout,ystep);
        grid on;
        hold off
        h.md.scaling.step.limOrig= [ get(h.ha( pos.step ),'XLim'),...
                                        get(h.ha( pos.step),'YLim') ];
%toc
        %------------------------------------------------------------
        % Bode
        %------------------------------------------------------------
        win=logspace(-2,3,1000);
        [mag,phase,wout]=bode(DI,win);
        mag=squeeze(mag);
        phase=squeeze(phase);
        h.md.ranges.bode=[];
        axes(h.ha( pos.bodeMag ));
        
        hold all;
        h.hbode(1)=semilogx(h.ha( pos.bodeMag ),wout,20*log10(mag));
        hold off;
        xlim(h.ha(pos.bodeMag), [1e-2 1e3]);
        set(h.ha(pos.bodeMag),'XtickLabel',[],'YScale','linear','XScale','log');
        grid on;
        
        axes(h.ha( pos.bodePhase ));
        set(gca,'XLimMode','manual','XScale','log');
        hold all;
        h.hbode(2)=semilogx(h.ha( pos.bodePhase ),wout,phase);
        hold off;
        xlim(h.ha(pos.bodePhase), [1e-2 1e3]);
%        set(h.ha(pos.bodeMag),'X%tickLabel',[]);
        grid on;
%toc
        guidata(f,h);
        return
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  Axis click callback                     %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function AxisClick_Callback (hObj,event)
        h = guidata(f);
        caller=get(hObj,'Tag');
        st=get(h.ub,'String');
        ubInd=find(strcmp(st, caller));
% SEL=st{ find(cell2mat( get(ub,'value') )) };        
        eventdataTmp=struct(    'EventName', 'SelectionChanged',...
                                'OldValue',   get(h.hgr,'SelectedObject'),...
                                'NewValue',   h.ub(ubInd) );
        set(h.hgr,'SelectedObject',h.ub(ubInd));
        guidata(f,h)
        selcbk(h.hgr,eventdataTmp)
        
        
        
%         h = guidata(f);
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

        h = guidata(f);

        new=get(eventdata.NewValue,'String');
        old=get(eventdata.OldValue,'String');
        if isempty(old)
            old=new;
        end
        
        set(h.ha(pos.(old)),'Selected','Off'); 
        set(h.ha(pos.(new)),'Selected','On'); 

        % aktuelle sliderwerte in das struct der vorherigen auswahl
        % (wok, nyquist,...) speichern
        h.md.scaling.(old).sliderVal(1:4)=cell2mat(get(h.sli,'Value'));    

        if strcmp(new,'nyquist')
%            set(h.sli(1),'Min',1/3,'Max',3);
            set(h.sli(2),'Enable','off');
        else
%            set(h.sli,'Min',1/3,'Max',3);
            set(h.sli(2),'Enable','on');
        end

        set(h.sli(1),'Value',   h.md.scaling.(new).sliderVal(1),...
                     'Callback',{@surfxlim, h.ha( pos.(new) )},...
                     'Tag',new);
        set(h.sli(2),'Value',   h.md.scaling.(new).sliderVal(2),...
                     'Callback',{@surfylim, h.ha( pos.(new) )},...
                     'Tag',new);
        set(h.sli(3),'Value',   h.md.scaling.(new).sliderVal(3),...
                     'Callback',{@surfxoff, h.ha( pos.(new) )},...
                     'Tag',new);
        set(h.sli(4),'Value',   h.md.scaling.(new).sliderVal(4),...
                     'Callback',{@surfyoff, h.ha( pos.(new) )},...
                     'Tag',new);

        guidata(f,h);
    end

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  Callbacks für alle slider              %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function surfxlim(hObj,event,ax) 
        h=guidata(f);

        if strcmp(get(hObj,'Tag'),'nyquist')
%            set(h.ha( pos.nyquist ),'dataAspectRatio',...
%                                    h.md.scaling.nyquist.ratios);
% Für nyquist spezielle Offset- Faktoren aus original xlim/ylim ableiten
            if ~isempty(event)    
                slVal=get(h.sli(1),'Value');
            else
                slVal=get(hObj,'Value');
            end
            
            offFactX=diff(h.md.scaling.nyquist.limOrig(1:2));
            offFactY=diff(h.md.scaling.nyquist.limOrig(3:4));
            
            offX=h.md.scaling.(get(hObj,'Tag')).sliderVal(3);
            offY=h.md.scaling.(get(hObj,'Tag')).sliderVal(4);
                        
            xlim(ax,h.md.scaling.nyquist.limOrig(1:2) * slVal + [1 1]*offX*offFactX);
            ylim(ax,h.md.scaling.nyquist.limOrig(3:4) * slVal + [1 1]*offY*offFactY);
        else
%             val = 11 - get(hObj,'Value');
%             off=h.md.scaling.(get(hObj,'Tag')).sliderVal(3);
%             xlim(ax,[-val val]+[1 1]*off);
            if ~isempty(event)    
                slVal=get(h.sli(1),'Value');
            else
                slVal=get(hObj,'Value');
            end
            
            offFactX=diff(h.md.scaling.(get(hObj,'Tag')).limOrig(1:2));
            
            offX=h.md.scaling.(get(hObj,'Tag')).sliderVal(3);
                        
            xlim(ax,h.md.scaling.(get(hObj,'Tag')).limOrig(1:2) * slVal + [1 1]*offX*offFactX);
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function surfylim(hObj,event,ax) 
        h=guidata(f);

        if ~isempty(event)    
            slVal=get(h.sli(2),'Value');
        else
            slVal=get(hObj,'Value');
        end

        offFactY=diff(h.md.scaling.(get(hObj,'Tag')).limOrig(3:4));
        offY=h.md.scaling.(get(hObj,'Tag')).sliderVal(4);
        ylim(ax,h.md.scaling.(get(hObj,'Tag')).limOrig(3:4) * slVal + [1 1]*offY*offFactY);        

%         val = 11 - get(hObj,'Value');
%         off=h.md.scaling.(get(hObj,'Tag')).sliderVal(4);
%         ylim(ax,[-val val]+[1 1]*off);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function surfxoff(hObj,event,ax) 
        h=guidata(f);
        h.md.scaling.(get(hObj,'Tag')).sliderVal(3)=get(hObj,'Value');
        guidata(f,h);
        
        event.source='subcall';
        surfxlim(hObj,event,ax)
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function surfyoff(hObj,event,ax) 
        h=guidata(f);
        h.md.scaling.(get(hObj,'Tag')).sliderVal(4)=get(hObj,'Value');
        guidata(f,h);
        
        event.source='subcall';
        if strcmp(get(hObj,'Tag'),'nyquist')
            surfxlim(hObj,event,ax)
        else
            surfylim(hObj,event,ax)
        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  Callbacks für alle buttons             %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function button_Callback(hObject, eventdata, h)
        callerTag=get(hObject,'Tag');
        h = guidata(f);
        
        switch callerTag
            case 'Stop'
                h.md.swVal=max(h.md.sweepVal);
                set(h.rb(1),'Value',0);
                h.md.sweep=0;
            case 'Clear'
                delete(findall(h.ha,'type','line'));
            case 'Reset'
%                 eventdataTmp=struct(    'EventName', 'SelectionChanged',...
%                                         'OldValue',   get(h.hgr,'SelectedObject'),...
%                                         'NewValue',   h.ub(2) );
%                 set(h.hgr,'SelectedObject',h.ub(2));  
%                 guidata(f,h)
%                 selcbk(h.hgr,eventdataTmp)
%                 h = guidata(f);

                st=get(ub,'String');
                SEL=st{ find(cell2mat( get(ub,'value') )) };
                h.md.scaling.(SEL).sliderVal=[1 1 0 0];
                set(h.sli(1:2),'value',1);
                set(h.sli(3:4),'value',0);
                set(h.ha( pos.(SEL) ),  'XLim',h.md.scaling.(SEL).limOrig(1:2),...
                                        'YLim',h.md.scaling.(SEL).limOrig(3:4));
                ;
            otherwise
        end
        
        guidata(f,h) 
    end

    function DEBUG_button_Callback(hObject, eventdata, h)
        h = guidata(f);
        disp('-----------------------------------------')
        disp('wok: '), disp(h.md.scaling.wok) 
        disp('nyquist: '), disp(h.md.scaling.nyquist) 
        disp('step: '), disp(h.md.scaling.step) 
        disp('callback: '), disp(get(h.ha,'Tag'))
        disp('callback: '), disp(get(h.ha,'ButtonDownFcn'))
        disp('-----------------------------------------')
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Callback für radio buttons außerhalb uibuttongroup %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function radio_Callback(hObject, eventdata, handlers)
        val = get(hObject,'Value');
        callTag=get(hObject,'Tag');
        h = guidata(f);

        switch callTag
            case 'hold'    
                h.md.hold=val;
            case 'autosc'  
                h.md.auto=val;
                ;
            otherwise
                disp('unknown radiobutton tag!')
        end
%         if md.auto == 0
%             md.
        guidata(f,h) 
    end




end
%************************************************************************
%************************************************************************
%************************************************************************
%************************************************************************
%************************************************************************
%************************************************************************
%************************************************************************

% 
%     function markerin_Callback(hObject, eventdata, handlers)
%         str = get(hObject,'String');
%         h = guidata(f);
% 
%         h.md.markerSize=abs(str2num(str));
%         for i=1:4
%             set(h.hplMa(i,:),'MarkerSize',h.md.markerSize);
%         end
%         
%         guidata(f,h) 
%     end
% 




% 
% 
% 
% 
% %  Pop-up menu callback. Read the pop-up menu Value property
% %  to determine which item is currently displayed and make it
% %  the current data.
% %       function popup_menu_Callback(source,eventdata) 
% %          % Determine the selected data set.
% %          str = get(source, 'String');
% %          val = get(source,'Value');
% %          % Set current data to the selected data set.
% %          switch str{val};
% %          case 'Peaks' % User selects Peaks.
% %             CD = peaks_data;
% %          case 'Membrane' % User selects Membrane.
% %             CD = membrane_data;
% %          case 'Sinc' % User selects Sinc.
% %             CD = sinc_data;
% %              otherwise
% %                  ;
% %          end
% %       end
%   
%   
%   
% %    function zedit_Callback(hObject, eventdata, h)
% %         id=get(hObject,'Tag');
% %         idNr=str2num(id(4:end))
% % 
% %         %        g0=syms2tf(strtrm(ge)
% %         if isempty(ge)
% %             ns(idNr)=NaN;
% %         else
% %             ns(idNr)=get(hObject,'String');
% %         end
% %         newPlot(ns,pol,currPlant);
% %    end
% 
% 
% %     function [SOL, kp] = parsePoly(hfactPoly)
% %         a.string=@(x) get(x,'String');
% %         a.tag=@(x) get(x,'tag');
% %         s=sym('s');
% % 
% %         h = guidata(f);
% %    
% %         clear i;
% %         di=a.string(hfactPoly)';
% % 
% %         ind1=cellfun(@symvar,di,'UniformOutput',false);   % Test cell di including pole symbolic 
% %         ind2a=~cellfun(@isempty,ind1); % pole ohne symvar müssen bei sol extra behandelt werden
% %         ind2b=~cellfun(@isempty,di);
% % 
% % %        kp=cell2mat( di(~ind2a & ind2b) );
% %         kp=cell2mat( di(~ind2a & ind2b) );
% %         if isempty(kp)
% %             kp=1;
% %         else
% %             kp=str2num(kp);
% %         end
% %         
% %         solc=cellfun(@solve,di(ind2a),'UniformOutput',false);
% %         sold=cellfun(@eval,solc,'UniformOutput',false);
% %         sole=cell2mat(sold);
% %         cmpxInd=(arrayfun(@imag, sole));
% %         reInd=(~arrayfun(@imag, sole));
% %         try
% %             SOL=[cplxpair(sole(cmpxInd)) sort(sole(reInd))]; 
% %         catch err
% %             SOL=[];
% %             disp('Nicht alle pole/NS sind konjugiert komplex! --> Komplexwertiges Zeitsignal')
% %         end        
% %         
% %         h.stateStruct=md;
% %         guidata(f,h) 
% %     end
% 
% 
% 
% %     function radio_Callback(hObject, eventdata, h)
% %         val = get(hObject,'Value');
% %         callTag=get(hObject,'String');
% % 
% %         h = guidata(f);
% %         
% %         switch callTag
% %             case 'hold' 
% %                 h.md.hold=val;
% %             case 'Hold' 
% %                 h.md.hold=val;
% %             case 'autoscale'  
% %                 h.md.auto=val;
% %             case 'Autoscale'  
% %                 h.md.auto=val;
% %             otherwise
% %                 disp('unknown radiobutton tag!')
% %                 ;
% %         end
% % %         if h.md.auto == 0
% % %             h.md.
% %         guidata(f,h) 
% % 
% %     end
% 
% 
% %         
% %         
% %         %        if (strcmp(symvar(den),'s') & strcmp(symvar(num),'s'))
% %         ch1=(strcmp(symvar(den),'s') & strcmp(symvar(num),'s')) ;
% %         ch2=(strcmp(symvar(den),'s') );
% %          if ch2 
% %             di={sym(num); sym(den)};
% %             solc=cellfun(@solve,di(:),'UniformOutput',false);
% %             if isempty(solc{1})
% %                 solc{1}='1';
% %                 sold=cellfun(@eval,solc,'UniformOutput',false);
% %                 imInNum=[];
% %                 imInDen=find( imag(cell2mat(sold(2))) );
% %             else
% %                 sold=cellfun(@eval,solc,'UniformOutput',false);
% %                 imInNum=find( imag(cell2mat(sold(1))) );
% %                 imInDen=find( imag(cell2mat(sold(2))) );
% %             end
% % %            sole=cellfun(@imag, sold, 'UniformOutput',false);
% % %            reInd=~find(arrayfun(@imag, sole));
% %             SOL=[];
% %             clear i;
% %             try
% %                 if ~isempty(imInNum) | strcmp(symvar(num),'s')
% %                     cplxpair(sold{1}); 
% %                     h.md.num  = sym2poly(eval(num)); 
% %                     h.md.zeros = eval(solve(eval(num)==0,s)).';
% %                 else
% %                     h.md.num  = str2double(num);
% %                     h.md.zeros = [];
% %                 end
% %                 set(h.htfnum, 'BackgroundColor','white');
% %             catch err
% %                 SOL=1;
% %                 disp('Nicht alle pole/NS sind konjugiert komplex! --> Komplexwertiges Zeitsignal')
% %                 set(h.htfnum, 'BackgroundColor','red');
% %             end
% %             
% %             
% %             try
% %                 if ~isempty(imInDen)
% %                     cplxpair(sold{2});
% %                     h.md.den  = sym2poly(eval(den));
% %                     h.md.poles = eval(solve(eval(den)==0,s)).';
% %                 else
% %                     disp('Nennergrad: 0')
% %                     SOL=1;
% %                 end
% %                 set(h.htfden, 'BackgroundColor','white');
% %             catch err
% %                 SOL=1;
% %                 disp('Nicht alle pole/NS sind konjugiert komplex! --> Komplexwertiges Zeitsignal')
% %                 set(h.htfden, 'BackgroundColor','red');
% %             end
% %             
% %             if SOL~=0
% %                 return
% %             end
% %             
% %             spowN=s.^[length(h.md.num)-1:-1:0];
% %             spowD=s.^[length(h.md.den)-1:-1:0];
% %             
% %             set(h.htfronum, 'string',char(h.md.num*spowN.'));
% %             set(h.htfroden, 'string',char(h.md.den*spowD.'));
% % 
% %             guidata(f,h);
% %             
% %             refresh_Callback(hObject, eventdata, h);
% %             
% %             abc=[];
% %         end   
%
%     RANGES=struct( 'rlocus',    [1 1 1 1],...
%                     'pzmap',    [1 1 1 1],...
%                     'nyquist',  [1 1 1 1],...
%                     'bode',     [1 1 1 1],...
%                     'step',     [1 1 1 1]);
%     NYQUIST=struct( 'sliderVal',[1 1 0 0],...
%                     'ratios',   [1 1 1]);
%     SCALING=struct( 'wok',      [1 1 0 0],...
%                     'pzmap',    [1 1 0 0],...
%                     'nyquist',  NYQUIST,...
%                     'bode',     [1 1 0 0],...
%                     'step',     [1 1 0 0]);
%     md=struct(      'auto',1,...
%                     'hold',0,...
%                     'num',[],...
%                     'den',[],...
%                     'zeros',[1],...
%                     'poles',[1 1 1],...
%                     'gain',[],...
%                     'ranges', RANGES,...
%                     'scaling', SCALING,...
%                     'lineWidth',1,...
%                     'parserError',1,...
%                     'sweep',0,...
%                     'markerSize',10);