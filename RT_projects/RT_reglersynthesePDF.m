% Reglersynthese nach dem Frequenzkennlinienverfahren PDF
% REGELUNGSTECHNIK
% 
% ausgeführt am
% Fachhochschul-Studiengang
% Automatisierungstechnik für Berufstätige
%
% von Christian Krachler
% Graz
%
%------------------------------------
% clear all; close all;
% tic; reglersynthesePDF; toc
% Elapsed time is 21.395058 seconds.
% -----------------------------------
% tic; reglersynthesePDF; toc
% Elapsed time is 18.380687 seconds.
% -----------------------------------

% -----------------------------------
% alles auf manuelle grenzen gestellt
% ------------------------------------

% -----------------------------------
% clear all; close all; 
% tic; reglersynthesePDF; toc;
% Elapsed time is 15.968318 seconds.!!!
% -----------------------------------
%
% -----------------------------------

tic;

wdZiel=2;
phiResZiel=45;

syms p;
GsSym=1/(p*(p+1)*(p/3+1));
% ... Bei eingangssignal rampe soll stationäre Regelabweichung
% eInf=1/20 gelten
% ... stationäres verhalten, Systemty i...

Kp=20;
GsKp=sym2tf(Kp*GsSym);

MODE=0;

clear am pm cmpx;
%____________________________________________________________________________________
if MODE==0
%____________________________________________________________________________________

%%%%%%%%%%%%%%%%%%%%
% figure 1
%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
delete(findall(f1,'type','line'))
SUB=220;

win=logspace(-2,2,200);
sub1=subplot(2,2,[1 3]);

bo=bodeoptions;
% bo.ConfidenceRegionNumberSD=3.9;
% bo.PhaseMatching='on';
% bo.PhaseMatchingFreq=0.25;

%-------------
% Bod
%-------------
hold all;
hf1bod=bodeplot(GsKp,win,bo);
hf1bod=bodeplot(feedback(GsKp,1),win,bo);
hold off;

childH = get(f1, 'Children');
axes(childH(3));    % Magnitude
line([wdZiel wdZiel],[-150 100],'color','red','linestyle','--');
axes(childH(1));    % Phase
line([wdZiel wdZiel],[-270 50],'color','red','linestyle','--');

figure(f1);
hleg=legend(sub1,'$$ G_{P} \cdot K_{P} $$');
set(hleg,'interpreter','latex','FontSize',12);
grid on;

%set(findall(0,'type','text'),'FontSize',12,...
%    'FontWeight','normal','FontName','Swiss 721');

%-------------
% nyquist
%-------------
%sub1=subplot(SUB+1);
sub1=subplot(2,2,[2 4]);

P=nyquistoptions;
P.ShowFullContour='off';

r=1;              % radius
rv=[-r:0.005:r];    % absciss vektor

%-------------
% Margins 
%-------------
[am(2) pm(2) wgm(2) wpm(2)]=margin(GsKp);
cmpx(1)=exp(j*(60*pi/180-pi));   % Ziel- Phasenreserve mit Lead
cmpx(2)=exp(j*(pm(2)*pi/180-pi));

hold all;
nyquistplot(GsKp,P);

