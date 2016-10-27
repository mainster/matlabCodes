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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Navigating supplemental software documentation freezes Matlab help browser.
%
% Fixit: The following suggestion from Mathworks support solved this problem for
% me: Execute the following command at the beginning of a MATLAB session at the
% MATLAB command window:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% com.mathworks.mlwidgets.html.HtmlComponentFactory.setDefaultType('HTMLPANEL');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%cd /home/mainster/CODES_local/matlab_workspace/RT_projects/GalvoProjekt/
cd /home/mainster/CODES_local/matlab_workspace/
optn=nyquistoptions('cstprefs');
optn.ShowFullContour='off';
optn.grid='off';

optb=bodeoptions('cstprefs');
optb.FreqUnits='Hz';
optb.grid='on';
optlti = {'bode';'nyquist';'pzmap';'step';'impulse'};
optlti2 = {'bode';'nyquist';'pzmap'};

projectsPath='/home/mainster/CODES_local/matlab_workspace/';
ltspicePath='/home/mainster/CODES_local/LTSpice_projects/';

global setWrap getWrap reim vname par2 par3;

setWrap = @(x,y)    set(x,y);
getWrap = @(x,y)    get(x,y);
reim    = @(x)      [real(x),imag(x)];
vname   = @(x)      inputname(1);
par2    = @(x,y)    (x.*y)./(x+y);
par3    = @(x,y,z)  (x.^(-1)+y.^(-1)+z.^(-1)).^(-1);

% Run this fprintf only if built-in fprintf is not shadowed by a function
% inside user workspace
if ~strcmp(which('fprintf'), 'matlab_workspace')
   disp('fprintf() built-in is not shadowed')
   fprintf('\nsetWrap = %s\ngetWrap = %s\nreim = %s\nvname = %s\npar2 = %s\npar3 = %s\n',...
      char(setWrap),char(getWrap),char(reim),char(vname),char(par2),char(par3))
end

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

global ol;
ol=struct();
for k=1:length(fields)
   ol.(fields{k}) = vars{k,1};
end

fields = fields';
fields( ~cellfun(@isempty,(strfind(fields,'ol'))) ) = [];
eval(['clear ' cell2mat(strcat(fields, repmat({' '},1,length(fields)))) ' envc'])

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BUNDLED!!!!
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ds='---------------------------------------';

%% Update relating global variable definition  01-07-2015
% basic function definitions are no longer global workspace variables. Using
% appdata functionality instead ans attach the structure bf to the most parent
% root handle (this is 0)!
%
% attach:            setappdata(0, <keyword>, <data object>)
% from every where:  <data object> = getappdata(0, <keyword>)
%
%% global csigma rect tri lin;

bf.csigma=@(x) heaviside(x);
bf.rect=@(x) heaviside(x+0.5)-heaviside(x-0.5);
bf.tri=@(x) (x+1).*heaviside(x+1)-2.*x.*heaviside(x)+(x-1).*heaviside(x-1);

setappdata(0,'basefunctions',bf);

% Run this fprintf only if built-in fprintf is not shadowed by a function
% inside user workspace
if ~strcmp(which('fprintf'), 'matlab_workspace')
   fprintf('csigma = %s\nrect = %s\ntri = %s\n%s\n',...
      char(bf.csigma),char(bf.rect),char(bf.tri),ds)
end

clear bf;

lin=@linspace;
%clear fields

%% Find matlab version of current instance
ver=version;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Dark color theme for all figures/axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colordef('black')
%reset(groot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change some default options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%'DefaultAxesFontName','Swiss 721',...

set(groot,...
   'DefaultAxesXGrid',           'on',...
   'DefaultAxesYGrid',           'on',...
   'DefaultAxesFontSize',        11,...
   'ShowHiddenHandles',          'on',...
   'DefaultTextFontSize',        11,...
   'DefaultFigurePosition',      [1930 400 845 600],...
   'DefaultFigureColor',         [1 1 1]*.175,...
   'DefaultLineLineWidth',       1); %,...
%   'DefaultLegendInterpreter',         'tex');
%         'DefaultFigureColor',         [1 1 1]*0.82 );
%         'DefaultAxesColor',           [1 1 1]*0.96,...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default options only for R2015a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(strfind(ver,'R2015a'))
   set(groot, ...
      'DefaultAxesGridAlpha',       0.5,...
      'DefaultLegendInterpreter',   'tex')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default options only for R2013a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(strfind(ver,'R2013a'))
   %    set(0,  'DefaultAxesGridAlpha',       0.2);
end

%%

%% Standard symbols
global w f t w0 f0 T0 T
syms w f t w0 f0 T0 T real

%% List all global variables, generated up to this point and
nam_=who('global');
disp('Variables declared with attribut ''Global'':\n')
disp(nam_)

clear *_;

global pi2;
pi2=sym(2*pi);

bf = getappdata(0,'basefunctions');

rect=bf.rect;
tri=bf.tri;
csigma=bf.csigma;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Safe "Initial vars" list
INITIALVARS=[];
INITIALVARS = whos;
INITIALVARS = struct2cell(INITIALVARS);

INITIALVARS = INITIALVARS(1,:);

fprintf(['To reset variable workspace to initial state, type:\n\n',...
   '\tclearvars(' '''-except''' ',INITIALVARS{:})\n\n'])
fprintf(['Run following command from command prompt:\n\n',...
   'com.mathworks.mlwidgets.html.HtmlComponentFactory.setDefaultType(''HTMLPANEL'')\n\n'])



s=tf('s');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Keep input focus on console window after hitting a breakpoint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(strfind(ver,'R2015a'))
    com.mathworks.services.Prefs.setBooleanPref('EditorGraphicalDebugging',false)
end