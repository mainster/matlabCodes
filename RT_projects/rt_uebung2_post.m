% Postprocessing sys2order.mdl
%
oldLines=findall(0,'type','line');    % Inhalte der letzten plots löschen, figure handle behalten
delete(oldLines);

%[A,b,c,d]=linmod('RCL_netzwerk_als_block');
[A,b,c,d]=linmod('rt_uebung2');

sys=ss(A,b,c,d);

%sim('RCL_netzwerk_als_block.mdl');
sim('rt_uebung2.mdl');
%t=simoutTime.signals.values;

fig1=figure(1);
% hold on;
% plot(t,UR2_out.signals.values,'b');grid on;
% plot(t,UR1_out.signals.values,'r');grid on;
% %plot(t,y(1:end,2),'g');grid on;
% %plot(t2,outY.signals.values,'b');grid on;
% hold off;
% legend('UR2(t)','UR1(t)')
% xlabel('time [s]')
% ylabel('out')

A
b
c
d


% subplot(311);
% bode(sys); grid on;
% subplot(312);
% step(sys); grid on;
% subplot(313);
% impulse(sys); grid on;

% convert statespace to transferfunction zp=zaehlerpolynom
[zp, np]=ss2tf(A,b,c,d)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  Rationale fkt. als tf-Objekt oder symbolische Ausdrücke 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tf:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=tf('s');
sys1=(s+2)/(s+1);
sys2=1/(s+3);
sys12=series(sys1,sys2) % Entspricht sys12=sys1*sys2;

k=2;
systot=feedback(sys12,k)

ztots=cell2mat(systot.num)
ntots=cell2mat(systot.den)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% symbolisch:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms s1 s2 K p
s1=(p+2)/(p+1);
s2=1/(p+3);
stot=(s1*s2)/(1+s1*s2*K);  % Normalform 
stot=simplify(stot)

stot=subs(stot,'K',2)
[ztot ntot]=numden(stot)
ztotp=sym2poly(ztot)
ntotp=sym2poly(ntot)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tf über funktion mit proportionalfaktor k als parameter:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[A2,b2,c2,d2]=rt_uebung2_post_func(2)
[A4,b4,c4,d4]=rt_uebung2_post_func(4)
[A8,b8,c8,d8]=rt_uebung2_post_func(8)

sysMat=zeros(3,length(ss(A2,b2,c2,d2)));
sys2=ss(A2,b2,c2,d2);
sys4=ss(A4,b4,c4,d4);
sys8=ss(A8,b8,c8,d8);

subplot(311);
hold on;
bode(sys2); grid on;
bode(sys4); grid on;
bode(sys8); grid on;
subplot(312);
hold on;
step(sys2); grid on;
step(sys4); grid on;
step(sys8); grid on;
subplot(313);
hold on;
impulse(sys2); grid on;
impulse(sys4); grid on;
impulse(sys8); grid on;


