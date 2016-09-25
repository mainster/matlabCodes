%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Softwareimplementierung der ganzen PID, PIDF (FWD), (BWD)...
% anhand einfacher Strecken prüfen...
% 
% Strecke 1:    passiver Tiefpass 2. Ordnung mit 
%               R1 = R2 = 1.2k und C1 = C2 = 220nF
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%         ____        ____   
%  Ue ---|_R1_|--+---|_R2_|--+----> ADC
%                |           |
%           C1 ~~~~~    C2 ~~~~~ 
%              ~~~~~       ~~~~~ 
%                |           |
%                |           |
%               _|_         _|_
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'));

par = @(x,y) (x.*y)./(x+y);
syms R1 R2 C1 C2 p

Ts = 50e-6;
Gs=1/(1+p*R1*C1) * 1/(1+p*R2*C2);
G1=sym2tf(subs(Gs,{'R1','R2','C1','C2'},{1.2e3,1.2e3,220e-9,220e-9}))

G1d=c2d(G1,Ts,'zoh');
C0 = pid(1,1,1,'Ts',Ts,'Tf',1,...
        'IFormula','BackwardEuler','DFormula','BackwardEuler')

[Cpid,info] = pidtune(G1d, C0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Ts*z               1      
%   C = Kp + Ki * ------ + Kd * -------------
%                   z-1         Tf+Ts*z/(z-1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tf = 1/N;
% 
% yd = yd[k]        yd_1 = yd[k-1]
% e = e[k]          e_1 = e[k-1]
%
Kp = Cpid.Kp;
Ki = Cpid.Ki;
Kd = Cpid.Kd;
Tf = Cpid.Tf;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   Figure 1    %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1 = figure(1);
SUB = 220;

subplot(SUB+1);

[yout,tout]=step(feedback(Cpid*G1d,1));
plot(tout,yout); grid on;
legend('feedback(Cpid*G1d,1)');

w = ones(1,length(tout));

youtS=dPID_self(w, yout, tout, Kp, Ki, Kd, Tf, Ts);

subplot(SUB+2);
plot(tout,youtS); grid on;
legend('youtS');






