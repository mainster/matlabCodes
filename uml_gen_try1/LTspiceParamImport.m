function varargout = LTspiceParamImport (ascfile, varargin)
% LTSPICEPARAMIMPORT    Scan and import parameters from LTspice *.asc files.
% Place pattern ".param MATLAB_PARAM=1" at the beginning of '+ (...)' extended
% parameter list as spice directive, for example:
%
% .param MATLAB_PARAM=1
% + Ve = 5V
% + Rc = 1k
% + R1 = 2u
% + R2 = 2m
%
%     LTSPICEPARAMIMPORT(ASCFILE) scan file 'ASCFILE' and evaluate params in
%     "base" workspace.
%
%     LTSPICEPARAMIMPORT(___ 'strucnam', STRUCNAM) scan file 'ASCFILE'
%     and evaluate params in "base" workspace using 'STRUCNAM' as a structure
%     name prefix.
%
%     STRUC_OUT = LTSPICEPARAMIMPORT(___ ['strucnam', STRUCNAM]) scan file
%     'ASCFILE' and evaluate params in "base" workspace using 'STRUC_OUT' as a
%     structure name prefix, ignoring 'strucnam', STRUCNAM if given.
%
%     [STRUC_OUT, STRUC_ORIG] = LTSPICEPARAMIMPORT(___) scan file
%     'ASCFILE' and evaluate params in "base" workspace using 'STRUC_OUT' as a
%     structure name prefix, ignoring 'strucnam', STRUCNAM if given. Retrun
%     original spice param strings in STRUC_OUT
%
%     LTSPICEPARAMIMPORT(___ 'evalin', EVALIN) ... and evaluate params in
%     workspace EVALIN using 'STRUCNAM' as a structure name prefix.
%  
%     EVALIN: 'base'    Default, eval param set in base workspace.
%             'none'    Do not evaluate param set in base workspace. Return
%                       structure containing the unevaluated param strings.
%

% ------------------------------------------------------------------------------
%   Check function arguments by inputParser
% ------------------------------------------------------------------------------
p = inputParser;

vEvalin = { 'base','global','caller','local'};
valEvalin = @(x) ischar(x) && any(validatestring(x,vEvalin));

addRequired(p,'ascfile', @checkpath);
addParameter(p,'strucnam', '', @ischar);
addParameter(p,'evalin', 'base', valEvalin);

parse(p, ascfile, varargin{:});
P = p.Results;
P.argout = false;

if nargout > 0
   % If outarg is sourced AND param value pair 'strucnam' is not an empty
   % string, throw warning that 'strucnam' gets ignored
   if ~strcmpi(P.strucnam, '')
      warning(['nargout > 0\nThis means that param value pair "strucnam",',...
               ' %s is beeing ignored!\n', P.strucnam]);
      P.strucnam = '';
   end
   
	P.argout = true;
   varargout{1}=[];
end
% ------------------------------------------------------------------------------
   
% Read lines from input file
fid = fopen(P.ascfile, 'r');
Cin = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);

% search pattern is MATLAB_PARAM=1
C1 = strfind(Cin{1}, 'MATLAB_PARAM=1');

% find index and create cell containing all lines that matches MATLAB...
lines = ~cellfun('isempty', C1);    
cp=Cin{1}(lines);   

if isempty(cp)
   error('Keywords "MATLAB_PARAM=1" no where found!\n');
else
   % cast cp to datatype cell if only one param set found 
   if ~iscell(cp)
      cp{1}=cp;
      disp('Single parameter set found...');
   else
      disp('Cell array of parameter set found...');
      cp
   end
end
% parse each param set into cell
cpk={zeros(1,length(cp))};

