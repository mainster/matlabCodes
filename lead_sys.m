% Lead glied

delete(findall(0,'type','line'));

% Lag- Glied "nacheilend"
% G(s)=k*(1+T*s)/(1+a*T*s)  a > 1

syms p;

%%%%%%%%%%%%%%%%%%%%%%%
% Uebertragungsglieder
%%%%%%%%%%%%%%%%%%%%%%%
s1=1/(p+1);
s2=1/(p+1)^2;
s3=1/(p+1)^3;


sys1=sym2tf(s1);
sys2=sym2tf(s2);
sys3=sym2tf(s3);
%syst=sym2tf((s3*s1*s2))
SUB=120;
%SUBS=[4 3];
wrange={1e-1,1e2};
s=tf('s');


%%%%%%%%%%%%%%%%%%%%%%%
% Lead glied
%%%%%%%%%%%%%%%%%%%%%%%
clear T a k;
syms T a k;
leadSym=k*(1+T*p)/(1+a*T*p);

T=1/2;  
a=1e-1;
k=1;

da=0.2;
imax=5;

legstr=[];
for i=1:imax
    lead(i)=sym2tf(eval(leadSym));
    wp(i)=1/(T*a);
    wn(i)=1/T;
    phimax(i)=atan(sqrt(wp/wn)*(1-a)/(1+a*wp/wn))*180/pi;
    legstr=[legstr sprintf('a=%.2f:',a)]; 
    a=a+da;
end

%sprintf('wn=%.2f  wp=%.2f  phimax=%.2fdeg  sqrt(wp*wn)=%.2frad  wp-wn=%.2frad  20*log10(k/a)=%.2fdB',...
%    wn,wp,phimax,sqrt(wp*wn),wp-wn,20*log10(k/a))

f1=figure(1);
%%%%%%%%%%%%%%%%%%%%%%%
% subplot 1
%%%%%%%%%%%%%%%%%%%%%%
% Bode
subplot(SUB+1);
hold all;
for i=1:imax
    bode(lead(i));
end
hold off;
title(['lead=' char(leadSym)]);
legend(strsplit(legstr,':'));
grid on;
%title(['sys3=' char(tf2sym(sys3))])
%legend('sys4');

% nyquist 
P = nyquistoptions;
P.ShowFullContour = 'off'; 
subplot(SUB+102);
hold all;
for i=1:imax
    nyquist(lead(i),P)
end
title(['lead=' char(leadSym)]);
hold off;

subplot(SUB+104);
pzmap(lead)

return;

