% Cross-Correlation of Delayed Signal in Noise
%
% This example shows how to use the cross-correlation sequence to
% detect the time delay in a noise-corrupted sequence. The output
% sequence is a delayed version of the input sequence with
% additive white Gaussian noise. Create two sequences. One
% sequence is a delayed version of the other. The delay is 3
% samples. Add  $N(0,0.3^2)$ white noise to the delayed signal.
% Use the sample cross-correlation sequence to detect the lag.
% Create and plot the signals. Set the random number generator to
% the default settings for reproducible results. rng default
% 
% if 0
% x = triang(20);
% y = [zeros(5,1);x]+0.3*randn(length(x)+5,1);
% 
% subplot(2,1,1)
% stem(x,'filled')
% axis([0 22 -1 2])
% title('Input Sequence')
% 
% subplot(2,1,2)
% stem(y,'filled')
% axis([0 22 -1 2])
% title('Output Sequence')
% 
% [xc,lags] = xcorr(y,x);
% [~,I] = max(abs(xc));
% 
% figure
% stem(lags,xc,'filled')
% legend(sprintf('Maximum at lag %d',lags(I)))
% title('Sample Cross-Correlation Sequence')
% 
% end

function [ref cmd] = crossCorrDelayedSignal (seqRef, seqCmd)
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
    ref = seqRef;
    cmd = seqCmdx;
else
    seqRefx = [seqRef(end+round(lags(I))); seqRef(end+round(lags(I))+1:end) ];
    plot(seqRefx,'LineWidth',1); grid on;
    plot(seqCmd,'LineWidth',1); grid on;
    legend('seqRef',sprintf('seqCmdx: max(lag(I))=%i', lags(I)));
    ref = seqRefx;
    cmd = seqCmd;
 end

 
return



PATHA = '/home/mainster/CODES_local/matlab_workspace/wavefiles/14_56_53/backup2';

l = struct2cell(dir(PATHA));
idx = find(~cellfun(@isempty, strfind(l(1,:),'.wav')));
N = length(idx);

f39 = figure(39); clf;
SUB = 330;
   
for k=1:5
    speech{k}=audioread(fullfile(PATHA, l{1,idx(k)}));
    [xc,lags] = xcorr(speech{1}, speech{k});
    [~,I] = max(abs(xc));

    suf(k) = subplot(SUB+k); hold all
    plf(k) = plot(speech{k},'LineWidth',1); grid on;

    if k == 4
        subplot(suf(1));
        hold all;
        plxx=plot(0.5*speech{k}((1-lags(I)):end)); 
        legend(sprintf(sprintf('speech # %i',k),sprintf('Maximum at lag %g',lags(I)) ));
        for g=1:5
            delayWait(0.5);
            set(plxx, 'Visible', 'off');
            drawnow;
            delayWait(0.5);
            set(plxx, 'Visible', 'on');
            drawnow;
        end
    end
    hold off;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%

WAV={   'wavefiles/0_57_43/waveout_nein_1.wav',...
        'wavefiles/0_57_43/waveout_nein_2.wav',...
        'wavefiles/0_57_43/waveout_nein_3.wav'};

clear ch2* inf* mp*;

f99=figure(99); clf;
SUB = 320;
    
for k=1:2
    ch2{k}=audioread(WAV{k}); ch2{k}=ch2{k}(:,2);
    inf{k}=audioinfo(WAV{k});
    mp{k}=audioplayer(ch2{k},inf{k}.SampleRate);
%    playblocking(mp{k})
    subplot(SUB+2*k-1);
    plot(ch2{k}); hold all
end

for k=1:1
    subplot(SUB+2*k);
    [xc,lags] = xcorr(ch2{k},ch2{k+1});
    [~,I] = max(abs(xc));

    plot(lags,xc)
    legend(sprintf('Maximum at lag %g',lags(I)))
end

    subplot(SUB+5);
    plot(ch2{1}); hold all
    plot(ch2{2}((1-lags(I)):end)); hold all


hold off;
grid on;


