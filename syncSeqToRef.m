%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% syncSeqToRef.m                                                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [varargout] = syncSeqToRef(seqCmd, seqRef, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% @@@MDB
% Synchronisieren eines Sprachbefehls mit einem Referenz- Befehl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% [SYNCED, OFFSET, LAG] = syncSeqToRef(seqCmd, seqRef, ...)
%% syncSeqToRef(..., NORM)
%% syncSeqToRef(..., NORM, SAMELENGTH)
%
% seqCmd:           Command input sequenze row vector
% seqRef:           Reference sequenze row vector
% NORM:             Normalize vector to given magnitude
%                   NUMERIC or string eg. '-20dB'
% LENGTH;           shorten the sample vector of the longer
%                   sequence... 
%                   LENGTH could be NUMERIC, 'equal', 'none'
%
% SYNCED:           synchronized sequenze output
% LAG:              lag [sample] (offset for synced sequence)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Check function arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p = inputParser;
    expLength = {'equal','none'};
    expNorm = {'db','dB','none'};

    valSeq = @(x) isnumeric(x) && ~isscalar(x);% && iscolumn(x) 
    valLength = @(x) isnumeric(x) || (ischar(x) && any(validatestring(x,expLength)));
    valNorm = @(x) isnumeric(x) || (ischar(x) && ~isempty(regexp(x,expNorm))); 

    addRequired(p,'seqCmd',valSeq);
    addRequired(p,'seqRef',valSeq);
    addParamValue(p,'norm','none',valNorm);
    addParamValue(p,'length','none',valLength);

    parse(p,seqCmd,seqRef,varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ischar(p.Results.norm)
        spl=strsplit(lower(p.Results.norm),'db');
        normdB = str2num(spl{1});
    else
        normdB = 20*log10(p.Results.norm);
    end

	if isnumeric(p.Results.length)
        lengthPar = p.Results.length;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Festlegung: Referenz- Signale und Sprachcommando müssen die
% ersten PRE_DELAY samples ein quiet delay besitzen. Die Audiopegel in
% diesem Bereich dürfen den Wert 3/DIVS (3/20) der maximal vorkommenden
% Signalamplitude nicht überschreiten. Alle Sequenzen werden auf
% identische quiet- delays zugeschnitten (sync)
% ALT!!!    ALT!!!    ALT!!!    ALT!!!    ALT!!!    ALT!!!    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    PRE_DELAY = 10;     % [samples]
%    POST_DELAY = 10;     % [samples]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% z = [zeros(1,20), 1 1 1 1 1 0 1 0 0 1, zeros(1,20), round(rand(1,100)), zeros(1,20), 1 1 1 1 1 0 1 0 0 1, zeros(1,20) ]
    sC = seqCmd;
    sR = seqRef;

    if ~strcmpi(p.Results.norm,'none')
        fprintf('Peak magnitude befor norm to %gdB: %.2gdB\n', normdB, 20*log10(max(sC)));
        sC = sC/max(sC) * 10^(normdB/20);
        fprintf('Peak magnitude after norm to %gdB: %.2gdB\n', normdB, 20*log10(max(sC)));
    end
    
    [xc,lags] = xcorr(sR, sC);
    [~,I] = max(abs(xc));
    
    if lags(I) > 0
%         error('Command sequenze pre mute duration to short --> lags(I) > 0')
        sCx=[sC(round(lags(I)/2):end); sC(1:round(lags(I)/2)-1)];
        sRx= sR;
    else
        sRx=[sR(round(lags(I)/2):end); sR(1:round(lags(I)/2)-1)];
        sCx= sC;
    end
    
%     sC = sC(1-lags(I):end);
    
%     if ~exist('lengthPar','var')
%         switch (p.Results.length)
%             case 'none'
% 
%             case 'equal'
%                 if length(sC) > length(sR)
%                     sC=sC(1:size(sR));
%                 end
%                 if length(sC) < length(sR)
%                     sR=sR(1:size(sC));
%                 end
%             otherwise
%         end
%     else
%        sC=sC(1:lengthPar); 
%        sR=sR(1:lengthPar); 
%        sCx=sCx(1:lengthPar); 
%        sRx=sRx(1:lengthPar); 
%     end
    
    varargout{1} = sCx;
    
    f33=figure(33); clf; hold all;
    plot(sR); 
    plot(sC);
    hold off; grid on;
    f34=figure(34); clf; hold all;
    plot(sRx); 
    plot(sCx);
    hold off; grid on;
    
    input('close plot?')

end


%