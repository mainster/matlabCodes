function [a, b, c, d] = feder_masse10(m, r, D, ii, io)
% Funktion feder_masse1.m in der für ein Feder-Masse-System die Matrizen 
% a, b, c und d des Zustandsmodells (ein Eingang ein Ausgang) ermittelt werden 
% m = Zeilenwektor der Massen (Länge n)
% r = Vektor der Dämpfungen (Länge n+1)
% D = Steifigkeit der Feder (Länge (n+1)
% ii = Index des Eingangs (zwischen 1 und n)
% io = Index des Ausgangs (zwischen 1 und 2*n);
%
% Testaufruf: [A, B, C, D] = feder_masse10(ones(1,4)*0.2, ones(1,4+1)*0.5, ...
%                            ones(1,4+1)*0.8, 2, 7);

n = length(m);

a = zeros(2*n, 2*n);       % Matrix a des Zustandsmodells
a(1:n, n+1:2*n) = eye(n,n);

a(n+1,:) = [-(D(1) + D(2))/m(1), D(2)/m(1), zeros(1,n-2), -(r(1)+r(2))/m(1), r(2)/m(1),...
        zeros(1,n-2)];

a(2*n,:) = [zeros(1,n-2), D(n)/m(1),-(D(n)+D(n+1))/m(1),zeros(1,n-2),...
        r(n)/m(1),-(r(n)+r(n+1))/m(1)];

for k = 2:n-1
    a(n+k,:) = [zeros(1,k-2), D(k)/m(k), -(D(k)+D(k+1))/m(k), D(k+1)/m(k),...
            zeros(1,n-3), r(k)/m(k), -(r(k)+r(k+1))/m(k), r(k+1)/m(k),...
            zeros(1,n-(k+1))];
end;

b = zeros(2*n,1);           % Matrix b des Zustandsmodells
b(n+ii) = 1/m(ii);

c = zeros(1,2*n);           % Matrix c der Ausgangsgleichung
c(io) = 1;

d = 0;                      % Matrix d der Ausgangsgleichung

