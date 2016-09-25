% Programm zeitseq1.m zur Untersuchung von Zeitseqeunzen mit
% den Funktionen etfe und spa

% -------- Erzeugung einer Sequenz mit Hilfe eines Tiefpa�filters
Ts = 0.5                     % Welligkeit im Durchla�bereich
fd = 0.3;                    % Durchla�frequenz f/fs
[b,a] = cheby1(8, R, fd);    % Diskretes Tchebyschev-Filter

sys_v_d = tf(b,a,Ts);        % LTI-System
noise = 0.1;                 % Varianz der unabh�ngigen Sequenz
ns = 2000;

e = sqrt(noise)*randn(ns,1);% Unabh�ngige Sequenz 
y = lsim(sys_v_d, e);       % Korrelierte Zeitsequenz

% -------- Daten f�r die Identifikation
data = iddata(y,[],Ts);

% -------- Frequenzeigenschaften
M = 128;
g = spa(data, M);
p = etfe(data, M);

figure(1);      clf;
bode(g, p);
legend('Identifiziert mit spa','Identifiziert mit etfe');

% -------- �berpr�fung der Skalierung des Spektrums
% Varianz aus der Zeitsequenz
sigma_y = std(y)^2

% Varianz aus der Integration der Leistungsspektraldichte aus g (oder p)
w = g.frequency;
delta_w = (w(2)-w(1))/(2*pi);         % in Hz

spektrum = squeeze(g.spectrumdata);
sigma_y_f = 2*sum(delta_w.*spektrum) 



