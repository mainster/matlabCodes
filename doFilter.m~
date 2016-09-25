function varargout = doFilter(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% varargout = doFilter(varargin)
%
% Aufnehmen von Sprachkommandos                                       @@@MDB
%
if nargin < 1
    error('No input parameter given')
end

if nargin >= 1
    if ~iscell(varargin{1})
        error('Need cell as input')
    end
    IN = varargin{1};
    
end
    %% -------------------------------------------------------------------------
    % HP Filter konstruieren
    % --------------------------------------------------------------------------
    Fpass = 3.5e3;  Fstop = 5e3;    Fs = [objRt{1,2}, objRef1{1,2}];    
    Apass = 20;     Astop = 1;      N = 4;

    % Filter Koeffizienten
    ctp = firls(N, [0 Fpass Fstop Fs(1)/2]/(Fs(1)/2), [1 1 0 0], [Apass, Astop]);
    ofir1 = dsp.FIRFilter('Numerator', ctp);   
    ctp = firls(N, [0 Fpass Fstop Fs(2)/2]/(Fs(2)/2), [1 1 0 0], [Apass, Astop]);
    ofir2 = dsp.FIRFilter('Numerator', ctp);  

    %% -------------------------------------------------------------------------
    % Filter anwenden
    % --------------------------------------------------------------------------
    stRt.orig = objRt{1};
    stRt.hped = step(ofir1, objRt{1});
    stRef1.orig = objRef1{1};
    stRef1.hped = step(ofir2, objRef1{1});

    %% --------------------------------------------------------------------------
    % Step response plotten
    % --------------------------------------------------------------------------
    if 0
        f7 = figure(7); clf; SUB=220; 
        clear tt;
        tt{1} = [0:1/Fs(1):length(stRt.orig)/Fs(1)-1/Fs(1)]';

        DATA = {stRt.orig, stRt.hped, stRef1.orig, stRef1.hped};
        VNAMEV = {vname(stRt.orig), vname(stRt.hped), vname(stRef1.orig), vname(stRef1.orig)};
        KEY = {'Ungefiltert', 'HP- gefiltert', 'Ungefiltert', 'HP- gefiltert'};
        for k=1:4
            su(k)=subplot(SUB+k); hold all; grid on;
            pl(k) = plot(tt{1}, DATA{k}); hold off;
            title(sprintf(['%s   fs = %g samples/sec'], VNAMEV{k}, Fs(1)));
        end
    end
end