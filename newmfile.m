function newmf(newMFileName)
%
% newmf.m--Makes a new m-file with standardized header.
%
% newmf.m will not overwrite existing files.
%
% User will be prompted to choose whether or not to edit the new m-file. By
% default, the MATLAB built-in editor is used. See the help for Matlab's
% edit.m to see how to over-ride this.
%
% Syntax: newmf(newMFileName);
%
% e.g.,   newmf newprogram
% e.g.,   newmf /home/talpa/bartlett/temp/newprogram

% Developed in Matlab 6.0.0.88 (R12) on SUN OS 5.8.
% Kevin Bartlett (kpb@uvic.ca), 04/2001.
%---------------------------------------------------------------------

% Change the following lines to customize newmf.m.
authorName = 'Manuel Del Basso (mainster87)';
authorEmail = 'manuel.delbasso@gmail.com';

% ...String describing the organization to which the author belongs. This
% string will appear in the second line of the attribution block preceded
% by the word 'for' (e.g., 'for the VENUS project (http://venus.uvic.ca/)'.
% Leave this string empty if you don't want an organization line.
orgStr = '';

% Set to true if you want to be given a choice at runtime of whether to
% invoke editor. If false, then you won't be given a choice and the default
% behaviour will be invoked (see below).
doAskToEdit = true; 

% If defaultDoEdit is true, editor will be invoked for the new file by
% default. 
defaultDoEdit = true;

% Collect information from system for printing to m-file header.
OS = computer;
matlabVersion = version;
createTime = now;

dateStr = datestr(createTime,'yyyy-mm-dd HH:MM');

% Append a .m extension to the filename if needed.
[path,baseName,ext] = fileparts(newMFileName);

% Use current directory if none specified.
if isempty(path)
    path = pwd;
end % if

if isempty(ext)
    name = [baseName '.m'];
elseif strcmp(ext,'.m')==1,
    name = [baseName ext];
else
    error([mfilename '.m--Must specify a ".m" extension, or no extension at all.']);
end % if

fullName = fullfile(path,name);

% Determine whether the file already exists.
if exist(fullName,'file')
    error([mfilename '.m--File ' fullName ' already exists. Choose another name or delete existing version.']);
end % if

% Some versions of Matlab will not accept m-files with filenames longer
% than 31 characters (e.g., tried to run
% initialise_start_stop_indices_file.m under Matlab version 6.1.0.450 and
% got:
% "Undefined function or variable 'initialise_start_stop_indices_f'".
MAXVARLENGTH = 31;

if length(baseName) > MAXVARLENGTH
    
    if length(baseName) > namelengthmax
        mssg = sprintf('Specified filename has more than %d characters.\n Your version of Matlab will not recognise filenames this long.',namelengthmax);
    else
        mssg = sprintf('Specified filename has more than %d characters.\n Some versions of Matlab will not recognise filenames this long.',MAXVARLENGTH);
    end % if

    disp(mssg);
    response = input(['Do you still want to create ' name '? (Y/N):  '],'s');
    
    if strncmp(lower(response),'y',1)==0,
        return;
    end % if
    
end % if

% Create the new m-file.
fid = fopen(fullName,'wt');

if fid<0,
    error([mfilename '.m--Failed to create new m-file ' fullName]);
end % if

head='%FUNCTION_NAME - One line description of what the function or script performs (H1 line)%Optional file header info (to give more details about the function than in the H1 line)
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    input1 - Description
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%    output2 - Description
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Denis Gilbert, Ph.D., physical oceanography
% Maurice Lamontagne Institute, Dept. of Fisheries and Oceans Canada
% email address: gilbertd@dfo-mpo.gc.ca  
% Website: http://www.qc.dfo-mpo.gc.ca/iml/
% December 1999; Last revision: 12-May-2004

%------------- BEGIN CODE --------------

Enter your executable matlab commands here

%------------- END OF CODE --------------

return 


% Place the header in the new m-file.
fprintf(fid,'%s\n',['function [] = ' baseName '()']);
fprintf(fid,'%s\n','%');
fprintf(fid,'%s\n',['% ' name '--']);
fprintf(fid,'%s\n','%');
fprintf(fid,'%s\n',['% Syntax: ']);
fprintf(fid,'%s\n','%');
fprintf(fid,'%s\n',['% e.g.,   ']);

% ...Create the attribution block.
fprintf(fid,'%s\n','');
%fprintf(fid,'%s\n',['% Developed in Matlab ' matlabVersion ' on ' OS '.']);
fprintf(fid,'%s',['% Developed in Matlab ' matlabVersion ' on ' OS]);

% ......If no organization string, then end this line with a period.
if isempty(orgStr)
    fprintf(fid,'.\n');
else
    fprintf(fid,'\n');
end % if

% ......If an organization string specified, print it out.
if ~isempty(orgStr)
    fprintf(fid,'%% for %s.\n',orgStr);
end % if

fprintf(fid,'%s\n',['% ' authorName ' (' authorEmail '), ' dateStr]);
fprintf(fid,'%s\n','%-------------------------------------------------------------------------');
fprintf(fid,'%s\n','');

fclose(fid);

disp([mfilename '.m--New m-file ' fullName ' created.']);

doEdit = defaultDoEdit;

if doAskToEdit==true
    
    response = input(['Would you like to edit ' name '? (Y/N):  '],'s');
    
    if strncmp(lower(response),'y',1)==1
        doEdit = true;
    else
        doEdit = false;
    end % if
    
end % if

if doEdit == true
    edit(fullName);
end % if