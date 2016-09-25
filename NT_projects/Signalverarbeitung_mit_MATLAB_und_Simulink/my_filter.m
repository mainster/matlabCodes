function y = my_filter(b,a,x);
% Funktion zur Filterung der Sequenz x mit einem
% Filter beschrieben als �bertragungsfunktion mit 
% den Koeffizienten des Z�hlers in b und des Nenners in a
% b = [b1, b2, ..., bm]
% a = [1, a2, ..., an]

m = length(b);
n = length(a);
nx = length(x);

xt = zeros(1,m);   % Tempor�rer Speicher f�r x-Werte
yt = zeros(1,n-1); % Tempor�rer Speicher f�r y-Werte

for k = 1:nx,
    xt = [x(k), xt(1:end-1)];    % Aktualisierung der x-Werte 
    if n == 1
        y(k) = b*xt';            % Filterausgang f�r FIR-Filter
    else 
        y(k) = b*xt'-a(2:end)*yt'; % Filterausgang f�r IIR-Filter
        yt = [y(k), yt(1:end-1)];% Aktualisierung der y-Werte
    end;    
end;

