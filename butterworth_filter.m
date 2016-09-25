%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Butterworth Filter                03-06-2015 @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[b,a] = butter(8,0.6);
freqz(b,a)
dataIn = randn(1000,1);
dataOut = filter(b,a,dataIn);

f2=figure(2);
plot(dataIn); hold all;
plot(dataOut); hold off;