for k=1:length(cp)
   cpk{k} = strsplit(cp{k},'\\n+')';
   % remove first cell entry due its the search pattern
   cpk{k}(1,:)=[];       
   
   % cpk holds k subcells with n cellstrings like 'R1 = 1k'
   for n=1:length(cpk{k})   
      % remove all whitespaces
      cpk{k}{n} = cpk{k}{n}(cpk{k}{n} ~= ' ');

      try 
         pset{k}{1, n} = strsplit(cpk{k}{n},'=');
%          psets.([f num2str(n)]) = strtrim( strsplit(cpk{k}{n},'=') );
%          pset{k}{1, n-1}
      catch err 
         disp (err.message)
         disp ([k, n])
      end
   end
end

% Create delimiter cell array
delims = repmat({'='},length(cpk{1}),1);
tmp1 = cellfun(@strsplit, cpk{1}, delims,'UniformOutput',false);

% malloc 
parn=cell(length(tmp1), 2*length(tmp1{k})+1 );

% cell ENUMS
enpar.EQ     = 2;     % idx of equality '=' signs
enpar.ORIG   = 3;     % idx of original param strings
enpar.EE     = 4;     % idx of EE non-calc evaluations
enpar.EECLC  = 5;     % idx of calc and non-calc evaluations
enpar.COL    = 6;     % idx of semicolons

for k=1:length(tmp1)
   try
      parn(k, [1 enpar.ORIG]) = tmp1{k}; 
   catch erra
      disp(erra.message)
   end
end

% Parse different LTspice notations like 
% 'Ve=5V'   'Ve=5'   'Ve=5.'
% 'I0 = 1mA'   'I0 = 1m'   'I0 = .001A'   'I0 = .001'
%
% Search rhs cell fields for physical extensions like 'V' (Volt) or 'A'
%    cpk{1}
%
%    'Ve = 5V'
%    'Rc = 1k'
%    'R2 = 4.7k'
%    'Vbe0 = .65V'
%    'Ic0 = 3.88mA'
%
% find indices of numeric char 0-9 or \. followed by patterns_A
%
% idx=regexp(cpk{1},'[0-9\.][VAva]')
% extA = { 'fF'  ,'pP'  ,'nN' ,'uU' ,'mM' ,'kK','[mM]eg','gG','tT'  };
% ext = {'[fF]','[pP]','[nN]','[uU]','[mM]','[kK]','[[mM]eg]','[gG]','[tT]'};
% EE  = { 'e-15','e-12','e-9','e-6','e-3','e3','e6'    ,'e9','e12' };

% Store index of faulty params here and remove them from the evaluation string
% cell
idxFaulty = [];  

%%
EE ={'[fF]', 'e-15';...
     '[pP]','e-12';...
     '[nN]','e-09';...
     '[uU]','e-06';...
     '([mM]eg)','e06';...
     '[mM]','e-03';...
     '[kK]','e03';...
     '[gG]','e09';...
     '[tT]','e12';...
     '[vVaA]','' };     % remove physical V (Volt) and A (Ampere) extensions
   
c = parn(:, enpar.ORIG);
% find index of non-calc LTspice parameters, this means all members that are NOT
% of type {...}
try
   idxNonCalc = cellfun(@isempty,strfind(c,'{'));
   c(idxNonCalc) = regexprep( c(idxNonCalc), EE(:,1)', EE(:,2)');
   parn(:, [enpar.EE, enpar.EECLC]) = [c, c];
catch err
   disp(err.message)
end

% Construct CALLER evaluation string. Evaluate non-calc params locally, eg. in
% CALLER workspace. This is necessary because there might be some LTspice calc
% params defined inside spice command ".param" For example:
%     .param MATLAB ....
%     + Ve = 5V
%     + Ve2 = {Ve/2}
parn(:,[enpar.EQ, enpar.COL]) = [repmat({'='}, size(parn(:,2))),...
                                 repmat({'; '}, size(parn(:,2))) ];

