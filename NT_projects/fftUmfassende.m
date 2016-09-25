% Zeitbereich 
% ---------------------------------- 

fa = 8000; % Abtastfrequenz 
fn = fa/2; % Nyquistfrequenz 
N = 1024; % gewünschte FFT-Länge (N=2^x, sonst wird der DFT-Algorithmus verwendet!) 
df = fa/N; % Frequenzauflösung 
% Erzeugung eines Datensatzes mit N Abtastwerten 
% ---------------------------------------------- 
t = 0 : 1/fa : (N-1)/fa; % x-Vektor 
% Frequenzvorgabe in Hz als ganzzahlig Vielfaches der Frequenzauflösung der DFT/FFT: 
f1 = df*100; % bei fa = 8000 Hz und N = 1024 beträgt df = 7,8125 Hz und 
% f1 damit 781,25 Hz 
 f1 = 784; 
 f1 = df; 
 phase = pi/2; 

a1 = 1; % Amplitudenvorgabe 
y = a1*sin(2*pi*f1*t); % y-Vektor 
y = [y(1:N/2) zeros(1, N/2)]; 
% Graphische Darstellung 
% ---------------------- 
% max. Amplitude zur Skalierung der graphischen Darstellung feststellen: 
max_y = max(abs(y))*1.1; 
fig = figure(1); 
plot(y) 
axis([0 N -max_y max_y]) 
title('Datensatz') 
ylabel('Amplitude') 
xlabel('N Stützstellen') 
grid 


% Frequenzbereich 
% ---------------------------------- 

% Berechnung der FFT 
% ------------------ 
H = fft(y, N); 
% Berechnung des Amplitudengangs aus dem komplexen Frequenzvektor H: 
amplH = abs(H); 
% Amplitudenskalierung (Normierung auf N) und verschieben der Elemente des 
% Amplitudenvektors, so dass die Darstellung des Amplitudengangs von -fn...0...fn 
% erfolgen kann: 
amplitudengang = fftshift(amplH/N); 
% Graphische Darstellung 
% ---------------------- 
% Frequenzvektoren (werden bei der graphischen Darstellung benötigt): 
x_fn = 0 : df : fn-df; 
x_fa = 0 : df : fa-df; 
% max. Amplitude zur Skalierung der graphischen Darstellung feststellen: 
%a = max([a1, a2, a3, a4, a5]); % wird später benötigt 
a = a1; 
fig = figure(fig+1); 
stem(x_fa-fn, amplitudengang, 'b.-') 
axis([-fn fn 0 a/2*1.1]) 
title('Amplitudengang') 
ylabel('Amplitude') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid 

% Ausgabe in dB 
% ------------------ 
fig = figure(fig+1); 
plot(x_fa-fn, 20*log10(amplitudengang)) 
%axis([-fn fn -100 20*log10(a/2)+3]) 
axis([-fn fn -100 3]) 
title('Amplitudengang') 
ylabel('Amplitude in dB') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid 

% Darstellung des interessierenden Frequenzbereichs des 
% Amplitudengangs (0...fn) und 
% daran angepasste Amplitudenskalierung (Normierung auf N/2): 
amplitudengang = [amplH(1)/N amplH(2:N/2)/(N/2)]; % DC-Bin auf N normieren! 
fig = figure(fig+1); 
stem(x_fn, amplitudengang, 'b.-') 
axis([0 fn 0 a*1.1]) 
title('Amplitudengang') 
ylabel('Amplitude') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid 

% Ausgabe in dB 
% ------------------ 
fig = figure(fig+1); 
plot(x_fn, 20*log10(amplitudengang)) 
axis([0 fn -100 20*log10(a)+3]) 
title('Amplitudengang') 
ylabel('Amplitude in dB') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid 


% Fensterfunktion 
% ---------------------- 

% Anhang an die bereits erfolgte Untersuchung 
% ------------------------------------------- 
win = hann(N)'; 
%y_win = y.*win; % Fensterung ohne Amplitudenkorrektur 
y_win = y.*win*N/sum(win); % Fensterung mit Amplitudenkorrektur 
max_y = max(abs(y_win))*1.1; 

fig = figure(fig+1); 
plot(y_win) 
axis([0 N -max_y max_y]) 
title('Datensatz nach Fensterung mit Hann-Fenster') 
ylabel('Amplitude') 
xlabel('N Stützstellen') 
grid 

% Berechnung der FFT 
% ------------------ 
H = fft(y_win, N); 
% Berechnung des Amplitudengangs aus dem komplexen Frequenzvektor H: 
amplH = abs(H); 
% Amplitudenskalierung (Normierung auf N) und verschieben der Elemente des 
% Amplitudenvektors, so dass die Darstellung des Amplitudengangs von -fn...0...fn 
% erfolgen kann: 
amplitudengang = fftshift(amplH/N); 

% Graphische Darstellung 
% ---------------------- 
fig = figure(fig+1); 
stem(x_fa-fn, amplitudengang, 'b.-') 
axis([-fn fn 0 a/2*1.1]) 
title('Amplitudengang nach Fensterung') 
ylabel('Amplitude') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid 

% Ausgabe in dB 
% ------------------ 
fig = figure(fig+1); 
plot(x_fa-fn, 20*log10(amplitudengang)) 
%axis([-fn fn -100 20*log10(a/2)+3]) 
axis([-fn fn -100 3]) 
title('Amplitudengang nach Fensterung') 
ylabel('Amplitude in dB') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid 