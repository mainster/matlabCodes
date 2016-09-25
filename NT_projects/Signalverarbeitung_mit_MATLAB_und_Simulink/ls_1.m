% Programm ls_1.m zu Löšsung der Least-Square Gleichung
% füŸr die Koeffizienten eines FIR-Filters

% -------- FIR-Filter 
nf = 13;
h = fir1(nf-1, 0.35)'; % oder
%h = (0.8.^(0:nf-1))';

% -------- Matrix des Eingangssignals
nx = 500;
x = randn(nx,1);
xrot = flipud(x);

M = 15;   % GeschŠtzte äLŠnge des Filters M

X = zeros(nx,M);
for k = 1:M
    X(:,k) = [xrot(k:nx); zeros(k-1,1)];
end;    

% ------- Ausgangssignal ("Gemessener" Ausgang)
d = filter(h,1,x);
d = flipud(d);

noise = 0.1;          % Varianz des Mesrauschens
randn('state', 12753);
d = d + sqrt(noise)*randn(length(d),1);  % Ausgang mit Messrauschen

% ------- GeschŠtzte Einheitspulsantwort des Filters
w = 1;                      % Forgetting factor
W = diag(w.^(0:nx-1));   % Gewichtungsmatrix 

hg = inv(X'*W*X)*X'*W*d;    % LS-Lšsung

figure(1);   clf;
subplot(221), stem(0:nf-1, h);
title(['Korrektes Filter']);
xlabel('i');   grid;

subplot(222), stem(0:length(hg)-1, hg);
title(['Identifiziertes Filter (Messrauschen \sigma^2 = ',num2str(noise),')']);
xlabel('i');   grid;