plot(rv,sqrt(r-rv.^2),'--r');
plot(rv,-sqrt(r-rv.^2),'--r');
plot(real(cmpx),imag(cmpx),'o','MarkerSize',4,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
plot(real(cmpx(1)),imag(cmpx(1)),'o','MarkerSize',6,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
line([0 real(cmpx(1))],[0 imag(cmpx(1))],'color','red','linestyle','--')%,'LineWidth',3)
hold off;

axis([-1.5 0.5 -2 .5]*4);
hleg=legend(sub1,'$$ G_{P} \cdot K_{P} $$');
set(hleg,'interpreter','latex','FontSize',12);
%set(hleg,'FontSize',11);

%set(findall(gcf,'tag','legend'),'FontSize',12,'FontWeight',...
%    'normal','FontAngle','normal','FontName','Swiss 721');

tfLen=length(GsKp.den{1});
d=strsplit(int2str(GsKp.den{1}));
ind=strcmp(d(:),'1');    % find ones
for k=1:length(ind)-1;
    if ind(k);
        d{k}=' ';
    end
end

%set(findall(0,'type','text'),'fontsize',12,'fontname','Swiss 721');

h(1) = text('position',[-5 -5.5], ...
    'fontsize',14,'fontName','Swiss 721','interpreter','latex','BackgroundColor',[0.9 0.9 0.9],...
     'string',['$$ G_{P}(s) = \frac{' int2str(GsKp.num{1}(tfLen)) '}{' d{1} 's^3+' d{2} 's^2+' d{3} 's+' d{4} '}$$']);
h(2) = text('position',[-5 -7], ...
    'fontsize',14, 'interpreter','latex','BackgroundColor',[0.9 0.9 0.9],...
    'string',['$$ G_{P}(s) = \frac{60}{ s \cdot \left( 0.33 ~ s + 1 \right) \cdot \left( s + 1 \right)} $$']);

MODE=1;
%____________________________________________________________________________________
end
%____________________________________________________________________________________

if MODE==1;
    
%%%%%%%%%%%%%%%%%%%%
% figure 2
%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
delete(findall(f2,'type','line'))

SUB=110;

%-------------
% Bode 
%-------------
%subplot(1,3,[1 2])
subplot(SUB+1)
% leadSym=Kl*(1+T*p)/(1+a*T*p));
% wn=1/T;       % untere Eckfrequenz
% wp=1/(a*T);   % obere Eckfrequenz
% mh=wp/wn;      % Verhältniss der Von oberer zu unterer Eckfrequenz
syms wn wp;

leadSym=(1+p/wn)/(1+p/wp);
%-------------------------------------------
% phiLead(wn) mit mh als Parameter Plotten
%-------------------------------------------

win=logspace(-1,2,50);

clear lead mh;
for mh=1:18        
% mh=wp/wn = 1/alpha
% Weil der phasenverlauf für unterschiedlichen mh als parameter
% geplottet werden sollen, wird w auf untere Eckfrequenz wn normiert, 
% also der Phasenverlauf als funktion von w/wn mit mh als parameter.
    wn=1;
    wp=mh*wn;   % also wp=mh für diesen parameterplott
% als Gain nicht 1 sonder mh angeben weil laut formel leadSyms nicht 
% direkt die Pole parametriert werden sondern die laplacevariable
% Durchmultiplizieren mit mh=wp/wn... und der Gain von lead(mh) ist immer 1
    lead(mh)=zpk([-wn],[-wp],[mh],'DisplayFormat','frequency');

    %    lead(mh)=sym2tf(subs(leadSym,{'wn','wp'},{1,mh}));
end
% wn ist bei Lead Glied die UNTERE Eckfrequenz weil beim lead die
% Nullstelle vor dem Pol erreicht wird, bezogen auf die w- Achse

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mh=12;     % aus parameterplot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Daraus können wn und wp für entsprechendes lead glied für wdZiel
% berechnet werden.
wn=wdZiel/sqrt(mh);     % !!!!!!!!!
wp=wn*mh;
%
wn=0.1*round(wn*10);
wp=0.1*round(wp*10);
lead12=zpk([-wn],[-wp],[12],'DisplayFormat','frequency');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FINDSTR = int2str(mh);

clear wn wp mh;

win=logspace(-1,2,50);
MH_RANGE=[1:18];
phimax=ones(1,MH_RANGE(end))*NaN;

legStr=[];
hold all;
for mh=MH_RANGE
    hf2bod=bodeplot(lead(mh),win);
    [~,phimax(mh)]=bode(lead(mh),sqrt(mh));
    legStr=[legStr sprintf('m_h=%.0f:',mh)];
    drawnow
end

resp=get(get(hf2bod,'Responses'));
for mh=MH_RANGE
    currCol=resp( mh-abs(diff([MH_RANGE(end),length(MH_RANGE)])) ).Style.Colors{:};

    line([sqrt(mh*1) sqrt(mh*1) ],[-1 phimax(mh)],'Color',currCol,...
        'LineStyle','--','Tag',sprintf('sqrt(wn*wp)[mh=%.0f]',mh));
    plot(sqrt(mh*1),phimax(mh),'Marker','o','MarkerSize',5,'MarkerEdgeColor',...
        currCol,'MarkerFaceColor',currCol);    
end

grid on;
hold off;

clear wn wp mh;

%-------------
% nyquist
%-------------
% subplot(1,3,3)
% 
% P=nyquistoptions;
% P.ShowFullContour='off';
% 
% hold all;
% for ms=2:15
%    nyquist(lead(mh),P);
%    drawnow;
% end
% hold off;


