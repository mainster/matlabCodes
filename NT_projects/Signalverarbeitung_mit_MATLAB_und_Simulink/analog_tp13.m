% Programm analog_tp13.m in dem das Modell analog_tp_13.mdl,
% mit den Filtern entwickelt im Programm analog_tp1.m, 
% mehrmals aufgerufen wird und das Eingangssignal
% aus rechteckigen Pulsen besteht.

% Entwicklung der Filter mit analog_tp1
analog_tp1;

text_{1} = 'Bessel';            
text_{2} = 'Butterworth';
text_{3} = 'Tschebyschev I';
text_{4} = 'Ellip';

period = 20e-3;     % Periode der rechteckigen Pulse
tau = 10;           % Dauer der Pulse in der Periode 
tau_r = period*tau/100; % Dauer der Pulse in s
dt = 1e-5;      % Schrittweite der Simulation

figure(3);      clf;
for Typ = 1:4
    sim('analog_tp_13', [0:dt:2*period-dt]);
    subplot(2,2,Typ), plot(tout, yout)
    title(text_{Typ});  grid
    La = axis;      axis([min(tout), max(tout), La(3:4)]);
    xlabel('Zeit in s')
end;   

figure(4);      clf;
for Typ = 1:4
    sim('analog_tp_13', [0:dt:period-dt]);
    subplot(2,2,Typ), plot(tout, yout)
    title(text_{Typ});  grid
    La = axis;      axis([min(tout), max(tout), ...
            min(min(yout)), 1.1*max(max(yout))]);
    xlabel('Zeit in s')
end;

% -------- Spektraldichten der Signale vor und nach den Filtern
% oder deren Fourier-Transformation

Typ = 2;            % Typ des Filters für die Spektraldichte
sim('analog_tp_13',[0:dt:period-dt]); 
[n,m] = size(yout);
nfft = max(2^nextpow2(n), 4096);

H = dt*abs(fft(yout,nfft)); % Annäherung der Fourier-Transformation
H = fftshift(H);

n_3000 = 3000*nfft*dt;     % Index für einen 
% Frequenzbereich von -3000 Hz bis 3000 Hz
ndfft = -fix(n_3000):fix(n_3000)-1;
fd = ndfft/(nfft*dt);

figure(5);      clf;
subplot(211), plot(fd, ...
    H(nfft/2-fix(n_3000)+1:nfft/2+fix(n_3000),1));
title(['Fourier-Transformation des Eingangspulses',...
        ' (Pulsdauer \tau = ',num2str(tau_r*1000),' ms)']);
xlabel('Hz');   grid;

subplot(212), plot(fd, ...
    H(nfft/2-fix(n_3000)+1:nfft/2+fix(n_3000),2));
title(['Fourier-Transformation des Ausgangspulses (',text_{Typ},')']);
xlabel('Hz');   grid;





