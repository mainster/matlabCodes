% Reglersynthese nach dem Frequenzkennlinienverfahren PDF
% REGELUNGSTECHNIK
% 
% ausgeführt am
% Fachhochschul-Studiengang
% Automatisierungstechnik für Berufstätige
%
% von Christian Krachler
% Graz

tic

wdZiel=2;
phiResZiel=45;

syms p;
GsSym=1/(p*(p+1)*(p/3+1));
% ... Bei eingangssignal rampe soll stationäre Regelabweichung
% eInf=1/20 gelten
% ... stationäres verhalten, Systemty i...

Kp=20;
G0a=sym2tf(Kp*GsSym);

MODE=0;

%____________________________________________________________________________________
if MODE==0
%____________________________________________________________________________________

%%%%%%%%%%%%%%%%%%%%
% figure 1
%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
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
hf1bod=bodeplot(G0a,win,bo);
hold off;

childH = get(f1, 'Children');
axes(childH(3));    % Magnitude
line([wdZiel wdZiel],[-150 100],'color','red','linestyle','--');
axes(childH(1));    % Phase
line([wdZiel wdZiel],[-270 50],'color','red','linestyle','--');

figure(f1);
hleg=legend(sub1,'G_{0 a}');
grid on;

set(findall(0,'type','text'),'FontSize',12,...
    'FontWeight','normal','FontName','Swiss 721');

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
[am(2) pm(2) wgm(2) wpm(2)]=margin(G0a);
cmpx(1)=exp(j*(60*pi/180-pi));   % Ziel- Phasenreserve mit Lead
cmpx(2)=exp(j*(pm(2)*pi/180-pi));

hold all;
nyquistplot(G0a,P);

