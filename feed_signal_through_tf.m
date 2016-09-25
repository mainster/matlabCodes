%% how to feed a signal through a transfer function
%% Klausur Stochastik SS2012 
% Aufgabe 1
%
syms w f t w0 f0 T s real
clear s; syms s;

if false


%%
f1=figure(1);
SUB=220;
delete(findall(0,'Type','line'));
s=tf('s');

a=21;
Gsym = @(k) (k+ sqrt(a))./((k+1).*(k+3));
Gk = @(k) (k+ sqrt(a))/((k+1)*(k+3));
Gw = @(w) Gsym(i*w)
Gmw = @(w) Gsym(-i*w)
Gs = eval('Gk(s)')
Gms = eval('Gk(-s)')

subplot(SUB+1);
bodeplot(Gs,ol.optb);hold all;
bodeplot(Gms,ol.optb);

subplot(SUB+2);
pzmap(Gs);hold all;
pzmap(Gms);

ww=2*pi*logspace(-3, 1, 250);
subplot(SUB+3);
plot(Gw(ww));hold all;
ax(1)=gca;
set(ax(1),'XScale','log');
% bodeplot(Gmw,ol.optb);

subplot(SUB+4);
% pzmap(Gw);hold all;
% pzmap(Gmw);
return
%%
tt=linspace(0,3,2500);
s=tf('s');

Gs=@(s) -(21-s^2)/((s^2-1)*(s^2-9));
[zs ps ks]=tf2zpk(Gs.num{1},Gs.den{1});
Gs=zpk(zs, ps, ks);

Gw=@(w) Gs(i*w);
s=tf('s');
Gs(s)
Gw(w)
bodeplot(G,ol.optb);
return

%% Klausur Stochastik SS2014 
% Aufgabe 1
%
syms w f t w0 f0 T real
A=10e-3;
f0=10e3;
T0=1/f0;
tt=linspace(0,3/f0,2500);

fprintf('%s\n',ds)
% Eingangssignal: sin mit Up=10mV und f0=10khz 
x1=@(t) A*sin(2*pi*f0*t);

% Tabsize=3 for pretty tabed printf ...
% Berechne Signalleistung ohne Rauschen mittels Definitionsgleich
px1=1/T0*int(x1(t).^2,t,0,T0);
fprintf('Signalpower of x1:\t\t\t\t\tpx1 = %g\n',double(px1))

% Eingangssignal mit widerstandsrauschquellen in serie
SNR1=45; % Dieser wert am Systemausgang muss in der Aufgabe berechnet werden 
x1n = awgn(x1(tt),SNR1);

% Berechne Signalleistung ohne Rauschen mittels matlab funktion
px1m=bandpower(x1(tt));
fprintf('Signalpower (bandpower())of x1:\t\tpx1m = %g\n',double(px1m))

% Berechne Signalleistung MIT Rauschen mittels matlab funktion
px1nm=bandpower(x1n);
fprintf('Signalpower of x1+awgn:\t\t\t\tpx1nm = %g\n',double(px1nm))

% Central moments of x1n
mxn = moment(x1n,1);
sx2n = moment(x1n,2);
sx2 = moment(x1(tt),2);
fprintf('Central moment (1. order) of x1n:\tmxn = %g\n',double(mxn))
fprintf('Central moment (2. order) of x1n:\tsx2n = %g\n',double(sx2n))
fprintf('Central moment (2. order) of x1:\tsx2 = %g\n',double(sx2))

% System
% Signalquelle x1, R1 in Serie mit ( R2||C1 )
s=tf('s');
R1=1e3; R2=1e3; C1=100e-9;
G=R2/(R1+R2+s*R1*R2*C1)
[poles,~]=pzmap(G);
fc=abs(poles)/(2*pi);
fprintf('System pole of G(s):\t\t\t\ts1 = %g\n',double(poles))
fprintf('Cutoff frequency of G(i*wc):\t\tfc = %g\n',double(fc))
% Simulation
[y1, t]=lsim(G,x1(tt),tt);

%% Plots
% figure 1
f1=figure(1);
SUB=220;

subplot(2,2,[1 3]);
bodeplot(G,ol.optb)
legend('G(i*w)')

subplot(SUB+2);
lsim(G,x1(tt),tt)

subplot(SUB+4);
lsim(G,x1n,tt)

% figure 2
f2=figure(2);
SUB=210;

subplot(SUB+1);
pxx1=pwelch(x1(tt));
plot(10*log10(pxx1))

%% Next try
% Eingangssignal: sin mit Up=10mV und f0=10khz 
end

A=1;
f0=1;
T0=1/f0;
x1=@(t) A*sin(2*pi*f0*t);

% y = wgn(m,n,p) generates an m-by-n matrix of white Gaussian noise. p
% specifies the power of y in decibels relative to a watt. The default load
% impedance is 1 ohm. in dBW relative to 1 Watt
noisePwr=-60;  
Ts=2*T0/500;

tt=[0:Ts:2*T0-Ts];
s1=x1(tt);
r1_wgn   = wgn(1,length(tt), noisePwr);
r1_awgn  = awgn(s1,35)-s1;

% figure 10
f10=figure(10);
SUB=310;

subplot(SUB+1)
plot(tt,s1);

subplot(SUB+2)
plot(tt,r1_wgn); 

subplot(SUB+3);
plot(tt,r1_awgn); hold off;

snr_wgn=10*log10( sum(s1.^2)./ sum(r1_wgn.^2) )
snr_awgn=10*log10( sum(s1.^2)./ sum(r1_awgn.^2) )

return
%%
N = 250;
n = 0:1:N-1;
x1 = 3*cos(20*pi*n/N);
num = [0.3881 0.3881];
den = [1 -0.4452 0.2700 -0.0486];
fs = 1/250;
hz = tf(num, den, fs)
[y,t]=lsim(hz,x1)
stem(t,y)