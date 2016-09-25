%%%%%%%%%%%%%%%%%%%%%
% Lead tests
%%%%%%%%%%%%%%%%%%%%%
f99=figure(99);
SUB=120;

t=1; k=10;
for i=1:5
    t=i*0.2;
    lead(i)=sym2tf(k*(p+t)/(p+k*t));
end
k=1;
T=22.2;
a=1/100;
wn=1/T
wp=1/(a*T)

lead(6)=sym2tf(k*(1+T*p)/(1+a*T*p));
[c r]=size(lead);

subplot(SUB+1);

hold all;
for i=r:r
    bode(lead(i));
end
hold off
grid on;
hleg=legend('lead');
set(hleg,'FontSize',11)


subplot(SUB+2);

P = nyquistoptions;
P.ShowFullContour = 'off'; 

hold all;
for i=1:r
    nyquistplot(lead(i),P);
end
hold off;