plot(rv,sqrt(r-rv.^2),'--r');
plot(rv,-sqrt(r-rv.^2),'--r');
plot(real(cmpx),imag(cmpx),'o','MarkerSize',4,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
plot(real(cmpx(1)),imag(cmpx(1)),'o','MarkerSize',6,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
line([0 real(cmpx(1))],[0 imag(cmpx(1))],'color','red','linestyle','--')%,'LineWidth',3)
hold off;

axis([-1.5 0.5 -2 .5]*4);
hleg=legend(sub1,'G_{0 a}');
%set(hleg,'FontSize',11);

%set(findall(gcf,'tag','legend'),'FontSize',12,'FontWeight',...
%    'normal','FontAngle','normal','FontName','Swiss 721');

tfLen=length(G0a.den{1});
d=strsplit(int2str(G0a.den{1}));
ind=strcmp(d(:),'1');    % find ones
for k=1:length(ind)-1;
    if ind(k);
        d{k}=' ';
    end
end

set(findall(0,'type','text'),'fontsize',12,'fontname','Swiss 721');

h(1) = text('position',[-5 -5.5], ...
    'fontsize',14, 'interpreter','latex','BackgroundColor',[0.9 0.9 0.9],...
     'string',['$$ G_{0A}(s) = \frac{' int2str(G0a.num{1}(tfLen)) '}{' d{1} 's^3+' d{2} 's^2+' d{3} 's+' d{4} '}$$']);
h(2) = text('position',[-5 -7], ...
    'fontsize',14, 'interpreter','latex','BackgroundColor',[0.9 0.9 0.9],...
    'string',['$$ G_{0A}(s) = \frac{60}{ s \cdot \left( 0.33 ~ s + 1 \right) \cdot \left( s + 1 \right)} $$']);

MODE=1;
%____________________________________________________________________________________
end
%____________________________________________________________________________________

if MODE==1;
    
%%%%%%%%%%%%%%%%%%%%
% figure 2
%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
SUB=110;

%subplot(1,3,[1 2 3])
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

delete(findall(gcf,'type','line'));
for mh=2:18
    lead(mh)=sym2tf(subs(leadSym,{'wn','wp'},{1,mh}));
end

legStr=[];
hold all;

for mh=2:18
    hf2bod=bodeplot(lead(mh),win);
    legStr=[legStr sprintf('m_h=%f:',mh)];
end

grid on;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           mh=12;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FINDSTR = int2str(mh);

childH = get(f2, 'Children');
axes(childH(1));    % Phase
line([wdZiel wdZiel],[-270 50],'color','red','linestyle','--');
title(childH(1),'Lead- Glied');

set(hf2bod,'MagVisible','off');
axis(gca,[1e-1 1e2 0 65]);
set(childH(1),'YTick',[0:10:70]);
hleg=legend(strsplit(legStr,':'),'Location','NorthEastOutside');

hl=xlabel(['$$ \frac{ \omega }{ \omega_n } $$'],...
    'interpreter','latex','fontweight','bold','fontsize',14);
set(hl,'Position',[700 -10]);

h(2) = text('position',[25 35], 'BackgroundColor',[0.9 0.9 0.9],...
    'interpreter','latex','fontweight','bold','fontsize',14,'string',...
    ['$$ G_{lead}(s) = \frac{1 + \omega / \omega_{n} }{ 1 +\omega / \omega_{p}  }$$']);

%set(findall(gcf,'type','text'),'FontSize',12,'FontWeight','normal','FontName','Swiss 721');

%%%%%%%%%%%%%%%%%%%%
% figure 3
%%%%%%%%%%%%%%%%%%%%
f3=figure(3);
SUB=110;

subplot(SUB+1)


wn=wdZiel/sqrt(mh);
wp=wn*mh;

Kp=20;
lead12=sym2tf(subs(leadSym,{'wn','wp'},{wn,wp}));

G0a=sym2tf(Kp*1/(p*(p+1)*(p/3+1)));

win=logspace(-2,2,200);
sub1=subplot(2,2,[1 3]);

hold all;
hf3boda=bodeplot(G0a);
hf3bodb=bodeplot(G0a*lead12,win);
hold off;

childH = get(f3, 'Children');
axes(childH(3));    % Magnitude
line([wdZiel wdZiel],[-150 100],'color','red','linestyle','--');
axes(childH(1));    % Phase
line([wdZiel wdZiel],[-270 50],'color','red','linestyle','--');

hleg=legend('G_{0 a}','G_{0 a}*lead_{12}');
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
[am(3) pm(3) wgm(3) wpm(3)]=margin(G0a*lead12);
cmpx(3)=exp(j*(pm(3)*pi/180-pi));

hold all;
nyquistplot(G0a,P);
nyquistplot(G0a*lead12,P);

plot(rv,sqrt(r-rv.^2),'--r');
plot(rv,-sqrt(r-rv.^2),'--r');
plot(real(cmpx),imag(cmpx),'o','MarkerSize',4,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
plot(real(cmpx(1)),imag(cmpx(1)),'o','MarkerSize',6,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
line([0 real(cmpx(1))],[0 imag(cmpx(1))],'color','red','linestyle','--')%,'LineWidth',3)
hold off;

axis([-1.5 0.5 -2 .5]*4);
hleg=legend(sub1,'G_{0 a}','G_{0 a}*lead_{12}','Location','SouthWest');

set(findall(gcf,'type','text'),'fontsize',12,'fontname','Swiss 721');



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
% Ermittlung des Frequenzverhältnisses ms aus nachstehender Funktion:
%
% 20*log10(ms)=22dB -> ms=10^22/20 = 12.6
% Mit j = -6° und m_s = 12,6 erhält man aus nachstehendem
% Phasendiagramm ein Verhältnis w/wp = 125


%%%%%%%%%%%%%%%%%%%%
% figure 4
%%%%%%%%%%%%%%%%%%%%
f4=figure(4);
SUB=110;

subplot(SUB+1)
% leadSym=Kl*(1+T*p)/(1+a*T*p));
% wn=1/T;       % obere Eckfrequenz
% wp=1/(a*T);   % untere Eckfrequenz, a > 1
% mh=wp/wn;      % Verhältniss der Von oberer zu unterer Eckfrequenz
syms wn wp;

lagSym=(1+p/wp)/(1+p/wn);
%-------------------------------------------
% phiLag(wp) mit m_s als Parameter Plotten
%-------------------------------------------

win=logspace(-1,2,50);

delete(findall(gcf,'type','line'));
for ms=2:15
    lag(ms)=sym2tf(subs(lagSym,{'wn','wp'},{1,ms}));
end

legStr=[];
hold all;

for ms=2:15
    hf4bod=bodeplot(lag(ms),win);
    legStr=[legStr sprintf('m_s=%f:',ms)];
end

grid on;
hold off;

childH4 = get(f4, 'Children');
axes(childH4(1));    % Phase
line([wdZiel wdZiel],[-270 50],'color','red','linestyle','--');
title(childH4(1),'Lead- Glied');

set(hf4bod,'MagVisible','off');
axis(gca,[1e-1 1e2 -65 0]);
set(childH4(1),'YTick',[-70:10:0]);
hleg=legend(strsplit(legStr,':'),'Location','NorthEastOutside');

hl=xlabel(['$$ \frac{ \omega }{ \omega_p } $$'],...
    'interpreter','latex','fontweight','bold','fontsize',14);
set(hl,'Position',[700 -10]);

h(2) = text('position',[25 -40], 'BackgroundColor',[0.9 0.9 0.9],...
    'interpreter','latex','fontweight','bold','fontsize',14,'string',...
    ['$$ G_{lag}(s) = \frac{1 + \omega / \omega_{p} }{ 1 +\omega / \omega_{n}  }$$']);

set(findall(gcf,'type','text'),'FontSize',12,'FontWeight','normal','FontName','Swiss 721');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           ms=12.6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    w/wp=125;  Aus Diagramm

% Untere Eckfrequenz
wp=wdZiel/125
% Obere Eckfrequenz
wn=wp*ms/125

%%%%%%%%%%%%%%%%%%%%
% figure 5
%%%%%%%%%%%%%%%%%%%%
f5=figure(5);
SUB=110;

subplot(SUB+1)

lag13=sym2tf(subs(lagSym,{'wn','wp'},{wn,wp}));
G0a=sym2tf(Kp*1/(p*(p+1)*(p/3+1)));

win=logspace(-2,2,200);
sub1=subplot(2,2,[1 3]);

hold all;
hbod=bodeplot(G0a);
hbod2=bodeplot(G0a*lead12,win);
hbod3=bodeplot(G0a*lead12*lag13,win);
hold off;

childH = get(f5, 'Children');
axes(childH(3));    % Magnitude
line([wdZiel wdZiel],[-150 100],'color','red','linestyle','--');
axes(childH(1));    % Phase
line([wdZiel wdZiel],[-270 50],'color','red','linestyle','--');

%hleg=legend('G_{0 a}','G_{0 a}*lead_{12}','G_{0 a}*lead_{12}*lag_{13}');
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

%____________________________________________________________________________________
end
%____________________________________________________________________________________


%-------------
% Margins 
%-------------
[am(4) pm(4) wgm(4) wpm(4)]=margin(G0a*lead12*lag13);
cmpx(4)=exp(j*(pm(4)*pi/180-pi));

hold all;
nyquistplot(G0a,P);
nyquistplot(G0a*lead12,P);
nyquistplot(G0a*lead12*lag13,P);

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
hleg=legend('G_{0 a}','G_{0 a}*lead_{12}','G_{0 a}*lead_{12}*lag_{13}',...
    'Location','SouthWest');
hlegla=legend(  '$$ G_{p}(s) \cdot K_p $$',...
                '$$ G_{p}(s) \cdot K_p \cdot G_{lead}(s)$$',...
                '$$ G_{p}(s) \cdot K_p \cdot G_{lead}(s) \cdot G_{lag}(s)$$',...
                'Location','SouthWest');
set(findall(gcf,'type','text'),'fontsize',12,'fontname','Swiss 721');
set(hlegla,'interpreter','latex','Fontsize',14,'FontWeight','bold');





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

toc

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





return;




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





