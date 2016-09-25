% Skript frame_filter1.m in dem eine blockweise Filterung
% programmiert wird

clear;
% -------- Eingangssignal
block_l = 100;
n_block =5;
nx = n_block*block_l;
x = randn(1, nx);
% -------- Block-Filterung
nord = 128;     fr = 0.4;
h = fir1(nord, 2*fr);     % Einheitspulsantwort des Filters

y = [];                   % Gefiltertes Signal        
zf = zeros(1, nord);      % Vektor für den Zustand des Filters
for k = 1:n_block
    [y_temp, zf] = filter(h,1,x(1,block_l*(k-1)+1:k*block_l), zf);
    y = [y, y_temp];
end;
figure(1);   clf;
subplot(211), plot(1:nx, y);
   title('Blockweise Filterung'), xlabel('n');  grid on;    
% -------- Klassische Filterung
ykl = filter(h,1,x);
subplot(212), plot(1:nx, ykl)
   title('Klassische Filterung'), xlabel('n');  grid on;    