% Programm zwei_kanal1.m zur Untersuchung einer 
% Zweikanalfilterbank

clear

% -------- Wahl der Filter
wavelet_typ = 'bior2.4';
[h0, h1, g0, g1] = wfilters(wavelet_typ);
%    Available wavelet names 'wname' are:
%    Daubechies: 'db1' or 'haar', 'db2', ... ,'db12'
%    Coiflets  : 'coif1', ... ,  'coif5'
%    Symlets   : 'sym2' , ... ,  'sym8', ... ,'sym12'
%    Discrete Meyer wavelet: 'dmey'
%    Biorthogonal:
%        'bior1.1', 'bior1.3' , 'bior1.5'
%        'bior2.2', 'bior2.4' , 'bior2.6', 'bior2.8'
%        'bior3.1', 'bior3.3' , 'bior3.5', 'bior3.7'
%        'bior3.9', 'bior4.4' , 'bior5.5', 'bior6.8'.
%    Reverse Biorthogonal: 
%        'rbio1.1', 'rbio1.3' , 'rbio1.5'
%        'rbio2.2', 'rbio2.4' , 'rbio2.6', 'rbio2.8'
%        'rbio3.1', 'rbio3.3' , 'rbio3.5', 'rbio3.7'
%        'rbio3.9', 'rbio4.4' , 'rbio5.5', 'rbio6.8'.

h0 = h0(find(abs(h0) > 0));   % Nur die Werte die verschieden von Null sind
g0 = g0(find(abs(g0) > 0));
h1 = h1(find(abs(h1) > 0));
g1 = g1(find(abs(g1) > 0));

figure(1);   clf;
subplot(221), stem(0:length(h0)-1, h0);
title(['h0          (Wavelet Typ = ',wavelet_typ,')']);     
grid;
child = get(gca, 'children');
set(child(2), 'Linewidth',2);

subplot(223), stem(0:length(h1)-1, h1);
title('h1');     grid;
child = get(gca, 'children');
set(child(2), 'Linewidth',2);

subplot(222), stem(0:length(g0)-1, g0);
title('g0');     grid;
child = get(gca, 'children');
set(child(2), 'Linewidth',2);

subplot(224), stem(0:length(g1)-1, g1);
title('g1');     grid;
child = get(gca, 'children');
set(child(2), 'Linewidth',2);

% ------- Frequenzg‰änge
nfft = 1024;
H0 = fft(h0,nfft);   H1 = fft(h1,nfft);
G0 = fft(g0,nfft);   G1 = fft(g1,nfft);

figure(2);   clf;
subplot(221), plot((0:nfft-1)/nfft, [(abs(H0))', (abs(H1))']);
hold on;
plot((0:nfft-1)/nfft, abs((H0.*G0)+(H1.*G1)));
hold off;
La = axis;    axis([La(1:3), 2.2]);
title('H0, H1, |H0*G0+H1*G1|');    grid;
xlabel('f/fs');

% -------- ‹Übertragungsfunktion der Filterbank
t = conv(h0,g0)+conv(h1,g1);

subplot(222), stem(0:length(t)-1, t);
title('Einheitspulsantwort t = conv(h0,g0)+conv(h1,g1)');
xlabel('n');     grid;
child = get(gca, 'children');
set(child(2), 'Linewidth',2);

% -------- Normierung, die zu einer ‹Übertragungsfunktion gleich 1 führt
h0 = h0/sqrt(2);
h1 = h1/sqrt(2);
g0 = g0/sqrt(2);
g1 = g1/sqrt(2);

H0 = fft(h0,nfft);   H1 = fft(h1,nfft);
G0 = fft(g0,nfft);   G1 = fft(g1,nfft);

subplot(223), plot((0:nfft-1)/nfft, [(abs(H0))', (abs(H1))']);
hold on;
plot((0:nfft-1)/nfft, abs((H0.*G0)+(H1.*G1)));
hold off;
La = axis;    axis([La(1:3), 1.2]);
title('H0, H1, |H0*G0+H1*G1|');    grid;
xlabel('f/fs');

% -------- ‹Übertragungsfunktion der Filterbank
t = conv(h0,g0)+conv(h1,g1);

subplot(224), stem(0:length(t)-1, t);
title('Einheitspulsantwort t = conv(h0,g0)+conv(h1,g1)');
xlabel('n');     grid;
child = get(gca, 'children');
set(child(2), 'Linewidth',2);


