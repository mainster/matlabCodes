%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%
% the SNR-Pe graph of "antipodal M=2" and "orthgonal M=4" signal
% BPSK vs QPSK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%
clear;
clc;
clf;
TheStartTime=datestr(now) % the simulation start time

SNRTail=8; % snr x-axis start
SNRHead=-1; % snr x-axis finish
BitLength=10000; % information BitLength
InputBit=randint(1,BitLength,[0,1]); % information set {0,1} 

%%%%%%%%%%%%%%%%%% (a2)
AntipodalSymbol=zeros(1,BitLength); % I symbol
% mapping information to symbol
for AntipodalMappingcnt=1:BitLength
if InputBit(AntipodalMappingcnt)==0
AntipodalSymbol(AntipodalMappingcnt)=-1;
else 
AntipodalSymbol(AntipodalMappingcnt)=+1;
end
end
%%%%%%%%%%%%%%%%%% (a2)
%%%%%%%%%%%%%%%%%% (o4)
Orothogornal4symbolI=zeros(1,BitLength/2); % I symbol
Orothogornal4symbolQ=zeros(1,BitLength/2); % Q symbol

% mapping information to symbol
for Orothogornal4mappingcnt=1:BitLength/2 %infromation mapping counting-index
if InputBit(2*Orothogornal4mappingcnt-1)==1 && InputBit(2*Orothogornal4mappingcnt)==1
Orothogornal4symbolI(Orothogornal4mappingcnt)=-1;
Orothogornal4symbolQ(Orothogornal4mappingcnt)=0;
elseif InputBit(2*Orothogornal4mappingcnt-1)==0 && InputBit(2*Orothogornal4mappingcnt)==1
Orothogornal4symbolI(Orothogornal4mappingcnt)=0;
Orothogornal4symbolQ(Orothogornal4mappingcnt)=1;
elseif InputBit(2*Orothogornal4mappingcnt-1)==0 && InputBit(2*Orothogornal4mappingcnt)==0
Orothogornal4symbolI(Orothogornal4mappingcnt)=1;
Orothogornal4symbolQ(Orothogornal4mappingcnt)=0;
else Orothogornal4symbolI(Orothogornal4mappingcnt)=0; Orothogornal4symbolQ(Orothogornal4mappingcnt)=-1;
end 
end
%%%%%%%%%%%%%%%%%% (o4)


for ss=SNRHead:SNRTail
SNRcnt=ss+(-SNRHead+1);

Antipodal2ErrorNum=0;
Orthogonal4ErrorNum=0;
% ber=zeros(1,SNRTail-SNRHead+1);
SNR(SNRcnt)=ss; % we can change the value 
n0=10^(-SNR(SNRcnt)/10); % the noise power, SNR = 10*log(ps/n0), ps=1

%%%%%%%%%%%%%%%%%%%%%%%% (o2)
n2i=randn(1,BitLength); % mean=0, var^2=1 Gaussian noise
Antipodal2noise=(1/2*(n0))^(1/2)*n2i; % mean=0 , var^2=1/2*n0 Gaussain noise
TxAntipodal2=AntipodalSymbol+Antipodal2noise; % received signal in I channel 
%%%%%%%%%%%%%%%%%%%%%%%%% (o2)

