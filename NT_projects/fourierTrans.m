function [y,t] = fourierTrans(ua,N,f,ap)

T=1/f;
w=2*pi*f;
n=1:N;
t=0:1/(f*f):T*ap;
y=0;
y2=0;
y3=0;

y = (2*ua / (pi)) * (1./n) * sin(w*n'*t); 

for n = 1:N
    y3 = y3 + [(2*ua / (pi)) * (1/n) * sin(2*pi*f*n*t)];
    figure(3)
    plot(t,y3)
    grid on
    hold on
    xlabel('t in s')
    ylabel('A in V')
    title('\it{harmonische Sinusschwingungen}','FontSize',16)

end  

y2=(-2*ua .*rem(t,T) ./T) + ua;
figure(1)
plot(t,y)
grid on
xlabel('t in s')
ylabel('A in V')
title('\it{Fouriertransformierte}','FontSize',16)
figure(2)
plot(t,y2)
grid on
xlabel('t in s')
ylabel('A in V')
title('\it{Sägezahnsignal}','FontSize',16)