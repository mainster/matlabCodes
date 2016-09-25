% Nyquist kriterium, stabilität und pole
% Loop gain / Kreisverstärkung
%
% http://www.mathworks.de/de/help/control/examples/assessing-gain-and-phase-margins.html
%
delete(findall(0,'type','line'))


% Nochmal nyquist plot
% 

% s1=tf([1],[1 1])
% s2=s1*s1
% s3=s1*s1*s1
% 
% f2=figure(2);
% nyquist(s1,s2,s3,s2*s2);
% legend(char(tf2sym(s1)),char(tf2sym(s2)),char(tf2sym(s3)))
% break;

%block1='nyquist_stab_mod/Subsystem'
SIM_MODEL='loopgain_stability_nyquist';

fb=1;
Kp=0.2;

plant1=struct('num',[0.5 1.3],'den',[1 1.2 1.6 0]);
plant2=struct('num',[1],'den',[4 5 1 0]);

plant=plant2;

block1=[SIM_MODEL '/fb'];
outPort=1;
[cm,~,~,info]=loopmargin(SIM_MODEL,{block1},outPort)

GainMargin=20*log(cm.GainMargin(1))
PhaseMargin=cm.PhaseMargin

fb=1;
[num den]=linmod(SIM_MODEL);    % get closed loop linear model
[z,p,k]=tf2zpk(num,den);
Gtot=zpk(z,p,k)

fb=0;
[num2 den2]=linmod(SIM_MODEL);    % get closed loop linear model
[z,p,k]=tf2zpk(num2,den2);
G0=zpk(z,p,k)

f1=figure(1);

SUB=240;
cla
subplot(SUB+1);
nyquist(Gtot);
legend('Gtot')
subplot(SUB+5);
nyquist(G0);
legend('G0')

subplot(SUB+2);
rlocus(Gtot)
legend('Gtot')
subplot(SUB+6);
rlocus(G0)
legend('G0')
grid off;

subplot(SUB+3);
pzmap(Gtot)
legend('Gtot')
subplot(SUB+7);
pzmap(G0)
legend('G0')

subplot(SUB+4);
bode(Gtot)
legend('Gtot')
subplot(SUB+8);
bode(G0)
legend('G0')

grid on;



   

