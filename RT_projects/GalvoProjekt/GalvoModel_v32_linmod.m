%% GalvoModel_v32_linmod
% 5.12.2016 MDB
SYSS={'Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v69_linmod'};
open_system(SYSS{1})

% Optaining statespace information from simulink system
[a,b,c,d] = linmod2(SYSS{1},'1SYS','2');

%%
clear z p k G1
[z,p,k] = ss2zp(a,b,c,d);
G1 = zpk(z,p,k);

return;


%% Encapsulate worksape variables exported from Data Dictionary
% 5.12.2016 MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MDD='modelDesignData_Galvo_sys_Ccont_Pcont';

dob = Simulink.data.dictionary.open([MDD '.sldd']);
sob = getSection(dob,'Design Data');
sob.exportToFile([MDD '.mat']');
load ([MDD '.mat']);
% eos = getEntry(sob,'KEL');

%%
for k = 1:length(vars)
   nam=getEntry(sob,'KEL').
end
      


