% regelNormalform.mdl proc
%
% G(s)=(z3*s²+z2*s+z1)/(s³+n3*s²+n2*s+n1)
% 

% RT_gesamt.pdf S.38
% Die Regelungsnormalform bildet so etwas wie eine Brücke zwischen der Beschreibung
% eines Systems im Zustandsraum und dessen Beschreibung mittels Übertragungsfunktion.
% Sie kann benützt werden, um von einer Darstellung im Zeitbereich zu einer
% Darstellung im Frequenzbereich oder vice versa zu gelangen.

clear all;

syms p;

z=[1 p 3];
n=[1 2 3];

[A,b,c]=linmod('regelNormalform')
