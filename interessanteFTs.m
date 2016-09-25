% interessante Fouriertransformierte
%

fa=1e6;
fn=2*fa;
fc=1e2;
Tc=1/fc;
Ta=1/fa;
N=10e3*Tc; 

h=sin(pi*fc*t)./(pi*fc*t);

plot(t,h);grid on;