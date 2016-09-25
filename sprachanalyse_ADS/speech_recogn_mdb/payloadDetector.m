function [objOut] = payloadDetector(seqIn, minLvl, pre, post, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% payloadDetector.m                                                      @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% funktion zur Erkennung und isolierung der eigentlichen
% Nutzdaten in einer wave- Datei:
% Noise am Anfang/Ende einer Aufnahme   -> keine Nutzdaten
% Mikrofon- Knaxen, kurze peaks         -> keine Nutzdaten
%
% Sinnvoll Anwendung: 
% Referenz- wav- Sequenzen auf minimales Pre- Mute kürzen;
% Sprachkommandos mit syncSeqToRef.m Synchronisieren
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% [objOut] = payloadDetector(seqIn, minLvl, PREDELAY, POSTDELAY)
%% [objOut] = payloadDetector(..., NORM)
%
% seqIn:            Input sequenze roe or column vector
% minLvl:           Threshold level for mute detection
%                   NUMERIC or string eg. '-20dB'
% NORM:             Normalize vector to given magnitude
%                   NUMERIC or string eg. '-20dB'
% PREDELAY:         integer count of samples that are not removed
%                   so the first PREDELAY samples could be less
%                   than minLvl
% POST:             integer count of samples that are not removed
%                   so the last PREDELAY samples are less
%                   than minLvl
%                   
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Check function arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isnumeric(seqIn)
    error('arg 1 must be numeric')
end

if ~(isnumeric(pre) && isnumeric(post))
    error('arg PREDELAY and POSTDELAY must be numeric value betwen 0...maxSam')
end

[dr, dc] = size(seqIn);
if min(dr, dc) > 1
    error('arg 1 must be row or column vector')
end

if ~isnumeric(minLvl) 
    if ~ischar(minLvl)
        error('parameter minLvl must be numeric or char string with pseudo unit dB')
    end
    if isempty(strfind(lower(minLvl), 'db'))
        error('parameter minLvl must have pseudo unit dB if a char string is used')
    end
    spl=strsplit(lower(minLvl),'db');
    gaindB = str2num(spl{1});
    if gaindB > 0
        error('minLvl gain must be smaller or equal to 0dB')
    end
else
    if varargin{1} > 1
        error('gain must be smaller or equal to 1')
    end
    gaindB = 20*log10(abs(varargin{1}));
end

% if ~isnumeric(maxMuteDuration)
%     error('arg 2 and arg 3 must be numeric')
% end

if nargin >= 5
    if ~isnumeric(varargin{1})
        if ~ischar(varargin{1})
            error('4th parameter must be numeric or char string with pseudo unit dB')
        end
        if isempty(strfind(lower(varargin{1}), 'db'))
            error('4th parameter must have pseudo unit dB if a char string is used')
        end
        spl=strsplit(lower(varargin{1}),'db');
        normdB = str2num(spl{1});
        if gaindB > 0
            error('gain must be smaller or equal to 0dB')
        end
    else
        if varargin{1} > 1
            error('gain must be smaller or equal to 1')
        end
        normdB = 20*log10(abs(varargin{1}));
    end
end

y = seqIn;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Festlegung: Referenz- Signale und Sprachcommando müssen die
% ersten PRE_DELAY samples ein quiet delay besitzen. Die Audiopegel in
% diesem Bereich dürfen den Wert 3/DIVS (3/20) der maximal vorkommenden
% Signalamplitude nicht überschreiten. Alle Sequenzen werden auf
% identische quiet- delays zugeschnitten (sync)
% ALT!!!    ALT!!!    ALT!!!    ALT!!!    ALT!!!    ALT!!!    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    PRE_DELAY = abs(pre);     % [samples]
    POST_DELAY = abs(post);     % [samples]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global figH;

if ~evalin('base','exist(''figH'',''var'')')
    evalin('base','global figH');
end    

if ~evalin('base','exist(''SUB_BASE'',''var'')')
    warning('Can not find variable SUB_BASE in base workspace, starting with 230')
%    SUB_BASE = 230;
    evalin('base','SUB_BASE=230');
    evalin('base',sprintf('f99=figure(99)'))
    evalin('base',sprintf('for u=1:5; subp(u)=subplot(SUB_BASE+u); end'));
else
 %   SUB_BASE = evalin('base','SUB_BASE');
end    


    
% z = [zeros(1,20), 1 1 1 1 1 0 1 0 0 1, zeros(1,20), round(rand(1,100)), zeros(1,20), 1 1 1 1 1 0 1 0 0 1, zeros(1,20) ]
    LOWERTHAN = 10^(gaindB/20);     % Grenzwert umrechnen
    lowvol = find(diff( find(y(:,1) < LOWERTHAN) )-1, 1, 'first'); 
    lowvolLast = find(diff( find(y(:,1) < LOWERTHAN) )-1, 1, 'last'); 

    if 0
        k=1;
        %% Create figure handle in base workspace
        evalin('base',sprintf('figure(99)'))
        baseH=evalin('base',sprintf('subplot(SUB_BASE)'));
        %% eval a handle copy through this function workspace
%        subpN=evalin('base',sprintf('subp(%i)',SUB_BASE));
%        set(figH,'name',['payloadDetector.m No: ( ' num2str(figNumber) ' )'],'NumberTitle','off');
        xx=[0:length(y)-1];
        h = plotyy(baseH, xx,20*log10(abs(y)), xx, y); grid on;
        set(h(k),'YTick',linspace(min( get(h(k),'YTick')),...
        max( get(h(k),'YTick')),11));
    end
            
    if (~isempty( find(lowvol < PRE_DELAY) ))
        warning('wenig quiet delay')
    end
    
    if exist('normdB','var')
        fprintf('Peak magnitude befor norm to %gdB: %.2gdB\n', normdB, 20*log10(max(y)));
        y = y/max(y) * 10^(normdB/20);
        fprintf('Peak magnitude after norm to %gdB: %.2gdB\n', normdB, 20*log10(max(y)));
    end
    
    % Vorne wegschneiden.... % Hinten wegschneiden...
    y([1:lowvol-PRE_DELAY, lowvolLast+POST_DELAY:end]) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
objOut = y;

end


%