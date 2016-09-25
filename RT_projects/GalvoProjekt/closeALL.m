%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% @!@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      close viewer, systems and figures
%
%       close almost all open Matlab windows except of Editor
%       and command line if undocked
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig=findall(0,'type','figure')

childs = allchild(0)
sol=strfind(upper(get(allchild(0),'Tag')),'SIMULINK_SIMSCOPE_FIGURE')
if iscell(sol)
   ind=find(~cellfun(@isempty, strfind(upper(get(allchild(0),'Tag')),'SIMULINK_SIMSCOPE_FIGURE')));
else
   ind=sol
end
close(childs(ind))      % clode viewer

syss = find_system('type', 'block_diagram');
if isempty(syss)
    disp('nothing to close')
else
    if iscell(syss)
        ind1=find(cellfun(@isempty, strfind(lower(syss),'eml_lib')))
        ind2=find(cellfun(@isempty, strfind(lower(syss),'simulink')))
        ind3=find(cellfun(@isempty, strfind(lower(syss),'simviewers')))
        indn=[find(diff(ind1)-1)+1, find(diff(ind2)-1)+1 find(diff(ind3)-1)+1]
    else
        ind=sol
    end
    
end
le=[1:length(syss)];
le(indn)=[];

syss;
syss(le);
try
    save_system(syss(le))
catch err
    if strcmpi(err.identifier, 'Simulink:LoadSave:FileWriteError')
        sprintf('Schreiben fehlgeschlagen')
    else
        sprintf('Error: %s',err.identifier)
    end
        
end
close_system(syss(le))
close all

