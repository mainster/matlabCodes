
% Ql=Rp/(w0*L)
L=1e-9;
Rp=100e3;

w=logspace(6,7,2e3);
Ql=Rp./(w*L);

f1 = figure(1);
semilogx(w,Ql)

f2 = figure(2);
plot(w,Ql)


return
Ql=70; 
Qc=200; 
f0=40e6; 
Igeff=1e-3;

syms f;
f=logspace(6,8,20e3);
f=linspace(1e6,100e6,20e3);

w=2*pi*f;
Rg=2200;
L=153e-9;
C=103e-12;
Rpc=Qc./(w*C);
Rpl=Ql.*w*L;

Ul=(Igeff*Rg*w*L)./(w*L+Rg*Rpl+Rg*w.*L.*Rpc.*w.*C);

plot(w,Ul)