% Lead Beispiel 
% IST
% Einfacher loop-shaping Entwurf
% http://www.ist.uni-stuttgart.de/education/courses/RTI/

delete(findall(0,'type','line'));

%%%% Plant %%%%
G=zpk([],[-0.5 -1 -5],[10]);

% P-Regler
Cp=1.7;
% Cp(s) = Cp 
% Die Ortskurve besteht nur aus einem Punkt auf der reellen Achse bei KP . Der Amplitudengang besteht
% aus einer Parallelen zur !-Achse im Abstand logKP von der 0 dB-Linie. Die Phase ist fur alle ! gleich
% null. Man hat nur einen Parameter KP um den Verlauf von GK im Bode-Diagramm zu beein
% ussen.

syms Kp Ki Ti p
% PI- Regler
CpiSym(1)=Kp*(p+Ki/Kp)/p;
CpiSym(2)=Kp*(p+1/Ti)/p;

% Hier stehen zwei Parameter, KP und TI , zum loop-shaping zur Verfugung. Auch hier sei wieder das
% prinzipielle Bode-Diagramm eines PI-Reglers dargestellt (Abbildung 6). Der Verstarkungsfaktor KP des
% PI-Reglers bewirkt ausschlielich eine Verschiebung des Amplitudenganges nach oben bzw. nach unten,
% ohne die Phase zu verandern. Der Parameter TI verandert die Form des Bode-Diagramms. Wie man
% aus dem Phasengang des PI-Reglers entnehmen kann, bewirkt er fur Frequenzen groer als 1
% 1/TI keine Phasendrehung mehr. Der Vorteil der PI-Parametrierung mit KP und TI gegenuber der Parametrierung
% mit KP und KI ist, da man die Eckfrequenz und die Verstarkung fur groe Frequenzen unabhangig
% voneinander einstellen kann.

vTi=1e2;
vKp=1.7;
vKi=vKp/vTi;

Cpi(1)=sym2tf(subs(CpiSym(1),{'Kp','Ki'},{vKp,vKi}));
Cpi(2)=sym2tf(subs(CpiSym(2),{'Kp','Ti'},{vKp,vTi}));

wd=1.7;

f1=figure(1);
SUB=120;

wrange={1e-3,1e2};

subplot(SUB+1);
hold all;
bode(G,wrange);
bode(Cpi(2),wrange);
bode(Cpi(2)*G,wrange);

childrenHnd = get(f1, 'Children');
axes(childrenHnd(3))    % Magnitude
line([wd wd],[-200 50],'color','red','linestyle','--');
axes(childrenHnd(1))    % Phase
line([wd wd],[-270 50],'color','red','linestyle','--');

hold off;
legend('G(s)','Kpi(Kp,Ki)','Kpi(Kp,Ti)*G');
grid on;



P = nyquistoptions;
P.ShowFullContour = 'off'; 

subplot(SUB+2);
hold all;
nyquistplot(G,P);
nyquistplot(Cpi(1),P);
nyquistplot(Cpi(2),P);
hold off;
legend('G(s)','Kpi(Kp,Ki)','Kpi(Kp,Ti)');
axis([-1.2 5 -3 .5]);




s10=sym2tf( 1/p );
s11=sym2tf( 1/(p+1) );
s21=sym2tf( 1/(p^2+1) );
s22=sym2tf( 1/(p^2+2) );
s301=sym2tf( 1/(p^3+1) );
s310=sym2tf( 1/(p^3+p^2) );
s311=sym2tf( 1/(p^3+p^2+1) );

sv=[s10; s11; s21; s22; s301; s310; s311];
f2=figure(2);
SUB=120;

subplot(SUB+1);
hold all;

leg=[];
for i=1:max(size((sv)))
    nyquist(sv(i),P)
    leg=[leg sprintf('%s:',char( tf2sym(sv(i))))];
end

axis([-2 2 -2 2]);
legend(strsplit(leg,':'));


f3=figure(3);

hold all;

nyquist(sv,P)

leg=[];
for i=1:max(size((sv)))
    leg=[leg sprintf('%s:',char( tf2sym(sv(i))))];
end

axis([-2 2 -2 2]);
%legend(strsplit(leg,':'));

hold off;