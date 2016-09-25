%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acquiring Speech                                             14-06-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For training, speech is acquired from a microphone and brought into the
% development environment for offline analysis. For testing, speech is
% continuously streamed into the environment for online processing. During the
% training stage, it is necessary to record repeated utterances of each digit in
% the dictionary. For example, we repeat the word ‘one’ many times with a pause
% between each utterance. Using the following MATLAB code with a standard PC
% sound card, we capture ten seconds of speech from a microphone input at 8000
% samples per second:
%
% We save the data to disk as ‘mywavefile.wav’:
if(0)
    Fs = 8000; % Sampling Freq (Hz)
    Duration = 10; % Duration (sec)

    %% Record voice for some seconds.
    recObj = audiorecorder;
    disp('Start speaking.')
    recordblocking(recObj, 5);
    disp('End of Recording.');

    %% Play back the recording.
    play(recObj);

    % Store data in double-precision array.
    myRecording = getaudiodata(recObj);

    % Plot the waveform.
    plot(myRecording);
end
%% use Data Acquisition Toolbox™ to set up continuous acquisition of the speech
% signal and simultaneously extract frames of data for processing.

% Define system parameters
framesize = 80;       % Framesize (samples)
Fs = 8000;            % Sampling Frequency (Hz)
RUNNING = 1;          % A flag to continue data capture

% Setup data acquisition from sound card
% ai = analoginput('winsound');
% addchannel(ai, 1);
% 
% % Configure the analog input object.
% set(ai, 'SampleRate', Fs);
% set(ai, 'SamplesPerTrigger', framesize);
% set(ai, 'TriggerRepeat',inf);
% set(ai, 'TriggerType', 'immediate');

% Start acquisition
start(ai)
ctr=10;

% Keep acquiring data while "RUNNING" ~= 0
while RUNNING
    % Acquire new input samples
    newdata = getdata(ai,ai.SamplesPerTrigger);
    % Do some processing on newdata

    % Set RUNNING to zero if we are done
    if ~ctr
         RUNNING = 0;
    end
    ctr=ctr-1;

end

% Stop acquisition
stop(ai);

% Disconnect/Cleanup
delete(ai);
clear ai;
