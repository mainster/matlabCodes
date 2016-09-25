function recordAudioExample
%     % Record your voice for 5 seconds.
%     har = dsp.AudioRecorder;
% hmfw = dsp.AudioFileWriter('myspeech.wav','FileFormat','WAV');
% 
% disp('Speak into microphone now');
% 
% tic;
% while toc < 10,
%      step(hmfw, step(har));
% end
% 
% release(har);
% release(hmfw);
% disp('Recording complete'); 
% 
%     return
    
    mic     = dsp.AudioRecorder;
    speak   = dsp.AudioPlayer;%('SampleRate','16000');
    spec    = dsp.SpectrumAnalyzer;
    
    tic;
    
    while (toc < 30)
        audio = step(mic);
                step(spec, audio);
                step(speak, audio);
    end
%     recObj = audiorecorder(44100, 16, 2);
%     record(recObj, 5);
%     
%      length(recObj.getaudiodata)
%          
%     % Play back the recording.
%     play(recObj);
% 
%     % Store data in double-precision array.
%     myRecording = getaudiodata(recObj);
% 
%     % Plot the waveform.
%     plot(myRecording);

end