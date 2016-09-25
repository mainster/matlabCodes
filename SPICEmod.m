%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Skript - Entwurf Analoger Systeme - SS2013
% Tastverhaeltnis als Funktion des Ausgangsstromes IA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L1 = 100e-6;
CA = 20e-6;
VE = 12;
VA = 5;
VD0 = 0.8;
T = 20e-6;
IAmin = T/(2*L1)*(VE-VA)*(VA+VD0)/(VE+VD0);

IA = [0:0.01:IAmin];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Lückbetrieb, IA < IAmin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p_dis = sqrt( 2*L1/T*(VA+VD0)/( (VE-VA)*(VE+VD0) )*IA );

f1 = figure(1);
plot(IA,p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Kontinuierlicher Betrieb, IA > IAmin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p_con = (VA+VD0)/(VE+VD0);



%%
% spice moidel diodes
clear dir1 idNam tmp names modNam

dir1='~/CODES_local/LTSpice_projects/LIBRARYS/diodes_incorporated/models/';
predict='pre';

if exist([dir1 predict '1'],'file')
    fprintf('\n\n')
	type([dir1 predict '1']);
    fprintf('\n\n')
end

tmp = struct2cell(dir(dir1));
tmp = tmp(1,:);

idNam = find(~cellfun(@isempty, (strfind(tmp,'pre'))));
names = tmp(idNam)';

% for k=1:length(idNam)
%     id1=fopen([dir1 names{k,1}]);
%     c = textscan(id1,'%s');
%     
%     idx = find(~cellfun(@isempty, (strfind(c{:},'.MODEL'))));
%     modNam{k} = c{:}{idx+1};
%     fclose(id1);
% end

libD=[];
for k=1:length(idNam)
    id1=fopen([dir1 names{k,1}]);
    
    tline = fgetl(id1);
    while ischar(tline)
        libD = sprintf('%s\n%s',libD,tline);
        tline = fgetl(id1);
    end
    
%     idx = find(~cellfun(@isempty, (strfind(c{:},'.MODEL'))));
%     modNam{k} = c{:}{idx+1};
    fclose(id1);
end
idD=fopen([dir1 'diodes.txt'], 'w', 'n');

fwrite(idD,libD);
fclose(idD);

disp(libD)

return
modNam'

for k=1:length(modNam) 
    copyfile([dir1 names{k,1}], [dir1 modNam{k}]);
end
    
dir(dir1)
    
    