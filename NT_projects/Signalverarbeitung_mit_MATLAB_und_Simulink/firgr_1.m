% Programm firgr_1.m zur Untersuchung der 
% Funktion firgr

clear
% -------- Hochpassfilter mit forciertem Wert und verschiedene 
% Approximierungsfehler in den Bereichen
W1 = [10,1,1];
h1 = firgr(128,[0 0.299 0.3 0.6 0.65 1],[0 0 0 0 1 1],...
       {'n' 'i' 'f' 'n' 'n' 'n'},W1, {'e1','e2','e3'});
W2 = [1,10,10];   
h2 = firgr(128,[0 0.299 0.3 0.6 0.65 1],[0 0 0 0 1 1],...
       {'n' 'i' 'f' 'n' 'n' 'n'},W2, {'e1','e2','e3'});
W3 = [1,1,10];   
h3 = firgr(128,[0 0.299 0.3 0.6 0.65 1],[0 0 0 0 1 1],...
       {'n' 'i' 'f' 'n' 'n' 'n'},W3, {'e1','e2','e3'});
W4 = [1,10,1];   
h4 = firgr(128,[0 0.299 0.3 0.6 0.65 1],[0 0 0 0 1 1],...
       {'n' 'i' 'f' 'n' 'n' 'n'},W4, {'e1','e2','e3'});

% -------- Frequenzgänge   
[H1,w] = freqz(h1,1, 1024);
[H2,w] = freqz(h2,1, 1024);
[H3,w] = freqz(h3,1, 1024);
[H4,w] = freqz(h4,1, 1024);

figure(1),   clf;
subplot(221), plot(w/pi, 20*log10(abs(H1)));
title(['Bewertung = ',num2str(W1)]);
xlabel('2f/fs');   grid;

subplot(222), plot(w/pi, 20*log10(abs(H2)));
title(['Bewertung = ',num2str(W2)]);
xlabel('2f/fs');   grid;

subplot(223), plot(w/pi, 20*log10(abs(H3)));
title(['Bewertung = ',num2str(W3)]);
xlabel('2f/fs');   grid;

subplot(224), plot(w/pi, 20*log10(abs(H4)));
title(['Bewertung = ',num2str(W4)]);
xlabel('2f/fs');   grid;
