function [ref cmd] = payloadCorrelation (seqCmd, seqRef, varargin)

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
%     addParamValue(p,'norm','none',valNorm);
%     addParamValue(p,'length','none',valLength);

    parse(p,seqCmd,seqRef,varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wave files:
% Synchronisieren von referenz- Audiosequenz mit echtzeit-
% Aufnahme per autokorrelation
% Zeit akf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PATHA = '/home/mainster/CODES_local/matlab_workspace/wavefiles/14_56_53/backup2';
% 
% l = struct2cell(dir(PATHA));
% idx = find(~cellfun(@isempty, strfind(l(1,:),'.wav')));
% N = length(idx);

f39 = figure(39); clf;
SUB = 220;
   
 for k=1:1
%     speech{k}=audioread(fullfile(PATHA, l{1,idx(k)}));
    [xc,lags] = xcorr(seqCmd, seqRef);
    [~,I] = max(abs(xc));

    
    
    suf(k) = subplot(SUB+k); hold all
    plot(seqRef,'LineWidth',1); grid on;
    plot(seqCmd,'LineWidth',1); grid on;
    k=k+1;
    suf(k) = subplot(SUB+k); hold all
    if lags(I)>0
        ref=[round(seqRef(round(lags(I)/2):end)); round(seqRef(1:round(lags(I)/2)-1))];
        cmd=seqCmd;
        
        plot([round(seqRef(round(lags(I)/2):end)); round(seqRef(1:round(lags(I)/2)-1))],'LineWidth',1); grid on;
        plot(seqCmd,'LineWidth',1); grid on;
    else
        cmd=[round(seqCmd(round(lags(I)/2):end)); round(seqCmd(1:round(lags(I)/2)-1))];
        ref=seqRef;

        plot([round(seqCmd(round(lags(I)/2):end)); round(seqCmd(1:round(lags(I)/2)-1))],'LineWidth',1); grid on;
        plot(seqRef,'LineWidth',1); grid on;
    end        

%     if k == 4
%         subplot(suf(1));
%         hold all;
%         plxx=plot(0.5*seqCmd((1-lags(I)):end)); 
%         legend(sprintf(sprintf('speech # %i',k),sprintf('Maximum at lag %g',lags(I)) ));
%         for g=1:5
%             delayWait(0.5);
%             set(plxx, 'Visible', 'off');
%             drawnow;
%             delayWait(0.5);
%             set(plxx, 'Visible', 'on');
%             drawnow;
%         end
%     end
    hold off;
   out=[]; 
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
