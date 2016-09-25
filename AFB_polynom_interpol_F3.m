% Polynominterpolation Übertragungsfunktion Sicherungsstrom AFB 
%
% 25-05-2013

clear all;
close all;


% Gemessene Wertetabelle
I_channel = [1.1;1.276;1.428;1.623;1.878;2.255;2.801;3.7;4.446;5.44;7.132;8.6;9.959];
U_adc = [0.155;0.225;0.284;0.362;0.46;0.606;0.827;1.178;1.472;1.862;2.4;2.6;2.62];

% ----------------------
%  Uadc = f(I_channel)
% ----------------------
S=sprintf('Koeffizienten für U_adc=f(I_channel)');
disp(S)
% Koeffizienten bestimmen
p = polyfit (I_channel, U_adc, 6);
disp(p)
% Polynom bilden
f = polyval (p,I_channel);

figure;
plot(I_channel, U_adc,'o',I_channel,f,'-');
axis([0  10  0  3])

% higher resolution comparison
x=(0: 0.1: 10);
f2=polyval(p,x);

figure(2);
plot(I_channel, U_adc,'o',x,f2,'-')

% Error Plot
table=[U_adc-f];
figure(3);
plot(I_channel, table,'-')
axis([0  10  0  3])

% ----------------------
%  Uadc = f(I_channel)
% ----------------------
S=sprintf('Koeffizienten für I_channel=f(U_adc)');
disp(S)
% Koeffizienten bestimmen
p = polyfit (U_adc, I_channel, 6);
disp(p)
% Polynom bilden
f = polyval (p,U_adc);

figure(4);
plot(U_adc,I_channel,'o',U_adc,f,'-');
axis([0  3  0  10])

% higher resolution comparison
x=(0: 0.1: 2.7);
f2=polyval(p,x);

figure(5);
plot(U_adc,I_channel,'o',x,f2,'-')

% Error Plot
table=[I_channel-f];
figure(6);
plot(U_adc, table,'-')
axis([0  3  0  10])

