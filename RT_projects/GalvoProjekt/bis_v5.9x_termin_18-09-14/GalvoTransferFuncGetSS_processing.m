%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Postprocessing GalvoTransferFuncGetSS.slx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%oldLines=findall(0,'type','line');    % Inhalte der letzten plots löschen, figure handle behalten
oldLines=findall(0,'type','figure');    % Inhalte der letzten plots löschen, figure handle behalten
delete(oldLines);



init=struct('TsSens',   30e-6, ...
            'TsSens2',  30e-6, ...
            'StopTime', 20e-3, ...
            'MinStepSize',  1e-6, ...
            'DelayTime',    10e-6);

PID=struct( 'P',    0.392064644185526, ...
            'I',    2068.15339037511, ...
            'D',    -6.65561460630199e-05, ...
            'N',    2036.00041035722, ...
            'Ts',   100e-6);

load('/home/mainster/CODES_local/matlab_workspace/pid1','PID')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Da der PID-L2 Regler diskret im Simulink- Model aufgebaut wurde, müssen
% einige Parameter aus dem Model mit intergriertem PID- Block "abgekuckt"
% werden:

%Extract continuous-time linear state-space model around operating point
[A,b,c,d]=linmod('GalvoTransferFuncGetSS'); 
sysPDg=ss(A,b,c,d);             % Erzeuge state space model aus den zustands- und 
                                % ausgangsvektoren
[num, den]=ss2tf(A,b,c,d);      % convert state space model to transferfunction 
w0=7720;
eps=0.65;
Hgcl=tf(w0^2,[1 2*eps*w0 w0^2]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
col=['r';'g';'b';'m';'c';'b'];
legendStr=[];
f1=figure('Position',[1943 568 560 420]);
hold all;
%f2=figure('Position',[2509 568 560 420]);

subplot(211);
step(Hgcl); grid on;
subplot(212);
bode(Hgcl); grid on;

%sim('GalvoTransferFuncGetSS.slx');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% open_system('GalvoDiskPIDeinzel');
% set_param(gcs,'location',[ 1926 3 3348 896]);
% 
% outTs100=struct('time',[],'values',[],'nSamp',[],'tSamp',[]);
% 
% sim('GalvoDiskPIDeinzel.slx');
% 
% f1=figure(1);
% hold all;
% plot(outTs1.Time,outTs1.Data);; grid on;
% plot(outDis.Time,outDis.Data);; grid on;
% hold off;
% legend ('outTs1','outDis');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




















% NN=1;
% %plot(sigTs1.signals.values)
% for n=1:NN
%     sim('GalvoTransferFuncGetSS.slx');
%     outTs1.time(n,1:length(simTime.Time))=simTime.Time';
%     outTs1.values(n,1:length(sigTs1.signals.values))=sigTs1.signals.values';
%     outTs1.nSamp(n)=length(sigTs1.signals.values);
% %    outTs1.tSamp(n)=PID.Ts;
%     outTs1.tSamp(n)=init.DelayTime;
% %    PID.Ts=PID.Ts+100e-6;
%     init.DelayTime=init.DelayTime+50e-6;
% %    outTs1.tSamp(n)=TsSens;
% %    TsSens=TsSens+200e-6;
% end
% 
% 
% f1=figure('Position',[1943 568 560 420]);
% hold all;
% f2=figure('Position',[2509 568 560 420]);
% 
% hold all;
% col=['r';'g';'b';'m';'c';'b'];
% legendStr=[];
% 
% for k=1:NN
%     figure(f1); hold all;
%     plot(outTs1.time(k,1:outTs1.nSamp(k)),k+outTs1.values(k,1:outTs1.nSamp(k)),col(k));grid on;
%     figure(f2); hold all;
%     plot(outTs1.time(k,1:outTs1.nSamp(k)),outTs1.values(k,1:outTs1.nSamp(k)),col(k));grid on;
%     legendStr(k,:)=['ZOH = ' num2str(outTs1.tSamp(k),'%.3e')];
%  %   legendStr(k,:)=['TsSens = ' num2str(outTs1.tSamp(k),'%.3e')];
% end
% 
% figure(f2);
% legend(char(legendStr));
% hold off;
% 
% k=k+1;
% figure(f1);
% legendStr(k,1:length('Ohne Delay'))='Ohne Delay';
% plot(simTime.Time, k+sigTs2.signals.values,col(k));grid on;
% legend(char(legendStr));
% hold off;
% 
% 
% 
% 
% 
% 
% 


% syms DOutMin DOutMax DParamMin DParamMax NParamMax NParamMin FilterOutMax FilterOutMin ParamMax ParamMin IntegratorOutMin IntegratorOutMax SumDOutMin SumDOutMax SumOutMax SumOutMin

%BlockType;
% DParamMin=-100;
% DParamMax=100;
% NParamMax=200;
% NParamMin=-200;
% FilterOutMax=10e3;
% FilterOutMin=-10e3;
% ParamMax=10e3;
% ParamMin=-10e3;
% IntegratorOutMin=-100;
% IntegratorOutMax=100;
% SumDOutMin=-100;
% SumDOutMax=100;
% SumOutMax=100;
% SumOutMin=-100;
% DOutMin=-100;
% DOutMax=100;
% 
