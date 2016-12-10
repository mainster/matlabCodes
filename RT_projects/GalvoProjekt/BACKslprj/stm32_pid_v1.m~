%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Regleralgorythmen auf stm32f4-disco testen
%%%% und mit matlab ergebnisse vergleichen
%%%%
%%%% Testprozess ist ein Tp 2. Ordnung 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delete(findall(0,'type','line'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% kleiner workaround wegen Simulink SegFault %%%
%%% bei geöffneten scope- views                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
open_bd = find_system('type', 'block_diagram');
ind=find(~cellfun(@isempty, strfind(open_bd,'stm32_pid_v1_mod')))

if isempty(ind)
    disp('blockdiagram not found')
else
    save_system(open_bd(ind));
    close_system(open_bd(ind));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

cd('/home/mainster/CODES_local/matlab_workspace/RT_projects/GalvoProjekt/')
MOD='stm32_pid_v1_mod';

open(MOD);

syms r1 r2 r3 c1 c2 s R C
par=@(x,y) (x*y)/(x+y);

% 
% z1A=1/(s*C);
% z3A=par(R,1/(s*C));
% H1A=(par(z1A,(R+z3A)))/(par(z1A,(R+z3A))+R);
% H2A=z3A/(z3A+R);
% G2A=H1A*H2A
% 
% pretty(G2A)
% 
% return

r1=12e3;
r2=12e3;
r3=120e15;
c1=220e-9;
c2=220e-9;


z1=1/(s*c1);
z3=par(r3,1/(s*c2));
H1=(par(z1,(r2+z3)))/(par(z1,(r2+z3))+r1);
H2=z3/(z3+r2);
G2=H1*H2;
g2=sym2tf(G2);

[z, p, k]=zpkdata(g2)
Gp=zpk(z,p,k);
tf2spiceLaplace(g2)

[num, den]=tfdata(g2);
disp('residue:')
[r, pr, kr]=residue(num{:}, den{:})
sprintf('Time constants: T1=%0.2e  T2=%0.2e',-1/pr(1),-1/pr(2))

[z, p, k]=tf2zpk(num{:}, den{:})
%dcGain=dcgain(g2)
%dcGainLog=20*log10(dcGain)

%%
opts = pidtuneOptions('PhaseMargin',40);
[Csis, info] = pidtune(( g2 ),'pidf',opts);

opts = pidtuneOptions('PhaseMargin',40);
[Csis2, info] = pidtune(( g2 ),'pid',opts);


%------------------------------------------------
%--  c2d   --------------------------------------
%------------------------------------------------
Ts=50e-6

opts = pidtuneOptions('PhaseMargin',40);
[Cpidf, info] = pidtune(( g2 ),'pidf',opts)

CpidfD=c2d(Cpidf,Ts,'zoh')
GpD=c2d(Gp,Ts,'zoh');

%------------------------------------------------
%--  Regler Koeffizienten nach "RT einführung"
%--  Heinz Mann
%------------------------------------------------

Kp=CpidfD.Kp;
Ki=CpidfD.Ki;
Kd=CpidfD.Kd;
Tf=CpidfD.Tf;
Ts=CpidfD.Ts;

% integration method: backwards square
b_bws(1) = Kp + Ki*Ts + Kd/Ts;
b_bws(2) = -(Kp + 2*Kd/Ts);
b_bws(3) = Kd/Ts; 

% integration method: triangle
b_tr(1) = Kp + Ki*Ts/2 + Kd/Ts;
b_tr(2) = -(Kp - Ki*Ts/2 + 2*Kd/Ts);
b_tr(3) = Kd/Ts; 

sprintf('backwards square coeffs:\nb0 = %.2e  \nb1 = %.2e  \nb2 = %.2e\n',...
    b_bws(1),b_bws(2),b_bws(3))

sprintf('triangular coeffs:\nb0 = %.2e  \nb1 = %.2e  \nb2 = %.2e\n',...
    b_tr(1),b_tr(2),b_tr(3))


% CpidfD zerlegen:
tfCpidfD=tf(CpidfD)
%[r1, p1, k1]=residue(tfCpidfD.num{1},tfCpidfD.den{1})
G0=tf(1,[1 1],CpidfD.Ts);
[G0.num{1}, G0.den{1}]=dlinmod(MOD,CpidfD.Ts);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 10 %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f10=figure(10);
SUB=220;

subplot(SUB+1);
step(feedback(Cpidf*Gp,1))
legend('Cpidf*Gp');

subplot(SUB+2);
hold all;
step(feedback(CpidfD*GpD,1))
    Tfback=CpidfD.Tf;
    CpidfD.Tf = 0;
step(feedback(CpidfD*GpD,1))
hold off

legend('CpidfD*GpD');
CpidfD.Tf = Tfback;     % restore Tf

subplot(SUB+3);
step(feedback(G0,1))
legend('feedback(G0,1)');


return

sisotool(GpD,CpidfD)

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=220;

subplot(SUB+1);
rlocus(g2)
xlim([1.1*min(p) 0.5*abs(max(p))]);
legend('G');
grid off;
toc

subplot(SUB+2);
hold all;
step(feedback(g2*Csis,1));
step(feedback(g2*Csis2,1));
hold off
legend('G*Csis','G*Csis2');
toc

subplot(SUB+3);
rlocus(g2*Csis)
xlim([1.1*min(p) 0.5*abs(max(p))]);
legend('G*Csis');
grid off;
toc

subplot(SUB+4);
rlocus(g2*Csis2)
xlim([1.1*min(p) 0.5*abs(max(p))]);
legend('G*Csis2');
grid off;
toc
%------------------------------------------------
%--  c2d   --------------------------------------
%------------------------------------------------
Ts=250e-6;

Csisd=c2d(Csis,Ts,'zoh');
g2d=c2d(g2,Ts,'zoh');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 2 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
SUB=220;

subplot(SUB+1);
hold all;
step(feedback(g2*Csis,1));
step(feedback(g2d*Csisd,1));
hold off
legend('g2*Csis','g2d*Csisd');

Csis.Kp=40; Csis.Ki=0; Csis.Kd=0; Csis.Tf=0;  
Csisd.Kp=40; Csisd.Ki=0; Csisd.Kd=0; Csisd.Tf=0;  
subplot(SUB+2);
hold all;
step(feedback(g2*Csis,1));
step(feedback(g2d*Csisd,1));
hold off
legend('g2*Csis','g2d*Csisd');

opts = pidtuneOptions('PhaseMargin',40);
[Csis, info] = pidtune(( g2 ),'pidf',opts);

opts = pidtuneOptions('PhaseMargin',40);
[Csis2, info] = pidtune(( g2 ),'pid',opts);

Csisd=c2d(Csis,Ts,'zoh');
Csis2d=c2d(Csis2,Ts,'zoh');
g2d=c2d(g2,Ts,'zoh');

subplot(SUB+3);
hold all;
step(feedback(g2*Csis,1)/g2);
step(feedback(g2d*Csisd,1)/g2d);
hold off
legend('g2*Csis','g2d*Csisd');


return
disp('--------------')

syms r1 r2 r3 c1 c2 s

r2=r1;
c2=c1;
z1=1/(s*c1);
z3=par(r3,1/(s*c2));
H1=(par(z1,(r2+z3)))/(par(z1,(r2+z3))+r1);
H2=z3/(z3+r2);
G2=H1*H2;
pretty(G2)