% Eval non-calc params locally
try
   eval( strjoin(parn( idxNonCalc, [1, enpar.EQ, enpar.EE, enpar.COL] )',''));
catch err0
   disp(err0.message)
end

% index of calc params
iCalc = find(~idxNonCalc);

parn{end-2,3}((parn{end-2,3}~='{')' & (parn{end-2,3}~='}')');
% Normaly, logical indexing should be preferred. In this case, the eval command
% could only be processed if there are no calc-params which are function off
% other calc-params.
% Solve this problem by sequentially try to eval one calc param after the other
%

% Try to localy evaluate calc param eg. 'alpha = {beta/(beta+1)}' 
for KK=1:length(iCalc)
   try
%      parn{iCalc(KK), enpar.EECLC } = num2str(eval( parn{iCalc(KK),3}(2:end-1) ));
%      idxt2 = ((parn{iCalc(KK),enpar.EECLC}~='{')' & (parn{iCalc(KK),enpar.EECLC}~='}')');  

      parn{iCalc(KK), enpar.EECLC} = ...
         regexprep(parn{iCalc(KK), enpar.EECLC},'(\*\*)', '^');
      parn{iCalc(KK), enpar.EECLC} = ...
         regexprep(parn{iCalc(KK), enpar.EECLC},'[{}]', '');
      
      
%       { parn{ iCalc(KK),enpar.EECLC }(idxt2) };
      eval( [strjoin(parn( iCalc(KK), [1, enpar.EQ, enpar.EECLC] )','') ';']);
%       evalin('base',strjoin(parn( iCalc(KK), [1, enpar.EQ, enpar.EECLC] )',''));
      parn{ iCalc(KK),enpar.EECLC } = ...
               num2str( eval([parn{ iCalc(KK),enpar.EECLC } ';']) );
   catch err;
      disp(err.message)
      
      % If err message contains substring 'Undefined function or variable',
      % then display "Remove all..." error message string.
      if ~isempty(strfind(err.message,'Undefined function or variable'))
         % Find the "undefined" variable.
         [~, B] = strtok(err.message,'\''');
         undef = B(B~='''' & B~='.');
      
         % Add index to faulty param entrys index storage.
         idxFaulty = [idxFaulty iCalc(KK)];
      end
      % Insert 'NaN' into faulty EECLC-row using index variable 'idxFaulty'
      parn{iCalc(KK), enpar.EECLC} = 'nan';
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Base workspace evaluation | return struct generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evLogic = logical( strcmpi( P.evalin, {'base','global'} ));

if evLogic(1) || evLogic(2)   % this means evalin('base','...)
   if ~strcmpi( P.strucnam, '' )
      pparn = [ repmat({[P.strucnam '.']}, size(parn(:,2))),...
                parn(:, [1, enpar.EQ, enpar.EECLC, enpar.COL]) ];
   else
      pparn = parn(:, [1, enpar.EQ, enpar.EECLC, enpar.COL]);
   end
   
	if (P.argout == false)  
      evalin('base', strjoin(pparn(1:end,:)','') );   
   else
      for k=1:length(pparn)
         outA.(pparn{k,1}) = str2double(pparn{k,3});
      end
   end
   
   if nargout == 1
      varargout{1} = outA;
      return;
   end
   
   if nargout == 2
      for k=1:length(pparn)
         outB.(pparn{k,1}) = parn{k, enpar.ORIG};
      end
      varargout{1} = outA;
      varargout{2} = outB;
      return;
   end
else
   warning('Not implemented yet...\n')
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Callback functions for input parser 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TF = checkpath (x)
   TF = false;
   if ~ischar(x)
      error(['\n"ascfile" must be a string containing a relative or absolut',...
            'path to a LTspice *.asc file']);
   end
   
   if exist(x,'file') == 0
      error( '\nFile %s not found!', x );
   else
      if exist(x,'file') ~= 2
         error( '\nReturn value of exist( %s ,''file'') = %g ~= 2 \n',...
                           x, exist(x,'file'));
      else
         TF = true;
      end
   end

   