function varargout = idSpice (varargin)
%   identify tf, analyze LTSpice export of frequency domain data 
%
%   TF = idSpice( FILENAME, VARS, FREQ_FOCUS, LAPLACE)
%
%       FILENAME FILENAME   is a string containing the name and path of
%                           the LTspiceIV .raw file to be converted.
%       VARS                is a string containing the name of LTSpice
%                           net name to be converted.
%           ('auto:1')      If you pas 'AUTO:N' to this parameter, idSpice
%                           trys to invoke the net name from a LTspice-
%                           plot- config file *.plt. N is the trace number
%                           to select, if signal selection count in LTspice 
%                           plot viewer is greater than 1
%
%                     NOTE: at this time, only the first plot pane will be
%                           parsed!!
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
% BUG:  DC- phase is SOMETIMES incorrect              @@@MDB 2-01-2015
% ----------------------------------------------------------------------------
%
% SOLVED:	Sporadisch hatten die mit idSpice approximierten Systeme einen
%           Phsendreher, bodeplots und nyquist- Diagramme haben bei +180°
%           angefangen. Manche Spicenetze wurden Fehlerfrei approximiert, andere
%           nicht...
%
%           MATLAB + ctrl-system-toolbox geht natürlich IMMER von Gtot ~ 1 aus.
%           Bei meiner freq. resp. identification Funktion idSpice kann nirgends
%           vorgegeben werden, ob der Frequenzgang von einer Schaltung mit
%           invertierendem Signalverlauf stammt oder eben nicht. !!!
%
% FIXME:    idSpice bekommt ein vararg wo man angeben kann, ob ein
%           invertierendes System approximiert werden soll oder nicht.
%           Entsprechend muss dann  >>>>> VOR <<<<< dem eigentlichen
%           Approximationsvorgang ( idfrd() ) der importierte complexwertige
%           Datensatz auf die Standardform gebracht werden, also cmpxCorrected =
%           abs(cmpx)*e^(j*arg(cmpx)-180°) =
%
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%                     
%
%       FREQ_FOCUS          is a row vector containing the frequency range
%                           focus for tf estimation. [Hz]
%       ORDER               is a row vector containing the order of
%                           approximation as [n_POLES n_ZEROS]
%                           focus for tf estimation. [Hz]
%       LAPLACE             is a flag for a LTSpice conform output of the
%                           estimated transfer function. 
%                           if true, string is written directly into clipboard
%                           buffer.
%       
%   example: 
%       Estimate a tf from complex frequency response simulation data.
%       From circuit input to V(out_A) with freq. range focus up to 2MHz
%       and a model with 2 poles and one zero in its estimated tf.
%
%   tfCC=idSpice('powerstage_PushPull_FET_lochraster_KOB.raw', 'V(out_A)',[0 2e6],[3 1],0);
%   
%   Manuel Del Basso    @@@MDB
%   2014-07-18
%

%------------------------------------------------------
%--- Default parameter values
%------------------------------------------------------
lap=0;
freqFocus=[];
orders=[3,2];
try2invokeNetNames = 0;
failures=0;


    if nargin==0,
        error( 'No input path for LTSpice raw- file' );
    elseif nargin==1,
        if ~exist(varargin{1},'file')
            error(['file ' varargin{1} ' could not be located in PATH space!'])
        end
    end
%%
    if nargin >= 2,
        selected_vars = varargin{2};
        if ischar(selected_vars)
            if strfind(lower(selected_vars),'auto')
                [nthTrace, matches] = strsplit(selected_vars,':');
                if ~isempty(matches)

                try 
                    nthTrace = str2num(nthTrace{2});
                catch err
                    disp(sprintf('catched: %s',err.identifier))
                    err('input something like   auto:3  to select signal trace number 3')
                end
    
    
                end
                try2invokeNetNames = 1;
            else
                selected_vars = lower(selected_vars);
            end
        else
            error('parameter 2 is string type!')
        end
    end
 %%   
    if nargin >= 3
%         selected_vars = varargin{2};
%         if ischar(selected_vars),  selected_vars = lower(selected_vars);  end

        freqFocus=varargin{3}*2*pi;
        [m n]=size(freqFocus);
        if ~isnumeric(freqFocus) || m>1
            error( 'Bad freq. focus' );
        end
    end
    if nargin >= 4
        orders=varargin{4};
        if ~(isnumeric(orders) && size(orders,1)==1 && size(orders,2)==2)
%            error( 'Bad order parameter' )
            isnumeric(orders)
             size(orders,1) 
             size(orders,2)
        end            
    end
    
    if nargin >= 5
        lap = varargin{5};
        if ischar(lap), lap=str2num(lap);   end
    else
        warning(['arg 5 must be a string,' ''' 0''' ' or' ''' 1'''])
        lap = 0
    end
% find path of LTSpice projects directory   
%     paths=strsplit(path,':'); 
%     fi=strfind(paths(:),'LTSpice_projects');
%     ind=find(~cellfun(@isempty, fi));
%     sp=strsplit(paths{ind(1)},'LTSpice_projects');
% %    ind=find(~isempty((strfind(paths(:),'LTSpice_projects'))));
%     rawPath=[sp{1} 'LTSpice_projects' '/' varargin{1}];
%     
%     if isempty(ascExpPath)
%         ascExpPath='OpAmp_LT1028_biased_currentsource_test.txt';
%     end
%     clear st;
%     tdat=[];
% 
%     fid=fopen(ascExpPath);
%     st=textscan(fid,'%s',2);
%     tdat=textscan(fid,'%f %f,%f','CollectOutput', 1);
%     fclose(fid);

