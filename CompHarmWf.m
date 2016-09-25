function [y]=CompHarmWf( f0,Ar,Ai,phi,Off,fa )
% CompHarmWf creates a Complex Harmonic Wave Form
% CompHarmWf( f0,Ar,Ai,phi )
% List of parameters:
%   f0 = signal frequency /MHz
%   Ar = Amplitude of the real part of the Waveform
%   Ai = Amplitude of the imaginary part of the Waveform
%   phi = difference of phase
%   Off = Offset
%   fa = sample frequency /MHz 

fa=160;
f0=19.2;
Ar=1.2;
Ai=0.8;
phi=0;
Off=0;

%y=(Ar.*cos((2*pi*f0).*t)+Off)+1i*(Ai.*sin((2*pi*f0).*t+phi)+Off);
%k=lcm(f0,fa);               %least common multiple of corresponding elements
%tx=lcm(k,32);                   %least common multiple of corresponding elements
t=0:1/fa:256/fa;

y1=Ar.*cos((2*pi*f0).*t);             % reeles Signal f�r Realteil
y2=Ai.*sin((2*pi*f0).*t+phi);           % reeles Signal als Imagin�rteil

y=y1+1i*y2;
y=y*((2^14)-1);
y=y+Off;

figure(1)
plot(t,real(y));
figure(2)
plot(t,imag(y));
figure(3)
plot(10*log10(psd(y)));grid;
figure(4)
plot(real(y),imag(y));


figure(1)
title('Real')
xlabel('t')
ylabel('Real-Part')
figure(2)
title('Imag')
xlabel('t')
ylabel('Imag-Part')
figure(3)
title('Spektrum')
xlabel('f/MHz')
ylabel('abs()')
figure(4)
title('Ortskurve')
xlabel('Real')
ylabel('Imag')
end