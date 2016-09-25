% Zusammenhang zwischen Phasenreserve und Überschwingweite (wichtige Faustformel)

delete(findall(0,'type','line'))
%delete(findall(0,'type','text'))

SUB=110;
wn=1;
D=1;


%[A,b,c]=linmod('RT_labor_Faustformel')
%[num1,den1]=linmod('RT_labor_Faustformel')

D=[0.1:0.05:0.9];    % Vektor für schritte des Dämpfungsmaß
T=[1.1:0.5:10.1];
tt=[0:0.1:200];     % Zeit
    
Dopt=5;              % Optimaler Overshoot, 5%

for i=1:length(D)
    for k=1:length(T)
        sys1=tf(1,[T(k)^2 2*T(k)*D(i) 1]);  % Rückgekoppeltes System
        [Y,TT,X]=step(sys1,tt);             % Sprungantwort Rückgekoppeltes System
        os(i,k)=100*(max(Y)-1.0);           % OS messen
        go=tf([1],[T(k)^2 2*T(k)*D(i) 0]);  % Kreisverstärkung G0
        [am,pm]=margin(go);                 % Amplituden- und Phasenreserve von G0
        phaseres(i,k)=pm;
    end
end


f10=figure(10);

cla;
ph=plotyy(D,os(:,1),D,phaseres(:,1));
hold all;
plot(D,os(:,1)+phaseres(:,1),'color','red');
plot(D([5:15]),os(5:15,1)+phaseres(5:15,1),'color','red','lineWidth',3);
axis(ph,[0.1 0.9 0 100]);
grid on;
hold off;
xlabel('Dämpfungsmaß D')
ylabel(ph(1),'Overshoot [%]')
ylabel(ph(2),'Phasenreserve[deg]')
legend('%os','%os+phiRes','Faustform','phiRes');


line([0.3 0.3],[0 100],'color','black','linestyle','--','LineWidth',3)
line([0.8 0.8],[0 100],'color','black','linestyle','--','LineWidth',3)
line([0.3 0.8],[70 70],'color','red','linestyle','--','LineWidth',1)

text(0.3+abs(0.3-0.8)/2,85,'Quasi linearer Bereich',...
    'FontSize',14,...
    'HorizontalAlignment','center',... 
    'BackgroundColor',[.7 .9 .7]);    
text(0.3+abs(0.3-0.8)/2,75,'Faustformel: %OS+phiRes=70 %deg',...
    'FontSize',12,...
    'HorizontalAlignment','center',... 
    'BackgroundColor',[.7 .9 .7]);    
break


subplot(SUB+1);
schr=ones(1,length(D))*Dopt;
plot(D,schr,'r');hold on;
plot(D,os);grid on; 
xlabel('Dämpfungsmaß D')
ylabel('Overshoot [%]')
axis([D(1) D(end) 0 80])
hold off;
text(-0.02,5,'5% OS');


freqResp=freqresp(sys1,w);




break

% Die Überschwingweite %OS ist unabhängig von T bzw. von der
% Kreisfrequenz wn
%
%OS=exp(-D*pi/sqrt(1-D^2))

Tr=zeros(length(D),length(tt));

subplot(SUB+3);
hold all;
for i=1:length(D)
    for k=1:length(T)
        sys1=tf(1,[T(k)^2 2*T(k)*D(i) 1]);
        [Y,TT,X]=step(sys1,tt);
        if Y(k)<1
           Tr(i,k)=TT(k);
        end
    end
end

subplot(SUB+2);

plot(Tr);grid on; 
xlabel('Dämpfungsmaß D')
ylabel('Overshoot [%]')


break;


for i=1:length(D)
    for k=1:length(T)
        sys1=tf(1,[T(k)^2 2*T(k)*D(i) 1]);
        [Y,TT,X]=step(sys1,tt);
        
    end
end
