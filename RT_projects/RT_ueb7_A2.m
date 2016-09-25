
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OS als funktion von K plotten, bei gegebenem G(s)
% gibt es z.T. mehrere Werte für K wo der OS der 
% Sprungantwort identisch ist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RT Uebung 2013-2014 Uebung 7 A2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delete(findall(0,'type','line'));

tic 

syms p K;
clear Kv os;

%%%%%%%%%%%%%%%%%%%%%%
%%%%% figure 8 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

f8=figure(8);
SUB=520;
alpha=2;

G0=K*10*(p+1)./(p^2*(p+24));
Gcs=sym2tf(10*(p+1)./(p^2*(p+24)));

GtotSym=G0./(1+G0);

Kv=[1e-3; 1e-2; 1e-1; 1; 250];
legStr=[];

col={'red','green','blue','magenta','cyan'};

for i=1:5
%    Gtot(i)=sym2tf(simplify( subs( GtotSym,'K',Kv(i)') ));
    Gtot(i)=feedback(Kv(i)*Gcs,1);
    subplot(SUB+2*i-1);
    step(Gtot(i),col{i});
    legStr=[legStr sprintf('K=%.3f:',Kv(i))];
    legend(sprintf('K=%.3f',Kv(i)));
    xlabel('');
    title('');
end
legStr(end)=[];

subplot(5,2,[2 4 6]);
hold on;
for i=1:5
    pzmap(Gtot(i),col{i});
end
hold off;
xlabel('');
title('');
legend(strsplit(legStr,':'));

subplot(5,2,[8 10]);
hold on;
for i=1:5
    pzmap(Gtot(i),col{i});
end
hold off;
xlabel('');
title('');

legend(strsplit(legStr,':'));
axis([-2 0.2 -1 1]);

%%%%%%%%%%%%%%%%%%%%%%
%%%%% figure 9 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
f9=figure(9);
SUB=120;

Kmin=0; Kmax=100; nK=200;

ti=[0:0.1:10];
Kv=linspace(Kmin,Kmax,nK);

for i=1:length(Kv)
%    Gtot(i)=sym2tf(simplify( subs( GtotSym,'K',Kv(i)') ));
    Gtot(i)=feedback(Kv(i)*Gcs,1);
    [yy tt]=step(Gtot(i),10);
    os(i)=max(yy);
end

dKv=abs(Kmin-Kmax)/nK;

[r c]=find(os>=1.195 & os<=1.21);
c=[c c(end)*2];

for i=1:length(c)-1
    if abs(c(i)-c(i+1))>=2
        cc(i)=c(i);
    else
        cc(i)=0;
    end
end

cc(cc==0)=[];   % Delete Zero components

subplot(SUB+1);
plot(Kv,os);
grid on;
title('OS als funktion von K')
xlabel('K');

str=[];
for i=1:length(cc)
    line([cc(i) cc(i)]*dKv,[0 1.8],'Linestyle','--','Color','red');
    str=[str '\tK=%.2f\t'];
end

str=['20%% os bei:' str];
sprintf(str,cc*dKv)

subplot(SUB+2);
hold all;
legStr=[];
for i=1:length(cc)
    tmp=feedback(cc(i)*dKv*Gcs,1);
    step(tmp);
    legStr=[legStr sprintf('K=%.2f:',cc(i)*dKv)];
end
grid on;
legStr(end)=[];
legend(strsplit(legStr,':'));

%%%%%%%%%%%%%%%%%%%%%%
%%%%% figure 10 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
f10=figure(10);
SUB=120;

subplot(SUB+1);
rlocus(Gcs)
legend('Gcs')

subplot(SUB+2);
rlocus(feedback(1*Gcs,1))
legend('feedback(1*Gcs,1)')


ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');

toc

return