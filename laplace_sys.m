% Definition der symbolischen Variablen
syms x X t s;
% Definition der Funktion
x = 2*heaviside(t) + 5*exp(3*t)*heaviside(t) + dirac(t-3);
X =laplace(x,t,s)
