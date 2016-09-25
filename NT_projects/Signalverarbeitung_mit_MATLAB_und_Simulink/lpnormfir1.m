% Programm lpnormfir1.m mit Beispielen für den Einsatz 
% der Filterfunktion firlpnorm

% --------- Spezifikationen
nord = 6;
f = [0:0.2:1];      
m = [1./sinc(0.5*(0:0.2:1))];    
edges =[0,1];

% --------- Filter Entwicklung
h = firlpnorm(nord, f, edges, m);

% --------- Frequenzgang
[H,w]=freqz(h,1,256,'whole');

figure(1),   clf;
subplot(221), plot(w/(2*pi), abs(H)); 
title('Amplitudengang'); grid;
subplot(223), plot(w/(2*pi), angle(H)); 
title('Phasegang'); grid;
xlabel('f/fs');
subplot(122), stem(0:length(h)-1, h); 
title('Einheitspulsantwort'); grid

% --------- Spezifikationen
nord = 6;
f = [0:0.2:1];      
m = [1./sinc(0.5*(0:0.2:1))];    
edges =[0, 0.2, 0.4, 1];

% --------- Filter Entwicklung
h = firlpnorm(nord, f, edges, m);

% --------- Frequenzgang
[H,w]=freqz(h,1,256,'whole');

figure(2),   clf;
subplot(221), plot(w/(2*pi), abs(H)); 
title('Amplitudengang'); grid;
subplot(223), plot(w/(2*pi), angle(H)); 
title('Phasegang'); grid;
xlabel('f/fs');
subplot(122), stem(0:length(h)-1, h); 
title('Einheitspulsantwort'); grid

% --------- Spezifikationen
nord = 6;
f = [0:0.2:1];      
m = [1./sinc(0.5*(0:0.2:1))];    
edges =[0,1];
Wb = [10 8 6 4 2 1];

% --------- Filter Entwicklung
h = firlpnorm(nord, f, edges, m, Wb);

% --------- Frequenzgang
[H,w]=freqz(h,1,256,'whole');

figure(3),   clf;
subplot(221), plot(w/(2*pi), abs(H)); 
title('Amplitudengang'); grid;
subplot(223), plot(w/(2*pi), angle(H)); 
title('Phasegang'); grid;
xlabel('f/fs');
subplot(122), stem(0:length(h)-1, h); 
title('Einheitspulsantwort'); grid

% --------- Spezifikationen
nord = 6;
f = [0:0.2:1];      
m = [1./sinc(0.5*(0:0.2:1))];    
edges =[0,1];
Wb = [10 8 6 4 2 1];

% --------- Filter Entwicklung
h = firlpnorm(nord, f, edges, m, Wb, 'minphase');

% --------- Frequenzgang
[H,w]=freqz(h,1,256,'whole');

figure(4),   clf;
subplot(221), plot(w/(2*pi), abs(H)); 
title('Amplitudengang'); grid;
subplot(223), plot(w/(2*pi), angle(H)); 
title('Phasegang'); grid;
xlabel('f/fs');
subplot(222), stem(0:length(h)-1, h); 
title('Einheitspulsantwort'); grid
subplot(224), zplane(roots(h), zeros(nord,1));
title('Null- Polstellenverteilung');

