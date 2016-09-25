M = 100;
n = -M:M;
Nx = 2*M+1;
tg = 3/4;
x = tg*sinc(tg*n);
% cut-off frequency
% signal with rectangular
% low pass spectrum
T = 6;
g = ones(1,T);
% interpolation function
y = [];
for n = 1:Nx
y = [y x(n)*g];
% stair case signal
end
Y = fft(y);
% spectrum of interpolated signal
Ny = length(y);
f = linspace(0,T,Ny/2+1);
% frequency axis

p1=figure(1);
subplot(321);
plot(f,abs(Y(1:Ny/2+1)));
xlabel('\theta/\pi'), ylabel('|Y(e^{j\theta})|'), grid on;
title('spectrum of stair case interpolation');


th = [0:M]/Nx;
Hc = 1./sinc(th).*exp(j*pi*th); % sin x/x compensation function
Yc = Hc .* Y(1:M+1);
subplot(322)
plot(2*th,abs(Y(1:M+1)),2*th,abs(Yc));
xlabel('\theta/\pi');
ylabel('|Y(e^{j\theta})|, |Y_c(e^{j\theta})|'), grid on;
title('sin x/x compensation');