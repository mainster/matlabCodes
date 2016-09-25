function [V, e_g] = feder_masse4(m,r,D,tf,delta_t,ausgang,modus),
% Funktion feder_masse4.m zur Ermittlung der nat�rlichen
% L�sung �ber die Funktion lsim
% Benutzt die Funktion feder_masse1.m
% m,r,D sind die Vektoren der Massen (Gr��e n), D�mpfunksfaktoren (Gr��e n+1)
% und Federkonstanten (Gr��e n+1)
% tf = die Zeitdauer f�r die L�sung
% delta_t = Schrittweite f�r die Simulation
% ausgang = Index des Ausgangs, der zusammen mit den n�chsten drei dargestellt wird
% modus = Modus der Eigenschwingung (zwischen 1 und n)
%
% Testaufruf: feder_masse4(ones(1,4)*0.2, ones(1,4+1)*0.1, ones(1,4+1)*1.2,...
%                         40, 0.1, 5, 3);

%-------Initialisierung des Systems
n = length(m);                % Anzahl Massen (>=4)

%-------Ermittlung der Matrizen des Zustandsmodells
[a,b,c,d] = feder_masse1(m,r,D);    % System mit n Eing�ngen und 2n Ausg�ngen

%************************************************************************
% Definition des LTIs (Linear-Time-Invariant)
my_system = ss(a, b, c, d);

% Zeitintervall definieren
ns = fix(tf/(2*delta_t))*2;     % Anzahl Schritte (eine gerade Zahl) 
u = zeros(ns,n);                % Eingangssignal = 0

t = (0:ns-1)*delta_t;

% Zuf�llige Anfangswerte f�r den Zustandsvektor
x0 = randn(1,2*n)

% Antwort mit lsim
y = lsim(my_system, u, t, x0);

% Darstellung von vier Ausg�nge beginnend mit ausgang (zwischen 1 und 2*n-3)
ausgang = 5;

% Amplitudenspektrum
Y = zeros(ns, 4);

Y(:,1) = abs(fft(y(:,ausgang))/ns);
Y(:,2) = abs(fft(y(:,ausgang+1))/ns);
Y(:,3) = abs(fft(y(:,ausgang+2))/ns);
Y(:,4) = abs(fft(y(:,ausgang+3))/ns);


figure(1);      clf;
subplot(221), plot(t, y(:,ausgang));
title(['Ausgang ',num2str(ausgang)]);
grid on;
subplot(222), plot(t, y(:,ausgang+1));
title(['Ausgang ',num2str(ausgang+1)]);
grid on;
subplot(223), plot((0:ns/2-1)/(ns*delta_t), Y(1:ns/2,1));
title(['Spektrum des Ausgangs ',num2str(ausgang)]);
grid on;
subplot(224), plot((0:ns/2-1)/(ns*delta_t), Y(1:ns/2,2));
title(['Spektrum des Ausgangs ',num2str(ausgang+1)]);
grid on;


% Amplitudenspektrum
Y = zeros(ns, 4);

Y(:,1) = abs(fft(y(:,ausgang))/ns);
Y(:,2) = abs(fft(y(:,ausgang+1))/ns);
Y(:,3) = abs(fft(y(:,ausgang+2))/ns);
Y(:,4) = abs(fft(y(:,ausgang+3))/ns);

figure(2);      clf;
subplot(221), plot(t, y(:,ausgang+2));
title(['Ausgang ',num2str(ausgang+2)]);
grid on;
subplot(222), plot(t, y(:,ausgang+3));
title(['Ausgang ',num2str(ausgang+3)]);
grid on;
subplot(223), plot((0:ns/2-1)/(ns*delta_t), Y(1:ns/2,3));
title(['Spektrum des Ausgangs ',num2str(ausgang+2)]);
grid on;        xlabel('Hz')
subplot(224), plot((0:ns/2-1)/(ns*delta_t), Y(1:ns/2,4));
title(['Spektrum des Ausgangs ',num2str(ausgang+3)]);
grid on;        xlabel('Hz')

%***********************************************************
% Anregung der Schwingungsmodis
% Die Wurzeln der charakteristischen Gleichung
[V, e_g] = eig(a);          % V = Eigenvektoren; e_g = Eigenwerte
diag(e_g)                   % Eigenwerte

% Anregung Modis
modus = 4;                  % modus = 1 bis n

c = [zeros(1,(modus-1)*2), 1 1 zeros(1,2*n-(modus-1)*2-2)];

% Die Anfangswerte um das Modus = modus anregen
x0 = V*eye(2*n, 2*n)*c';

% Nat�rliche L�sung
y1 = lsim(my_system, u, t, x0);

figure(3);      clf;
subplot(221), plot(t, y1(:,ausgang));
title(['Ausgang ',num2str(ausgang),' (Modus ',num2str(modus),')']);
grid on;
subplot(222), plot(t, y1(:,ausgang+1));
title(['Ausgang ',num2str(ausgang+1),' (Modus ',num2str(modus),')']);
grid on;
subplot(223), plot(t, y1(:,ausgang+2));
title(['Ausgang ',num2str(ausgang+2),' (Modus ',num2str(modus),')']);
grid on;
subplot(224), plot(t, y1(:,ausgang+3));
title(['Ausgang ',num2str(ausgang+3),' (Modus ',num2str(modus),')']);
grid on;


