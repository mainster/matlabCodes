% Programm zeitseq3.m zur Untersuchung von Zeitseqeunzen mit
% den Funktionen arx und armax

% -------- Erzeugung einer Sequenz mit Hilfe eines Tiefpaﬂfilters
R = 1;                       % Welligkeit im Durchlaﬂbereich
fd = 0.3;                    % Durchlaﬂfrequenz f/fs
Ts = 0.5;                    % Abtastfrequenz

[b,a] = cheby1(5, R, fd);    % Diskretes Tchebyschev-Filter

sys_v_d = tf(b,a,Ts);        % LTI-System
ir = lsim(sys_v_d, [1; zeros(49,1)]); % Impulsantwort

noise = 0.1;                 % Varianz der unabh‰ngigen Sequenz
ns = 5000;
e = sqrt(noise)*randn(ns,1); % Unabh‰ngige Sequenz 
y = lsim(sys_v_d, e);        % Korrelierte Zeitsequenz

% Kovarianzfunktion aus der Impulsantwort des Filters
Ryy = conv(ir, ir(50:-1:1))*noise;

% Kovarianzfunktion aus der Zeitsequenz
Ryy_g = covf(y, 50);
Ryy_g = [Ryy_g(end:-1:2), Ryy_g]';

figure(1);      clf;
subplot(211), stem(0:49, ir);
title('Impulsantwort des Generierungsfilters');

subplot(223), 
stem([-49:49], Ryy);
title('Kovarianzfunktion aus der Impulsantwort');

subplot(224),
stem([-49:49], Ryy_g);
title('Kovarianzfunktion aus der Zeitsequenz');




