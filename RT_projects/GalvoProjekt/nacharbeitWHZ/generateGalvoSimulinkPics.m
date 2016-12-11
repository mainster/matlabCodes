%% Export subsystems of single mdl
mdls = {'galvoMdl3'};

[~, HOST]=system('echo $HOSTNAME');

if strfind(HOST,'x58a')
   outbase = '/media/storage/data_notebook/whz/projectGalvoDocu/pics/simulExport/';
else
   if strfind(HOST,'XPS')
      outbase='/media/data/whz/projectGalvoDocu/pics/simulExport/';
   else
      error(['Unknown hostname: ' HOST])
   end
end

open_system(mdls{1}); 

ONOFF = 'off';

outbase

%% Find subsystem block paths
sspaths = find_system(mdls{1},'BlockType','SubSystem');
for i=1:length(sspaths) 
    try 
        submdl=strsplit(sspaths{i},'/');
        open_system(sspaths{i});
        
        % Find all system of type 'block' and enable Shadow
        blks = find_system(gcs, 'FindAll', 'on', 'type', 'block')
        
        set(blks,'DropShadow','off')
        print(['-s' sspaths{i}], '-r55', '-dsvg', [outbase, submdl{end}, '.svg']);        
        system(['sed -i ''s/fill\=\"\#ffffff\"/fill="none"/g'' ' [outbase, submdl{end}, '.svg']])
        %print(['-s' sspaths{i}], '-r150', '-dpng', [outbase, submdl{end}, '.png']);        
        close_system(sspaths{i}, 0); 
    catch err
        disp msg
    end
end

open_system(mdls{1});
return
%%
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
