% Postprocessing spiBitbangSimulink.slx
%
oldLines=findall(0,'type','line');    
delete(oldLines);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- SPI Parameter
f_sclk=100e3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ 
sampleTime = 1e-6;                             % Symbolzeite-
simulationTime = 100e-3;                        % Simulationszeit
MaxStepSize=10e-6;
sampleTimeGPIOin = 1e-6;
SCKgenVec.time = [0:sampleTime:simulationTime]; % Zeitvektor
MOSIgenVec.time = [0:sampleTime:simulationTime]; % Zeitvektor
%siminSymbols.time = [0:sampleTime:simulationTime]; % Zeitvektor



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Eingansdaten erzeugen 
%SCKgenVec.signals.values = boolean( ceil(2*rand(length(SCKgenVec.time),1))-1 ); % 
%MOSIgenVec.signals.values = boolean( ceil(2*rand(length(MOSIgenVec.time),1))-1 ); % 
SCKgenVec.signals.values = ceil(2*rand(length(SCKgenVec.time),1))-1; % 
MOSIgenVec.signals.values = ceil(2*rand(length(MOSIgenVec.time),1))-1 ; % 

genPer=2*round(1/(2*f_sclk*sampleTime));

periSam=20;

txBinBuff.signals.values=ceil(2*rand(16,1))-1;
txBinBuff.time=[0:sampleTime:simulationTime];
% 
% channelsFast(1).xData=DIV*channelsFast(1).xData
% channelsFast(2).xData=DIV*channelsFast(2).xData
% channelsFast(3).xData=DIV*channelsFast(3).xData
% channelsFast(4).xData=DIV*channelsFast(4).xData
% 
% channelsFast(1).stepX=DIV*channelsFast(1).stepX
% channelsFast(2).stepX=DIV*channelsFast(2).stepX
% channelsFast(3).stepX=DIV*channelsFast(3).stepX
% channelsFast(4).stepX=DIV*channelsFast(4).stepX
% 
% save ('channelsFast.m',channelsFast)
% 
% txBuffIn=timeseries(ceil(2*rand(16,1))-1)
%pulsSam=5
%sim('spiBitbangSimulink_v3.slx');

% nel=logsout.numElements;
% logsout.getElementNames
% sigStruc=logsout.getElement(1).Values.Data(1,1:end)
% 
% t=logsout.getElementNames;
% sigStrucVar=[t [1:length(logsout.getElement(1).Values.Data(1,1:end))]
% sigStruc=struct(
% %inSig1=timeseries([channels(3).xData]','Name',[channels(3).yData]')
% 
% SCLK_PLOT=[1:20];
% %plot (outSclkGen.time(SCLK_PLOT), outSclkGen.signals.values(SCLK_PLOT)); grid on;



