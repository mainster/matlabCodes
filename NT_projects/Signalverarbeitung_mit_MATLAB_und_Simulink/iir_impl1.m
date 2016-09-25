% Programm iir_impl1.m zur Implementierung
% eines IIR-Filters

p = 3;    % Anzahl der Abschnitte 2. Ordnung
N = 500;  % Anzahl der Eingangswerte die gefiltert werden müssen

Rp = 0.1;
Rs = 60;
fr = 0.4;

[b,a] = ellip(2*p, Rp, Rs, fr);
sos = tf2sos(b,a);      % Matrix der Koeffizienten
s1 = 1;                 % Skalierungsfaktor

% -------- Eingangssignal
fr1 = fr*0.4/2;                 % Relative Frequenz im Durchlassbereich
fr2 = fr*2/2;                   % Relative Frequenz im Sperrbereich
x1 = sin(2*pi*(0:N-1)*fr1);          % Signal im Durchlassbereich
x2 = 2*sin(2*pi*(0:N-1)*fr*2/2);   % Signal im Sperrbereich
x = x1 + x2;

% ------- Ausgangssignal
y = zeros(1,N);
w = zeros(p, 3);         % Zwischenwerte (w(k))

m = 1;  n = 1;
for k = 1:N
    e = s1*x(k);
    for i = 1:p
        w(i,n) = e + (-sos(i,m+4)*w(i,n+1) -sos(i,m+5)*w(i,n+2))/sos(i,m+3);
        e = sos(i,m)*w(i,n) + sos(i,m+1)*w(i,n+1) + sos(i,m+2)*w(i,n+2);
        w(i,n+2) = w(i,n+1);
        w(i,n+1) = w(i,n);
    end;
    y(k) = e;
end;   

% ----------------------------------
figure(1);     clf;
nd = 1:fix(N/5);
subplot(221), plot(nd-1, x(nd));
title(['Eingangssignal (fr1 = ',num2str(fr1),' ; fr2 = ',num2str(fr2),' )']);
xlabel('Zeit in s');   grid;
subplot(223), plot(nd-1, y(nd));
title(['Ausgangssignal (relative Durchlassfrequenz = ', num2str(fr/2),' )']);
xlabel('Zeit in s');   grid;

% ------Messen des Frequenzgangs
% Erstes Verfahren über die Einheitspulsantwort
N = 500;
x = [1, zeros(1,N-1)];
y = zeros(1,N);
w = zeros(p,3);         % Zwischenwerte (w(k))

m = 1;  n = 1;
for k = 1:N
  e = s1*x(k);
  for i = 1:p
     w(i,n) = e + (-sos(i,m+4)*w(i,n+1) -sos(i,m+5)*w(i,n+2))/sos(i,m+3);
     e = sos(i,m)*w(i,n) + sos(i,m+1)*w(i,n+1) + sos(i,m+2)*w(i,n+2);
     w(i,n+2) = w(i,n+1);
     w(i,n+1) = w(i,n);
  end;
  y(k) = e;
end;   

% --------FFT des Eingangs- und Ausgangs
X = fft(x);
Y = fft(y);
H = Y./X;

subplot(222), plot((0:N-1)/N, 20*log10(abs(H)));
title(['Amplitudengang (ueber Einheitspulsantwort)']);
xlabel('f/fs');   grid;
La = axis;    axis([La(1:2), -100, 10]);

subplot(224), plot((0:N-1)/N, angle(H));
title(['Phasengang des IIR-Filters ']);
xlabel('f/fs');   grid;

% -------------------------------------------------------------------
% Zweites Verfahren mit weißem Rauschen am Eingang
x = [randn(1,N), zeros(1,N)];
y = zeros(1,2*N);
w = zeros(p,3);         % Zwischenwerte (w(k))

m = 1;  n = 1;
for k = 1:2*N
  e = s1*x(k);
  for i = 1:p
     w(i,n) = e + (-sos(i,m+4)*w(i,n+1) -sos(i,m+5)*w(i,n+2))/sos(i,m+3);
     e = sos(i,m)*w(i,n) + sos(i,m+1)*w(i,n+1) + sos(i,m+2)*w(i,n+2);
     w(i,n+2) = w(i,n+1);
     w(i,n+1) = w(i,n);
  end;
  y(k) = e;
end;   

% --------FFT des Eingangs- und Ausgangs
X = fft(x);
Y = fft(y);
H = Y./X;

figure(2);      clf;
subplot(221), plot((0:2*N-1)/(2*N), 20*log10(abs(H)));
title(['Amplitudengang (ueber weisses Rauschen)']);
xlabel('f/fs');   grid;
La = axis;    axis([La(1:2), -100, 10]);

subplot(223), plot((0:2*N-1)/(2*N), angle(H));
title(['Phasengang des IIR-Filters ']);
xlabel('f/fs');   grid;


% -------------------------------------------------------------------
% Drittes Verfahren (der nlm-Methode ähnlich)
Hm = zeros(1,N);
for L = 1:1;
   x = real(ifft(exp(j*rand(1,N)*2*pi)));
   x = [x,x];
   y = zeros(1,2*N);
   w = zeros(p,3);         % Zwischenwerte (w(k))

   m = 1;  n = 1;
   for k = 1:2*N
     e = s1*x(k);
     for i = 1:p
        w(i,n) = e + (-sos(i,m+4)*w(i,n+1) -sos(i,m+5)*w(i,n+2))/sos(i,m+3);
        e = sos(i,m)*w(i,n) + sos(i,m+1)*w(i,n+1) + sos(i,m+2)*w(i,n+2);
        w(i,n+2) = w(i,n+1);
        w(i,n+1) = w(i,n);
     end;
     y(k) = e;
   end; 
end;   
% --------FFT des Eingangs- und Ausgangs
X = fft(x(N+1:2*N));
Y = fft(y(N+1:2*N));
Hm = Hm + Y./X;
Hm = Hm/L;

subplot(222), plot((0:N-1)/N, 20*log10(abs(Hm)));
title(['Amplitudengang (ueber nlm-Methode)']);
xlabel('f/fs');   grid;
La = axis;    axis([La(1:2), -100, 10]);

subplot(224), plot((0:N-1)/N, angle(Hm));
title(['Phasengang des IIR-Filters ']);
xlabel('f/fs');   grid;
% -------------------------------------------------------------------
