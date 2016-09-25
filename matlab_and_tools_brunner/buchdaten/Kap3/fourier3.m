% Programm (fourier3.m)zur Darstellung der Amplitudenspektren
% eines Pulses 
% Es wird die Funktion fourier2.m benutzt

imax = 50;            % Maximaler Index der Harmonischen

figure(1);        clf;
delta_tau = 0.1;
[Ai, phi, ni, Aik, phik, nik] = fourier2(delta_tau, imax, 0);
subplot(311), stem(ni, Ai);    hold on;
plot(nik, Aik);
title(['Amplitudenspektrum (delta-tau = ', num2str(delta_tau),' )']);
hold off; 
p = get(gca,'Position');
set(gca,'Position',[p(1),p(2),p(3),p(4)*0.9]);

%-------------------------------------------
delta_tau = 0.05;
[Ai, phi, ni, Aik, phik, nik] = fourier2(delta_tau, imax, 0);
subplot(312), stem(ni, Ai);    hold on;
plot(nik, Aik);
title(['Amplitudenspektrum (delta-tau = ', num2str(delta_tau),' )']);
hold off; 
p = get(gca,'Position');
set(gca,'Position',[p(1),p(2),p(3),p(4)*0.9]);

%-------------------------------------------
delta_tau = 0.01;
[Ai, phi, ni, Aik, phik, nik] = fourier2(delta_tau, imax, 0);
subplot(313), stem(ni, Ai);    hold on;
plot(nik, Aik);
title(['Amplitudenspektrum (delta-tau = ', num2str(delta_tau),' )']);
hold off; 
p = get(gca,'Position');
set(gca,'Position',[p(1),p(2),p(3),p(4)*0.9]);
xlabel('Ordnung der Harmonischen');

