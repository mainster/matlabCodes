%%%%% NT Klausur WS12-13
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSD, Gleichanteil, wechselanteil

fs=100;
ts=1/fs;
tt=[-.3:ts:.3];

x1p=@(t,f0) cos(2*pi*f0*t);
x2p=@(t,t0) heaviside(t+t0)-heaviside(t-t0);
x1s='@(t,f0) cos(2*pi*f0*t)';
x2s='@(t,t0) heaviside(t+t0)-heaviside(t-t0)';
x3s='@(t,B) 2*B*(sin(pi*t*2*B)./(pi*t*2*B)).^2';

HS=x3s;
A=1;
A=7.13;
B=7.13;
x1=feval(str2func([HS]), tt, A);

syms t;
x1(round(end/2))=eval(limit(str2func([HS]),t,0));

f1=figure(1);clf;
SUB=320;
subplot(SUB+1);
stem(tt, x1); grid on;
% legend(HS)
xlim([-.3,0.3]);

nfft = 2^nextpow2(length(x1));
Pxx = abs(fft(x1,nfft)).^2/length(x1)/fs;

% Create a single-sided spectrum
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'fs',fs);  
%hold all;
subplot(SUB+2);
stem(Hpsd.Data);
% xlim([0 10])
subplot(SUB+3);
stem(log10(Hpsd.Data),'r');
grid on;

subplot(SUB+4);
lxx=xcorr(x1);
plot([-fliplr(tt(1:end-1)) tt],lxx)
grid on;

return

clear all;
delete(findall(0,'type','line'));

% Die Temperatur ist ein Zufallsprozess mit der Wahrscheinlichkeitsdichte
dtheta=0.001;
theta=-32:dtheta:32;

ft=-1/128*theta+1/8;
ft(1:32/dtheta)=zeros(1,32/dtheta);
ft(48/dtheta+1:end)=zeros(1,16/dtheta+1);

ftt(1,:)=theta;
ftt(2,:)=ft;

clf ('reset');
f1=figure(1);
SUB=120;

subplot(SUB+1);
plot(ftt(1,:),ftt(2,:));
grid on;
xlabel('theta / degC');
title('Wahrscheinlichkeitsdichte');

subplot(SUB+2);

%fs = 32e3;   
%t = 0:1/fs:2.96;
%x = cos(2*pi*t*1.24e3)+ cos(2*pi*t*10e3)+ randn(size(t));
fs=1/dtheta;
nfft = 2^nextpow2(length(ftt(2,:)));
Pxx = abs(fft(ftt(2,:),nfft)).^2/length(ftt(2,:))/fs;

% Create a single-sided spectrum
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'fs',fs);  
%hold all;
plot(Hpsd.Data);
xlim([0 10])
%plot(log10(Hpsd.Data),'r');
hold off;