childH = get(f2, 'Children');
axes(childH(1));    % Phase
title(childH(1),'Lead- Glied','FontWeight','bold','FontSize',16);

set(hf2bod,'MagVisible','off');
%axis(gca,[1e-1 1e2 0 65]);
ylim(gca,[0 65]);
set(childH(1),'YTick',[0:10:70]);
hleg=legend(strsplit(legStr,':'),'Location','NorthEastOutside');

hl=xlabel(['$$ \frac{ \omega }{ \omega_n } $$'],...
    'interpreter','latex','fontweight','bold','fontsize',12);
set(hl,'Position',[700 -10]);

h2(2) = text('position',[25 35], 'BackgroundColor',[0.9 0.9 0.9],...
    'interpreter','latex','fontweight','bold','fontsize',14,'string',...
    ['$$ G_{LEAD}(s) = \frac{1 + \omega / \omega_{n} }{ 1 +\omega / \omega_{P}  }$$']);

%set(findall(gcf,'type','text'),'FontSize',12,'FontWeight','normal','FontName','Swiss 721');


%%%%%%%%%%%%%%%%%%%%
% figure 3
%%%%%%%%%%%%%%%%%%%%
f3=figure(3);
SUB=110;

subplot(SUB+1);

GsKp=sym2tf(Kp*1/(p*(p+1)*(p/3+1)));

win=logspace(-2,2,200);
sub1=subplot(2,2,[1 3]);

hold all;
hf3boda=bodeplot(GsKp);
hf3bodb=bodeplot(GsKp*lead12,win);
hold off;

childH = get(f3, 'Children');
axes(childH(3));    % Magnitude
line([wdZiel wdZiel],[-150 100],'color','red','linestyle','--');
axes(childH(1));    % Phase
line([wdZiel wdZiel],[-270 50],'color','red','linestyle','--');

hleg=legend('$$ G_{P} \cdot K_{P}','G_{P} \cdot K_{P} \cdot lead_{12} $$');
set(hleg,'interpreter','latex','FontSize',12);

grid on;

% set(findall(gcf,'tag','legend'),'FontSize',12,'FontWeight',...
%     'normal','FontAngle','normal','FontName','Swiss 721');

%-------------
% nyquist
%-------------
%sub1=subplot(SUB+1);
sub1=subplot(2,2,[2 4]);

P=nyquistoptions;
P.ShowFullContour='off';

r=1;              % radius
rv=[-r:0.005:r];    % absciss vektor

%-------------
% Margins 
%-------------
[am(3) pm(3) wgm(3) wpm(3)]=margin(GsKp*lead12);
cmpx(3)=exp(j*(pm(3)*pi/180-pi));

hold all;
nyquistplot(GsKp,P);
nyquistplot(GsKp*lead12,P);

plot(rv,sqrt(r-rv.^2),'--r');
plot(rv,-sqrt(r-rv.^2),'--r');
plot(real(cmpx),imag(cmpx),'o','MarkerSize',4,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
plot(real(cmpx(1)),imag(cmpx(1)),'o','MarkerSize',6,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
line([0 real(cmpx(1))],[0 imag(cmpx(1))],'color','red','linestyle','--')%,'LineWidth',3)
hold off;

axis([-1.5 0.5 -2 .5]*4);
hlegBB=legend(sub1,'$$ G_{P} \cdot K_{P} $$','$$ G_{P} \cdot K_{P} \cdot lead_{12} $$',...
    'Location','SouthWest');
set(hlegBB,'interpreter','latex','FontSize',12);

%set(findall(gcf,'type','text'),'fontsize',12,'fontname','Swiss 721');

%
% Lösung – Teil 3: 
% Erweiterung des offenen Regelkreises um phasenabsenkendes Glied
%
% Für viele Fälle ist es wichtig, die Bandbreite klein und die stationäre Regelabweichung gering zu
% halten bzw. die Amplitude bei hohen Frequenzen abzusenken. Hierfür ist es erforderlich,
% phasenabsenkende Übertragungsglieder in den Regelkreis zu integrieren.
% Um eine Betragssenkung zu erhalten, erweitert man den offenen Regelkreis um ein
% phasenabsenkendes Übertragungsglied, so dass eine gewünschte Betragssenkung bezogen auf die
% Übertragungsfunktion der Strecke von 11 dB bei w = wDZiel = 2 erreicht wird.
% Durch das hinzugekommene phasenanhebende Übertragungsglied hat sich unbeabsichtigterweise
% auch die Betragskennlinie GO2(s) geändert. Es muss daher im nächsten Schritt die Betragskennlinie
% für w = wDZiel nicht um 11 dB sondern um 22 dB abgesenkt werden.
%

%%%%%%%%%%%%%%%%%%%%
% figure 4
%%%%%%%%%%%%%%%%%%%%
f4=figure(4);
SUB=110;

% leadSym=Kl*(1+T*p)/(1+a*T*p));
% wn=1/T;       % obere Eckfrequenz
% wp=1/(a*T);   % untere Eckfrequenz, a > 1
% mh=wp/wn;      % Verhältniss der Von oberer zu unterer Eckfrequenz
syms wn wp;

