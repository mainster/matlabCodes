clearvars('-except',INITIALVARS{:})
PRJ='/media/data/CODES/matlab_workspace/RT_projects/GalvoProjekt/';
cd(PRJ);

[status,mdlPaths] = system('find . -iname "*\.slx" -print -o -iname "*\.mdl" -print');
[status,cmdls] = system('find . \( -iname "*\.slx" -o -iname "*\.mdl" \) -exec basename {} \; | sed -r ''s/\.(slx|mdl)//g''');

mdls = strsplit(cmdls, '\n'); 
clear cmdls;

%%
for i=1:5 %length(mdls)
    try 
        open_system(mdls{i}); 
        cr = get_param(mdls{i}, 'Created');
        md = get_param(mdls{i}, 'LastModifiedDate');
        mdlPar{i}(1)=cr(regexp(cr, '([0-9]{2}:){2}'):regexp(cr, '([0-9]{2}:){2}')+8);
        close_system(mdls{i}, 0); 
    catch err
        disp(err.message)
    end
end

mdlPar{:}
%%
return
index = 'picme2';
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
