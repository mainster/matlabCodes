urlwrite('http://freewavesamples.com/files/Yamaha-SY-35-Clarinet-C5.wav','sample.wav');
%reads from web and saves the wav file in local folder with name sample.wav
%this might not save the file if so please download the file from the link

[W,fs]=wavread('sample.wav');
%[W,fs]=wavread(FileName);

%[~,~,T,P]=spectrogram(W(:,end),200,199,256,fs);

[~,~,T,P]=spectrogram(W(:,end),200,200/2,256,fs);
%[~,~,T,P]=spectrogram(W(:,end),tres,tres/2,fres,fs);
I=flipud(-log(P));
% I is the image of spectrogram in 2D matrix now

% I want to plot this spectrogram in 3d
h = surf(I.*-1);
set(h, 'edgecolor','none');

%this does the job however it is very blocky I want to smooth this