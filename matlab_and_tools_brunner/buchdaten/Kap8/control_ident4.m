% Programm (control_ident4.m) zur Untersuchung 
% von Modellen der Control-System-TB und System-Identification-TB

% -------- LTI-Modell
my_sys_lti = drss(4,3,2)      % System 4. Ordnung mit 3 Ausg�ngen und 2 Eing�ngen

% ------- Umwandlung in einem id-Modell
my_sys_id = idss(my_sys_lti, 'NoiseVar', 0.1*eye(3))

% ------- Simulation des Modells um Daten f�r eine Identifikation zu erhalten
u = iddata([], idinput([800,2],'rbs'));  % Zuf�llige bin�re Sequenz
e = iddata([], randn(800,3));            % Me�rauschen f�r die 3 Ausg�nge

% Ausgangssignal
y = sim(my_sys_id, [u,e]);

disp('*****************************');
disp('Bitte warten !!!');
disp('*****************************');

% -------- Identifikation basierend auf u und y
data_id = [y,u];
my_sys_g = pem(data_id(1:400));          % Identifikation eines Pr�diktionssystems

% -------- Umwandlung in tf-Form
tf(my_sys_g)                             % LTI-Modell in tf-Form

% -------- Vergleichen des Vorausgesagten und der korrekten Daten
compare(data_id(401:800), my_sys_g)

% -------- Eigenschaften mit Viewer
view(my_sys_g);

