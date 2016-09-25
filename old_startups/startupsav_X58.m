%STARTUPSAV   Startup file
%   Change the name of this file to STARTUP.M. The file 
%   is executed when MATLAB starts up, if it exists 
%   anywhere on the path.  In this example, the
%   MAT-file generated during quitting using FINISHSAV
%   is loaded into MATLAB during startup.

%   Copyright 1984-2000 The MathWorks, Inc. 
%   $Revision: 1.4 $  $Date: 2000/06/01 16:19:26 $

%load matlab.mat

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % exec shortcut 'cd CODES_local'
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
% jDesktop.getMainFrame.setTitle('... Really a Soft Skill? ...');

format shortg

%cd /home/mainster/CODES_local/matlab_workspace/RT_projects/GalvoProjekt/
cd /home/mainster/CODES_local/matlab_workspace/
optn=nyquistoptions;
optn.ShowFullContour='off';
optn.grid='off';

optb=bodeoptions;
optb.FreqUnits='Hz';
optb.grid='on';

projectsPath='/home/mainster/CODES_local/matlab_workspace/';
ltspicePath='/home/mainster/CODES_local/LTSpice_projects/';

setWrap = @(x,y)    set(x,y)
getWrap = @(x,y)    get(x,y)
reim    = @(x)      [real(x),imag(x)]
vname   = @(x)      inputname(1)
par2    = @(x,y)    (x*y)/(x+y) 
par3    = @(x,y,z)  (x^(-1)+y^(-1)+z^(-1))^(-1)

cl=clock; 
timeAndDate=sprintf('Date: %i-%i-%i\tTime: %i:%i:%i', fliplr(cl(1:3)), round(cl(end-2:end)));

scrsz = get(0,'ScreenSize');
scr.x=scrsz;
scr.x1=scrsz(3)-1440;scr.x2=scrsz(3)-1920;scr.y=scrsz(4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bundle environmental variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fields=[];  k=[];   vars=[];    envc=[]; 

envc = struct2cell(whos);
fields = envc(1,:)';
fields( find(~cellfun(@isempty,(strfind(fields,'ans')))) ) = [];

% vars = eval(fields)
vars=cellfun(@eval, fields,'UniformOutput', false);
ol=struct();
for k=1:length(fields)
    ol.(fields{k}) = vars{k,1};
end

fields = fields';
fields( find(~cellfun(@isempty,(strfind(fields,'ol')))) ) = [];
eval(['clear ' cell2mat(strcat(fields, repmat({' '},1,length(fields)))) ' envc'])

ds='---------------------------------------';

%clear fields

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set default text options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(0,  'DefaultAxesFontName','Swiss 721',...
        'DefaultAxesFontSize',12);

set(0,  'DefaultTextFontName','Swiss 721',...
        'DefaultTextFontSize',12);
%        'DefaultTextInterpreter','latex');


%run softSkill.m
%%
p = mfilename('fullpath')
