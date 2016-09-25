% Programm mra1.m zur Initialisierung des Modells
% mra_1.mdl in dem eine Multi-Resolution-Analyse üŸber
% drei Stufen simuliert wird


% -------- Allgemeine Parameter
fs = 1000;
Ts = 1/fs;

% -------- Filter der Zerlegung
wname = 'db8';
[h0, h1, g0, g1] = wfilters(wname);

%  Available wavelet names 'wname' are:
%    Daubechies: 'db1' or 'haar', 'db2', ... ,'db12'
%    Coiflets  : 'coif1', ... ,  'coif5'
%    Symlets   : 'sym2' , ... ,  'sym8', ... ,'sym12'
%    Discrete Meyer wavelet: 'dmey'
%    Biorthogonal:
%        'bior1.1', 'bior1.3' , 'bior1.5'
%        'bior2.2', 'bior2.4' , 'bior2.6', 'bior2.8'
%       'bior3.1', 'bior3.3' , 'bior3.5', 'bior3.7'
%        'bior3.9', 'bior4.4' , 'bior5.5', 'bior6.8'.
%    Reverse Biorthogonal: 
%        'rbio1.1', 'rbio1.3' , 'rbio1.5'
%        'rbio2.2', 'rbio2.4' , 'rbio2.6', 'rbio2.8'
%        'rbio3.1', 'rbio3.3' , 'rbio3.5', 'rbio3.7'
%        'rbio3.9', 'rbio4.4' , 'rbio5.5', 'rbio6.8'

figure(1),   clf;
subplot(221), stem(0:length(h0)-1, h0);
title('h0');  grid;
subplot(222), stem(0:length(h0)-1, h1);
title('h1');  grid;
subplot(223), stem(0:length(h0)-1, g0);
title('g0');  grid;
subplot(224), stem(0:length(h0)-1, g1);
title('g1');  grid;

% ------- VerspäŠtungen
L1 = length(h0);     L2 = length(g0);
L = (L1+L2)/2
delay1 = L-1
delay2 = delay1*3
delay3 = delay2*2+L-1

% -------- Aufruf der Simulation
% sim('mra_1',[0, 10]);
% oder
% sim('mra_2',[0, 10]);
% oder
 sim('mra_3',[0, 10]);