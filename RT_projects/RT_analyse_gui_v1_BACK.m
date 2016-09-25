function simple_gui2
% SIMPLE_GUI2 Select a data set from the pop-up menu, then
% click one of the plot-type push buttons. Clicking the button
% plots the selected data in the axes.

% Monitor 24"=60.96cm
% 16:9
% Breite:   53cm
% Höhe:     37cm
%
ppc=1920/((60.96/sqrt(16^2+9^2))*16);


%DimFigure=[3,3,45,24]*ppc;
deltaVert=-12;
%DimFigure=[3,6,45+deltaVert,16]*ppc;
%DimFigure=[8.8, 11.6, 33.7, 16]*ppc;
DimFigure=[4.8 5.7 42 23];
WX=DimFigure(3);
WY=DimFigure(4);
%DimAxis=[1,1,8,7];
DimAxis=[1.5, 1.5 , 12, 10];
hiaxis=DimAxis(end);
wiaxis=DimAxis(end-1);

DimButton=[ 40+deltaVert, 4, 3, 1.4];
hspace=0.4;
vspace=0.4;


DimPoleEdit=[45+deltaVert-6*(2.2+0.25*vspace/ppc), 8, 2.2, 0.9];

for i=1:5
    editsv(i,:)=DimPoleEdit+[(i-1)*(DimPoleEdit(end-1)+vspace),0, 0, 0];
end
%editsv(6,[3 4])=editsv(6,[3 4])/1.6;

