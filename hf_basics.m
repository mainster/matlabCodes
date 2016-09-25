%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% @!@MDB
%%% HF Grundlagen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'));
clf;

smithdata = 0.1+j*[1:1000]*0.001;
% f66 = figure(66);
% does not produce the expected result because the Smith® Chart is drawn on
% the normal Cartesian coordinate system. However, you can use the z2gamma
% function to perform a bilinear transform on the vector first
smithdata_trans = z2gamma(smithdata,1);
% hold all;
smithchart(smithdata);  
set(gca,'NextPlot','add');
smithchart(smithdata_trans);  
grid on;

return
%% ---------------------------------------
%   Impedanz, Addmitanz, Reaktanz
%  ---------------------------------------
syms Rp Rs C w;
assume([Rp Rs C w],'real'); 

%fprintf('%s\n%s\n%s\n%s\n',ds,ds,ds,ds)
fprintf(repmat('\n',1,10))

% Äquivalente Ersatzschaltung von Reaktanz- Netzwerken
% Zs: Serienimpedanz RC- Glied
% Zp: äquivalente Parallelimpedanz, Cp=Cs=C

% Die thermischen Verluste der Spule können in einem begrenzten
% Frequenzbereich entweder durch einen Parallel- oder einen
% Serienwiderstand (R p  oder R s ) beschrieben werden. Mit den
% Möglichkeiten einer Parallel-Seriell-Wandlung sollte eine Wandlung vom
% einen in das andere Ersatzschaltbild  problemlos  möglich  sein.  Diese
% Wandlung  soll  nun  durchgeführt  werden. Allerdings  werde
% vorausgesetzt,  dass  der  Parallelwiderstand  groß  gegen  den
% induktiven Widerstand  der  Spule  sei.  Diese  Voraussetzung  ist
% insofern  sinnvoll,  als  bei  Nichterfüllung man kaum von einem
% Bauelement Spule reden dürfte.  Der Eingangswiderstand der
% Parallelschaltung berechnet sich zu

Zs=Rs+1/(w*C*1j);
Zp=Rp/(1+1j*w*C*Rp);
Yp=1/Zp;
fprintf('Zs=%s\nZp=%s\nYs=%s\n',char(Zs),char(Zp),char(Yp))
fprintf('%s\nZs:',ds); pretty(real(Zs)+j*imag(Zs)); 
fprintf('%s\nZp:',ds); pretty(real(Zp)+j*imag(Zp)); 
fprintf('%s\nYp:',ds); pretty(real(Yp)+j*imag(Yp)); 

%%
% Schwingkreis parallel
syms R C L w;
assume([R L C w],'real'); 

Z=ol.par3(1j*w*L, R, 1/(1j*w*C));
fprintf('%s\nZ:',ds); pretty(real(Z)+j*imag(Z)); 

reSelf=((w^2*L^2*R)/(R^2*(1-2*w^2*L*C+w^4*L^2*C^2+w^2*L^2)));
pretty(reSelf)

simplify(real(Z)-reSelf)

%%
% Quarz
delete(findall(0,'type','line'));
syms R Cs Cp L w;
assume([R Cs Cp L w],'real'); 

Zs=i*w*L+R+1/(i*w*Cs)
Zq=ol.par2(Zs,1/(i*w*Cp));
pretty(real(Zq))
pretty(imag(Zq))
s=tf('s');
Cs=98.9e-12; R=1; L=1e-6;
Gs=s*L+R+1/(s*Cs)
Gq=ol.par2(Gs,1/(s*2e-9));

%w=logspace(6,8,500);

w=linspace(10e6,10e8,5000);
hold all;
bp1=bodeplot(Gs,w,optb)
bp2=bodeplot(1/(s*2e-9),w,optb)
bp3=bodeplot(Gq,w,optb)

%%
% konforme Abbildung der Reflextionsfaktorebene

S = sparameters('passive.s2p');
s11 = rfparam(S,1,1);
f2=figure(2);
smithchart(s11)
%%    
delete(findall(0,'type','line'));

re1=[0:0.01:3];
Im1=[0:0.01:3];

r = @(z,z0) (z-z0)./(z+z0)
zv=linspace(-10,10,200);
z0v=linspace(0,20,200);
ra=r(zv,z0v);

f2=figure(2);
plot(repmat(0,1,length()))
%%
plot(zv,ra)
plot3(zv,ra,z0v)
grid on


