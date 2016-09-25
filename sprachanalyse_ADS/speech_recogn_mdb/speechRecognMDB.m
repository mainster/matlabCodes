%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% speechRecognMDB.m                                                      @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main für ADS- Projekt: Sprachkommando
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PATHA = '/home/mainster/CODES_local/matlab_workspace/wavefiles/14_56_53/';
% PATHB = '/home/mainster/CODES_local/matlab_workspace/wavefiles/16_48_38/backup';
% PATHA = '/home/mainster/CODES_local/matlab_workspace/wavefiles/14_56_53/backup';
% PATHB = '/home/mainster/CODES_local/matlab_workspace/wavefiles/16_48_38/';
% 
% PATHB = '/home/mainster/CODES_local/matlab_workspace/wavefiles/14_56_53/backup2/';
% PATHC= 'home/mainster/CODES_local/matlab_workspace/wavefiles/25112014_16-1-33/';
% renameWaveFiles(PATHC, {'haus','maus','raus','vogel','eins'});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path to reference wavefiles
%PATHC= '/home/mainster/CODES_local/matlab_workspace/wavefiles/20141211_1-25-40';
PATHC= '/home/mainster/CODES_local/matlab_workspace/wavefiles/fuer_matze';

refName = {'haus','maus','raus','vogel','eins'};%,'zwei','drei','vier','funf'};

USE_ALGORITHM   = 'Munkres';
FRAMESIZE       = 250;        % dim of munkres input matrices
SET_FS          = 8000;

% CLASSIFY = 'Enabled (4 bit)';
CLASSIFY = 'Disabled';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
if 0
    isOpen = matlabpool('size') > 0;
    c = parcluster

    if ~isOpen
    %     matlabpool open 12
    end
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nummer 1...9 
% sequenzen aus wave dateien lesen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TIC_ALL = tic;

if 0
for k=1:5
    CMD = 'audioread';
    speech{k}  = eval(cell2mat(strrep([CMD '(''' [PATHC , '/%i.wav'')']], '%i', refName(k))));
    CMD = 'audioinfo';
    tmp1  = ((strrep([CMD '(''' [PATHC , '/%i.wav'')']], '%i', refName(k))));
	fss(k) = eval(tmp1{1});
    if fss(k).TotalSamples ~= length(speech{k})
        warning(['file #' num2str(k) ', different sizes??'])
    end
    mp(k) = audioplayer(speech{k},fss(k).SampleRate);
end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Haus maus raus .... sequenzen 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


audioCapture(SET_FS, 1, 1, PATHC, 'select', 'load');



%%
% Aufnehmen
SET_FS=11025*2;
FS=SET_FS;
%  T=input('\nWie lange? [sec] ???  ');
NAMES={'Pommes_ref.txt','Pommes2.txt','Cola.txt','Pizza.txt'};

clear wavMic* wavPay

for k=1:length(NAMES)
    T=2;
    %nam=input('Name ???  ','s');
    nam=NAMES{k};
    fprintf('\n-----------\nsage: %s\n-----------\n', nam)

    [wavMic, opt, cmdSrc] = audioCapture(SET_FS, 1, T, PATHC,'select', 'mic','overwrite','yes');

    delete(findall(0,'type','line'));
    %Speichern, Plotten
    wavMicN = wavMic/max(abs(wavMic))*2^14;
    figure(1);
    plot(wavMic)
