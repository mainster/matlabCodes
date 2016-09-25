function [] = four_t1(T0,tau)
% Programm (four_t1.m) mit dem die Bilder 3.19 und 3.20 aus 
% Kapitel 3 erzeugt wurden.
% Es wird die Fourier-Transformation für Pulse der Dauer tau 
% über die FFT ermittelt
% Parameter: T0 = [T1, T2, T3], Vektor mit 3 Periodenwerten 
%            tau = Dauer des Pulses
%
% Testaufruf: four_t1([2,5,10], 0.5);

%------- Bereich für die Kreisfrequenz i*w0 (rad/s)
iomega_max = 40;

%------- ciT für die erste Periode
T_t = T0(1);
i_max = fix(iomega_max*T_t/(2*pi));
i1 = -i_max:i_max;
ciT1 = 2*tau*sin(i1*2*pi*tau/T_t+eps)./(i1*2*pi*tau/T_t+eps);
ciT1 = abs(ciT1);

%------- ciT für die zweite Periode
T_t = T0(2);
i_max = fix(iomega_max*T_t/(2*pi));
i2 = -i_max:i_max;
ciT2 = 2*tau*sin(i2*2*pi*tau/T_t+eps)./(i2*2*pi*tau/T_t+eps);
ciT2 = abs(ciT2);

%------- ciT für die dritte Periode
T_t = T0(3);
i_max = fix(iomega_max*T_t/(2*pi));
i3 = -i_max:i_max;
ciT3 = 2*tau*sin(i3*2*pi*tau/T_t+eps)./(i3*2*pi*tau/T_t+eps);
ciT3 = abs(ciT3);
%--------------------------------------------------
figure(1);      clf;
subplot(311), stem(i1*2*pi/T0(1), ciT1);
title(['Amplitudenspektrum für T0 = ',...
      num2str(T0(1)),' ;',...
      num2str(T0(2)),' ;',...
      num2str(T0(3)),' ; und tau = ',...
      num2str(tau)]);
ylabel('|ciT0|');		xlabel('k*w0    rad/s');
gr = get(gca, 'Position');
set(gca, 'Position', [gr(1:3), 0.85*gr(4)]);

subplot(312), stem(i2*2*pi/T0(2), ciT2);
ylabel('|ciT0|');		xlabel('k*w0    rad/s');
gr = get(gca, 'Position');
set(gca, 'Position', [gr(1:3), 0.85*gr(4)]);

subplot(313), stem(i3*2*pi/T0(3), ciT3);
ylabel('|ciT0|');		xlabel('k*w0    rad/s');
gr = get(gca, 'Position');
set(gca, 'Position', [gr(1:3), 0.85*gr(4)]);

%--------------------------------------------------
%----- Die Fourier-Transformation

omega = -iomega_max:iomega_max/200:iomega_max;
X = 2*tau*sin(omega*tau+eps)./(omega*tau+eps);

figure(2);      clf;
subplot(211), plot(omega, abs(X));
title('Fourier-Transformation (2*tau*sinc(w*tau)');
xlabel('w   rad/s');
ylabel('|X(w)|');