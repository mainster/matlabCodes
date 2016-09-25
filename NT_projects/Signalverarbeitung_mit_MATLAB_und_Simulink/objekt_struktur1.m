% Skript objekt_struktur1.m, in dem der Umgang mit
% Struktur-Objekten gezeigt wird
clear;
% -------- Filter mit Objektspezifikation
d = fdesign.lowpass('Fp,Fst,Ap,Ast',0.2, 0.22, 1, 60);
get(d)
% -------- Ändern der Eigenschaften
d.Fpass = 0.4      % Als Struktur-Feld
d.Fstop = 0.42
set(d, 'Fstop', 0.43)   % Mit Methode set  
get(d)

% -------- Entwicklung des Filters
f = design(d,'equiripple');
get(f)
% -------- Ändern der Eigenschaften
f.Arithmetic = 'fixed'          % Als Struktur-Feld
set(f, 'PersistentMemory',1)    % Mit Methode set
get(f)
% -------- Filtern mit overloaded-Funktion
x = randn(1,1000);
y = filter(f, x);     % Overloaded Funktionen
[s, t] = stepz(f);
[h, t] = impulse(f);