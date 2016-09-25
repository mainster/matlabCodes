function h = plot_mt(t, y, a)

% Plot Funktion fuer die Darstellung in Form von vertikalen Linien.

np= nargin;
n = length(t);
if np == 1
    y = t;
    t = 1:n;
end;

z =  zeros(1, 3*n);
t1 = zeros(1, 3*n);

for j = 1 : n,
   j_1 = 3*(j - 1);

   z(j_1 + 1) = 0;
   z(j_1 + 2) = y(j);
   z(j_1 + 3) = 0;

   t1(j_1+ 1) = t(j);
   t1(j_1+ 2) = t(j);
   t1(j_1+ 3) = t(j);
end;
if np == 3
   h = plot(t1, z, a);
else
   h = plot(t1, z);
end;
