% Experiment (my_tick.m) zum Ändern der Tick-Märker

%------- Sprungantwort eines Systems
b = 1;
a = [1, 0.7, 1];
t = 0:0.1:20;
hs = step(b,a,t);
hs_final = b/a(3);    % Endwert der Sprungantwort

figure(1);      clf;
plot(t, hs);
tick_alt = get(gca,'YTick');

tick_neu = sort([tick_alt, 0.1*hs_final, 0.9*hs_final, ...
      0.95*hs_final,1.05*hs_final]);

%------ Setzen der neuen Tick-Märker
set(gca, 'YTick',tick_neu);
xlabel('Zeit in s');    grid on;

