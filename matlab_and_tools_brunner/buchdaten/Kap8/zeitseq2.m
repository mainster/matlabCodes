% Programm zeitseq2.m zur Untersuchung von Zeitseqeunzen mit
% den Funktionen arx und armax

% -------- Erzeugung einer Sequenz mit Hilfe eines Tiefpaßfilters
Ts = 0.5                     % Welligkeit im Durchlaßbereich
fd = 0.3;                    % Durchlaßfrequenz f/fs
[b,a] = cheby1(8, R, fd);    % Diskretes Tchebyschev-Filter

sys_v_d = tf(b,a,Ts);        % LTI-System
noise = 0.1;                 % Varianz der unabhängigen Sequenz
ns = 200;

e = sqrt(noise)*randn(ns,1);% Unabhängige Sequenz 
y = lsim(sys_v_d, e);       % Korrelierte Zeitsequenz

% -------- Daten für die Identifikation
data = iddata(y,[],Ts);

% -------- Frequenzeigenschaften
na = 10;       nc = 10;
garx = arx(data, na);
garmax = armax(data, [na, nc]);

figure(1);      clf;
bode(garx, garmax);
legend('Identifiziert mit arx','Identifiziert mit armax');

% -------- Überprüfung der Skalierung des Spektrums
% Varianz aus der Zeitsequenz
sigma_y = std(y)^2

% Varianz aus der Integration der Leistungsspektraldichte aus g (oder p)
% Werte des Frequenzgangs
[betrag, phase, w] = bode(garx);
%diff(w);
delta_w = (w(2)-w(1))/(2*pi);         % in Hz
sigma_y_f = 2*sum(delta_w.*betrag) 



