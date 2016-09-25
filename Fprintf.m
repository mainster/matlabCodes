function fprintf (varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Work with shadowed functions
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% store a handle to the shipped MATLAB funtion of the same name

% the name of this function that is shadowing one or more MATLAB functions
this = [mfilename '.m']; 

% find all the functions that are shadowd by this one 
list = which(this, '-all') 

% Remember: Only that
% function names which are equal and NOT stored as a methode.
% This means, the function must not be stored in a folder with a preceeding
% '@' in its function name

% find the ''built-in'' function 
%%
idx = find(cellfun(@isempty, strfind(list, ol.projectsPath )));
idx = find(cellfun(@isempty, strfind(list(idx),'@')));

idx = find(~cellfun(@isempty, strfind(list,'built-in')));

if max(size(idx)) > 1
   disp('Error, function name is NOT unique inside MATLAB built-ins\n')
   return;
end

selFunc = strsplit(list(idx),{'(',')'});
selFunc = selFunc{2};
cd(selFunc(1:end-length(this))) 

%%
% locate 1st in list under matlabroot
f = strncmp(list, matlabroot, length(matlabroot));
% extract from list the exact function we want to be able to call
selFunc = list{find(f, 1)} 

% temporarily switch to the containing folder
here = cd(selFunc(1:end-length(this))); 
% grab a handle to the function
fu=str2func(selFunc)

fu('hey')
% go back to where we came from
cd(here); 


shippedout = 0;
return
end