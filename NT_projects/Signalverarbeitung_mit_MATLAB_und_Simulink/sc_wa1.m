% Programm sc_wa1.m zur Ermittlung der Einheitspulsantworten
% der Rekonstruktionspfade einer MRA-Filterbank mit drei
% Stufen
clear
% -------- Filter der Zerlegung und Rekonstruktion
wname = 'db4';
[h0, h1, g0, g1] = wfilters(wname);
L1 = length(g0);
L2 = length(g1);
L = (L1+L2)/2;
% -------- Stufen 
stufen = 3;
% -------- Einheitspulsantworten füŸr jeden Pfad
phi = cell(stufen,1);
psi = cell(stufen,1);

for k = 1:stufen,
    [phi_t, psi_t] = scale_wavelet(h0, h1, g0, g1, k, 0);
    phi{k} = phi_t;
    psi{k} = psi_t;
end;

nl = length(phi{3});
for k = 1:stufen,
    phi{k} = [phi{k}, zeros(1,nl-length(phi{k}))];
    psi{k} = [psi{k}, zeros(1,nl-length(psi{k}))];
end;

%-------------------------------
figure(1);   clf;
cd = [1, zeros(1, 4)];

subplot(431), stem((0:length(cd)-1)*2, cd);
La = axis;   axis([-1,(length(cd)-1)*2, -0.25, 1.2]);
ylabel('cd1');   grid;

subplot(434), stem((0:length(cd)-1)*4, cd);
La = axis;   axis([-2,(length(cd)-1)*4, -0.25, 1.2]);
ylabel('cd2');   grid;

subplot(437), stem((0:length(cd)-1)*8, cd);
La = axis;   axis([-4,(length(cd)-1)*8, -0.25, 1.2]);
ylabel('cd3');   grid;

subplot(4,3,10), stem((0:length(cd)-1)*8, cd);
La = axis;   axis([-4,(length(cd)-1)*8, -0.25, 1.2]);
ylabel('ca3');   grid;
xlabel('t/Ts');
%---------------------------------
subplot(432),  plot((0:length(psi{1})-1), psi{1});
hold on;
stem((0:length(psi{1})-1), psi{1});
hold off;
La = axis;   axis([La(1),length(psi{1})-1, La(3:4)]);
ylabel('psi1');   grid;

subplot(435),  plot((0:length(psi{2})-1), psi{2});
hold on;
stem(0:length(psi{2})-1, psi{2});
hold off;
La = axis;   axis([La(1),length(psi{2})-1, La(3:4)]);
ylabel('psi2');   grid;

subplot(438),  plot(0:length(psi{3})-1, psi{3});
hold on;
stem(0:length(psi{3})-1, psi{3});
hold off;
La = axis;   axis([La(1),length(psi{3})-1, La(3:4)]);
ylabel('psi3');   grid;

subplot(4,3,11),  plot(0:length(phi{3})-1, phi{3});
hold on;
stem(0:length(phi{3})-1, phi{3});
hold off;
La = axis;   axis([La(1),length(phi{3})-1, La(3:4)]);
ylabel('phi3');   grid;
xlabel('t/Ts');

% --------- Wavelet und Scaling
n = 3;
[phit, psit] = scale_wavelet(h0, h1, g0, g1, n, 0);

nnorm = (2^n-1)*L-(2^n-2);
nphi = length(phit);
npsi = length(psit);

subplot(233), plot((0:npsi-1)*(L-1)/(nnorm), psit);
hold on
%stem((0:npsi-1)*(L-1)/(nnorm), psit);
hold off,    grid;
La = axis;    axis([La(1), nphi*(L-1)/nnorm, La(3:4)]);
title(['Wavelet-Function \psi(t) (', wname,')']);

subplot(236), plot((0:nphi-1)*(L-1)/(nnorm), phit);
hold on
%stem((0:nphi-1)*(L-1)/(nnorm), phit);
hold off,    grid;
La = axis;    axis([La(1), nphi*(L-1)/nnorm, La(3:4)]);
title(['Scaling-Function \phi(t) (', wname,')']);









