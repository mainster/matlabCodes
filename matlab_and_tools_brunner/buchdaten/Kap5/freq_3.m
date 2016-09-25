% Programm freq_3.m in dem die Frequenzfunktionen mit eigenen
% Darstellungen angewandt werden

clear
% ------- Erzeugung eines LTI-Systems
sys = zpk([-7],[-2+j*1, -2-j*1, -5],1);

[Sigma, Omega] = meshgrid(-10:0.2:1, -2:0.1:2);

[n,m] = size(Sigma);
H = zeros(n,m);
for k = 1:n
    for p = 1:m
        H(k,p) = evalfr(sys, Sigma(k,p)+j*Omega(k,p));
    end;
end;
    
figure(1);    clf;
surf(Sigma, Omega, 20*log10(abs(H)));
colormap(gray);
title('Betrag in dB');
xlabel('sigma');
ylabel('omega');
