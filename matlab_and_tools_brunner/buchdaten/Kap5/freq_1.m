% Programm freq_1.m in dem die Frequenzfunktionen mit eigenen
% Darstellungen angewandt werden

clear
% ------- Erzeugung eines LTI-Systems
sys = [tf(1,[1,1]),tf([0.1,1],[1,0.5,1]);tf(1,[1,0.2,1]),...
                      zpk([],[-1,-0.5+j*0.2,-0.5-j*0.2],1)]

Ts = 0.5;              
sys_d = c2d(sys, Ts)

% ------- Frequenzgang des kontinuierliche Modells
f = logspace(-2,0,200);
w = 2*pi*f;
[betrag, phase] = bode(sys, w);

n = length(w);
b11(1:n) = betrag(1,1,:);      % Betrag Eingang 1 zu Ausgang 1 
b21(1:n) = betrag(2,1,:);      % Betrag Eingang 1 zu Ausgang 2
b12(1:n) = betrag(1,2,:);      % Betrag Eingang 2 zu Ausgang 1
b22(1:n) = betrag(2,2,:);      % Betrag Eingang 2 zu Ausgang 2

p11(1:n) = phase(1,1,:);       % Phase Eingang 1 zu Ausgang 1 
p21(1:n) = phase(2,1,:);       % Phase Eingang 1 zu Ausgang 2
p12(1:n) = phase(1,2,:);       % Phase Eingang 2 zu Ausgang 1
p22(1:n) = phase(2,2,:);       % Phase Eingang 2 zu Ausgang 2

figure(1);      clf;
subplot(221), semilogx(f, 20*log10(b11));
title('Frequenzgang von Eing. 1 zu Ausg. 1');
xlabel('Hz');   grid;
subplot(223), semilogx(f, p11);
xlabel('Hz');   grid;

subplot(222), semilogx(f, 20*log10(b21));
title('Frequenzgang von Eing. 1 zu Ausg. 2');
xlabel('Hz');   grid;
subplot(224), semilogx(f, p21);
xlabel('Hz');   grid;

figure(2);      clf;
subplot(221), semilogx(f, 20*log10(b12));
title('Frequenzgang von Eing. 2 zu Ausg. 1');
xlabel('Hz');   grid;
subplot(223), semilogx(f, p12);
xlabel('Hz');   grid;

subplot(222), semilogx(f, 20*log10(b22));
title('Frequenzgang von Eing. 2 zu Ausg. 2');
xlabel('Hz');   grid;
subplot(224), semilogx(f, p22);
xlabel('Hz');   grid;

% ------- Frequenzgang des zeitdiskreten Modells
fd = linspace(0, 0.5/Ts, 200);
wd = pi*fd;
[betragd, phased] = bode(sys_d, wd);

n = length(wd);
b11(1:n) = betrag(1,1,:);      % Betrag Eingang 1 zu Ausgang 1 
b21(1:n) = betrag(2,1,:);      % Betrag Eingang 1 zu Ausgang 2
b12(1:n) = betrag(1,2,:);      % Betrag Eingang 2 zu Ausgang 1
b22(1:n) = betrag(2,2,:);      % Betrag Eingang 2 zu Ausgang 2

p11(1:n) = phase(1,1,:);       % Phase Eingang 1 zu Ausgang 1 
p21(1:n) = phase(2,1,:);       % Phase Eingang 1 zu Ausgang 2
p12(1:n) = phase(1,2,:);       % Phase Eingang 2 zu Ausgang 1
p22(1:n) = phase(2,2,:);       % Phase Eingang 2 zu Ausgang 2

figure(3);      clf;
subplot(221), plot(f, 20*log10(b11));
title('Frequenzgang von Eing. 1 zu Ausg. 1');
xlabel('Hz');   grid;
subplot(223), plot(f, p11);
xlabel('Hz');   grid;

subplot(222), plot(f, 20*log10(b21));
title('Frequenzgang von Eing. 1 zu Ausg. 1');
xlabel('Hz');   grid;
subplot(224), plot(f, p21);
xlabel('Hz');   grid;

figure(4);      clf;
subplot(221), plot(f, 20*log10(b12));
title('Frequenzgang von Eing. 2 zu Ausg. 1');
xlabel('Hz');   grid;
subplot(223), plot(f, p12);
xlabel('Hz');   grid;

subplot(222), plot(f, 20*log10(b22));
title('Frequenzgang von Eing. 2 zu Ausg. 2');
xlabel('Hz');   grid;
subplot(224), plot(f, p22);
xlabel('Hz');   grid;

% ------- Andere Möglichkeiten die Ergebnisse zu zerlegen
b1x = zeros(2,n);
for k = 1:2
   b1x(k,:) = betrag(k,1,:);     % Amplitudengang vom Eingang 1 zu Ausgang 1 und 2
end;

b2x = zeros(2,n);
for k = 1:2
   b2x(k,:) = betrag(k,2,:);     % Amplitudengang vom Eingang 2 zu Ausgang 1 und 2
end;

figure(5);      clf;
subplot(121), plot(f, 20*log10(b1x'));
title('Amplitudengang vom Eing. 1 ');
xlabel('Hz');   grid;
subplot(122), plot(f, 20*log10(b2x'));
title('Amplitudengang vom Eing. 2 ');
xlabel('Hz');   grid;

