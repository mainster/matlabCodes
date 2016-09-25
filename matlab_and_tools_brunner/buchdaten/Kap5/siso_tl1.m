% Programm siso_tl1.m zur Initialisierung eines Entwurf
% mit dem sisotool-Werkzeug

clear
% ------- Prozess
G_p = zpk([],[-2+j*1, -2-j*1, -4],10)

% ------- Sensor
H_s = tf(1, [0.1,1])

% ------- Prefilter
F_s = tf(1)

% ------- Reglerentwurf
sisotool(G_p)