lagSym=(1+p/wp)/(1+p/wn);
%-------------------------------------------
% phiLag(wp) mit m_s als Parameter Plotten
%-------------------------------------------

win=logspace(-1,3,50);

delete(findall(gcf,'type','line'));

clear lag ms;
for ms=1:15        
% ms=wn/wp = 1/alpha
% Weil der phasenverlauf für unterschiedlichen ms als parameter
% geplottet werden sollen, wird w auf die untere Eckfrequenz wp normiert,  
% also der Phasenverlauf als funktion von w/wp mit ms als parameter.
    wp=1;
    wn=ms*wp;   % also wn=ms für diesen parameterplott
% als Gain nicht 1 sonder 1/ms angeben weil laut formel lagSyms nicht 
% direkt die Pole parametriert werden sondern die laplacevariable
% Durchmultiplizieren mit 1/ms=wp/wn... und der Gain von lag(ms) ist immer 1
    lag(ms)=zpk([-wn],[-wp],[1/ms],'DisplayFormat','frequency');

    %    lead(mh)=sym2tf(subs(leadSym,{'wn','wp'},{1,mh}));
end
% wp ist bei Lag Glied die UNTERE Eckfrequenz weil beim lag der Pol vor der
% Nullstelle erreicht wird, bezogen auf die w- Achse

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ermittlung des Frequenzverhältnisses ms aus nachstehender Funktion:
%
% 20*log10(ms)=22dB -> ms=10^22/20 = 12.6
% Mit phi = -6° und m_s = 12,6 erhält man aus nachstehendem
% Phasendiagramm ein Verhältnis w/wp = 125
    ms=12.6;    
    phiLagRes=-6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    w/wp=125;  Aus Diagramm
% Daraus können wn und wp für entsprechendes lag glied für wdZiel
% berechnet werden.
%
% Untere Eckfrequenz
wp=wdZiel/125;
% Obere Eckfrequenz
wn=wp*ms;
%
lag13=zpk([-wn],[-wp],[1/ms],'DisplayFormat','frequency');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

legStr=[];

%-------------
% Bode
%-------------
subplot(SUB+1)

hold all;
for ms=1:15
    hf4bod=bodeplot(lag(ms),win);
    legStr=[legStr sprintf('m_s=%f:',ms)];
    drawnow;
end

grid on;
hold off;

childH4 = get(f4, 'Children');
axes(childH4(1));    % Phase
title(childH4(1),'Lag- Glied','FontWeight','bold','FontSize',14);
line([1e-1 1e2],[phiLagRes phiLagRes],'color','red','linestyle','--');
line([125 125],[phiLagRes -70],'color','red','linestyle','--','LineWidth',2);

set(hf4bod,'MagVisible','off');
%axis(gca,[1e-1 1e2 -65 0]);
set(childH4(1),'YTick',[-70:10:0]);
hleg=legend(strsplit(legStr,':'),'Location','NorthEastOutside');

hl=xlabel(['$$ \frac{ \omega }{ \omega_p } $$'],...
    'interpreter','latex','fontweight','bold','fontsize',12);
%set(hl,'Position',[700 -10]);

h(2) = text('position',[25 -40], 'BackgroundColor',[0.9 0.9 0.9],...
    'interpreter','latex','fontweight','bold','fontsize',14,'string',...
    ['$$ G_{LAG}(s) = \frac{1 + \omega / \omega_{P} }{ 1 +\omega / \omega_{n}  } $$']);

%set(findall(gcf,'type','text'),'FontSize',12,...
%    'FontWeight','normal','FontName','Swiss 721');