%    wavPay=payloadDetector(wavMic,'-25dB',200,100);
wavPay=wavMic;    
figure(2);
    plot(wavPay)

    % ENDs=input('Ende bei [samples]: ');
    ENDs=11025*2;
    wavPay=wavPay(1:ENDs);
    plot(wavPay)
    figure(2); hold all;
    plot(wavPay)


    NAM=['/media/global_exchange/wav_21-02/' nam];
    % dlmwrite([NAM '_1'], wavMicN'/max(abs(wavMicN')), 'delimiter',',')
    dlmwrite(NAM ,round(wavPay*2^14)', 'delimiter',',');
    NAM

    % Anhören
    soundsc(wavPay,FS)

    

    dlmwrite(['/media/global_exchange/wav_21-02/' timeDate('_')] ,wavPay', 'delimiter',',')
end
%%


%%
if 0
    %% 10-12-2014
    % Mic level überprüfen
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    w1=audioCapture(8000,'select','mic','overwrite','yes'); flvl=figure(777); clf; 
    subplot(211); plot(w1); ylim([-.4 .4]);hold all; subplot(212); plot(objRef.wav.data); 
    ylim([-.4 .4]); figure(flvl);
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Referenzsignal bilden: payloadDetector liefert eine
% zugeschnittene Sequenz --> ref1 
% Die Payload wird durch den parameter minLvl bestimmt, bei z.B.
% minLvl='-25dB' werden vorne und hinten alle Abtastwerte
% abgeschnitten, bis die Amplitude zum Erste mal > -25dB groß
% ist. PREDELAY und POSTDELAY sind Integer werte, die von den
% erkannten Grenzen abgezogen bzw. drauaddiert werden.
%

if ~isempty(refslo)
    objRef.info         = refslo.info.haus;
    objRef.wav.fs       = refslo.info.haus.SampleRate;
    objRef.wav.data     = refslo.haus;
else
    objRef.info         = refs.info.haus;
    objRef.wav.fs       = refs.info.haus.SampleRate;
    objRef.wav.data     = refs.haus;
end

objCmd.info.SampleRate  = objRef.wav.fs;
objCmd.wav.data         = wavMic;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wav sequenzen klassifizieren vor Anwendung des 
% Algorithmus??
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
disp(' ');
disp(timeDate(1));
disp(' ');

REF_DUMMY = repmat('%s,',1,length(refName));
REF_DUMMY = REF_DUMMY(1:end-1);
fprintf(['Klassifizierung: \t%s\nUsed algorithm: \t%s\nRef sequences: \t\t',...
    REF_DUMMY, '\n'], CLASSIFY, USE_ALGORITHM, refName{:});
fprintf('Framesize: \t\t\t%.0fx%.0f\n', FRAMESIZE, FRAMESIZE);
fprintf('Samplerate: \t\t%.3gkHz\n', SET_FS*1e-3);
fprintf('Cmd sequence: \t\t%s\n%s\n', cmdSrc, ds);



%% 
% REF=1;
% CMD=4;
% 
% objRef.info         = fss(REF);
% objRef.wav.fs       = fss(REF).SampleRate;
% objRef.wav.data     = speech{REF};
% 
% objCmd.info         = fss(CMD);
% objCmd.wav.fs       = fss(CMD).SampleRate;
% objCmd.wav.data     = speech{CMD};
for NN=1:5

    if ~isempty(refslo)
        objRef.wav.data = refslo.(refName{NN})(:,1);
    else
        objRef.wav.data = refs.(refName{NN})(:,1);
    end
    
    objCmd.wav.data = objCmd.wav.data(:,1);

    PREPROCESSING = 1;
    
    switch PREPROCESSING 

        % Payload detector mit akf - Sync sequences
        case 0 
            SUB_BASE = 230+NN;
            objRef.payload.data = payloadDetector(objRef.wav.data, '-45db',200,200);
            objCmd.payload.data = syncSeqToRef(objCmd.wav.data,...
                                              objRef.wav.data, 'length', 'equal');
        
        % keine Vorverarbeitung
        case 1
            objRef.payload.data = objRef.wav.data;    %!!!
            objCmd.payload.data = objCmd.wav.data;
        
        case 2
            [refc, cmdc]=crossCorrDelayedSignal(objRef.wav.data, objCmd.wav.data);
            objRef.payload.data = refc;
            objCmd.payload.data = cmdc;
            
        case 3
            [objRef.payload.data, objCmd.payload.data] = payloadCorrelation(...
                                            objRef.wav.data, objCmd.wav.data);
        otherwise
            error(' bad case ')
    end
%     KEIN SYNC ODER PAYLOAD DETECTOR MEHR
%      MUNKRES MACHT GENAU DASS
% *****************************************************
%         objRef.payload.data = objRef.wav.data;    %!!!
%         objCmd.payload.data = objCmd.wav.data;

%     end
    
%     
%     fprintf('\nSamples befor payload detector:\t%i\n', length(objRef.wav.data))
%     fprintf('Samples after payload detector:\t%i\n\n',length(objRef.payload.data))

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % objRef.payload.data = filter...
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
  
    if ~isempty(strfind(lower(CLASSIFY),'enable'))
        objRef.classify.data = classify2bit( objRef.payload.data' );
        objCmd.classify.data = classify2bit( objCmd.payload.data' );
        clref = objRef.classify.data;
        clcmd = objCmd.classify.data;
        
    else
        if ~isempty(strfind(lower(CLASSIFY),'disable'))
            clref = objRef.payload.data';
            clcmd = objCmd.payload.data';
        else
            error('bad parameter CLASSIFY')
        end
    end

%    cmat = costMatFramer(clref([ADDR]), clcmd([ADDR2]), 25)
%    cmat = InputMatFramerAbgespeckt(clref, clcmd, 100);
    tic;
    cmat = InputMatFramer(clref, clcmd, FRAMESIZE);
    toccing = toc;
%    fprintf('InputMatFramer %i:\t%5.2f\n', NN, toccing);

    tic;
    
    
%     for k=1:size(cmat,2)
%         [ass{k}, cost(k)] = munkres(cmat{k});
% %         [ass{k}, cost(k)] = munkres(cmat);
%     %    fprintf('Kosten #%i: %g\n',k,cost(k))
%     end
    spmd 
%    parfor k=1:size(cmat,2)
        [ass, cost] = munkres(cmat(labindex+4));
%         [ass{k}, cost(k)] = munkres(cmat);
    %    fprintf('Kosten #%i: %g\n',k,cost(k))
    end
    
    
    toccing = toc;
    fprintf('Reference:\t"%s"\n', refName{NN});
    fprintf('Munkres:\t%.1fsek\n', toccing);
%    fprintf('Cost:\t\t%.0f\n%s\n', sum(cost(:)), ds);

    f80=figure(80); clf;
    SUB = 210;

    fs=objCmd.info.SampleRate;

    for k=1:2
        s(k) = subplot(SUB+k);
    end
    subplot(s(1));
    hold all;
    plot([0:1:length(objRef.wav.data)-1]/fs, objRef.wav.data); 
    plot([0:1:length(objCmd.wav.data)-1]/fs, objCmd.wav.data);
    legend('Ref.wav.data','Cmd.wav.data');
    xlim([0, length(objRef.wav.data)/fs])
    hold off;
    grid on;

    subplot(s(2));
    hold all;
    plot([0:1:length(objRef.payload.data)-1]/fs, objRef.payload.data); 
    plot([0:1:length(objCmd.payload.data)-1]/fs, objCmd.payload.data);
    legend('Ref.payload.data','Cmd.payload.data');
    xlim([0, length(objRef.payload.data)/fs]);
    grid on;
    hold off;
    
    COSTALL(:,NN) = cost;
end


%%
    [~, idx] = min(sum(COSTALL));
    
    fprintf('\n\t\tAnd the winner iiiiis:\n%s\n%s\n \t\t\t %s \n%s\n%s\n',...
        ds,ds, refName{idx}, ds,ds);
    tg=toc(TIC_ALL);
    fprintf('Gesamtlaufzeit: %.1fsek\n%s\n\n\n', tg, ds);
    assignin('base','COSTALL',COSTALL);
%     assignin('base','COSTALLSUM', cellfun(@sum, COSTALL));
    evalin('base','COSTALL;');
   