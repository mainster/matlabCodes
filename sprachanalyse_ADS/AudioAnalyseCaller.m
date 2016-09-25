% AudioAnalyseCaller
%
function AudioAnalyseCaller
% 
% global chirp;
% load chirp;
% 
% clf
% Fs = Fs;   
% % t = 0:1/Fs:2.96;
% % x = cos(2*pi*t*1.24e3)+ cos(2*pi*t*10e3)+ randn(size(t));
% x=y;
% nfft = 2^nextpow2(length(x));
% Pxx = abs(fft(x,nfft)).^2/length(x)/Fs;
% % Create a single-sided spectrum
% Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs);  
% tt=[0:1/Fs:(length(x)-1)/Fs];
% 
% f55=figure(55); clf
% su(1)=subplot(211);
% p(1)=plot(tt, x); 
% su(2)=subplot(212);
% p(2)=plot(Hpsd); 
% 
% 
% N = 10;  
% Fc = 0.4;
% B = fir1(N,Fc);
% Hf1 = dsp.FIRFilter('Numerator',B);
% %freqz(b,1,512)
% xf=step(Hf1, x);
% 
% Pxxf = abs(fft(xf,nfft)).^2/length(xf)/Fs;
% % Create a single-sided spectrum
% Hpsdf = dspdata.psd(Pxxf(1:length(Pxxf)/2),'Fs',Fs);  
% 
% f56=figure(56); clf
% su(3)=subplot(211); 
% p(3)=plot(tt, xf); hold off 
% su(4)=subplot(212); 
% 
% p(4)=plot(Hpsd); hold all;
% p(5)=plot(Hpsdf); 
% hold off
% legend('Unfiltered', 'Bandpassed')
% 
% set(p(:,1),'Color','red');
% set(p(:,2),'Color','blue');
% set(p(:,3),'Color','green');
% set(p(:,4),'Color','red');
% set(p(:,5),'Color','blue');