%-------------
% nyquist
%-------------
% subplot(1,3,3)
% 
% P=nyquistoptions;
% P.ShowFullContour='off';
% 
% hold all;
% for ms=2:15
%    nyquist(lag(ms),P);
%    drawnow;
% end
% hold off;

%%%%%%%%%%%%%%%%%%%%
% figure 5
%%%%%%%%%%%%%%%%%%%%
f5=figure(5);
SUB=110;

subplot(SUB+1)

temp=zpk([-0.2 -0.6],[0 -0.016 -1 -3 -7.2],[20]);

GsKp=sym2tf(Kp*1/(p*(p+1)*(p/3+1)));

win=logspace(-3,2,100);
sub1=subplot(2,2,[1 3]);

hold all;
hbod=bodeplot(GsKp,win);
hbod2=bodeplot(GsKp*lead12,win);
hbod3=bodeplot(GsKp*lead12*lag13,win);
%hbod=bodeplot(lead12,win);
%hbod=bodeplot(lag13),win;
%hbod=bodeplot(temp),win;
hold off;

childH = get(f5, 'Children');
axes(childH(3));    % Magnitude
line([wdZiel wdZiel],[-100 50],'color','red','linestyle','--');
axes(childH(1));    % Phase
line([wdZiel wdZiel],[-270 -90],'color','red','linestyle','--');
grid on;

% hlegBod=legend( '$$ G_{P}(s) \cdot K_P $$',...
%                 '$$ G_{P}(s) \cdot K_P \cdot G_{LEAD}(s)$$',...
%                 '$$ G_{P}(s) \cdot K_P \cdot G_{LEAD}(s) \cdot G_{LAG}(s)$$',...
%                 'Location','NorthEast');

%                '$$ G_{LEAD}(s) $$',...
%                '$$ G_{LAG}(s) $$',...
%                '$$ Temp(s) $$',...


% set(findall(gcf,'tag','legend'),'FontSize',12,'FontWeight',...
%     'normal','FontAngle','normal','FontName','Swiss 721');

%-------------
% nyquist
%-------------
%sub1=subplot(SUB+1);
sub1=subplot(2,2,[2 4]);

P=nyquistoptions;
P.ShowFullContour='off';

r=1;              % radius
rv=[-r:0.005:r];    % absciss vektor

%____________________________________________________________________________________
end
%____________________________________________________________________________________

%-------------
% Margins 
%-------------
[am(4) pm(4) wgm(4) wpm(4)]=margin(GsKp*lead12*lag13);
cmpx(4)=exp(j*(pm(4)*pi/180-pi));

hold all;
nyquistplot(GsKp,P);
nyquistplot(GsKp*lead12,P);
nyquistplot(GsKp*lead12*lag13,P);
%nyquistplot(temp,P);

figure(f5);

