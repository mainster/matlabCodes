% 
% Speech recognition
%
% http://de.mathworks.com/company/newsletters/articles/developing-an-isolated-word-
% recognition-system-in-matlab.html
%

%%%%%%%%%%%%%%%%%%%
% Acquiring Speech
%%%%%%%%%%%%%%%%%%%


PATHE='/home/mainster/CODES_local/matlab_workspace/wavefiles/14_56_53/';
PATHF='/home/mainster/CODES_local/matlab_workspace/wavefiles/16_48_38/';
clear mp Pxx speech* fs* mp*; 

speech = [];
speechB = [];
for k=1:9
    fss(k) = eval('audioinfo([PATHE, sprintf(''waveout_%i.wav'',1)]);');
    fssB(k) = eval('audioinfo([PATHF, sprintf(''wav_numberB_%i.wav'',1)]);');
%     if fss(k).NumChannels == 2
%         tmp = eval( strrep('audioread([PATHE, ''waveout_%i.wav''])', '%i', num2str(k)));
%         plot(tmp);
%         return
%     end
%     if fssB(k).NumChannels == 2
%         tmp = eval( strrep('audioread([PATHF, ''wav_numberB_%i.wav''])', '%i', num2str(k)));
%         figure; plot(tmp(:,1)); legend('idx1');
%         figure; plot(tmp(:,2)); legend('idx2');
%         return
%     end
    speech(:,k) = eval( strrep('audioread([PATHE, ''waveout_%i.wav'']);', '%i', num2str(k)));
    speechB(:,k) = eval( strrep('audioread([PATHF, ''wav_numberB_%i.wav'']);', '%i', num2str(k)));
    mp(k) = audioplayer(speech(:,k),fss(k).SampleRate);
    mpB(k) = audioplayer(speechB(:,k),fssB(k).SampleRate);
end
%%
ONE = 1;
order = 12;
nfft = 512;
Fs = fss(ONE).SampleRate;

f40 = figure(40); clf;
SUB = 330;
for k=1:size(speech,2)
    Pxx(:,k) = pyulear(speech(:,k),order,nfft,Fs);
    PxxB(:,k) = pyulear(speechB(:,k),order,nfft,Fs);
    su(k) = subplot(SUB+k); 
    hold all
    pl(k) = plot(Pxx(:,k),'LineWidth',1); grid on;
    plB(k) = plot(PxxB(:,k),'LineWidth',1); grid on;
    hold off;
    NOS{k} = num2str(k);
    title(['Number ' num2str(k)]);
end
legend(su, 'Numbers', 'Numbers B');

return
%%
%  For training, speech is acquired from a microphone and brought into the development environment for offline
%  analysis. For testing, speech is continuously streamed into the environment for online processing.During the training stage, it is necessary to record repeated utterances of each digit in the dictionary.
%  Forexample, we repeat the word ‘one’ many times with a pause between each utterance.Using the following MATLAB code with a standard PC sound card, we capture ten seconds of speech from amicrophone input at 8000 samples per second:


Fs = 8000;                      % Sampling Freq (Hz)
Duration = 10;                  % Duration (sec)
y = wavrecord(Duration*Fs,Fs);

% The following MATLAB code uses a Windows sound card to capture data at a sampling rate of 8000 Hz. Data
% is acquired and processed in frames of 80 samples. The process continues until the “RUNNING” flag is set to
% zero. Define system parameters
framesize = 80;       % Framesize (samples)
Fs = 8000;            % Sampling Frequency (Hz)
RUNNING = 1;          % A flag to continue data capture
% Setup data acquisition from sound card
ai = analoginput('winsound');
addchannel(ai, 1);
% Configure the analog input object.
set(ai, 'SampleRate', Fs);
set(ai, 'SamplesPerTrigger', framesize);
set(ai, 'TriggerRepeat',inf);
set(ai, 'TriggerType', 'immediate');
% Start acquisition
start(ai)
% Keep acquiring data while "RUNNING" ~= 0
while RUNNING
    % Acquire new input samples
    newdata = getdata(ai,ai.SamplesPerTrigger);
    % Do some processing on newdata
%      ...
%      <DO _ SOMETHING>
%      ...
%     % Set RUNNING to zero if we are done
%     if <WE _ ARE _ DONE>
%          RUNNING = 0;
%     end
end
% Stop acquisition
stop(ai);
% Disconnect/Cleanup
delete(ai);
clear ai;

% Developing a Speech­Detection Algorithm
% The speech­detection algorithm is developed by processing the prerecorded speech frame by frame within a
% simple loop. For example, this MATLAB code continuously reads 160 sample frames from the data in ‘speech’.
% Define system parameters
seglength = 160;                    % Length of frames
overlap = seglength/2;              % # of samples to overlap
stepsize = seglength - overlap;     % Frame step size
nframes = length(speech)/stepsize-1;
% Initialize Variables
samp1 = 1; samp2 = seglength; %Initialize frame start and end
for i = 1:nframes
    % Get current frame for analysis
    frame = speech(samp1:samp2);
    % Do some analysis
%       ...
%       <DO _ SOMETHING>
%       ...
    % Step up to next frame of speech
    samp1 = samp1 + stepsize;
    samp2 = samp2 + stepsize;
end


