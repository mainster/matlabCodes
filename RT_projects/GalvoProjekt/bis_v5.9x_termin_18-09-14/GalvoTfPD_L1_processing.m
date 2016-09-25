% processing GalvoTfPD_L1.mdl
%
oldLines=findall(0,'type','line');    % Inhalte der letzten plots löschen, figure handle behalten
delete(oldLines);

%[A,b,c,d]=linmod('RCL_netzwerk_als_block');
[A,b,c,d]=linmod('GalvoTfPD_L1');

sys=ss(A,b,c,d);

%sim('RCL_netzwerk_als_block.mdl');
sim('GalvoTfPD_L1.mdl');
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

% convert statespace to transferfunction zp=zaehlerpolynom
[zp, np]=ss2tf(A,b,c,d);
w0=7720;
eps=0.65;
Hgts=tf(w0^2,[1 2*eps*w0 w0^2]);

subplot(211);
step(Hgts); grid on;
subplot(212);
bode(Hgts); grid on;