% return
%%
% 
% [Y, ffopt] = genSpectraMatrix(y,Fs);
% specObj = {Y ffopt};
% fv = ffopt.freqLin;
% NFFT = ffopt.NFFT;
% syms X
% 
% fnameR={'Chirp'};
% 
% XSCAL = 0.05;
% XSCAL = 1;
% XSCAL = double(solve(length(fv)*X==round(length(fv)*XSCAL),X));
% %XSCALFIL = double(solve(length(fv)*X==round(length(fv)*XSCAL),X));
% 
% % Plot Spektrum
% %%%%%%%%%%%%%%%%%%%%%
% 
% f10=figure(10);
% clf;
% %SUB=(100*min(size(Y)) + 10);
% SUB=210;
% 
% 
% su(1) = subplot(SUB+1); hold all;
% su(2) = subplot(SUB+2); hold all;
% 
% % X- Vektor mit lin. Frequenzen
% % Y- Matritzen lin. und log
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SF = fv(1:length(fv)*XSCAL);
% for k=1:size(Y,2)
%     YLI(:,k) = 2*abs( Y(1:XSCAL*(NFFT/2+1),k) ); 
%     YLG(:,k) = 10*log10( 2*abs(Y(1:XSCAL*(NFFT/2+1),k)) );
% end
% 
% % untere Y- Grenze für log. diagramm
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MINY_LOG = round(0.1*min(YLG(:)))*10;
% 
% % X- Vektor mit lin. Frequenzen
% % Y- Vektoren für das gefüllte 
% % Referenz- Signal, lin. und log
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fix=fv(1:length(fv)*XSCAL);
% fix=fv(1:length(fv)*XSCAL);
% 
% fiy=[0; 2*abs(Y(2:round(XSCAL*(NFFT/2+1-1)),1)); 0];
% fiyLg=[MINY_LOG; 10*log10( 2*abs(Y(2:round(XSCAL*(NFFT/2+1-1)),1)) ); MINY_LOG];
% %%
% % Referenz- Signale mit fill
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % subplot(su(1));
% % p(1,1)=fill(fix, fiy,[1 1 1]*.8);
% % set(p(1,1),'EdgeColor',[1 1 1]*.55);
% % subplot(su(2));
% % p(2,1)=fill(fix, fiyLg,[1 1 1]*.8);
% % set(p(2,1),'EdgeColor',[1 1 1]*.55);
% 
% % Spektrum der Testsignale
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for k=1:min(size(Y))
%     p(1,k) = plot(su(1), SF, YLI(:,k)); 
%     p(2,k) = plot(su(2), SF, YLG(:,k)); 
% end
% 
% title(su(1),'Referenz- und Test Spektren, linear')
% title(su(2),'Referenz- und Test Spektren, y- logarithmisch')
% FMAX = 500;
% set(su(1),'XLim',[0 FMAX]);
% set(su(2),'XLim',[0 FMAX]);
% grid(su(1), 'on');
% grid(su(2), 'on');
% legend(su(1), fnameR,'Interpreter','none');
% legend(su(2), fnameR,'Interpreter','none');
% %legend(su(1), strrep(fnameR,{'wN','mN'},{'_frau_N','_man_N'}));
% 
% %set(p(1,1),'Color',[1 1 1]*0.55);
%     set(p(:,1),'Color','blue');
% % set(p(:,1),'Color','black');
% if length(p) > 2
%     set(p(:,2),'Color','blue');
% end
% if length(p) > 3
%     set(p(:,3),'Color','green');
% end
% if length(p) > 4
%     set(p(:,4),'Color','red');
% end
% 
% su(1); hold off;
% su(2); hold off;
% 
% return
% %%
% aa=NaN(4,4)
% s1=[1, -1, 2, -2];
% s2=[1, -1, 2, -2];
% for i=1:4
%     for j=1:4
% %        aa(i,j)=mod(s2(i),s1(j));
%         switch(abs(s2(i)-s1(j)))
% %         switch(kkk)
%             case 0
%                 aa(i,j) = 0;
%             case 1
%                 aa(i,j) = 5;
%             case 2
%                 aa(i,j) = 10;
%             case 3
%                 aa(i,j) = 8;
%             case 4
%                 aa(i,j) = 10;
%             otherwise
%         warning('bad solution')
%         end
%     end
% end
% aa
% 
% st1=[];
% for i=1:4
%     for j=1:4
%         st1=[st1 sprintf('\tmod(%i,%i)',s2(i),s1(j))];
%     end
%     st1=[st1 sprintf('\n')];
% end
% 
% st1
% 
% return
% 
% %%
% 
% PATHA = '/home/mainster/CODES_local/matlab_workspace/wavefiles/5_29_51/'; % an,aus,hoch,runter x2
% PATHB = '/home/mainster/CODES_local/matlab_workspace/wavefiles/0_57_43/';
% PATHC = '/home/mainster/CODES_local/matlab_workspace/wavefiles/15_17_21/';
% 
% if 1
% 
% %
% recs0 = {[PATHC, 'waveout_1.wav'],...
%         [PATHC, 'waveout_2.wav']};
% %
% recs1 = {[PATHC, 'waveout_1.wav'],...
%         [PATHB, 'waveout_nein_1.wav']};
% %
% recs2 = {[PATHC, 'waveout_1.wav'],...
%         [PATHB, 'waveout_nein_2.wav']};
% %
% recs3 = {[PATHC, 'waveout_1.wav'],...
%         [PATHB, 'waveout_nein_2.wav']};
% %
% recs4 = {[PATHA, 'waveoutmono_1.wav'],...
%         [PATHA, 'waveoutmono_2.wav']};
% %
% recs5 = {[PATHA, 'waveoutmono_1.wav'],...
%         [PATHA, 'waveoutmono_3.wav']};
% %
% recs6 = {[PATHA, 'waveoutmono_1.wav'],...
%         [PATHA, 'waveoutmono_5.wav']};
% %
% recs7 = {[PATHA, 'waveoutmono_1.wav'],...
%         [PATHA, 'waveoutmono_7.wav']};
%%
%%end
%%
PATHD = '/home/mainster/CODES_local/matlab_workspace/wavefiles/10_18_3/'
PATHF='/home/mainster/CODES_local/matlab_workspace/wavefiles/16_48_38/'

