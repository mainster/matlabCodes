% Experimente zur Umwandlung von LTI-Modellen

% ------- Umwandlung diskreter Modelle
my_sys = drss(10);      % Abtastperiode -1 nicht spezifiziert

% ------- Definieren der Abtastperiode z.B. Ts = 0.1
Ts = 0.1;
my_sys = ss(a,b,c,d,Ts);
a = my_sys.a;
b = my_sys.b;
c = my_sys.c;
d = my_sys.d;
p = eig(a)

disp('************ SS-Modell ************');
get(my_sys);

% ------- Umwandlung ss in tf
my_sys1 = tf(my_sys);
disp('************ SS-TF-Modell ************');
get(my_sys1)
p1 = roots(my_sys1.den{:})

% ------- Umwandlung tf in ss
my_sys2 = ss(my_sys1);

a2 = my_sys2.a;
b2 = my_sys2.b;
c2 = my_sys2.c;
d2 = my_sys2.d;
p2 = eig(a2)

disp('************ SS-TF-SS-Modell ************');
get(my_sys2)
% ------- Vergleich der Pole
p = sort(p);
p1 = sort(p1);
p2 = sort(p2);

differenz_ss_tf = p-p1
differenz_ss_tf_ss = p-p2