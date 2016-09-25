%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compare fourier series and fourier transformation
% Stochastik 28-12-2015        SS14715  A.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourier reihe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'));
clearvars('-except',INITIALVARS{:})
%%
T0_ = 1e-3;

% Periodic continous x(t)
x0=@(t,T0) tri(t/(T0/4));
xn=@(t,T0,N) sum(tri((t-(-N:N)*T0)/(T0/4)));

f1=figure(1);
N_=3; 
tt=lin(-N_*T0_/2,N_*T0_/2,200); 
plot(tt, subs(xn(t,T0_,N_),t,tt)); hold all; 

N_=1; 
tt=lin(-N_*T0_/2,N_*T0_/2,200); 
plot(tt, subs(xn(t,T0_,N_),t,tt),'LineWidth',2); hold off; 
ylim([-.1 1.1])

%% Fourier transform x0(t) o--o X0(w) of the non-periodic function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X0=str2func(['@(w,T0)' char(fourierS(x0,t,w))]);
X0=dotExpansion(X0);

f2=figure(2);
ezplot(X0(w,T0_),[-1 1]*10*2*pi/T0_)

w0_=2*pi/T0_;
fprintf('T0=%g --> f0=%g --> w0=%g\n\n', T0_, 1/T0_, w0_)

areaT='int(x0(t,T0_),t,-inf,+inf)';
areaW='int(X0(w,T0_),w,-inf,+inf)/pi2 == x0(0,T0_)';
fprintf('%s:  %g\n',areaT, double(eval(areaT)));
fprintf('%s:  %g\n',areaW, double(eval(areaW)));

%% Fourier transform x0(t) o--o X0(w) of the non-periodic function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_=10;
cnx=w0_*(-N_:N_);
cny = X0(cnx,T0_); %/pi2;
cny(find(isnan(cny))) = limit( X0(w,T0_), w, 0);

figure(f2); hold all
plot(cnx, cny,'o')
%cn=@(n) int(x0(t,T0)*exp())

%% Fourier series part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Complex fourier coeffs
syms n 'integers'

cn  = @(n,T0,funh) 1/T0*int(funh.*exp(-1i*n*w0*t),t,-T0/2,T0/2)
cn_ = simplify( cn(n,T0,x0(t,T0)), 'steps', 50 )
%cn_ = dotExpansion(cn_)

return



%%
clear x a c
syms x T w real
assumeAlso([T] > 0);
T0=1e-3;
Ttr=T0/4;    % periode parameter for tri

x=@(t)tri(t/Ttr);
f1=figure(1);
ezplot(x(t),[-T0/2,T0/2]);
set(gca,'XTick',[-T0/2:T0/4:T0/2])

%%

X=simplify(fourier(x(t),t,w),'steps',150);
X=str2func(['@(w,T)' char(X)]); 
X=dotExpansion(X); 
ww=lin(-3*2*pi/Ttr,3*2*pi/Ttr,100); 
%%
f2=figure(2);
plot(ww,X(ww,T0)); hold all; 
plot([-1,1]*2*pi/Ttr,[0,0],'X','MarkerSize',15,'LineWidth',2); 
hold off;
