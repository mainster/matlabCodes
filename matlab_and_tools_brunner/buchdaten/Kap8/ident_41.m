% Programm ident_41.m in dem die Identifikation eines 
% AR-Modells mit den Funktionen ivar und ar verglichen wird
%

% ------- Datensequenz
y = sin([(1:500)*1.2]') + sin([(1:500)*1.5]') + randn(500,1)*0.2; 

% ------- Daten f�r die Funktion ar vorbereiten
y = iddata(y,[]);

% ------- Einsatzt der Funktion ar und ivar
my_sys = ar(y, 4,'burg');         % Burg-Verfahren
my_sys1 = ivar(y,4);                % Vorw�rts und R�ckw�rts-Pr�diktion-Verfahren

% ------- Darstellung der Frequenzg�nge
figure(1),     clf;
bode(my_sys,my_sys1)
title('Frequenzg�nge der AR-Modelle');
xlabel('rad/s');   % grid

% ------- Polstellen des Systems
a = my_sys.a;
p = roots(a);

a1 = my_sys1.a;
p1 = roots(a1);


figure(2),     clf;
subplot(121),
zplane([], p1);
title('IV-Verfahren');

subplot(122),
zplane([], p);
title('Rueck- und Vorwerts-Pr�diktion');