rec{1}={[PATHD, 'waveout_1.wav']}; % fernseher aus
rec{2}={[PATHD, 'waveout_2.wav']}; % radio aus
rec{3}={[PATHD, 'waveout_3.wav']}; % fenster zu
rec{4}={[PATHD, 'waveout_4.wav']}; % Türe auf

%%
for L=1:4
    % rec1{1}
    for l=1:4
        [st, tmp]=AudioAnalyse(rec{l}{:});
        sto(l) = st;
        COSTVEC1{l,:} = tmp;
    end
    %[COSTSUM(k), tmp] = eval(sprintf('AudioAnalyse(rec%i{1});',1));
    %%
    if exist('ymic.mat','file')
        delete('ymic.mat');
    end
end

%%
f9=figure(9);
hold all;
stem(sto);
save('CostSummer.mat','sto','-append');

%%


for k=1:4
    audinf(k,1) = eval(sprintf('audioinfo(rec%i{1})',k));
%    audinf(k,2) = eval(sprintf('audioinfo(rec%i{2})',k));
%    [COSTSUM(k), tmp] = eval(sprintf('AudioAnalyse(rec%i{1})',k));
    [COSTSUM(k), tmp] = eval(sprintf('AudioAnalyse(rec%i{1})',k));
%     audinf(k,1) = eval(sprintf('audioinfo(recs%i{1})',k-1));
%     audinf(k,2) = eval(sprintf('audioinfo(recs%i{2})',k-1));
%     [COSTSUM(k), tmp] = eval(sprintf('AudioAnalyse(recs%i{1},recs%i{2})',k-1,k-1));
    COSTVEC{k} = tmp;
end
    stem(COSTSUM/max(COSTSUM))
    save('CostSummer.mat','COSTSUM','COSTVEC','-append');
%%
if exist('ymic.mat','file')
    delete('ymic.mat');
end

%%
[MA, I] = max(COSTSUM)
fs = audinfo(I,1).SampleRate;
%fs = audinf(I,2).SampleRate;
mp(1) = eval(sprintf('audioplayer(audioread(recs%i{1}), fs);',I-1));
%mp(2) = eval(sprintf('audioplayer(audioread(recs%i{2}), fs);',I-1));

playblocking(mp(1));
playblocking(mp(2));
%%
[MA, I] = min(COSTSUM)
fs = audinf(I-1,1).SampleRate;
fs = audinf(I-1,2).SampleRate;
mp(1) = eval(sprintf('audioplayer(audioread(recs%i{1}), fs);',I-1));
mp(2) = eval(sprintf('audioplayer(audioread(recs%i{2}), fs);',I-1));

playblocking(mp(1));
playblocking(mp(2));

%%
for k=1:8
%    YY(k)=audioinfo(sprintf([PATHA 'waveout_%i.wav'],k));
    YY(k)=audioinfo(sprintf([PATHF 'wav_numberB_%i.wav'],k));
end
YY(:).NumChannels
%%
for k=1:8
    YY(k)=audioinfo(sprintf([PATHA 'waveoutmono_%i.wav'],k));
end
YY(:).NumChannels

%%
for k=1:9
%    YY=audioread(sprintf([PATHA 'waveout_%i.wav'], k));
    YY=audioread(sprintf([PATHF 'wav_numberB_%i.wav'], k));
%    audiowrite( sprintf([PATHA 'waveoutmono_%i.wav'], k), YY(:,2), 16000 );
    audiowrite( sprintf([PATHF 'wav_numberB_%i.wav'], k), YY(:,2), 8000 );
end

%%

%% -------------------------------------------------------------------------
% Play buttons callbacks
% --------------------------------------------------------------------------
% function playbutton(hObj,event,mpobj,hsub)
%     na = get(hObj, 'String');
%     val = get(hObj,'Value');
%     
%     if ~isempty(na)
%         idx=find(cellfun(@isempty, strfind({'play rt';'play ref1'},na)));        
%         subplot(hsub); hold on; 
%         
%         play(mpobj);
%         CUR = mpobj.CurrentSample;
% 
%         while CUR > 1
%            li=line([CUR, CUR]/mpobj.SampleRate,[mpobj.UserData],'Color','Red');
%            drawnow;
%            CUR = mpobj.CurrentSample;
%            delete(li); 
%         end
%         
%         hold off;
%     end
% end

end