plot(rv,sqrt(r-rv.^2),'--r');
plot(rv,-sqrt(r-rv.^2),'--r');
plot(real(cmpx),imag(cmpx),'o','MarkerSize',4,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
plot(real(cmpx(1)),imag(cmpx(1)),'o','MarkerSize',6,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
line([0 real(cmpx(1))],[0 imag(cmpx(1))],'color','red','linestyle','--')%,'LineWidth',3)
hold off;

axis([-1.5 0.5 -2 .5]*4);
hlegNy=legend(  '$$ G_{P}(s) \cdot K_P $$',...
                '$$ G_{P}(s) \cdot K_P \cdot G_{LEAD}(s)$$',...
                '$$ G_{P}(s) \cdot K_P \cdot G_{LEAD}(s) \cdot G_{LAG}(s) $$',...
                'Location','SouthWest');
 %               '$$ Temp(s)$$',...

%set(findall(gcf,'type','text'),'fontsize',12,'fontname','Swiss 721');

set(hlegNy,'interpreter','latex','Fontsize',12,'FontWeight','bold');
%set(hlegBod,'interpreter','latex','Fontsize',12,'FontWeight','bold','fontname','Helvetica');


return

%%%%%%%%%%%%%%%%%%%%
% figure 6
%%%%%%%%%%%%%%%%%%%%
f6=figure(6);
SUB=110;


subplot(SUB+1)

win=logspace(-4,2,100);

hold all;
hbod=bodeplot(GsKp,win);
hbod2=bodeplot(GsKp*lead12,win);
hbod3=bodeplot(GsKp*lead12*lag13,win);
hbod=bodeplot(lead12,win);
hbod=bodeplot(lag13),win;
hbod=bodeplot(temp),win;

hold off;

childH = get(f6, 'Children');
axes(childH(3));    % Magnitude
%line([wdZiel wdZiel],[-150 100],'color','red','linestyle','--');
%axes(childH(1));    % Phase
%line([wdZiel wdZiel],[-270 50],'color','red','linestyle','--');
grid on;

hlegBod=legend( '$$ G_{P}(s) \cdot K_P $$',...
                '$$ G_{P}(s) \cdot K_P \cdot G_{LEAD}(s)$$',...
                '$$ G_{P}(s) \cdot K_P \cdot G_{LEAD}(s) \cdot G_{LAG}(s)$$',...
                '$$ G_{LEAD}(s) $$',...
                '$$ G_{LAG}(s) $$',...
                '$$ Temp(s) $$',...
                'Location','NorthEastOutside');

set(hlegBod,'interpreter','latex');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%   Durchsuche Figure- Handles  nach childs mit bestimmtem namen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figChilds=[get(f2,'Children') ; get(f4,'Children')];

inc=strfind(get(figChilds(:),'type'),'axes');        % indexiere Childes vom type 'axes'
ind=find(~cellfun(@isempty,inc));            % take all children handles of all axes handle into structure

axisChilds=get(figChilds(ind),'Children')';

for i=1:length(axisChilds)
    sprintf('Child %.f (DisplayName)',i);
    get(axisChilds{i},'DisplayName');
    % objekt suchen und indexieren
    inc=strfind(get(axisChilds{i},'DisplayName'),  FINDSTR);
    if ~isempty(find(~cellfun(@isempty,inc))')
        indDispName{i,1}=find(~cellfun(@isempty,inc));
    end
end

for i=1:length(axisChilds)
    sprintf('Child %.f (Tag)',i);
    get(axisChilds{i},'Tag');
    % objekt suchen und indexieren
    inc=strfind(get(axisChilds{i},'Tag'),  FINDSTR);
    if ~isempty(find(~cellfun(@isempty,inc))')
        indTag{i,1}=find(~cellfun(@isempty,inc));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indDispName=indDispName';
indTag=indTag';

% SEL=2;   % Zugriff auf 1. handle der 2. axes (suchstring in 'DisplayName')
% get(axisChilds{SEL}(indDispName{SEL}),'DisplayName')
% SEL=3;   % Zugriff auf 1. handle der 3. axes
% get(axisChilds{SEL}(indDispName{SEL}),'DisplayName')
% SEL=1;   % Zugriff auf 1. handle der 1. axes (suchstring in 'Tag')
% get(axisChilds{SEL}(indTag{SEL}),'Tag')
% SEL=2;
% set(get(axisChilds{SEL}(indDispName{SEL}),'Children'),'LineWidth',5)

SEL=2;
set(get(axisChilds{SEL}(indDispName{SEL}),'Children'),'LineWidth',5)
set(get(axisChilds{SEL}(indDispName{SEL}),'Children'),'Color',[1 0 0])

SEL=5;
set(get(axisChilds{SEL}(indDispName{SEL}),'Children'),'LineWidth',5)
set(get(axisChilds{SEL}(indDispName{SEL}),'Children'),'Color',[1 0 0])


ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');


toc;
return
%%%%%%%%%%% Postprocess Strings %%%%%%%%%%% 
htext=findall(0,'type','text');
hlegend=findall(0,'tag','legend');
hlatex1=htext   ( find(~cellfun(@isempty,strfind(get(htext,'String'),'$$') )) );
%hlatex2=hlegend ( find(~cellfun(@isempty,strfind(get(hlegend,'String'),'$$') )) );
htex=htext( find(cellfun(@isempty,strfind(get(htext,'String'),'$$') )) )

set(hlatex1,'interpreter','latex');
%set(htex,'interpreter','tex');


toc;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Create MessageBox
%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('tbox1')
    if ishghandle(tbox1);
        delete(findall(tbox1,'type','text'));
    end
end

tbox1=subplot(SUB+2);
set(tbox1,'Visible','off','DefaultTextFontName','Serif');

%------------------
% Textbox defines
%------------------
cs=1/130;
lf=1/5;
tab=1.3;

pos=ones(2,1/lf+1)';
pos(:,1)=0;

for i=2:1/lf+1
    pos(i,2)=pos(i-1,2)-lf;
end

t1=text(pos(1,1),pos(1,2),['\Omega_{d_{Ziel}}= ' sprintf('%.0f',wdZiel)],...
    'FontSize',10,'BackgroundColor',[.7 .9 .7]);
t1=text(tab*length(get(t1,'String'))*cs,pos(1,2),['\phi_{R_{Ziel}}= ',...
    sprintf('%.0f',phiResZiel)],'FontSize',10,'BackgroundColor',[.7 .9 .7]);
t1=text(pos(1,1),pos(2,2),...
   ['\phi_{R_{Ziel}}= ' sprintf('%.0f',phiResZiel)],'FontSize',10);






%  x = 0:0.1:2*pi;
%  hold on
%  axis([0 2*pi -1 1]);
%  h = zeros(1, 5);
%  colors =colormap(hsv(5)); ;
%  for k = 1:5
%  h(k) = plot(x, sin(k*x), 'Color', colors(k, :), ...
%  'DisplayName', sprintf('x-vs-sin(%d*x)', k));
%  end
%  legend(h) 



%set(findall(h(1),'type','text'),'FontSize',12,'FontWeight',...
%    'normal','FontAngle','normal','FontName','Helvetica');

% 
% div=strfind(gstr,'/');
% ps=strfind(gstr,'p');
% mult=strfind(gstr,'*');
% lh=strfind(gstr,'(');
% rh=strfind(gstr,')');
% 
% indVec=ones(1,length(gstr));
% indVec([div ps mult lh rh])=0
% 
% gstrBak=gstr;
% texS=struct([]);
% 
% for k=1:length(indVec);
%     if indVec(k);
%         texS{k}=gstr(k);
%     end
% end
% 
% for k=1:length(mult)
%     texS{mult(k)}='\cdot ';
% end
% for k=1:length(div)
%     texS{div(k)}='\frac';
% end
% for k=1:length(lh)
%     texS{lh(k)}='{';
% end
% for k=1:length(rh)
%     texS{rh(k)}='}';
% end
% for k=1:length(ps)
%     texS{ps(k)}='s';
% end
% 
% texS
% strcat(texS{:})
% 
% text('position',[-3 -6], ...
% 'fontsize',18, 'interpreter','latex', 'string',...
% ['$${1} \over {s \cdot {s \over 3+1}\cdot{s+1}} $$']);
% 
% return
% h(1) = text('position',[-5 -3], ...
%     'fontsize',14, 'interpreter','latex', 'string',...
%     ['$$\hbox {magic(3) is } \left( {\matrix{ 8 & 1 & 6 \cr'...
%     '3 & 5 & 7 \cr 4 & 9 & 2 } } \right)$$']);



% str=[]
% for i=1:10
%     str=[str sprintf('no-%.f:',i)];
% end
% strs=strsplit(str,':');
% legend(strs)
% 
% inc=strfind(get(axisChilds(:),'DisplayName'),'-2')
% ind=find(~cellfun(@isempty,inc))


% f2lin=findall(f2,'type','line');
% par=get(f2lin(:),'Parent');
% k=1;
% indc=struct([]);
% for i=1:length(par);
%     if ~strcmp(get(par{i},'Tag'),'');
%         pTagH(k)=par(i);
%         indc{k}=strfind(get(pTagH{k},'Tag'),int2str(12));
%         get(pTagH{k},'Tag');
%         k=k+1;
%     end
% end
% 
% ind=find(~cellfun(@isempty,indc));
% get(get(pTagH{ind},'Parent'))

%pTagsC=struct2cell(pTags);
%ind=find(~cellfun(@isempty,pTags))
% bode([1],[1 1]);
% set(gcf,'HandleVisibility','on'); 
% h1=get(gca,'Children'); 
% h2=get(h1(1),'Children'); 
% set(h2,'LineWidth', 5);

% rn=get(bod.Responses,'Name')
% indC=strfind(rn,int2str(mh));
% ind=find(~cellfun(@isempty,indC))
% set(bod.Responses(ind).Style,'LineWidth',2)
% 
% bodR=get(bod,'Responses');
% bodRnam=get(bodR,'Name');
% 
% indCell=strfind(bodRnam,int2str(mh));
% ind=find(~cellfun(@isempty,x))
%  
% bodStyles=get(bodR,'Style');
% set(bodStyles{ind},'LineWidth',5);
% 
% set(bod,'Responses',bodR)
%%%%





