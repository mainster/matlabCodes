% Programm (ident_per1.m) in dem eine Identifikation
% mit periodischen Signalen gezeigt wird

% -------- System
my_sys = idpoly([1 -1.5 0.7], [0 1 0.5])

% -------- Eingangssignal
P = 20;                        % Periode
M = 200;                       % Anzahl der Perioden (L‰nge der Sequenz M*P)
Nu = 1;                        % Anzahl Eing‰nge

u = idinput([P Nu M],'rbs');   % Periodisches zuf‰lliges bin‰res Signal 

% -------- Identifikationsdaten
Ts = 0.5;                      % Abtastperiode
u_data = iddata([], u, Ts, 'Period', P);   % Nur periodisches Eingangssignal
e = iddata([], randn(M*P,1), Ts);          % Unabh‰ngige Eingangssequenz als Meﬂrauschen

% -------- Antwort des Systems
y = sim(my_sys, [u_data, e]);  % e spielt hier die Rolle eines Meﬂrauschsignals

% -------- Identifikation mit etfe
my_sys_g = etfe([y, u_data]);         % Identifiziertes System im Frequenzbereich

% ------- Die Signale aus der Identifikation
figure(1);     clf;
nd = M*P/20;
t = (0:M*P-1)*Ts;
subplot(211), stairs(t(1:nd), u_data.inputdata(1:nd))
La = axis;   axis([La(1:2), -1.2, 1.2]);
subplot(212), plot(t(1:nd), y.outputdata(1:nd))

% ------- Frequenzg‰nge
figure(2);     clf;
bode(my_sys_g, my_sys, my_sys_g, 'o')


