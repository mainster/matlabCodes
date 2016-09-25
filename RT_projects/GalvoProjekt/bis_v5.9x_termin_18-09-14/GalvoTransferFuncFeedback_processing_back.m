% processing GalvoTransferFuncFeedback.mdl
%
oldLines=findall(0,'type','line');    % Inhalte der letzten plots löschen, figure handle behalten
delete(oldLines);

%[A,b,c,d]=linmod('RCL_netzwerk_als_block');
%[A,b,c,d]=linmod('GalvoTfPD_L1');

%sys=ss(A,b,c,d);

init=struct('TsSens',   30e-6, ...
            'TsSens2',  555e-6, ...
            'TsCtrl',   100e-6, ...
            'StopTime', 50e-3, ...
            'MinStepSize',  10e-6);


% For Variable-Step:
MaxStepSize='auto';
MinStepSize=init.MinStepSize;
TsSens=init.TsSens;
TsSens2=init.TsSens2;
TsCtrl=init.TsCtrl;
StopTime=init.StopTime;

%sim('RCL_netzwerk_als_block.mdl');
sim('GalvoTransferFuncFeedback.slx');

%t=simoutTime.signals.values;

outTs1=struct('time',[],'values',[],'nSamp',[],'tSamp',[]);

NN=3;
%plot(sigDiscTs1.signals.values)
for n=1:NN
    outTs1.time(n,1:size(simTime.Time))=simTime.Time';
    outTs1.values(n,1:size(sigDiscTs1.signals.values))=sigDiscTs1.signals.values';
    outTs1.nSamp(n)=length(sigDiscTs1.signals.values);
    outTs1.tSamp(n)=TsCtrl;
    TsCtrl=TsCtrl+100e-6;
%    outTs1.tSamp(n)=TsSens;
%    TsSens=TsSens+200e-6;
    sim('GalvoTransferFuncFeedback.slx');
end


f1=figure(1);
col=['r';'g';'b';'m';'c';'b'];
legendStr=[];
for k=1:NN
    hold all;
    plot(outTs1.time(k,1:outTs1.nSamp(k)),k+outTs1.values(k,1:outTs1.nSamp(k)),col(k));grid on;
    legendStr(k,:)=['TsCtrl = ' num2str(outTs1.tSamp(k),'%.3e')];
 %   legendStr(k,:)=['TsSens = ' num2str(outTs1.tSamp(k),'%.3e')];
end
    k=k+1;
    legendStr(k,1:length('Continuous'))='Continuous';
    plot(simTime.Time, k+sigCont.signals.values,col(k));grid on;
    legend(char(legendStr));
    hold off;




TsSens=init.TsSens;
TsSens2=init.TsSens2;
TsCtrl=init.TsCtrl;
StopTime=init.StopTime;

%sim('RCL_netzwerk_als_block.mdl');
sim('GalvoTransferFuncFeedback.slx');

%f1=figure(1);
%plot(outTs1.time(k,1:outTs1.nSamp(k)),outTs1.values(k,1:outTs1.nSamp(k));
