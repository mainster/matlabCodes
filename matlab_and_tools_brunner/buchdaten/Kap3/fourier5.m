% Programm (fourier5.m) zur Darstellung des  
% Leakage-Effekts der FFT

f1 = 130;           % Frequenz des 1. Signals           
f2 = 200;           % Frequenz des 2. Signals
fs = 800;           % Abtastfrequenz und Abtastperiode
Ts = 1/fs;

x1max = 15;         % Amplituden
x2max = 5;

t = 0:0.1e-4:49e-3; % Zeitbereich für die kontinuierlichen 
                    % Signale
td = 0:Ts:49e-3;    % Zeitbereich für die diskreten Signale

x1 = x1max*cos(2*pi*t*f1-pi/2);     % Kontinuierliche Signale
x2 = x2max*cos(2*pi*t*f2+pi/3);

xd1 = x1max*cos(2*pi*td*f1-pi/2);   % Diskrete Signale
xd2 = x2max*cos(2*pi*td*f2+pi/3);

%------ Darstellung der Signale
figure(1);        clf;
subplot(211), plot(t,x1);   hold on;
stem(td,xd1);   grid;
title(['Signal mit f1 = ',num2str(f1),' Hz (fs = ',...
                         num2str(fs),' Hz)']);
xlabel('Zeit in s');        hold off;

tm = max(t)/1;
p = find(t<=tm);
q = find(td<=tm);

subplot(212), plot(t(p),x2(p));   hold on;
stem(td(q),xd2(q));    grid;
title(['Signal mit f2 = ',num2str(f2),' Hz (fs = ',...
                         num2str(fs),' Hz)']);
xlabel('Zeit in s');        hold off;

%------ Darstellung der FFT (abs(FFT)/N und Winkel(FFT))
Xi1 = fft(xd1);
Xi2 = fft(xd2);

N = length(Xi1);
N_2 = fix(N/2);

figure(2);
subplot(211), stem((0:N_2-1)*fs/N, abs(Xi1(1:N_2)/N));
title(['Amplitudenspektrum des Signals xd1 (f1 = ',...
         num2str(f1), 'Hz)']);
xlabel('Frequenz in Hz');
ylabel('Betrag(DFT/N)');      

subplot(212), stem((0:N_2-1)*fs/N, abs(Xi2(1:N_2)/N));
title(['Amplitudenspektrum des Signals xd2 (f2 = ',...
         num2str(f2), 'Hz)']);
xlabel('Frequenz in Hz');
ylabel('Betrag(DFT/N)');      


%------ 
m1 = N*f1/fs;
m2 = N*f2/fs;

in = 0:0.1:N-1;
Xdin1 = zeros(1,length(in));
Xdin2 = zeros(1,length(in));

for l = 1:length(in)
   Xdin1(l) = sum(xd1.*exp(-j*2*pi*in(l)*(0:N-1)/N));   
   Xdin2(l) = sum(xd2.*exp(-j*2*pi*in(l)*(0:N-1)/N));   
end;

in1 = find(in <= N_2);
figure(3);      clf;
subplot(211), plot(in(in1)*fs/N, abs(Xdin1(in1)/N));
hold on;  stem((0:N_2-1)*fs/N, abs(Xi1(1:N_2)/N));
hold off;
title('DFT als kontinuierliche und diskrete Funktion (Ausschnitt)');
ylabel('Betrag(DFT/N)');      
xlabel(['Frequenz in Hz; (f1 = ',num2str(f1),' Hz; fs = ',...
         num2str(fs),' Hz; m1 = ',num2str(m1),')']);
subplot(212), plot(in(in1)*fs/N, abs(Xdin2(in1)/N));
hold on;  stem((0:N_2-1)*fs/N, abs(Xi2(1:N_2)/N));
hold off;
ylabel('Betrag(DFT/N)');      
xlabel(['Frequenz in Hz; (f2 = ',num2str(f2),' Hz; fs = ',...
      num2str(fs),' Hz; m2 = ',num2str(m2),')']);

%------ Spektrum mit Fenstergewichtung
w = hanning(N);                 % Wahl des Fensters
w_t = hanning(length(t));
text_1 = 'hanning';

figure(4);        clf;
xd1_f = xd1.*w';
subplot(211), stem(td, xd1_f); hold on
plot(t, x1.*w_t');
hold off;                   grid;
title(['xd1*',text_1,'-Fenster (f1 = ',...
                         num2str(f1),' Hz; fs = ',...
                         num2str(fs),' Hz)']);
xlabel('Zeit in s');        hold off;
%--------------------------------------------------------
Xd1_f = fft(xd1_f);

in = 0:0.1:N-1;
Xdin1_f = zeros(1,length(in));
for l = 1:length(in)
   Xdin1_f(l) = sum(xd1_f.*exp(-j*2*pi*in(l)*(0:N-1)/N));   
end;

subplot(212), stem((0:N_2-1)*fs/N, abs(Xd1_f(1:N_2)/N));
hold on; 
plot(in(in1)*fs/N, abs(Xdin1_f(in1)/N));
title(['Amplitudenspektrum von xd1*',text_1,'-Fenster (f1 = ',...
         num2str(f1), 'Hz)']);
xlabel('Frequenz in Hz');
ylabel('Betrag(DFT/N)');      





