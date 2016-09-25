% Kardinalsinus plots
%
delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten

fa=25000;
Ta=1/fa;
N=2^14;
%T1=1e-3;
f=fa*linspace(0,4,N);

s1=sin(pi*Ta*f)./(pi*Ta*f);
s2=sin(pi*0.5*Ta*f)./(pi*0.5*Ta*f);
s12=2*cos((2*pi*f*Ta)/4).^2;
s3=sin(pi*f/250)./(pi*f/250);

p1kk=figure(101);
subplot(221);
hold on;
plot(f,abs(s1),'b');grid on;
plot(f,s12,'r');grid on;
%plot(f,0.5*abs(s2));grid on;
%line([100 100],[0 0.5],'Marker','.','LineStyle','-')
%line([0 2*fa],[0.38 0.38],'Marker','.','LineStyle','-')
%xlim([0 300]);

hold off;
subplot(222);
hold on;
plot(f,10*log10(abs(s1)),'b');grid on;
hold off;
ylim([-50 0]);

subplot(224);
hold on;
plot(f,10*log10(s12));grid on;
hold off;
ylim([-180 20]);
xlim([0 2*fa]);


