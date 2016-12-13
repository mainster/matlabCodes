%% Compare freq response for different KTB/KFR values
clear Gcalc Glin; clf;
MDL='GalvoModel_v161b';
DDS={'dataDict_galvoMod6860.sldd', 'dataDict_galvoLSK040EF.sldd'};

set_param(MDL,'DataDictionary',DDS{1});
Gcalc=cell(1); Glin=cell(1);

% c = parcluster
% parpool('AttachedFiles',{'calcGtot.m',DDS{1},DDS{2}})

%%
% set_param(MDL,'DataDictionary',DDS{2});
tic
for iL40=0:8
%     [Gcalc{end+1}, Glin{end+1}]=
    calcGtot(MDL, iL40*.25);
    drawnow;
end
toc

