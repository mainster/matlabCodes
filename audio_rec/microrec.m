% Audio recording
% Projektthema "Sprachanalyse" bei Herr Schäfer, Algorithmen und
% Datenstrukturen

% Record your voice for 5 seconds.
recObj = audiorecorder(44100, 16, 2);
disp('Start speaking.')
recordblocking(recObj, 5);
disp('End of Recording.');

% Play back the recording.
play(recObj);

% Store data in double-precision array.
myRecording = getaudiodata(recObj);

% Plot the waveform.
plot(myRecording);