function [phi, psi] = scale_wavelet(h0, h1, g0, g1, n, flag)
% Funktion zur Iteration der Scale- und Wavelet-Funktion,
% die den Filtern g0 (als Synthese-Tiefpassfilter) und g1 (als 
% Synthese-Hochpassfilter)
% entsprechen
% n = Anzahl der Iterationen
% flag = 1 füŸhrt auch zu Darstellung

% Testaufruf: [h0, h1, g0, g1] = wfilters('db4');
%             scale_wavelet(h0, h1, g0, g1, 7, 1);

L1 = length(g0);
L2 = length(g1);
L = (L1+L2)/2;

phi = g0*sqrt(2);    % Einheitspulsantwort der Filter
psi = g1*sqrt(2);

for k = 1:n-1
    phi = upsample(phi,2);     phi = phi(1:end-1);
    psi = upsample(psi,2);     psi = psi(1:end-1);
    phi = conv(g0, phi)*sqrt(2);
    psi = conv(g0, psi)*sqrt(2);
end;

if flag == 1
    figure(1),   clf;
    subplot(221), stem(0:length(h0)-1, h0);
    title('h0');  grid;
    subplot(222), stem(0:length(h0)-1, h1);
    title('h1');  grid;
    subplot(223), stem(0:length(h0)-1, g0);
    title('g0');  grid;
    subplot(224), stem(0:length(h0)-1, g1);
    title('g1');  grid;
    figure(2);  clf;
    nnorm = (2^n-1)*L-(2^n-2);
    nphi = length(phi);
    npsi = length(psi);
    subplot(121), plot((0:nphi-1)*(L-1)/(nnorm), phi);
    hold on
    stem((0:nphi-1)*(L-1)/(nnorm), phi);
    hold off
    grid;
    La = axis;    axis([La(1), nphi*(L-1)/nnorm, La(3:4)]);
    subplot(122), plot((0:npsi-1)*(L-1)/(nnorm), psi);
    hold on
    stem((0:npsi-1)*(L-1)/(nnorm), psi);
    hold off
    grid;
    La = axis;    axis([La(1), nphi*(L-1)/nnorm, La(3:4)]);
end;


