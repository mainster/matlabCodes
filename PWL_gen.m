% Generierung von csv files im LTSpice PWL- Format
%

t=[0:1000-1].';     % 100ms funktion mit 100us Ts
f=sin(2*pi*10*t/1000);
tf=[t f];
plot(t,f);

save t_sin.csv tf -ascii -tabs

% Weil LTSpice die werte zwischen zwei Zeitschritten Interpoliert,
% ist im Plot von LTSpice keine Treppenfunktion sichtbar

% Um eine Treppe zu erhalten, musst du die Sprünge mit einem zweiten Punkt 
% kontrollieren.
% 
% 0.0000ms 0.0000V
% 0.024499ms 0.0000V
% 0.0245ms 0.1227V
% 0.049099ms 0.1227V
% 0.0491ms 0.2453V
% 0.073599ms 0.2453V
% 0.0736ms 0.3678V

t2=[0:0.5:1000-0.5].';     
t2k=[0:0.5:1000-0.5];
t2k=t2k*0.999999;

t2k=t2k.';

for k=2:2:length(t2)-2
    t2(k)=t2k(k+1);
end


f2=[0:length(t2)-1].';

j=1;
for k=1:length(f)-1
    f2(j)=f(k);
    j=j+1;
    f2(j)=f2(j-1);
    j=j+1;
end

t2=t2/1e3;     % Zeitvektor auf 1sec normieren
f2(end-1)=0;
f2(end)=0;
tf2=[t2 f2];
save '/media/storage/data_raid_back/mainster/DATAPOOL/TRANSFER/CODES/LTSpice_projects/DAC_harmonics/t_sin.csv' tf2 -ascii -tabs
