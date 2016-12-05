% plot musterfunktion
% f0=1000Hz
% funktionsvektor soll werte für 30ms enthalten
% ersten 400 Werte plotten
%
delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten
clc;
%

fa=100e3;
Ta=1/fa;
f0=1e3;
T0=1/f0;
N=30e-3/Ta;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Aufgabe 3.1
%%%%%%%%%%%%%%%%%%%%%%%%%
t=[0:1:N-1]*Ta;
thetak=[0 pi/2 pi 3/2*pi];

[X1 fa]=zufall(thetak,length(t));

p1=figure(1);
sub=220;

% Plotten der 4 Musterfunktionen
for i=1:4
    subplot(sub+i);
    plot(t(1:400)*1e3,X1(i,1:400)); grid on;
    xlabel('t/ms');
    legend(['\theta = ' num2str(thetak(i))]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% Aufgabe 3.2
%%%%%%%%%%%%%%%%%%%%%%%%%
% Werte der Zufaallsvariablen zu versch. Zeitpunkten Tn
%
Tn=[0 0.5 1.25 2.2 3.4]*T0;   
Nexp=length(thetak);

Emom1=zeros(1,length(Tn));
Emom2=zeros(1,length(Tn));

for k=1:4
    for n=1:length(Tn)
        X(k,n)=cos(2*pi*f0*Tn(n)+thetak(k));
    end;
end;

for k=1:length(Tn)
    for n=1:length(thetak) % Summe über n Musterfkt.
        Emom1(k)=Emom1(k)+1/4*X(n,k);
        Emom2(k)=Emom2(k)+1/4*(X(n,k)^2);
    end;
end;

Res32=zeros(6,length(Tn));

for k=1:4 
    Res32(k,:)=X(k,:);
end;
Res32(5,:)=Emom1(:);
Res32(6,:)=Emom2(:);

Res32

% AKF von X1!!
%
t1t2=[0 0.7 1.9 2.6];   % Vorgegebene Zeitpunkte t1 und t2
lxx=zeros(4,4);         % Ergebnismatrize

for k=1:length(t1t2)
    for l=1:length(t1t2)
        lxx(k,l)=akf(X1,t1t2(k),t1t2(l),fa);
    end;
end;

lxx     % in ms

% Mittelwerte und Leistung berechnen
%

t1=[0:Ta:30e-3-Ta];
mom=zeros(4,2);

for n=1:length(thetak)
    mom(n,1)=mean(cos(2*pi*f0*t1+thetak(n)));
    mom(n,2)=mean( cos(2*pi*f0*t1+thetak(n)).^2 );
end;

mom

% Zeit- AKF plotten
%
TMAX=1000;
lxxt=zeros(length(thetak),length(t1));
x=zeros(length(thetak),length(t1));
tout=zeros(length(thetak),TMAX);

for n=1:length(thetak)
    x(n,:)=cos(2*pi*f0*t1+thetak(n));
    [tmp2 tmp1]=zeit_akf(x(n,:),3,fa);
    tout(n,1:length(tmp1))=tmp1;
    lxxt(n,1:length(tmp2))=tmp2;
end;

p2=figure(2);
sub=220;

for n=1:length(thetak)
    subplot(sub+n);
    plot(tout(n,[1:400])*1e3,lxxt(n,[1:400]));grid on;
    xlabel('t/ms');
    legend(['AKF von X(\theta=' num2str(thetak(n)) ', t)']);
end;
% AKFs der Musterfunktionen unterscheiden sich nicht da f0 identisch ist
% und AKF nur von delta_t abhängt

[data fs]=wavread('VersuchZUF/sqr1k_a2.wav');

[ysqrt tout1]=zeit_akf(data,4,fs);
p3=figure(3);
plot(tout1, ysqrt);grid on

%%%%% PSD
f0=44100e3;
T0=1/f0;
N=T0*80e3;

sqrt1=data;
fs=length(data);
nfft = 2^nextpow2(length(sqrt1));

Pxx = abs(fft(sqrt1,nfft)).^2/length(sqrt1)/fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',fs);  
plot(Hpsd); 
set(gca,'XTick',(0:1:1e-3*length(Pxx)/2));

% 
% for s=1:4
% figure(s+2);
% zeit_akf(x(s,:),t_1, fs);
% end
