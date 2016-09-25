% Programm overl_add2.m zur Demonstartion der 
% overlap-add Methode

Nt = 300;   % Gesamt Länge der Eingangssequenz
N = 100;    % Länge der Blöcke für die Eingangssequenz
M = 10;     % Länge der Einheitspulsantwort

x = randn(1,Nt); % Sequenz der Länge Nt
h = ones(1,M);   % Einheitspulsantwort der Länge M

yl = conv(x,h);  % Lineare Faltung
%% yl = yl(1:end-M+1);% ohne Endteil der Länge M-1

% -------- Filterung über die DFT
L = M+N-1;      % Länge der erweiterten Blöcke
y_fft = []; 
p = Nt/N;
for k = 1:p     % Faltung der blöcke
    x_temp = x((k-1)*N+1:k*N);
    Xe = fft(x_temp, L); % DFT des laufenden Blocks
    He = fft(h, L); % DFT der erweiterten Sequenz h
    ylfft = real(ifft(Xe.*He)); % lineare Faltung über DFT
    if k==1
        y_fft = ylfft;
    else
        y_fft(end-M+2:end) = y_fft(end-M+2:end) + ylfft(1:M-1);  %% add
        y_fft = [y_fft, ylfft(M:L)];% weitere Zusammensetzung
    end
end;

figure(2),   clf;
subplot(211), stem(0:length(yl)-1, yl);
title('Lineare Faltung mit conv');
xlabel('n');    grid on;

subplot(212), stem(0:length(y_fft)-1, y_fft);
title('Lineare Faltung ueber die overlap-add Methode');
xlabel('n');    grid on;