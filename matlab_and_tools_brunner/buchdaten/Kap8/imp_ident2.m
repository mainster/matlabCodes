% Programm imp_ident2.m zur Untersuchung der Identifikation 
% einer Impulsantwort mit Whitening-Filter über die Funktion cra
% Das Ergebnis wird mit der Impulsantwort über die Funktion arx verglichen 
% Hier wird Messrauschen hinzugefügt

% ------- Kontinuierliches System
my_sys = tf(1,[1,0.4,1])

% ------- Diskretisierung
Ts = 0.5;
my_sys_d = c2d(my_sys, Ts)

% ------- Impulsantwort
n = 50;
t = (0:n-1)*Ts;
h = impulse(my_sys_d,t);

figure(1);    clf;
stairs(t,h);
title('Impulsantwort des Systems');
xlabel(['Zeit in s (Ts = ',num2str(Ts),'s)']);
grid;

% ------- Modell für die korrelierte Eigangssequenz
ns = 5000;
t = (0:ns-1)*Ts;
e = randn(ns,1);      % unabhängige Sequenz
sys_w = tf(1,[1,1]); % Modell des Eingangssignals
sys_w_d = c2d(sys_w,Ts);

% ------- Korrelierte Eingangssequenz
u = lsim(sys_w_d, e);
nd = 1:fix(ns/10);

figure(2);    clf;
subplot(211), plot(t(nd),e(nd));
title('Unabhaengige Eingangssequenz');

subplot(212), plot(t(nd),u(nd));
title('Korrelierte Eingangssequenz');
xlabel(['Zeit in s (Ts = ',num2str(Ts),'s)']);

% ------- Identifikation mit der Funktion cra
% ------- Antwort des Systems
y = lsim(my_sys_d, u);
noise = 0.1;
y = y + sqrt(noise)*randn(ns,1);
data = iddata(y,u,Ts);

figure(3);      clf;
[hg, R, cl] =cra(data, n, 20, 2);

% -------- Identifikation der Impulsantwort als ARX-Modell
narx = ns;
data_arx = iddata(y(1:narx), u(1:narx),Ts);
sys_arx = arx(data_arx, [0, n, 0]);
harx = sys_arx.b;

figure(4);     clf;
subplot(211), stairs(0:length(h)-1, h);
title(['Gewuenschte und über cra ermittelte Impulsantwort (Varianz = ',...
        num2str(noise),')']);
hold on
stairs(0:length(hg)-1, hg,'r');
hold off
subplot(212), stairs(0:length(h)-1, h);
title(['Gewuenschte und über arx ermittelte Impulsantwort (Varianz = ',...
        num2str(noise),')']); 
hold on
stairs(0:length(harx)-1, harx, 'r');
hold off;
xlabel(['Zeit in s (Ts = ',num2str(Ts),'s)']);
    
    
    