%     if isempty(tdat)
%         disp('non standard spice export')
%         fid=fopen(ascExpPath);
%         st=textscan(fid,'%s',2);
%         tdat=textscan(fid,'%f,%f,%f','CollectOutput', 1);
%         fclose(fid);
%     end
% 
%     freq=tdat{1}(:,1);
%     re=tdat{1}(:,2);
%     im=tdat{1}(:,3);
%     cpx=re+1j*im;       % <------- import this as complex freq. function

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Try to invoke the Signal trace from a plot config file *.plt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if try2invokeNetNames
    fullFilePath = which(varargin{1});
    pltFile = strrep(varargin{1},'raw','plt');
    
    if exist(pltFile, 'file')  % plot- config exists?
%        disp(sprintf('%s ...\nEXISTS',pltFile));

% import config lines
        LINES = importdata(pltFile,'\n');
        ind = find(~cellfun(@isempty, strfind(lower(LINES), 'traces')));
% delimit all length(ind) substrings
        delims = cellfun(@strsplit, LINES(ind),repmat({{':','{'}},...
            length(LINES(ind)),1),'UniformOutput',false);

        for k=1:length(delims)
             if (str2num(delims{k}{2}) == (length(delims{k})) - 2)
%                 disp(['traces count matches' delims(k)]);
             else
                 error (sprintf('wrong traces count %s', delims{k}{end}))
             end
        end
        
        try 
%            traceNames = strsplit(delims{nthTrace}{3},'"');
            traceNames = strsplit(delims{1}{1,nthTrace+2},'"');

        catch err
            disp(sprintf('catched: %s',err.identifier))
            warning(sprintf('No signal number %i found in plt file. Default: selecting signal 1',...
                nthTrace))
            traceNames = strsplit(delims{1}{3},'"');   
            failures=1;
        end
        
        selected_vars = traceNames{2};
        disp (sprintf('idSpice: Selecting trace:\t--> #%i\t%s', nthTrace, selected_vars))
    else
        error('No plt file found, need a signal name!')
    end
end
%%

    raw=LTspice2Matlab(varargin{1},[]);
    
    ind=find(strcmpi(raw.variable_name_list, selected_vars));
    if isempty(ind)
        error( 'variable name not found' )
    end;
    
    raw=LTspice2Matlab(varargin{1}, ind);
        cpx=raw.variable_mat;
    
    if isfield(raw,'freq_vect')
        freq=raw.freq_vect;
    else
        if isfield(raw,'time_vect')
            error(sprintf('%s\nis a spice transient analyze raw file. Need a AC- analyze raw file!',varargin{1}))
        end
    end
    
    fr_data=idfrd(cpx,freq,0);
    set(fr_data,'FrequencyUnit','Hz')

    estOpt=tfestOptions;
    estOpt.SearchOption.MaxIter=200;
    estOpt.Focus=freqFocus;

    %----------------------------------------------------
    estTf=tfest(fr_data,orders(1),orders(2),estOpt);
    %----------------------------------------------------
if 0
    cpx2 = cpx.*exp(j*pi/2.*length(cpx));
    semilogx(freq, angle(cpx)*180/pi); hold all;
    semilogx(freq, angle(cpx2)*180/pi); hold off;
    grid on;
        fr_data2=idfrd(cpx2,freq,0);
        set(fr_data2,'FrequencyUnit','Hz')

        estOpt=tfestOptions;
        estOpt.SearchOption.MaxIter=200;
        estOpt.Focus=freqFocus;

        %----------------------------------------------------
        estTf2=tfest(fr_data2,orders(1),orders(2),estOpt);
        %----------------------------------------------------
        estTf = estTf2;
    
end
    syms s;
    
    spowN=s.^[length(estTf.num)-1:-1:0];
    spowD=s.^[length(estTf.den)-1:-1:0];

    noteLap=sprintf('laplace=(%s)/(%s)',...
                    strrep( strrep(char(vpa(estTf.num*spowN.',4)),'^','**'), ' ',''),...
                    strrep( strrep(char(vpa(estTf.den*spowD.',4)),'^','**'), ' ',''));
    if lap > 0
        noteLap
        clipboard('copy', noteLap);
    end
    
%    rawPathO = searchPath(varargin{1});
     rawPathO = varargin{1};
    noteRow=sprintf(' - LTSpice %s', rawPathO);
    
    estTf.Notes={   'estOpt=tfestOptions;',...
                    'estOpt.SearchOption.MaxIter=200;'...
                    'estOpt.Focus=[0 2e6*2*pi];',...
                    '',...
                    ' - Fit Frequency Range: 0...2e6*2*pi',...
                    noteRow,...
                    ' - Freq. response estimation of current controller',...
                    '',...
                    'Laplace tf for direct LTSpice import: ',...
                    noteLap,...
                    ''};
                
                
	varargout{1} = estTf;
    
    if nargout >= 2
        format4Fieldname = strrep(selected_vars,'(','_');
        format4Fieldname = strrep(format4Fieldname,')','');
        varargout{2} = format4Fieldname;
    end
    if nargout == 3
        varargout{3} = failures;
    end
    
end