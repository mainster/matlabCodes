% Programm feder_masse2.m zum Experimentieren mit den Funktionen
% bode, step, impulse und lsim für ein Feder-Masse-System
% Benutzt die Funktion feder_masse10.m

%-------Initialisierung des Systems
n = 4;
m = ones(1,n)*0.2;    % Massen
r = ones(1,n+1)*0.2;  % Dämpfungsfaktoren
D = ones(1,n+1)*0.8;  % Federkonstante
ii = 1;               % Die Kraft auf Masse ii ist Eingang (ii zwischen 1 und n) 
io = 6;               % Ausgang ist die Zustandsvariable io (io zwischen 1 und 2*n)

%-------Ermittlung der Matrizen des Zustandsmodells
[a,b,c,d] = feder_masse10(m,r,D,ii,io);

%************************************************************************
%-------Frequenzgang mit bode
% Definition des LTIs (Linear-Time-Invariant)
my_system = ss(a, b, c, d);

f = logspace(-2, 1, 200);   % Frequenzbereich in Hz
w = 2*pi*f;                 % Frequenz in rad/s
% Aufruf der Funktion bode
[betrag, phase] = bode(my_system, w); 

betrag1 = squeeze(betrag);  % Singletone aus betrag und phase entfernen
phase1  = squeeze(phase); 

% Darstellung                

figure(1);      clf;
subplot(211), semilogx(f, 20*log10(betrag1));
ylabel('dB');       grid on;
title(['Amplitudengang von ',num2str(ii),' zu ', num2str(io)]);
subplot(212), semilogx(f,  phase1);
title('Phasengang');    xlabel('Hz');
ylabel('Grad');     grid on;

%************************************************************************
%-------Sprungantwort mit step
[s,t1] = step(my_system);

%-------Impulsantwort mit impulse
[g,t2] = impulse(my_system);

figure(2);      clf;
subplot(211), plot(t1, s);
title(['Sprungantwort von ',num2str(ii),' zu ', num2str(io)]);
grid on;
subplot(212), plot(t2, g);
title(['Impulsantwort von ',num2str(ii),' zu ', num2str(io)]);
grid on;
%************************************************************************
%-------Antwort auf weisses Rauschen

ns = 1000;                      % Anzahl Schritte (muss gerade sein)
u = randn(1,ns);                % Eingangsrauschen
delta_t = 0.1;                  % Schritte von 1 s

t = (0:length(u)-1)*delta_t;

y = lsim(my_system, u, t);

figure(3);      clf;
subplot(211), plot(t, y);
title(['Antwort von ',num2str(ii),' zu ', num2str(io)]);
grid on;

%-------Leistungsspektrum der Antwort über (|fft|/N)^2 ermittelt

S = abs(fft(y)/ns).^2;

subplot(212), plot((0:ns/4-1)/(ns*delta_t), S(1:ns/4));
title(['Leistungsspektrum  über (|FFT|/N)^2']);
grid on;        xlabel('Hz');

