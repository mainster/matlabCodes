%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  - Simulink parameter 
%%%  - Keine Torsionsfeder mehr im modell
%%% 
%%%  - Statespace und polplatzierung bei siso
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%set(0,'DefaultFigureRenderer','OpenGL')
%set(0,'DefaultFigureRendererMode', 'manual')

delete(findall(0,'type','line'));

SIMFILES={  'Galvo_sys_SS_v1'};
%            'CurrentComp_v20',...
%            'GalvoModel_v53'};
        
% *********************************************************************
%               Init block models
% *********************************************************************
param = loadGalvoParam(4);
paramCtrl = loadCtrlParam(4);

load_system(SIMFILES);
%set_param(  [SIMFILES{1} '/GalvoModel'],...
%            'OverrideUsingVariant',SIMFILES{2});
set_param(SIMFILES{1}, 'AbsTol', '1e-5','MaxStep','1e-4');
open_system(SIMFILES{1});

% Zustandsregelung mit I-Anteil und Polplazierung
% für ein Servosystem mit Hilfe des Simulink-Modells 

%------- Ursprüngliches System
%------- Eigenfrequenzen und Dämpfungsfaktoren
w01 = 1;	zeta1 = 0.1;	% Erster Abschnitt
w02 = 0.8;	zeta2 = 0.1;	% Zweiter Abschnitt 
w03 = 0.6;	zeta3 = 0.1;	% Dritter Abschnitt

%------- übertragungsfunktionen der Abschnitte
zaehler1 = 1;	nenner1 = [1/(w01^2), 2*zeta1/w01, 1];
zaehler2 = 1;	nenner2 = [1/(w02^2), 2*zeta2/w02, 1];
zaehler3 = 1;	nenner3 = [1/(w03^2), 2*zeta3/w03, 1];

%------- übertragungsfunktion des Systems
my_sys = tf(zaehler3, nenner3)*tf(zaehler2, nenner2)*tf(zaehler1, nenner1);
my_sys1 = ss(my_sys);	% Zustandsmodell
A = my_sys1.a;     B = my_sys1.b;
C = my_sys1.c;     D = my_sys1.d;

%------- Verhalten des nichtkorrigierten Systems:
t = [0:0.1:50];
nt = length(t);

[y,t,x] = lsim(my_sys1, [1,zeros(1,nt-1)], t, zeros(1,6));

figure(1);	clf;
subplot(211), plot(t, x)
title('Sprungantwort, Zustandsvariablen x1, x2, ... x6 ');
grid;	xlabel('Zeit in s');
subplot(212), plot(t, y)
title('Ausgangsvariable y');
grid;	xlabel('Zeit in s');

%------- Bestimmung der Rückführungsmatrix Kn
%------- für das erweiterte Modell
[n,m] = size(A); 
An = [A, zeros(n,1); -C, 0];	% Erweiterte A-Matrix
Bn = [B; 0];			% Erweiterte B-Matrix

%------- Gewünschte Pole für das erweiterte System
p1 = -0.5+j*1;		p2 = conj(p1);  
p3 = -0.3+j*0.6;	p4 = conj(p3);
p5 = -0.2+j*0.4;	p6 = conj(p5);
p7 = -2;

p = [p1; p2; p3; p4; p5; p6; p7];

%------- Erweiterte Rückführungsmatrix
Kn = place(An, Bn, p)
K = Kn(1:n)			    % Teil-Rückführungsmatrix		
ki = -Kn(n+1)			% I-Gewichtung

%------- Antwort des Servosystems (Aufrif der Simulation)
my_opt = simset('InitialStep', 0.1, 'OutputVariables', 'txy');
[t,x,y] = sim('s_pol5', [0, 50], my_opt);    % SIMULINK 2
  
figure(2);	clf;
subplot(211), plot(t,x);
title('Sprungantwort, Zustandsvariablen des Servosystems');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,y);
title('Ausgang und Fehler');
grid;	xlabel('Zeit in s')



%% 
% *********************************************************************
%               Update simulink configs struct
% *********************************************************************
clear open_bd ind del
open_bd = find_system('type', 'block_diagram');
ind = [1:length(open_bd)];

del{1} = find(~cellfun(@isempty, strfind(lower(open_bd),'simulink')));
del{2} = find(~cellfun(@isempty, strfind(lower(open_bd),'simviewers')));
del{3} = find(~cellfun(@isempty, strfind(lower(open_bd),'eml_lib')));
if length(find(cellfun(@isempty, del))) > 0
    
    ind(del{~cellfun(@isempty,del)}) = [];
end
% 
% if exist('simulinkConfigSets','var')
%     save('simulinkConfigSetsBACK','-struct',...
%         simulinkConfigSets.Galvo_sys_cc_neu_v32.);
%     clear savesimulinkConfigSets;
% end
clear simulinkConfigSets;

for k=1:length(open_bd(ind))
    tmp1 = getActiveConfigSet(SIMFILES{k})
    simulinkConfigSets.(SIMFILES{k}) = tmp1;
end
simulinkConfigSets

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NUR LINMOD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%set_param( [SIMFILES{1} '/ScopeMain'],'open','off');
LIMOD={'Galvo_CC_linmod_v30'};
load_system(LIMOD{1});
set_param(LIMOD{1}, 'MaxStep', '1e-4');
clear S;

S = linmod(LIMOD{1})
S.filename = LIMOD{1};
u_ = strrep(S.InputName, [S.filename '/'], '');
y_ = strrep(S.OutputName, [S.filename '/'], '');
S.InputName = u_;
S.OutputName = y_;

%GvCCa = ss(S.a, S.b, S.c, S.d, 'u', u_, 'y', y_);           % Kompletter Regelkreis 
[num, den] = ss2tf(S.a, S.b, S.c, S.d);

NUM=mat2cell(num, [ones(1, size(num,1))], size(num,2));
GvCCb = tf(NUM, den, 'u', u_, 'y', y_); 

syms Kp Ki Kd N
pid=Kp+Ki/p+Kd*N/(1+N/p);
Kp=1.7;Ki=0.2;Kd=-1.26;N=0.1781;
PID=sym2tf(eval(pid))

loop=feedback(PID*GvCCb(2),1);
s1=balred(loop,1);
kb=1/pole(s1)