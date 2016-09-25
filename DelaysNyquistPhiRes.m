%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output Delay
% Nyquist verhalten, wie verändert sich phasenreserve und/oder 
% die durchtrittsfrequenz
%
% RT Klausur SS2011 A3 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%delete(findall(0,'type','line'))

ps=tf(1,[5 11 2]);      % Strecke
psApp=tf(0.5,[5.5 1]);  % Approximation einer PT2 durch PT1

kr=1;
Tn=5;
cs=tf(kr*[Tn 1],[Tn 0]);    % Regler


g0=cs*ps;
g0Sh=zpk([],[0 -2],1/5);    % Gekürzte Kreisverstärkung nach
                            % Platzierung der NS des Reglers 

                            
% Asymptoten der pole                            
% Nur bei den relativen Systemgraden 1 und 2 stehen asymptoten mit
% 90* auf der Re- Achse --> beliebiges Kr ohne instabilität
nm=1;ii=[0:nm-1];str1=(2*ii+1)*pi/nm*180/pi
nm=2;ii=[0:nm-1];str2=(2*ii+1)*pi/nm*180/pi
nm=3;ii=[0:nm-1];str3=(2*ii+1)*pi/nm*180/pi
nm=4;ii=[0:nm-1];str4=(2*ii+1)*pi/nm*180/pi

if str1>180
    str1=str1-360;
end
for i=1:2
    if str2(i)>180
        str2(i)=str2(i)-360;
    end
end
for i=1:3
    if str3(i)>180
        str3(i)=str3(i)-360;
    end
end
for i=1:4
    if str4(i)>180
        str4(i)=str4(i)-360;
    end
end


[   sprintf('%.0f\n',str1),...
    sprintf('%.0f %.0f \n',str2'),...
    sprintf('%.0f %.0f %.0f\n',str3),...
    sprintf('%.0f %.0f %.0f %.0f \n',str4) ]

clear hn

MODE=2;

if MODE==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=220;

subplot(SUB+1); hold all;
step(ps);
step(psApp);
hold off; grid on;
legend('ps','psApp')

subplot(SUB+2); hold all;
pzmap(ps);
pzmap(cs);
hold off;
legend('ps','cs')

subplot(SUB+3); hold all;
pzmap(g0);
hold off;
legend('cs*ps')

% [r p k]=residue(g0.num{1},g0.den{1});
% 
% ps=pole(g0);
% [zs gain]=zero(g0);
% 
% g0Zpk=zpk(zs,ps,gain);

subplot(SUB+4);
hold all;
step(feedback(g0,1));
step(feedback(g0Zpk,1));
step(feedback(g0Sh,1));
hold off;
legend('fb(g0)','fb(g0Zpk)','fb(g0Sh)')

MODE=2;
end

if MODE==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 2 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
SUB=120;

% Input Delay von T sek hinzufügen
% exp(-T*s)
g0ShDel=g0Sh;
set(g0ShDel,'InputDelay',0.0);

subplot(SUB+1); hold all;

str1=[];
incDel=0.05;

for i=1:6
    hn(1)=nyquistplot(g0ShDel*28.3);
    str1=[str1 sprintf('g0 T: %.2f#',incDel*(i-1))];
%    subplot(subPz);
%    pzmap(g0ShDel*28.3);
    marg=allmargin(g0ShDel*28.3);
    margPhase(i,1:length(marg.PhaseMargin))=marg.PhaseMargin;
    margGain(i,1)=20*log10(marg.GainMargin(1));
    set(g0ShDel,'InputDelay',incDel*(i-1));
end
legend(strsplit(str1(1:end-1),'#'),'Location','SouthEast')

margGain(:,2:end)=[];

for i=1:length(hn)
    hn(i).ShowFullContour='off';
    hop=getoptions(hn(i));
    hop.XLim=[-1.2 0.2];
    hop.YLim=[-1.2 0.2];
    setoptions(hn(i),hop);
end

dphi=(pi/4+angle(exp(-j*2*[2e-4:0.05:0.26])))*180/pi;

[   sprintf('--------------------------------------------------------\n'),...
    sprintf('Phasenreserve in [deg] für untereschiedliche Totzeiten\n'),...
    sprintf('--------------------------------------------------------\n'),...
    sprintf('Mit matlab gemessen : %s\n',num2str(round(1e2*margPhase')*1e-2)),...
    sprintf('Argumentenprinzip   : %s\n',num2str(round(1e2*dphi)*1e-2))]

% 
% hold all;
% hn(1)=nyquistplot(g0Sh*28.3);
% hn(2)=nyquistplot(g0ShDel*28.3);
% legend('g0Sh','g0ShDel')
% 
% for i=1:length(hn)
%     hn(i).ShowFullContour='off';
%     hop=getoptions(hn(i));
%     hop.XLim=[-2 0.5];
%     hop.YLim=[-2 0.5];
%     setoptions(hn(i),hop);
% end
% 
% 
% subplot(SUB+1);
% hold all;
% step(feedback(g0Sh,1))
% step(feedback(g0ShDel,1))
% hold off;
% grid on;
% legend('fb(g0Sh)','fb(g0ShDel)')
MODE=3;
end

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');


return
