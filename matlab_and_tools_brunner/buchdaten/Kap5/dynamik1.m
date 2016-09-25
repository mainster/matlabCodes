% Programm dynamik1.m zur Untersuchung der Dynamik von LTI-Modellen

% ------- SISO SS-Modell
randn('seed', 13795);
sys = rss(6);        % Zufalls SS-Modell

% ------- Tf-Modell
sys_tf = tf(sys)

% ------- Polstellen
pol_stellen = pole(sys_tf)

% ------- Nustellen
null_stellen = tzero(sys_tf)

% ------- Verteilung der Pol-Nullstellen
figure(1);    clf;
pzmap(pol_stellen, null_stellen);

% ------- Verstärkung bei Frequenz 0
dc_gain = dcgain(sys_tf)

% ------- Norm des Systems als Mass der Robustheit
[ninf, fpeak] = norm(sys_tf, inf);   % Spitzenwert des Frequenzgangs

disp(['Spitzenwert = ',num2str(ninf)]);
disp(['Frequenz des Spitzenwertes = ',num2str(fpeak)]);

% ------- Frequenzgang
figure(2);     clf;
bode(sys_tf);


