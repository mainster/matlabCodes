
Are=1;
Aim=1;
phi=0; % [phi]=°
DCre=0;
DCim=0;

fc=15;
fa=160;
Ta=1/fa;
Tc=1/fc;

n=8;

k=(fa/fc)*(n/32);

t=[0:Ta:k*Tc-Ta]; 

sig=sin(2*pi*fc*t);

plot(t,sig)

mod(length(t),32)