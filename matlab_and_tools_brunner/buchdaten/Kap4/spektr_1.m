% Programm (spektr_1.m) zur Erzeugung eine Rauschsignals mit
% gegebener Leistungsspektraldichte über ein Synthese-Filter

%-------- Gewünschte Leistungsspektraldichte
N = 256;
df = 1/N;
f = 0:df:1-df;

f01 = 0.1;      f02 = 0.3;

Sy = 1./(1+1000*(f-f01).^2)+ 1./(1+1000*(f-(1-f01)).^2)+...
     1./(1+5000*(f-f02).^2)+ 1./(1+5000*(f-(1-f02)).^2);

%------- Darstellung von Sy(f)
figure(1);       clf;
subplot(311),   plot(f, Sy);
title('Gewuenschte Leistungsspektraldichte Sy');
xlabel('f/fs'); grid;
p = get(gca, 'Position');
set(gca, 'Position', [p(1),p(2),p(3), 0.85*p(4)]);

%------- Synthese Filter H(f)
H = sqrt(Sy);
subplot(312),   plot(f,H);
title('Betrag H des idealen Synthese-Filters ');
xlabel('f/fs'); grid;
p = get(gca, 'Position');
set(gca, 'Position', [p(1),p(2),p(3), 0.85*p(4)]);

%------ Parameter des Filters
N_2 = N/2;
na = 1;                       nb = 21;

[b,a] = invfreqz(H(1:N_2),f(1:N_2)*2*pi, nb, na);
m = find(abs(roots(a)) >= 1);   % Testen der Stabilität

if ~isempty(m)
   disp(' Synthesefilter ist instabil (wird korrigiert !)');
   [b,a] = invfreqz(H(1:N_2+1),f(1:N_2+1)*2*pi, nb, na, [], 20);
end;

%------ Amplitudengang des Filters
[Hg, w] = freqz(b,a,N,'whole');
Hg = abs(Hg)/max(abs(Hg));

subplot(313), plot(f,Hg);
title('Betrag H des geschaetzten Synthese-Filters ');
xlabel('f/fs'); grid;
p = get(gca, 'Position');
set(gca, 'Position', [p(1),p(2),p(3), 0.85*p(4)]);

%------ Test des Verfahrens
randn('seed', 379516);
x = randn(1,4000);          % weißes Rauschen
y = filter(b,a,x);          % erzeugtes Rauschsignal

%------ Gemessene Spektraldichte
Nfft = 128;
[Syg, fw] = psd(y, Nfft, 1, hanning(Nfft/2), Nfft/4);
Syg = [Syg', Syg(Nfft/2:-1:2)'];  % Spektrum für f = 0 bis fs

figure(2);    clf;
subplot(211), plot(f, Sy);
title('Gewuenschte Leistungsspektraldichte Sy');
xlabel('f/fs'); grid;
subplot(212), plot((0:Nfft-1)/Nfft, Syg);
title('Gemessene Leistungsspektraldichte Syg');
xlabel('f/fs'); grid;



