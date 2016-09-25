% Postprocessing sys2order.mdl
%
oldLines=findall(0,'type','line');    % Inhalte der letzten plots löschen, figure handle behalten
delete(oldLines);

L=0.5;
C=0.5;
R1=0.5;
R2=1.5;

[A,b,c,d]=linmod('RCL_netzwerk_als_block');
sys=ss(A,b,c,d);

sim('RCL_netzwerk_als_block.mdl');
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

subplot(311);
bode(sys); grid on;
subplot(312);
step(sys); grid on;
subplot(313);
impulse(sys); grid on;

% convert statespace to transferfunction zp=zaehlerpolynom
[zp, np]=ss2tf(A,b,c,d)


