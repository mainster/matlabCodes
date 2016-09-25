% Skript farrow_1.m in dem das Beispiel aus Ricardo Losada
% Seite 146 untersucht wird
clear;

del = 0.8;    % Verspätung
Hf_cub = fdesign.fracdelay(del,3);  % Kubische Interpolation
Hcub = design(Hf_cub, 'Lagrange');  % Typ Lagrange

% ------- Einheitspulsantwort
C = Hcub.Coefficients
lcub = C*[del^3, del^2, del, 1]';   % Parameter lk
hcub = flipud(lcub)';               % Einheitspulsantwort FIR-Filter
% hcub = [del^3, del^2, del, 1]*C'

figure(1);   clf;
stem(0:length(hcub)-1, hcub);
title('Einheitspulsantwort des Kubischen-Filters');
xlabel('Index');   grid on;

% ------- Frequenzgang
[Hfcub, w] = freqz(hcub,1);
figure(2);   clf;
subplot(211), plot(w/(2*pi), 20*log10(abs(Hfcub)));
title(['Amplitudengang (del = ', num2str(del),')']);
xlabel('Relative Frequenz');   grid on;
subplot(212), plot(w/(2*pi), angle(Hfcub));
title('Phasengang');
xlabel('Relative Frequenz');   grid on;

% ------- Beispiel für eine Interpolierung
tk = [0, 1, 2, 3];        % Stützpunkte tk
xk = [1, 2, 1.6, -0.5];   % Funktonswerte an den Stützpunkten
yint = xk*lcub;           % Interpolierter Wert    

% ------- Lagrange-Interpolation mit polyinterp_lagrange_2
dt = 3/30;
t = 0:dt:3;
nt = length(t);
y = polyinterp_lagrange_2([0,1,2,3],[1,2,1.6,-0.5],t);

figure(3);   clf;
stem(tk, xk);         grid on;            hold on;
stem([0,1,1+del,2,3],[0, 0, yint, 0, 0],'*','Linewidth',2);
plot(t, y, 'r');   hold off; 
title(['Lagrange Interpolation (Delta = ',num2str(del),' )']);
xlabel('Abtastintervalle');    grid on;



