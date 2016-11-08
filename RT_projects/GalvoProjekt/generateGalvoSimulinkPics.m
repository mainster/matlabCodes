clearvars('-except',INITIALVARS{:})

index = '~/CODES_local/matlab_workspace/RT_projects/GalvoProjekt/picme2';
outbase='/tmp/GalvoModelPngs/';

mdls=importdata(index); 
for i=[1:length(mdls)]; 
    try 
        open_system(mdls{i}); 
        print(['-s' mdls{i}], '-r200', '-dpng', [outbase mdls{i} '.png']); 
        close_system(mdls{i}, 0); 
    catch err
        disp msg
    end
end 