%%%%%%%%%%%%%%%%%%%%%%%%% (o4)
n4i=randn(1,BitLength/2); % mean=0, var^2=1 I channel Gaussian noise, noise BitLength= (signal BitLength)/2
n4q=randn(1,BitLength/2); % mean=0, var^2=1 Q channel Gaussian noise, noise BitLength= (signal BitLength)/2
Orthogonal4noiseI=(1/2*(n0))^(1/2)*n4i; % mean=0 , var^2=1/2*n0 Gaussain noise
Orthogonal4noiseQ=(1/2*(n0))^(1/2)*n4q; % mean=0 , var^2=1/2*n0 Gaussain noise
TxOrthogonal4I=(2^(1/2))*Orothogornal4symbolI+Orthogonal4noiseI; % received signal in I channel 
TxOrthogonal4Q=(2^(1/2))*Orothogornal4symbolQ+Orthogonal4noiseQ; % received signal in Q channel
TxOrthogonal4=(TxOrthogonal4I+TxOrthogonal4Q*i); % received signal in signal space 
%%%%%%%%%%%%%%%%%%%%%%%%% (o4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% (a2)
RxAntipodal2=zeros(1,BitLength);
for Antipodal2demappingcnt=1:BitLength
if TxAntipodal2(Antipodal2demappingcnt) >= 0;
RxAntipodal2(Antipodal2demappingcnt)=1 ;
else RxAntipodal2(Antipodal2demappingcnt)=0;
end
if RxAntipodal2(Antipodal2demappingcnt)-InputBit(Antipodal2demappingcnt)==0 % count the error number 
Antipodal2ErrorNum=Antipodal2ErrorNum;
else Antipodal2ErrorNum=Antipodal2ErrorNum+1; 
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% (a2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% (o4)
RxOrthogonal4=zeros(1,BitLength);
% decision criterion 
for Orthogonal4Demappingcnt=1:BitLength/2 % demapping countiong-index
Orthogonal4SymbolAngle(Orthogonal4Demappingcnt)=mod(angle(TxOrthogonal4(Orthogonal4Demappingcnt)),2* pi);
if mod(angle(-1+1*i),2*pi)<=Orthogonal4SymbolAngle(Orthogonal4Demappingcnt) && Orthogonal4SymbolAngle(Orthogonal4Demappingcnt)<=mod(angle(-1-1*i),2*pi)
RxOrthogonal4(2*Orthogonal4Demappingcnt-1)=1; RxOrthogonal4(2*Orthogonal4Demappingcnt)=1;
elseif mod(angle(1+1*i),2*pi)<=Orthogonal4SymbolAngle(Orthogonal4Demappingcnt) && Orthogonal4SymbolAngle(Orthogonal4Demappingcnt)<=mod(angle(-1+1*i),2*pi)
RxOrthogonal4(2*Orthogonal4Demappingcnt-1)=0; RxOrthogonal4(2*Orthogonal4Demappingcnt)=1;
elseif mod(angle(-1-1*i),2*pi)<=Orthogonal4SymbolAngle(Orthogonal4Demappingcnt) && Orthogonal4SymbolAngle(Orthogonal4Demappingcnt)<=mod(angle(1-1*i),2*pi)
RxOrthogonal4(2*Orthogonal4Demappingcnt-1)=1; RxOrthogonal4(2*Orthogonal4Demappingcnt)=0;
else RxOrthogonal4(2*Orthogonal4Demappingcnt-1)=0; RxOrthogonal4(2*Orthogonal4Demappingcnt)=0;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% (o4)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%% (a2)
Antipodal2ErrorSum(SNRcnt)=Antipodal2ErrorNum;
Antipodal2BER(SNRcnt)=Antipodal2ErrorSum(SNRcnt)/BitLength; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%% (a2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%% (o4)
for Orthogonal4Errorcnt=1:BitLength
if RxOrthogonal4(Orthogonal4Errorcnt)-InputBit(Orthogonal4Errorcnt)==0 % count the error number 
Orthogonal4ErrorNum=Orthogonal4ErrorNum;
else Orthogonal4ErrorNum=Orthogonal4ErrorNum+1; 
end
end
Orthogonal4ErrorSum(SNRcnt)=Orthogonal4ErrorNum;
Orthogonal4BER(SNRcnt)=Orthogonal4ErrorSum(SNRcnt)/BitLength;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%% (o4)
end
axis([SNRHead SNRTail 0 10^-5])
semilogy(SNR,Antipodal2BER,': ^')
hold on
semilogy(SNR,Orthogonal4BER,'--r*')
grid on
legend('Antipodal-2(BPSK)','Orthogonal-4(QPSK)')

TheFinishTime=datestr(now) % the finish time of this simulation