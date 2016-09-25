% 18.09.2014
delete(findall(0,'type','line'));

SIMFILES={  'GalvoModel_v44_simply',...
            'Galvo_compare_cc_and_nocc_v1',...  % o
            'Galvo_sys_cc_feed_v40',...
            'Galvo_sys_v21_old_cc_feedfor'};

%%
% ********************************************************************
%               Init block models
% *********************************************************************
param = loadGalvoParam(4);
paramCtrl = loadCtrlParam(4);
evalGalvoParam(4)

FS = 5e-6;

%%
open_system(SIMFILES{1})

%%
open_system(SIMFILES{2})

%%
open_system(SIMFILES{3})

%%
open_system(SIMFILES{4})








