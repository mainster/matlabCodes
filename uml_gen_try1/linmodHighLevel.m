function ret = linmodHighLevel(varargin)
% @@@MDB
modType=[];
if nargin == 0
    error('Please give me a Model to linmod')
else
    if nargin >= 1
        if ~ischar(varargin{1})
            error('Please give me a Model to linmod, this is not a string to a model file')
        end
    end
    if nargin >= 2
        if ~isstruct(varargin{2})
            warning('Datatyp isnt struct, overwrite it')
            Stmp=varargin{2};
        else
            Stmp=varargin{2};
        end
    end
    if nargin >= 3
        if ~ischar(varargin{3})
            error('Argument 3 expects one of the following strings: LIN DLIN   ')
        else
            if ( isempty(strfind(lower(varargin{3}), 'lin')) && isempty(strfind(lower(varargin{3}), 'dlin')))
                error('Argument 3 expects one of the following strings: LIN DLIN   ')
            else
                modType=varargin{3};
            end
        end
    end
end

% *********************************************************************
%   SIMO LTI des Streckenmodells inkl. Input/Output- Namen
% *********************************************************************
% ------------------------------------------------------------------------
% Check wether we need to use dlinmod or linmod
% ------------------------------------------------------------------------
SYSTEM = varargin{1};
%load_system(sys);

ds='---------------------------------------------------';
clear blocks S P num den
blocks.name = find_system(SYSTEM,'type', 'block');

blocks.handle = cell2mat(get_param(blocks.name,'handle'));

for k=1:length(blocks.handle)
    try
        blocks.sampleTime(k,:) = {get(blocks.handle(k),'SampleTime')};
    catch err
        blocks.sampleTime(k,:) = {sprintf('catched: %s',err.identifier)};
    end
end
blocks.isTsInd = find(cellfun(@isempty, strfind(blocks.sampleTime, 'catched')));
indA=find(cellfun(@isempty, strfind(blocks.sampleTime(blocks.isTsInd),'-1')));

%type = get_param(gcs,'SolverType');

if ~isempty(modType)
    if strcmpi(modType,'lin')
        S.linmod=linmod(SYSTEM);
    end
    if strcmpi(modType,'dlin')
        S.linmod=dlinmod(SYSTEM,evalin('base','FS;'));
    end
else
	S.linmod=linmod(SYSTEM);
end    

if strfind(lastwarn, 'Ignoring discrete states (use DLINMOD for proper handling)')
  disp('dlinmod is used instead of linmod')
  S.linmod=dlinmod(SYSTEM,evalin('base','FS;'));
  lastwarn('no warnings');
end


S.linmod.filename = SYSTEM;
uu = strrep(S.linmod.InputName, [S.linmod.filename '/'], '');
yy = strrep(S.linmod.OutputName, [S.linmod.filename '/'], '');
S.linmod.InputName = uu;
S.linmod.OutputName = yy;

S.ss = ss(S.linmod.a, S.linmod.b, S.linmod.c, S.linmod.d, 'u', uu,'y',yy);
[nu de]=tfdata(S.ss);
S.tf = tf(nu, de, 'u', uu,'y',yy);
[zs ps ks]=zpkdata(S.ss);
S.zpk = zpk(zs, ps, ks, 'u', uu,'y',yy);

ret = S;
end
% end
% P = ss(S.a, S.b, S.c, S.d, 'u', uu, 'y', yy);       
% %%
% % nInlength(S.InputName);
% % nOutlength(S.OutputName);
% [num, den] = tfdata(P);
% n=1;
% 
% if ((length(S.InputName) > 1) && (length(S.OutputName) > 1))
%     fprintf('%s\n\tMIMO system\n%s',ds,ds)
%     Gsys = tf(num , den, 'u', uu, 'y', yy);
% end
% 
% if ((length(S.InputName) > 1) && (length(S.OutputName) == 1))
%     disp(sprintf('%s\n\tMISO system\n%s',ds,ds))
%     Gsys = tf(num , den, 'u', uu, 'y', yy);
% end
% %%
% if ((length(S.InputName) == 1) && (length(S.OutputName) > 1))
%     disp(sprintf('%s\n\tSIMO system\n%s',ds,ds))
%     NUMa=mat2cell(num, [ones(1, size(num,1))], size(num,2))
%     DENa=mat2cell(den, [ones(1, size(den,1))], size(den,2))
%     Gsys = tf(NUMa, den{1}, 'u', uu); 
% end
% 
% if ((length(S.InputName) == 1) && (length(S.OutputName) == 1))
%     disp(sprintf('%s\n\tSISO system\n%s',ds,ds))
%     Gsys = tf(num, den, 'u', uu, 'y', yy); 
% end
% 
% %%
% 
% P.Name = [S.filename]
% %Gsys.Name = [S.filename];
% 
% [A, b, c, d] = ssdata(P)
% [z p k]=zpkdata(P);
% 
% if exist('Stmp','var')
%     Stmp.S=S;
%     Stmp.ss=P;
%     Stmp.tf=Gsys;
%     Stmp.zpk=zpk(z,p,k);
%     
%     ret=S;
%     ret.a
% 
% end
% 
% end