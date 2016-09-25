%%% Effekt der Fensterfunktionen
%%% F. Quint, FH Karlsruhe, 12.06.03
close all;

%%% Wunsch: idealer TP realisieren
%%% bei fs=2048Hz, TP mit B=100Hz, W=200Hz
H=zeros(1,2048);
H(925:1124) = 1;
f=-1023:1024;
figure
plot(f,H); axis([-1023 1024 0 1.1]); grid on;
legend(' idealer TP');
%% die Impulsantwort ist unendlich lang
h=ifft(H,2048);
h=fftshift(h);
t= (-0.5 + 1/2048) : 1/2048 : 0.5;
figure;
plot(t,abs(h)); grid on; axis([-0.5 0.5 -0.01 0.1]);
legend('Theoretische Impulsantwort');
%% unendlich ist uns zu lang
%% wir nehmen nur 200 Abtastwerte der Impulsantwort
%% und zwar Rechteck-Fenster der Breite 200/2048 s
%% entspricht Nullstellen der sinx/x bei 2048/200 = 10 Hz = 0.1*B
rect = ones(1,200);
window_rect=zeros(1,2048);
window_rect(925:1124) = rect;

g=h.*window_rect;
figure;
plot(t,abs(g)); grid on; axis([-0.5 0.5 -0.01 0.1]);

%% mit dem abgeschnittenen g realisieren wir tatsächlich diese
%% Systemfunktion:
G=fft(g,2048);
figure
plot(f,abs(G)); axis([-1023 1024 0 1.15]); grid on;

%% und jetzt mit Hamming-Fenster gleicher Länge abschneiden
ham = hamming(200);
window_ham=zeros(1,2048);
window_ham(925:1124) = ham;

d=h.*window_ham;
figure;
plot(t,abs(d)); grid on; axis([-0.5 0.5 -0.01 0.1]);

%% mit dem Hamming-gefensterten d relaisieren wir tatsächlich diese
%% Systemfunktion:
D=fft(d,2048);
figure
plot(f,abs(D)); axis([-1023 1024 0 1.15]); grid on;

%% und zum Vergleich alle drei
figure;
plot(f,abs(H),f,abs(G),f,abs(D)); axis([-1023 1024 0 1.15]); grid on;
legend('gewünscht','Rechteck','Hamming');