editsh=editsv;
editsh(:,2)=editsh(:,2)+ones(length(editsh),1)*0.5*(DimPoleEdit(end-1)'+hspace);

editsv(6,:)=DimPoleEdit;
editsv(6,2)=editsv(6,2)-4;

editsv(7,:)=DimPoleEdit;
editsv(7,3)=editsv(7,3)*1.2;
editsv(7,2)=editsv(7,2)-4;
editsv(7,1)=editsv(7,1)+3;


buts(1,:)=DimButton;
buts(2,:)=DimButton+[0, DimButton(end)+vspace, 0,  0];

for i=1:5
    posax(i,:)=DimAxis;
end
% posax(2,1)=posax(2,1)+wiaxis+2*vspace;
% posax(3,2)=posax(3,2)+hiaxis+2*hspace;
% posax(4,1)=posax(4,1)+wiaxis+2*vspace;
% posax(4,2)=posax(4,2)+hiaxis+2*hspace;
% posax(5,1)=posax(5,1)+2*(wiaxis+2*vspace);
% posax(5,2)=posax(5,2)+hiaxis+2*hspace;

markSize=7;
hpl=[];
hplMa=[];

% pol=char(zeros(1,10));
% ns=char(zeros(1,10));
pol=[];
ns=[];

str=@(x) get(x,'String');
getWrap=@(x,y) get(x,y);
mm2pix=@(x) (x*72/25.4)

P=nyquistoptions;
P.ShowFullContour='off';

RANGES=struct( 'rlocus',    [1 1 1 1],...
                'pzmap',    [1 1 1 1],...
                'nyquist',  [1 1 1 1],...
                'step',     [1 1 1 1]);

md=struct(  'auto',1,...
            'hold',0,...
            'num',[],...
            'den',[],...
            'zeros',[],...
            'poles',[],...
            'gain',[],...
            'ranges', RANGES,...
            'lineWidth',1,...
            'markerSize',10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Only for development purposes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evalin('base',['RANGES=struct( ''rlocus'',    [1 1 1 1],''pzmap'',    [1 1 1 1],''nyquist'',  [1 1 1 1],''step'',     [1 1 1 1]);']);
evalin('base',['md=struct(  ''auto'',1,''hold'',0,''num'',[],''den'',[],''zeros'',[],''poles'',[],''gain'',[],''ranges'', RANGES,''lineWidth'', 1,''markerSize'',10);']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    currPlant=zpk([2],[-2 -1-j -1+j],1);        
    [tfN tfD]=zp2tf([2],[-2 -1-j -1+j],1);
    initsym=tf2sym(tf(tfN,tfD));
    
    md.num=tfN;
    md.den=tfD;
    md.num=[1 -3];
    md.den=[1 2 1];

    
% ns= currPlant.z{:};
% pol=currPlant.p{:};
    Initstr={'s-2';'s^3+4*s^2+6*s+4'};
    Initstr={'s-2';'s^2+2*s+1'};
    Initstr={'s-2';'s+5*s^2+3*s^3+s^4-10'};
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%      Constructed and the main GUI 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    pos=struct('wok',1,'pzmap',2,'bode',3,'nyquist',4,'step',5)

f = figure('Visible','on','Position',DimFigure*ppc);
    set(f,'Units','Centimeters');
%  Construct the components.


    hbut(1)=uicontrol(  'Style','pushbutton','String','plot',...
                        'Position',buts(1,:)*ppc,...
                        'Callback',{@buttonZPK_Callback});

    hbut(2)=uicontrol(  'Style','pushbutton','String','do what',...
                        'Position',buts(2,:),...
                        'Callback',{@doWhat_Callback});

    for i=1:5
        hpoedit(i)=uicontrol('Style','edit',...
                        'String','',...
                        'Tag',sprintf('po#%i',i),...
                        'Position',editsv(i,:)*ppc,...
                        'Callback',{@pzedit_Callback}); 

        hzoedit(i)=uicontrol('Style','edit',...
                        'String','',...
                        'Tag',sprintf('zo#%i',i),...
                        'Position',editsh(i,:)*ppc,...
                        'Callback',{@pzedit_Callback}); 
    end

    hpoedit(i+1)=uicontrol('Style','edit',...
                        'String','markersize',...
                        'Position',editsv(6,:)*ppc,...
                        'Callback',{@markerin_Callback}); 


    hauto = uicontrol( 'Style', 'radiobutton', ...
                        'Callback', {@radio_Callback},...
                        'Units',    'pixels', ...
                        'Position',  editsv(7,:)*ppc, ...
                        'String',   'Autoscale', ...
                        'Tag',      'autosc',...
                        'Value',    1);

    hhold = uicontrol( 'Style', 'radiobutton', ...
                        'Callback', {@radio_Callback},...
                        'Units',    'pixels', ...
                        'Position',  (editsv(7,:)+[0 1 0 0])*ppc, ...
                        'String',   'Hold', ...
                        'Tag',      'hold',...
                        'Value',    0);
                    
    boxposden=[45+deltaVert-6*(1.6+vspace/ppc), 12, 9.1, 1.1]
    boxposnum=[45+deltaVert-6*(1.6+vspace/ppc), 13, 9.1, 1.1]

    htfnum = uicontrol('Style','edit',...
                        'String', Initstr{1},...
                        'Tag','numerator',...
                        'Units', 'pixel',...
                        'Position',boxposnum*ppc,...
                        'Callback',{@tfeditbox_Callback}); 

    htfden = uicontrol('Style','edit',...
                        'String',Initstr{2},...
                        'Tag','denominator',...
                        'Units', 'pixel',...
                        'Position',boxposden*ppc,...
                        'Callback',{@tfeditbox_Callback}); 


    ha(3) = axes('Units','Pixels','Position',posax(1,:)*ppc); 
    ha(4) = axes('Units','Pixels','Position',posax(2,:)*ppc); 
    ha(1) = axes('Units','Pixels','Position',posax(3,:)*ppc); 
    ha(2) = axes('Units','Pixels','Position',posax(4,:)*ppc); 
    ha(5) = axes('Units','Pixels','Position',posax(5,:)*ppc); 
%--------------------------------------------------------------------------------------
    set(ha,'Position',DimAxis*ppc)
    align([ha([pos.wok pos.pzmap pos.bode])], 'Fixed',mm2pix(10),'HorizontalAlignment')
    align([ha([pos.nyquist pos.step])], 'Fixed',mm2pix(10),'HorizontalAlignment')
%--------------------------------------------------------------------------------------
    align([ha([pos.step pos.bode  ])],'Bottom','Fixed',mm2pix(10))
    align([ha([pos.nyquist pos.pzmap ])],'Bottom','Fixed',mm2pix(10))
    align([ha([pos.nyquist pos.wok ])],'Bottom','Fixed',mm2pix(10))
%--------------------------------------------------------------------------------------
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    newPlot(md.num,md.den);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  Callback für den tf- Parser  %%%%%%%%%%%%%%%%%%%%%%%%
    
    function tfeditbox_Callback(hObject, eventdata, handles)
        callertag=get(hObject,'Tag');
        callerstr=get(hObject,'String');
        p=sym('p');
        s=sym('s');
   tic     
        switch callertag
            case 'numerator'
                disp('caller: Num')
                if isempty(symvar(callerstr)) % kein sym gefunden?
                    md.num=eval(callerstr);
                else
                    md.num=(sym2poly(eval(callerstr)));
                end
                
                den=get(htfden,'String');
                test=strcmp(symvar(den),'s')
                
                if length(test)==1 && test==1
                    den=get(htfden,'String');
                    md.den=(sym2poly(eval(den)));
                    toc
                    newPlot(md.num, md.den);
                    toc
                else
                    disp('Bad expression in den')
                end       

            case 'denominator'
                disp('caller: Den')
                if isempty(symvar(callerstr))
                    md.den=eval(callerstr);
                else
                    md.den=(sym2poly(eval(callerstr)));
                end
                
                num=get(htfnum,'String');
                test=strcmp(symvar(num),'s')

                if length(test)==1 && test==1
                    num=get(htfnum,'String')
                    md.num=(sym2poly(eval(num)))
                    newPlot(md.num, md.den);
                else
                    disp('Bad expression in num')
                end       

                ;
            otherwise
                disp('caller unknown')
        end
        toc
        
%        md.zeros=eval(solve(poly2sym(md.num)==0))
%        md.poles=eval(solve(poly2sym(md.den)==0))
        md.zeros=(solve(poly2sym(md.num)==0))
        md.poles=(solve(poly2sym(md.den)==0))
        lfz=(s*[ones(length(md.zeros),1)]-md.zeros)
        lfp=(s*[ones(length(md.poles),1)]-md.poles)
        
        for i=1:5
            set(hzoedit(i),'String','')
            set(hpoedit(i),'String','')
        end
        for i=1:length(md.zeros)
            charve=char(lfp(i,:));
            set(hzoedit(5-(i-1)),'String',charve(~isspace(charve)))
        end
        for i=1:length(md.poles)
            charve=char(lfp(i,:));
            set(hpoedit(5-(i-1)),'String',charve(~isspace(charve)))
        end
toc
    end

   %  Pop-up menu callback. Read the pop-up menu Value property
   %  to determine which item is currently displayed and make it
   %  the current data.
      function popup_menu_Callback(source,eventdata) 
         % Determine the selected data set.
         str = get(source, 'String');
         val = get(source,'Value');
         % Set current data to the selected data set.
         switch str{val};
         case 'Peaks' % User selects Peaks.
            CD = peaks_data;
         case 'Membrane' % User selects Membrane.
            CD = membrane_data;
         case 'Sinc' % User selects Sinc.
            CD = sinc_data;
         end
      end
  
  
  
    function zedit_Callback(hObject, eventdata, handles)
        id=get(hObject,'Tag');
        idNr=str2double(id(4:end))

%         %        g0=syms2tf(strtrm(ge)
%         if isempty(ge)
%             ns(idNr)=NaN;
%         else
%             ns(idNr)=get(hObject,'String');
%         end
%         newPlot(ns,pol,currPlant);
        
    end


    function buttonZPK_Callback(hObject, eventdata, handles)
        
        [polyZ kz] = parsePoly(hzoedit(1:5));
        [polyP kp] = parsePoly(hpoedit(1:5));
        
        md.zeros=[polyZ];
        md.poles=[polyP];
        md.gain=kz/kp;
        
        newPlot(md.num, md.den);
        
        md.zeros
        md.poles
        md
%        save('uiout','di','sold','sole');
    end


    function [SOL kp] = parsePoly(hfactPoly)
        a.string=@(x) get(x,'String');
        a.tag=@(x) get(x,'tag');
        s=sym('s');

       
        clear i;
        di=a.string(hfactPoly)';

        ind1=cellfun(@symvar,di,'UniformOutput',false);   % Test cell di including pole symbolic 
        ind2a=~cellfun(@isempty,ind1); % pole ohne symvar müssen bei sol extra behandelt werden
        ind2b=~cellfun(@isempty,di);

%        kp=cell2mat( di(~ind2a & ind2b) );
        kp=cell2mat( di(~ind2a & ind2b) );
        if isempty(kp)
            kp=1;
        else
            kp=str2num(kp);
        end
        
        solc=cellfun(@solve,di(ind2a),'UniformOutput',false);
        sold=cellfun(@eval,solc,'UniformOutput',false);
        sole=cell2mat(sold);
        cmpxInd=find(arrayfun(@imag, sole));
        reInd=find(~arrayfun(@imag, sole));
        try
            SOL=[cplxpair(sole(cmpxInd)) sort(sole(reInd))]; 
        catch err
            SOL=[];
            disp('Nicht alle pole/NS sind konjugiert komplex! --> Komplexwertiges Zeitsignal')
        end        
        
        
    end


    function markerin_Callback(hObject, eventdata, handles)
        str = get(hObject,'String');

        md.markerSize=abs(str2num(str));
        for i=1:4
            set(hplMa(i,:),'MarkerSize',md.markerSize);
        end
    end


    function radio_Callback(hObject, eventdata, handles)
        val = get(hObject,'Value');
        callTag=get(hObject,'Tag');

        switch callTag
            case 'hold'    
                md.hold=val;
            case 'autosc'  
                md.auto=val;
                ;
            otherwise
                disp('unknown radiobutton tag!')
        end
%         if md.auto == 0
%             md.
    end





    function newPlot(zerosv,polesv)
         lo=[];
         lu=[];
        
        zerosv(find(isnan(zerosv)))=[];
        polesv(find(isnan(polesv)))=[];

        sys=tf(zerosv, polesv);
        [gPoles, gZeros]=pzmap(sys);

        DI=sys;

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % zähler/nennergrade, rel. systemgrade, wurzelschwerpunkte,
        % asymptotenwinkel, xrange min/max  für alle G0's in 
        % vektoren schreiben
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Ntf=1;
        
        for i=1:Ntf
            m(i)=length(gZeros);
            n(i)=length(gPoles);
            nrel(i)=n(i)-m(i);
            tmp=1/nrel(i)*( sum(real(gPoles) )-( sum(real(gZeros)) ));
%            dw(i)=eval(sym(1)*tmp);
            dw(i)=tmp
            asym{i}=round( (2*[0:1:nrel(i)-1]+1)*pi/nrel(i)*180/pi);
            lo=min(min(min(real(gPoles),dw(i))) , min(min(real(gZeros),dw(i))) );
            up=max(max(max(real(gPoles),dw(i))) , max(max(real(gZeros),dw(i))) );

            xRan(i,:)=[lo up];
            up=max(max(imag(gPoles)),max(imag(gZeros)));
            if up==0
                up=0.5*sum(abs(xRan(i,:)));
            end
            yRan=[-up up];
        end
        
        
        md.ranges.pzmap=[xRan(1,:)*1.2, yRan*2.2];
        md.ranges.rlocus=md.ranges.pzmap;
        
        [re,im,w,~,~] = nyquist(DI);
        nyq(1,:)=squeeze(re);
        nyq(2,:)=squeeze(im);

%         if min(re) >= 0; min(re)=-0.1*max(re);   end;
%         if max(re) <= 0; max(re)=-0.1*min(re);   end;
        
        md.ranges.nyquist=[min(re) max(re) min(im) max(im)]*1.2;
        
%         r1=@(x) round(10*x)/10;
%         md.ranges.nyquist=r1(md.ranges.nyquist);
%         md.ranges.pzmap=r1(md.ranges.pzmap);
%         md.ranges.rlocus=r1(md.ranges.rlocus);
%         md.ranges.rlocus=r1(md.ranges.rlocus);

        if md.hold == 0
            delete(findall(ha,'type','line'));
        end
%        cla reset;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % alle subplots formatieren
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if md.auto == 1  
            xx= @(x) line(get(gca,'xlim') ,[0 0], 'LineStyle','-','Color',[1 1 1]*0.5,'LineWidth',1);
            yy= @(x) line([0 0],get(gca,'ylim'), 'LineStyle','-','Color',[1 1 1]*0.5,'LineWidth',1);
            setRng=@(h,x) set(h, 'XLim',x(1,:),'YLim',x(2,:));
%            setRng=@(h,x) set(h, 'XLim',x(1,:));

            %zcross={'LineStyle','-.','Color',[1 1 1]*0.7,'LineWidth',0.2};
            set(ha,'XLimMode','manual','YLimMode','manual');

            if md.hold == 0
                for i=1:length(ha)  %%% Reset color
                    axes(ha(i));
                    hold off;
                    plot(0);
                    hold all;
                end
            else
                axes(ha(i));
                hold all;
            end

            
            RR=[md.ranges.rlocus([1,2]); md.ranges.rlocus([3,4])];
            setRng(ha(1),RR); 
            RR=[md.ranges.pzmap([1,2]); md.ranges.pzmap([3,4])];
            setRng(ha(2),RR);
            RR=[md.ranges.nyquist([1,2]); md.ranges.nyquist([3,4])];
            setRng(ha(3),RR);

            for i=1:length(ha)-1
                axes(ha(i)); xx(0); yy(0);
            end
%             
%             for i=1:length(ha)-1
%                 hold(ha(i),'all');
%             end
            
%
%             
%             set(ha(2),  'XLim',md.ranges.pzmap([1,2]),...
%                         'YLim',md.ranges.pzmap([3,4]));
%             set(ha(3),  'XLim',md.ranges.nyquist([1,2]),...
%                         'YLim',md.ranges.nyquist([3,4]));

                    
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % wok zeichnen
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        lightGray=[1 1 1]*0.6;

        rloc=rlocus(DI);
        [arms ~]=size(rloc);

        axes(ha(1))
        hold all;
        grid on;
        
        %%%% Asymptoten
        for i=1:length(asym{1})
            lh(i,:)=line([dw(1) 10],[0 0],'LineStyle','-.',...
            'Color',lightGray,'LineWidth',0.2);
            rotate(lh(i),[0 0 1],asym{1}(i),[dw(1) 0 0]);
        end
   
        for i=1:arms
            hpl(i,:)=plot(real(rloc(i,:)),imag(rloc(i,:)),'LineWidth',md.lineWidth);
        end
        
        hplMa(1,:)=plot(real(gZeros),imag(gZeros),'o','Color','black');
        hplMa(2,:)=plot(real(gPoles),imag(gPoles),'X','Color','black');
        hold off;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % pz- map zeichnen
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        axes(ha(2));
        hold on;
        hplMa(3,:)=plot(real(gZeros),imag(gZeros),'o');
        hplMa(4,:)=plot(real(gPoles),imag(gPoles),'X');
        grid on;
        hold off;

        for i=1:4
            set(hplMa(i,:),'MarkerSize',md.markerSize);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Nyquistkurve zeichnen
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        axes(ha(3))
        [Gm,Pm,Wgm,Wpm]=margin(DI); 

        %%%% margins
        lh(1,:)=line([0 10],[0 0],'LineStyle','-.',...
        'Color',lightGray,'LineWidth',md.lineWidth);
        rotate(lh(1),[0 0 1],(180+Pm),[0 0 0]);

        lh(2,:)=line([-1 (1-10^(Pm/10))],[0 0],'LineStyle','-.',...
        'Color',[1 1 1]*0.9,'LineWidth',md.lineWidth);

        hold all;
        hplMa(5,:)=plot(nyq(1,:), nyq(2,:));
        hold off;
        grid on;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % nyquistplot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        axes(ha(4))
        hold on
        nyquist(DI,P)

        hold off

%        k=findall(gca,'type','text')
%        for i=1:length(k); get(k(i),'String'), end;


        hold off;
        
        for i=1:4
            axes(ha(i)); 
            ishold(gca)
        end
    end

 
end 
% % 
% % %        c1=zpk(zeros,polesv,1);
% %         P1=zpk(gZeros, gPoles, 1);
% %  %       DI=c1*P1;
% %         DI=P1;
% % 
% %         for i=1:5
% %            set(hpoedit(i),'String','')   
% %         end
% %         for i=1:5
% %            set(hzoedit(i),'String','')   
% %         end
% %         
% %         for i=1:length(DI.p{1})
% %            set(hpoedit(i),'String',num2str(DI.p{1}(i)))   
% %         end   
% %         for i=1:length(DI.z{1})
% %            set(hzoedit(i),'String',num2str(DI.z{1}(i)))   
% %         end  
% %         md