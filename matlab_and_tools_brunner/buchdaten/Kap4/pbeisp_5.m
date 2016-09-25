% Programm (pbeisp_5.m) zur Parametrierung des Modells 
% beisp_5.mdl

%------- Signale der Generatoren
t1 = 0:0.01:10;               u1 = sin(2*pi*t1/1.5);
t2 = 0:0.02:10;               u2 = sign(cos(2*pi*t2/2));

A1 = [t1',u1'];               A2 = [t2',u2'];   

%------- Abtastperiode
Ts = 0.1;                
%------- Kontinuierliches System
bk = 1;                       ak = [1 1];
%------- Diskretes System
[bd, ad] = impinvar(bk,ak,1/Ts);

%------- Impulsantwort des kontinuierlichen und diskreten Systems

my_sysk = tf(bk,ak);          % LTI-System
tfinal = 10;
[hk, tk] = impulse(my_sysk, tfinal);

ni = tfinal/Ts;
hd = filter(bd,ad,[1, zeros(1,ni-1)]);

figure(1);    clf;
subplot(211), plot(tk, hk);
title('Impulsantwort des kontinuierlichen Systems');
xlabel('Zeit in s');          grid;

subplot(212), stem((0:ni-1)*Ts, hd/Ts);
title('Impulsantwort des aequivalenten diskreten Systems');
xlabel('Zeit in s');          grid;
