% Raised-Cosine Filter / Pulsform
%
jump=@(x) (0.5*sign(x)+0.5);

fs=2    % symbol frequency
r=0.5   % roll- off factor
fn=fs/2  % Nyquist frequency --> fn=fs/2 (half the symbol frequency)

f=[-3:0.01:3];
t=[-3:0.01:3];

Hrc= @(f) (cos(pi/4*(abs(f)-(1-r)*fn)/(r*fn))).^2 .* (jump(f+(1+r)*fn)-jump(f-(1+r)*fn))
Hrc2= @(f) -( ((cos(pi/4*(abs(f)-(1-r)*fn)/(r*fn))).^2 -1).* (jump(f+(1-r)*fn)-jump(f-(1-r)*fn)))

h=@(t) 2*fn* sin(2*pi*fn*t)/(2*pi*fn*t) * cos(2*pi*r*fn*t)/(1-(4*r*fn*t).^2) 

%h(0)
%plot(f,Hrc(f))
%figure
plot(f,Hrc(f)+Hrc2(f))
%figure
%plot(t,h(t))
hold off