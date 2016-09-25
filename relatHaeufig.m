% Relative häufigkeit
% WAHRSCHEINLICHKEITSBEGRIFF DER STATISTIK NACH KOLMOGOROFF
% http://www.eit.hs-karlsruhe.de/mesysto/teil-c-stochastische-signale/grundlagen-der-wahrscheinlichkeitstheorie/wahrscheinlichkeitsbegriff-der-statistik-nach-kolmogoroff.html
%
% Würfelexperiment mit einem regelmäßigen Würfel
% relative Häufigkeit, eine gerade Zahl zu würfeln.
delete(findall(0,'type','line'));
N=10e3;
x1=1;

nr.B=zeros(1,N);
nr.C=zeros(1,N);

for k=1:N+1
   x2=k;
   % Experiment durchführen
   v=randi([1,6],1,(x2-x1));
   
   % absolute häufigkeit dass das Ereigniss B (gerade Zahl, mod(x,2)==0) eintrifft
   na.B = length(find(mod(v(1:end),2)==0));
   % absolute häufigkeit dass das Ereigniss C (3 oder6) eintrifft
   na.C = length(find(mod(v(1:end),3)==0));
   
   % relative häufigkeit für Ereigniss B: h(C)=h_abs(C)/N
   nr.B(k)=na.B/x2;
   % relative häufigkeit für Ereigniss C: h(C)=h_abs(C)/N
   nr.C(k)=na.C/x2;
%   nr(1:k);
end

f1 = figure(1); SUBS=210;

s1=subplot(SUBS+1);
plot(nr.B,'-'); hold all;
plot(nr.C,'-'); 
legend('$h_a(B)$','$h_a(C)$')
ah=gca;  ah.XScale='log';  ylim([0,1]);   
title('Ereigniss B: {2,4,6}')
ylabel('rel. Häufigkeit h(B)=ha(B)/N')
hold off;

s2=subplot(SUBS+2);
plot(nr.C,'-'); %hold all;
ah=gca;  ah.XScale='log';  ylim([0,1]);   
title('Ereigniss C: {3,6}')
ylabel('rel. Häufigkeit h(C)=ha(C)/N')
hold off;

