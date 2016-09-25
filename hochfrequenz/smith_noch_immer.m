%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HFSS11 A2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Za = Ra || 1/(j*w*Ca)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ra = 80; 
Ca = 9.2e-12;
f0 = 433e6;
w = 2*pi*f0;
Z0 = 50;


% Za = ol.par2(Ra,1/(j*w*Ca));
% Ya = 1/Za;
% YaZ0 = Ya*Z0

YanaZ0 = 2.2+0.98j;
clf;
[m1, d1, VSWR1, Rloss1] = smith_ch_calc(1/YanaZ0)
[m1, d1, VSWR1, Rloss1] = smith_ch_calc(YanaZ0)

%%
zx = 0.2+0.5j;
zx = [0:0.01:0.5]+0*1j;
zx=0.625+0.25j;
figure(1);
[lineseries,hsm] = smithchart(zx); 
set(lineseries,'Marker','*','MarkerSize',10);
%figure(2);
%[m1, d1, VSWR1, Rloss1] = smith_ch_calc(zx)

%%
figure(1);
ff=get(gca,'children');
ind=find(~cellfun(@isempty, strfind(get(ff,'Type'),'line')));
delete(ff(ind));


%%
figure(3);
plotSmithChart(zx,1)


