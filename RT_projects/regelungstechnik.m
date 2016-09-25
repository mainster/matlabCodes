% Regelungstechnik mit Matlab
% https://www.google.de/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&ved=0CDAQFjAA&url=http%3A%2F%2Fwww.hs-weingarten.de%2Fc%2Fdocument_library%2Fget_file%3Fuuid%3Dd70537c4-a4fa-4c98-bdc9-7171def7225b%26groupId%3D34058&ei=NcF-UpKXFI7Aswb144DoCQ&usg=AFQjCNE2B92dHtBuHso2eB7V22WW4UmFJw&sig2=p06CkRsv81ay1iJ3S8Za1g&bvm=bv.56146854,d.Yms
% RTL_MATLAB_Einfuehrung_Script_ver6.pdf
% "Einführung in das ProgrammMATLAB / SIMULINK"

num=[1];
den=[0.001 0.8 1];
Gs=tf(num,den);         % Übertragungsfunktion bestehend aus Zähler und Nenner

num=conv([1],[1]);      % Eingabe einer Übertragungsfunktion als Multiplikation von mehreren
den=conv([1 6 10],[1 3]);   % Polynomen, z.B. wenn Pol- und Nullstellen des Systems bekannt
Gs=tf(num,den);         

Gs_zpk=zpk(Gs);         % Umwandlung einer Übertragungsfunktion in die Polform (faktorisierte Form)

% PT2 Glied, periodischer Fall d<1
% Gs=k/(1+2*d*T*s+T^2*s^2)
%
k=1;
T=8e-3;
d=80e-3;
Gs=tf([k],[T^2 2*T*d 1])
GsZpk=zpk(Gs)
%--------------------------------------------------------------
%--------- Grafische Darstellungsmöglichkeiten einer Gs
%--------------------------------------------------------------
DEVPLOT=0;

if DEVPLOT==1
impulse(Gs);            % Impulsantwort (Gewichtsfunktion).
step(Gs);               % Sprungantwort (Übergangsfunktion).
bode(Gs);               % BODE-Diagramm (Frequenzlinien).
nyquist(Gs);            % NYQUIST Ortskurve.
% Unerwünschte Darstellung des negativen Frequenzbereichs kann
% deaktiviert werden durch Rechtsklick mit der Maus auf eine freie
% Fläche neben der Nyquist-Kurve und bei „Show“ den Haken vor
% „Negative Frequencies“ entfernen. Diese Funktion ist nicht mehr
% sichtbar, sobald die Grafik in irgendeiner Weise bearbeitet wurde!
pzmap(Gs);              % Pol- und Nullstellendiagramm des offenen Regelkreis.
rlocus(Gs);             % Wurzelortskurve (WOK) im geschlossenen Regelkreis.

subplot(223);
nyquist(Gs);grid;
subplot(221);
step(Gs);grid;
subplot(222);
bode(Gs);grid;
subplot(224);
rlocus(Gs);grid;
end

PS=pole(Gs)             % Berechnung der Polstellen einer Übertragungsfunktion.
NS=tzero(Gs);           % Berechnung der Nullstellen einer Übertragungsfunktion

% Reglerentwurf PID
% GrPID=Kp*(1+1/(Tn*s)+Tv*s)
% Tn=Kp/Ki
% Tv=Kd/Kp
%
% bzw.
%
% GrPID=(Kp+Kp*Tn*s+Kp*Tv*Tn*s^2)/(Tn*s)
%
% GrPid laut PID Block Simulink
% GrPid=P+I*1/s+D*N/(1+N*1/s)
% N=27.1
% Faktorisiert:
% GsPid=((D*N+P)*s^2+(N*P+I)*s+I*N)/(s^2+N*s+0)
syms Ki Kp Kd N

Kp=1.83899;     % Tuned by Simulink
Ki=33.0737;     % Tuned by Simulink
Kd=-0.00691;    % Tuned by Simulink
N=27.1;

numSimulink=[Kd*N+Kp N*Kp+Ki Ki*N];
denSimulink=[1 N 0];

Kp=1;
Ki=20;
Kd=1e-3;

Tn=Kp/Ki;
Tv=Kd/Kp;
num=[Kp*Tv*Tn Kp*Tn Kp];
den=[Tn 0];

GrPid=tf(num,den) 
%GrPid=tf(numSimulink,denSimulink)

Gs=tf([1],[1e-3 8e-2 1])
%--------------------------------------------------------------
%--------- Reglerdimensionierung mit BODE-Diagramm 
%--------------------------------------------------------------
% Befehlsfolge für das Berechnen der optimierten Reglerverstärkung für beliebige Regler Gr
% Also P-Anteil!!!
%
Go=GrPid*Gs    % Berechnen der Übertragungsfunktion des offenen Regelkreis
bode(Go)    % BODE-Diagramm grafisch ausgeben,um zu sehen, in welchem Frequenzbereich die Phase von -120° liegt

Prand=60;   % Definieren der Phasenreserve Prand = 60°
w=logspace(-2,2,100000);    % Definieren von Frequenzbereich w; eventl. Anpassen an richtigen Bereich (vgl. dazu BODE-Diagramm.
                            % Semikolon NICHT vergessen, sonst Auflistung von 100.000 Zeilen!
[a,p,w]=bode(Go,w);       % Zuordnen von Phasen- (p) und Amplitudenwerten (a)
[Kr,Pr,wa,wp]=margin(a,p-Prand,w)   % Berechnen des Verstärkungsparameters Kr

margin(Kr*Go);grid;title('Verschiebung von Go um Phasenrand von 60°')   %Grafische Darstellung des Phasenrands
Gw =feedback(Go*Kr,1)       % geschlossener RK optimiertem Verstärkungsfaktor Kr

% Sprungantworten im Vergleich
figure;step(Gs,Gw);grid;legend('Gs - Strecke im offenen RK','Gw - geschlossener RK mit optimiertem Regler')
Gw_p=Gw;    % eigener eindeutiger Name für jede Führungsübertragungsfunktion




