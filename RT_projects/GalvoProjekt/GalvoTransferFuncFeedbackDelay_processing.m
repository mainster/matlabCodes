% processing GalvoTransferFuncFeedbackDelay.mdl
%
%oldLines=findall(0,'type','line');    % Inhalte der letzten plots löschen, figure handle behalten
%delete(oldLines);
figs=findall(0,'type','figure');    % Inhalte der letzten plots löschen, figure handle behalten
delete(figs);



%[A,b,c,d]=linmod('RCL_netzwerk_als_block');
%[A,b,c,d]=linmod('GalvoTfPD_L1');

%sys=ss(A,b,c,d);

init=struct('TsSens',   30e-6, ...
            'TsSens2',  30e-6, ...
            'StopTime', 50e-3, ...
            'MinStepSize',  1e-6, ...
            'DelayTime',    10e-6);

PID=struct( 'P',    0.127867810268812, ...
            'I',    2557.35620537625, ...
            'D',    0, ...
            'N',    100, ...
            'Ts',   100e-6);

PID=struct( 'P',    0.392064644185526, ...
            'I',    2068.15339037511, ...
            'D',    -6.65561460630199e-05, ...
            'N',    2036.00041035722, ...
            'Ts',   100e-6);

load('/home/mainster/CODES_local/matlab_workspace/pid1','PID')
        
% For Variable-Step:
MaxStepSize='auto';
MinStepSize=init.MinStepSize;
TsSens=init.TsSens;
TsSens2=init.TsSens2;
StopTime=init.StopTime;

%sim('RCL_netzwerk_als_block.mdl');
%sim('GalvoTransferFuncFeedbackDelay.slx');

%t=simoutTime.signals.values;

outTs1=struct('time',[],'values',[],'nSamp',[],'tSamp',[]);

NN=5;
%plot(sigTs1.signals.values)
for n=1:NN
    sim('GalvoTransferFuncFeedbackDelay.slx');
    outTs1.time(n,1:size(simTime.Time))=simTime.Time';
    outTs1.values(n,1:size(sigTs1.signals.values))=sigTs1.signals.values';
    outTs1.nSamp(n)=length(sigTs1.signals.values);
%    outTs1.tSamp(n)=PID.Ts;
    outTs1.tSamp(n)=init.DelayTime;
%    PID.Ts=PID.Ts+100e-6;
    init.DelayTime=init.DelayTime+50e-6;
%    outTs1.tSamp(n)=TsSens;
%    TsSens=TsSens+200e-6;
end


f1=figure('Position',[1943 568 560 420]);
hold all;
f2=figure('Position',[2509 568 560 420]);

hold all;
col=['r';'g';'b';'m';'c';'b'];
legendStr=[];

for k=1:NN
    figure(f1); hold all;
    plot(outTs1.time(k,1:outTs1.nSamp(k)),k+outTs1.values(k,1:outTs1.nSamp(k)),col(k));grid on;
    figure(f2); hold all;
    plot(outTs1.time(k,1:outTs1.nSamp(k)),outTs1.values(k,1:outTs1.nSamp(k)),col(k));grid on;
    legendStr(k,:)=['ZOH = ' num2str(outTs1.tSamp(k),'%.3e')];
 %   legendStr(k,:)=['TsSens = ' num2str(outTs1.tSamp(k),'%.3e')];
end

figure(f2);
legend(char(legendStr));
hold off;

k=k+1;
figure(f1);
legendStr(k,1:length('Ohne Delay'))='Ohne Delay';
plot(simTime.Time, k+sigTs2.signals.values,col(k));grid on;
legend(char(legendStr));
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some info by UICONTROL's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scrsz = get(0,'ScreenSize');
scr0=struct('x0',1,'y0',1,'x1',scrsz(3)-1440,'y1',scrsz(4));
scr1=struct('x0',scrsz(3)-1440,'y0',scrsz(4)-900,'x1',scrsz(3),'y1',scrsz(4));

%f4=figure('Position',[1950 840 350 170]);
f4=figure('Position',[1943 343 350 170]);
% Make a text uicontrol to wrap in Units of Pixels
% Create it in Units of Pixels, 100 wide, 10 high
pos = [20 170-20-100 300 100];   
ht = uicontrol('Style','Text','Position',pos);

msg={};
for i=1:NN
   msg=[msg, strcat('outTs1.nSamp(',num2str(i),') = ',num2str(outTs1.nSamp(NN)))];
end
% Wrap string, also returning a new position for ht
[outstring,newpos] = textwrap(ht,msg) 
set(ht,'String',msg,'Position',pos)



% 
% 
% 
% 
% TsSens=init.TsSens;
% TsSens2=init.TsSens2;
% TsCtrl=init.TsCtrl;
% StopTime=init.StopTime;
% 
% %sim('RCL_netzwerk_als_block.mdl');
% sim('GalvoTransferFuncFeedback.slx');

%f1=figure(1);
%plot(outTs1.time(k,1:outTs1.nSamp(k)),outTs1.values(k,1:outTs1.nSamp(k));
