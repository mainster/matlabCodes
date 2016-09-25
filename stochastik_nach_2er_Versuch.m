% Gegeben ist ein Spektrum F(w) und ein periodisches Rechtecksignal r(t) im 
% Zeitbereich mit r0(t)=rect((t-T/4)/T)
syms w w0 f f0 T real
assumeAlso([w0,f0,T] > 0);

%F=@(w,f0) 1/f0*w/pi2*rect((w/pi2-f0/2)/f0)+( 1/f0*(-w/pi2)*rect((-w/pi2-f0/2)/f0) );
Fa=@(f,f0) 1/f0*f*rect((f-f0/2)/f0)+( 1/f0*(-f)*rect((-f-f0/2)/f0) );
r0=@(t,T) rect((t-.5*T/2)/(.5*T));
r0=@(t,T) rectpuls(t,T);

tt = 0:1/1e3:1;         % 1 kHz sample freq for 1 s
dd = 0:1/3:1;           % 3 Hz repetition frequency
yy = pulstran(tt,dd,'rectpuls',.1);


f1=figure(1);
SUBS = 220;

f0_=1e3;
w0_=2*pi*f0_;
T_=5e-3;

sp(1)=subplot(SUBS+1);
ezplot(Fa(f,f0_),[-1,1]*2*f0_)
legend 'Fa(f)'

fa = ifourier(Fa(f,f0),f,t);
fa = simplify(fa,'steps',150);

fa = str2func(['@(t,f0)' char(fa)])
pretty(fa(f,f0))

sp(2)=subplot(SUBS+2);
ezplot(fa(t,f0_),[-1,1]*6*T_);
set(gca,'YLimMode','auto')
legend 'fa(t)'

sp(3)=subplot(SUBS+3);
%ezplot(r0(t,T_),[-1,1]*3*T_);
plot(tt,yy)
set(gca,'YLimMode','auto')
legend 'r0(t)'

sp(4)=subplot(SUBS+3);
%ezplot(r0(t,T_),[-1,1]*3*T_);
ezplot(r0([0:1e-3:1],T_))
set(gca,'YLimMode','auto')
legend 'r0(t)'

