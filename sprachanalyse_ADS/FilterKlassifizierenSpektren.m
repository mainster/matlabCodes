%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testimplementierung Sprachanalyse nach der "Ungarischen Methode"    @@@MDB
% ( Kuhn-Munkres-Algorithmus ) / Frequenzmethode nach Habr et al.
%
% http://de.wikipedia.org/wiki/Ungarische_Methode
% 08-11-2014
% ADS
%
% 10-11-2014    Rücksprache mit Hr. Schäfer
%
% * Zur Filterung/Gleichrichtung:
%   Sprachinformation wird auf einen Grundton aufmoduliert, Frauen haben 
%   Grundtöne irgendwo um 250Hz, bei Männern etwa die Hälfte, 125Hz
%   Durch Gleichrichten (Einweg- oder Vollweg-) und anschließender
%   DC- Entkopplung wird die modulierte Information unabhängig vom Grundton
%   (Frauen und männer sollen Gleichermaßen Kommandos geben können)
%   weiterverarbeitet.
% * Der Grundton könnte nach einer Vollweggleichrichtung auch mit einem
%   "running average" Algorithmus gedämpft werden... 
%    (alternative laut H. Schäfer... 
%
%   In Matlab:
%   data = [1:0.2:4]';
%   windowSize = 5;
%   filter(ones(1,windowSize)/windowSize,1,data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FilterKlassifizierenSpektren
clearvars -except ol ds 

SAVEPOS = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   save window pos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START_OF_MANIPULATION

figpos=[ [3052,-28,718,820];
		[1601,-13,718,820];
		[960,29,958,447];
		[4,29,958,447];
		[960,555,958,447];
		[4,555,958,447]];

figHdl = [22;21;13;12;11;10];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%




for null=0:1 %SAVEPOS
    if SAVEPOS 
        disp('null\n')

hd = findall(0,'type','figure');
hd(hd > 100) = [];

for k=1:length(hd)
    posNew(k,:) = get(hd(k),'Position');
end


options.Interpreter = 'none';
options.Default = 'No';
qstring = 'refresh figure position matrix?';

ret = questdlg(qstring,'Write access?','Yes','No',options)

if strcmp(ret,'Yes')
    hd = findall(0,'type','figure');
    hd(hd > 100) = [];
    if isempty(hd)
        break;
    end

    command = ['cp UngarischeMethode.m ' sprintf('UngarischeMethode_%s.m', timeDate('-')) ];
    [status,cmdout] = unix(command);
    if status
        error('backup not successfull');
    end

    for k=1:length(hd)
        posNew(k,:) = get(hd(k),'Position');
    end
   
	%%%%%%%%%%%%%%
    fd=fopen('UngarischeMethode.m', 'rt+');
    str = {};
    ftell(fd);
    for n=1:100
        if ~isempty(strfind(fgetl(fd),'START_OF_MANIPULATION'))
            ftell(fd);
            %%%%%%%%%%%%%%
            str(1) = {sprintf('\r\nfigpos=[ [%i,%i,%i,%i]', posNew(1,:))}

            for m=1:size(posNew,1)-1  % m- positionsvektoren 
                str(m+1) = {sprintf(';\r\n\t\t[%i,%i,%i,%i]',posNew(m+1,:))}
            end
            str(end+1) = {'];'}
            %%%%%%%%%%%%%%
            
            str2 = sprintf('\n\nfigHdl = %s;\r\n\r\n', mat2str(hd))
            %%%%%%%%%%%%%%
            fwrite(fd, [cell2mat(str) str2]);
            break
        end
    end
    fclose(fd);
end
%end
%save(TIPS_TRICKS.m, 'figpos','-append')
%%
for k=1:length(figHdl)
    set(figHdl(k),'Position',figpos(k,1:4))
end
%%

    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%         Time            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Zeitbereich, testen der Funktionen zur Klassifizierung
%%%     Running average Grundton- Filter testen (nach Gleichrichtung)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
norm={   'wavefiles/CoolEditPro/AUS_frau_Norm.wav',... % Reference
          'wavefiles/CoolEditPro/AN_frau_Norm.wav',...
         'wavefiles/CoolEditPro/AUS_mann_Norm.wav',...
          'wavefiles/CoolEditPro/AN_mann_Norm.wav'};
      
normee={   'wavefiles/CoolEditPro/AUS_frau_Norm.wav',... 
          'wavefiles/CoolEditPro/aus_frau_lt_cr_n1_50.wav',...
          'wavefiles/CoolEditPro/aus_frau_lt_cr_n1_100.wav',...
          'wavefiles/CoolEditPro/aus_frau_lt_cr_n1_150.wav'};      
fname = norm;

fnameR = cellfun(@strsplit, fname,[repmat({'/';},1,length(fname))], 'UniformOutput', false);
for k=1:length(fname)
    fnameR(k) = fnameR{k}(3);
end

clear mi wavObj lh;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wave dateien laden
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if 1
        % sample vektor aus *.wav datei laden
        [W opt] = readCutWav(fname);     
        % samples und fs in celle speichern
        objWaus = {W(:,1), opt(1).fmt.nSamplesPerSec};
        
        % sample vektor aus zuvor gespeicherten *.mat laden
        wavMdb = load('lampeAusMdb_A.mat');
        
        wa = unwrap(wavMdb.wvo.Data(:));
        wa = wa(round(end/2*1:end));
        fswa = (wavMdb.wvo.TimeInfo.get.End/length(wavMdb.wvo.Data(:)))^(-1);        
        objMdb = {wa, fswa};
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wav Sequenz in audioplayer laden
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if 1
        mpWaus = audioplayer(objWaus{:,1}, objWaus{1,2});
        mpWaus.UserData = [min(objWaus{:,1}), max(objWaus{:,1})];
        mpMdb = audioplayer(10*objMdb{:,1}, objMdb{1,2});
        mpMdb.UserData = [min(objMdb{:,1}), max(objMdb{:,1})];
    end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In Simulink aufgenommenes Audio- Obj mit audioplayer()          13-11-2014
% Plot timeseries incl. Playbutton
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frame based format: nPerFrame x nCHannels x nFrames 
% open_system('block_ads')
    while 0     % get wave info frome simulink timeseries; write wav files
        wvo.DataInfo
        wa = wvo.Data;
        wa = unwrap(wa(:));
        disp(size(wa))

        mp1=audioplayer(10*ga.wa,fs);
        playblocking(mp1);
        f98=figure(98);
        plot(wa)
        
        audiowrite(sprintf('wavefiles/wavout_%s.wav',timeDate('_')),wa,fs);
        audiowrite(sprintf('wavefiles/wavout_20dB%s.wav',timeDate('_')),10*wa,fs);
        break;
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    while 0     % load previously saved, simulink mic recorded obj
%                 % load woman 'lampe aus' bot wave 
%         waves = load('lampeAusMdb_A.mat')
%         wvo = waves.wvo;
%         
% %         playblocking(mp1);
% 
%         ttwa=[0:1/fswa:length(wvo.Data(:))/fswa-1/fswa]';
% 
%         mp = audioplayer(W(:,1), fs);
%         mp1 = audioplayer(10*wa,fs);
% 
%         
%         [tmp1 opt] = readCutWav(fname{1});     
%         wobjref = {tmp1 opt};
%         fsref = wobj{2}(1).fmt.nSamplesPerSec; 
%         ttref=[0:1/fsref:length(tmp1)/fsref-1/fsref]';
%         break;
    end
    %%
    while 0     % audioplayer obj and play()
        mpref=audioplayer(wobjref{1}, fsref);
        mp =audioplayer(10*wa, fsref);
        playblocking(mpref);
        playblocking(mp);
    end
    
    while 1     % run filter and classification for wav vectors 
        %% -------------------------------------------------------------------------
        % Grundton dämpfen, Filter konstruieren
        % --------------------------------------------------------------------------
        Fpass = 3.5e3;  Fstop = 5e3;    Fs = [objMdb{1,2}, objWaus{1,2}];    
        Apass = 20;     Astop = 1;      N = 4;
        
        % Filter Koeffizienten
        ctp = firls(N, [0 Fpass Fstop Fs(1)/2]/(Fs(1)/2), [1 1 0 0], [Apass, Astop]);
        ofir1 = dsp.FIRFilter('Numerator', ctp);   
        ctp = firls(N, [0 Fpass Fstop Fs(2)/2]/(Fs(2)/2), [1 1 0 0], [Apass, Astop]);
        ofir2 = dsp.FIRFilter('Numerator', ctp);  

        %% --------------------------------------------------------------------------
        % Step response plotten
        % --------------------------------------------------------------------------
        f7 = figure(7); clf; SUB=210; 
        tt{1} = [0:1/Fs(1):length(objMdb{1})/Fs(1)-1/Fs(1)]';
        su(1)=subplot(SUB+1); hold all; grid on;
        wavMdb = plot(tt{1}, step(ofir1, objMdb{1}));
        title(sprintf('%s   fs = %g samples/sec', vname(objMdb), Fs(1)));
        
        tt{2} = [0:1/Fs(2):length(objWaus{1})/Fs(2)-1/Fs(2)]';
        su(2)=subplot(SUB+2); hold all; grid on;
        wavWaus = plot(tt{2}, step(ofir2, objWaus{1}));
        title(sprintf('%s   fs = %g samples/sec', vname(objWaus), Fs(2)));

         hold off;

        %% -------------------------------------------------------------------------
        %% -------------------------------------------------------------------------
        uicontrol('Style', 'pushbutton', 'String', 'play mdb',...
        'Units','Normalized', 'Position', [5 50 5 3]/100,...
        'Callback', {@playbutton, mpMdb, su(1)}); 

        uicontrol('Style', 'pushbutton', 'String', 'play Waus',...
        'Units','Normalized','Position', [5 5 5 3]/100,...
        'Callback', {@playbutton, mpWaus, su(2)}); 
        %% -------------------------------------------------------------------------
        %% -------------------------------------------------------------------------

        % --------------------------------------------------------------------------

        break;
    end
%%
return
%        delete wavefiles/wavout_23_3_* 
%%
    
    %%
    while 0
        simout1.DataInfo
        W1 = simout.Data;
        FA = filterA.Data;
        FA1 = filterA1.Data;
        FA2 = filterA2.Data;
        whos W1 FA*
%        disp(size(W1))
        f1=figure(1); clf;
        hold all;
        pac=[W1, FA, FA1, FA2];
        %%
        plot(W1(1:end))
        plot(FA(1:end))
        plot(FA1(1:end))
        plot(FA2(1:end))
        for k=1:length(pac)
%            plot(pac(k,1:end))
        end
        hold off;

        mp2 = audioplayer(W1(:,1:end), fs);
        play(mp2);
    end
    
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spektren vergleichen mit / ohne Gleichrichtung und anschließendem Filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if 1
       acw = wobj{1}(:,1);        % Ohne Gleichrichtung
       dcw = abs(wobj{1}(:,1));   % Mit Gleichrichtung
       wCmpObj = {[acw, dcw], opt};
%       cas =  classification_2bit(dcw(1:5000)');
    end

    %% -------------------------------------------------------------------------
    % Grundton entfernen durch abs() und/oder Filter dämpfung
    % --------------------------------------------------------------------------
    Fpass = 3.5e3;  Fstop = 5e3;    Fs = fs;    
    Wpass = 20;     Wstop = 1;      N = 4;

    ctp = firls(N, [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Wpass Wstop]);
    ofir = dsp.FIRFilter('Numerator', ctp);

    if 0
        f10.fig = figure(10);
        clf;
        SUB=110;

        hold all;
        plot(yw{1}(:,1));
        plot(step(ofir, yw{1}(:,1)));
        hold off
    end

    facw = step(ofir, acw);
    fdcw = step(ofir, dcw);

    fCmpObj = {[acw, facw, fdcw], opt};
    [Y ffopt] = genSpectraMatrix(fCmpObj);


    %% -------------------------------------------------------------------------
    % Spektren Plotten
    % --------------------------------------------------------------------------

    clear YLI YLG
    specObj = {Y ffopt};    % spectra object
    fv = ffopt.freqLin;
    NFFT = ffopt.NFFT;
    syms X

    XSCAL = 0.05;
    XSCAL = 1;
    XSCAL = double(solve(length(fv)*X==round(length(fv)*XSCAL),X));

    f30 = figure(30);
    cla;
    SUB=210;

    % X- Vektor mit lin. Frequenzen
    % Y- Matritzen lin. und log
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SF = fv(1:length(fv)*XSCAL);
    for k=1:size(Y,2)
        YLI(:,k) = 2*abs( Y(1:XSCAL*(NFFT/2+1),k) ); 
        YLG(:,k) = 10*log10( 2*abs(Y(1:XSCAL*(NFFT/2+1),k)) );
    end

    %%
    % Spektrum der Testsignale
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    su(1) = subplot(SUB+1); 
    hold all;
    set(su(1),'XLim',[0 round(fv(round(length(fv)*XSCAL)))]);

    hax = axes('Units','pixels');

    uicontrol('Style', 'slider',...
            'Min',50,'Max',8e3,'Value',8e3,...
            'Position', [400 20 200 20],...
            'Callback', {@surfbandw,hax});   
        
    uicontrol('Style', 'pushbutton', 'String', 'recbutton',...
        'Position', [20 20 50 20],...
        'Callback', {@recbutton});   
    
    % Uses cell array function handle callback
    % Implemented as a local function with an argument

    for k=1:min(size(Y))
        pl(k) = plot(su(1),SF, YLI(:,k)'); 
    end
%     subplot(su(2));
    legend({'acw: orig'; 'facw: filtered'; 'fdcw: rect+fil'},'Interpreter','none');
    title('Referenz- und Test Spektren, linear')
    xlabel('Freq / [Hz]')
    grid 'on';

    su(2) = subplot(SUB+2); hold all;

    for k=1:min(size(Y))
        pg(k) = plot(SF, YLG(:,k)'); 
    end
    legend(su(2), {'acw: orig'; 'facw: filtered'; 'fdcw: rect+fil'},'Interpreter','none');
    title('Referenz- und Test Spektren, y- logarithmisch')
    set(su(2),'XLim',[0 round(fv(round(length(fv)*XSCAL)))]);
    xlabel('Freq / [Hz]')

    set(su,'XGrid','on','YGrid','on');
    set(pg(1),'Color','blue');
    set(pg(2),'Color','green');
    set(pg(3),'Color','red');

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Klassifizierung der 3 wavedateien, original, gefiltert und
    % Gleichgerichtet + Gefiltert
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
        
    tmp=fCmpObj;
    tmp{end}=[];
    tmp=tmp{:};
    
    for k=1:3
        classi(k) =  classification_2bit(tmp(750:1000),'nophlot');
    end

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Handler
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function surfbandw(hObj,event,ax) 
    val = get(hObj,'Value');

    xlim([1, val])

end


function playbutton(hObj,event,mpobj,hsub) 
    na = get(hObj, 'String');
    val = get(hObj,'Value');
    
    if ~isempty(na)
        idx=find(cellfun(@isempty, strfind({'play mdb';'play Waus'},na)));        
        subplot(hsub); hold on; 
        
        play(mpobj);
        CUR = mpobj.CurrentSample;
%        li=line([CUR, CUR]/mpobj.SampleRate,[mpobj.UserData]);
        while CUR > 1
           li=line([CUR, CUR]/mpobj.SampleRate,[mpobj.UserData]);
           drawnow;
           CUR = mpobj.CurrentSample;
           delete(li); 
%           delete(findall(li, 'type','line')); 
%           disp(CUR)
%           delay(0.05);
        end
        
        hold off;
    end
end





%% GENERAL FUNCTIONS
function liverecording
    
    fs = 44100;
    fs = 11025;
    nBits = 16;
    mag = 1.05;

    plot(ha1,0,0);
    ylim(ha1,[-mag mag])
    xlim(ha1,[0 RecordLength])
    xlabel(ha1,'Time [s]')
    idx_last = 1;

    recObj = audiorecorder(fs,nBits,1);
    
    record(recObj,RecordLength);
    tic
    while toc<.1
    end
    tic
    bit = 2;
    while toc<RecordLength
        myRecording = getaudiodata(recObj);
        idx = round(toc*fs);
        while idx-idx_last<.1*fs
            idx = round(toc*fs);
        end

        plot(ha1,(max(1,size(myRecording,1)-fs*ShowLength):(2^bit):size(myRecording,1))./fs,myRecording(max(1,size(myRecording,1)-fs*ShowLength):(2^bit):end))
        mag = max(abs(myRecording));
        ylim(ha1,[-1.2 1.2]*mag)
        xlim(ha1,[max(0,size(myRecording,1)/fs-ShowLength) max(size(myRecording,1)/fs,ShowLength)])
        
    spectrogram(myRecording(max(1,size(myRecording,1)-fs*ShowLength):(2^bit):end),2^9/(2^bit),2^7/(2^bit),2^12/(2^bit),fs/(2^bit))
    xlim(ha2,[FrequencyWindow1 FrequencyWindow2])
    ylim(ha2,[0 ShowLength])
    view(ha2,-90,90) 
    set(gca,'ydir','reverse')       
    set(gca, 'YTick', []);
    
        drawnow
        idx_last = idx;
        
    end

    endrecording
end


function endrecording
    set(hbuttonPlay,'visible','on')
    set(hbuttonPlayAll,'visible','on') 
    set(hbuttonShowFigures,'visible','on') 
    set(hbuttonSave,'visible','on')
    set(hbuttonSaveAs,'visible','on')
    
end
