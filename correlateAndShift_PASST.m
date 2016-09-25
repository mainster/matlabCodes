% function crossCorrDelayedSignal (seqRef, seqCmd)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wave files:
% Synchronisieren von referenz- Audiosequenz mit echtzeit-
% Aufnahme per autokorrelation
% Zeit akf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(seqRef) > length(seqCmd)
    seqRef = seqRef(1:length(seqCmd));
    disp('seqRef > seqCmd');
else
    if length(seqRef) < length(seqCmd)
        seqCmd = seqCmd(1:length(seqRef));
        disp('seqRef < seqCmd');
    end
end
    
[xc,lags] = xcorr(seqRef, seqCmd);
[~,I] = max(abs(xc));

f39 = figure(39); clf;
SUB = 220;
subplot(SUB+1); hold all
plot(seqRef,'LineWidth',1); grid on;
plot(seqCmd,'LineWidth',1); grid on;
legend('seqRef','seqRef');

disp(lags(I))

subplot(SUB+2); hold all
 if lags(I) > 0
    seqCmdx = [seqCmd(end-round(lags(I)):end); seqCmd(1:end-round(lags(I))) ];
    plot(seqRef,'LineWidth',1); grid on;
    plot(seqCmdx,'LineWidth',1); grid on;
    legend(sprintf('seqRefx: max(lag(I))=%i', lags(I)),'seqCmd');
else
    seqRefx = [seqRef(end+round(lags(I))); seqRef(end+round(lags(I))+1:end) ];
    plot(seqRefx,'LineWidth',1); grid on;
    plot(seqCmd,'LineWidth',1); grid on;
    legend('seqRef',sprintf('seqCmdx: max(lag(I))=%i', lags(I)));
end

return