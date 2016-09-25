% Programm zur Simulation eines Beoabachters reduzierter 
% Ordnung

% ---------Erzeugung eines Systems
n = 6;          % Ordnung
mo = 4;         % Anzahl Ausg‰nge
mi = 3;         % Anzahl Eing‰nge  (muss >= 2)

my_sys = rss(n, mo, mi);

% ---------Extrahieren der Matrizen
A = my_sys.a;    B = my_sys.b;
C = my_sys.c;    D = my_sys.d;

% ---------Eigenschaften des Systems
disp('Eigenwerte des Systems '), eig(A)

% Steuerbarkeitsmatrix
disp('Rang der Steuerbarkeitsmatrix '), rank(ctrb(A,B))

% Beobachtbarkeitsmatrix
disp('Rang der Beobachtbarkeitsmatrix '), rank(obsv(A,C))

% ---------Bestimmen der meﬂbaren Zust‰nden
n1 = 2;         % Zwei Zustandsvariablen sind meﬂbar 
n2 = n - n1;    % nicht meﬂbare Zustandsvariablen

% ---------Zerlegung des Systems
A11 = A(1:n1, 1:n1);       A12 = A(1:n1, n1+1:n);
A21 = A(n1+1:n, 1:n1);     A22 = A(n1+1:n, n1+1:n);

C11 = C(1:mo, 1:n1);       C12 = C(1:mo, n1+1:n);
B1 = B(1:n1,1:mi);         B2 = B(n1+1:n,1:mi);

% ---------System mit neuenm Ausgangsvektor bestehend aus meﬂbaren Zustandsvariablen
% und alter Ausgang
Cn = [eye(n1,n1),zeros(n1,n2); C];
Dn = [zeros(n1, mi);D];

my_sys_n = ss(A, B, Cn, Dn);

% ---------Matrix zur Trennung der meﬂbaren Zustandsvariablen
% aus dem Ausgang
mess_zust = [eye(n1,n1), zeros(n1, mo)]

ausgang = [zeros(mo, n1), eye(mo,mo)] 

% ---------Beobachter
p = -(1:n2)      % Pole des Beobachters

Ke = place(A22', C12', p).'

% Beobachtbarkeitsmatrix des reduzierten Systems
my_rang = rank(obsv(A22,C12));
disp('Rang der reduzierten Beobachtbarkeitsmatrix '), my_rang
if my_rang == n2
    disp('Das reduzierte System ist beobachtbar !!!');
end;

dt = 0.1;
my_opt = simset('OutputVariables', 'ty');
[t,x,y] = sim('red_beob1', [0:dt:5], my_opt);  

figure(1);     clf;
plot(t, y);
title('Differenz zwischen den Ausgaengen und deren Schaetzungswerten');
xlabel('Zeit in s');    grid;



