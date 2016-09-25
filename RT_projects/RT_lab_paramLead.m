% Parametrierung eines Lead glieds
% C(s)=
if exist('f100')
    if exist('f101')
        delete(findall(f100,'type','line'))
        delete(findall(f101,'type','line'))
    end
end
% Lead mit konstantem k
f100=figure(100);

k=1;T=10;
a=[2 3 5 8];

hold all;

for i=1:length(a)
    bode([a(i)*T 1],[T 1]);
end;
grid on;
title('Lead mit konstantem k --> |A(w->inf)| = k*a')

hold off;


% Lead mit skalierung von k für hohe freq. A=0dB

f101=figure(101);

k=1;T=10;
a=[2 3 5 8];

hold all;

for i=1:length(a)
    bode((k./a(i))*[a(i)*T 1],[T 1]);
end;
title('Lead mit skalierung von k für hohe freq.: A=0dB');
grid on
hold off;


