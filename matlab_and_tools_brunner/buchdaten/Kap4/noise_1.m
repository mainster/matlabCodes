% Programm (noise_1.m) zur Erzeugung einer Sequenz f�r 
% ein Rauschvektor mit gegebener Kovarianzmatrix Q
% Arbeitet mit dem Modell s_noise1.mdl

%------- Gew�nschte Kovarianzmatrix
Q = [1 0.1 0.05; 0.1 2.0 0.5; 0.05 0.5 3];

%------- Schrittweite der Simulation
d_t = 0.1;

%------- Transformationsmatrix
G = chol(Q)/sqrt(d_t);

%------- Aufruf des Modells
t_final = d_t * 1000;

%------- Initialisierung der Rauschgenerators des Modells
varianz = [1 1 1 ];
seed = [13378, 9257, 1278];

%------- Aufruf der Simulation
my_options = simset( 'FixedStep', d_t,...
   'OutputVariables','ty');
[t,x,y] = sim('s_noise1', t_final, my_options);

%------ �berpr�fen der Kovarianz der Sequenz
Qg = cov(y)*d_t;             % die Multiplikation mit d_t ist
% wegen des kontinuierlichen Systems, das simuliert wird

disp(['Gew�nschte Kovarianz Q = ']);
disp(num2str(Q));
disp(['Geschaetzte Kovarianz Qg = ']);
disp(num2str(Qg));

plot(y);

