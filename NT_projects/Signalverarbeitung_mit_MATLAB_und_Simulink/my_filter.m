function y = my_filter(b,a,x);
% Funktion zur Filterung der Sequenz x mit einem
% Filter beschrieben als Übertragungsfunktion mit 
% den Koeffizienten des Zählers in b und des Nenners in a
% b = [b1, b2, ..., bm]
% a = [1, a2, ..., an]

m = length(b);
n = length(a);
nx = length(x);

xt = zeros(1,m);   % Temporärer Speicher für x-Werte
yt = zeros(1,n-1); % Temporärer Speicher für y-Werte

for k = 1:nx,
    xt = [x(k), xt(1:end-1)];    % Aktualisierung der x-Werte 
    if n == 1
        y(k) = b*xt';            % Filterausgang fÜr FIR-Filter
    else 
        y(k) = b*xt'-a(2:end)*yt'; % Filterausgang für IIR-Filter
        yt = [y(k), yt(1:end-1)];% Aktualisierung der y-Werte
    end;    
end;

