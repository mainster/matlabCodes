%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SpeechRecognition_2.0                                           14-06-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

global s loops loopsStatic nextFrame

fs = 8e3;
Ts=1/fs;
frs = 250;      % Frame size in [Samples]
durate = 1.5;  % record duration in [sec]
sprintf('\n%s\n\tSoundcard DAQ tests...\n%s', ds, ds )
s=[];
tic;
%%
reading_soundcard(fs, frs, durate)
%%
ti=double(toc);
fprintf('Final toc after % .2gms or % .2gs \n', ti*1e3, ti)

f1=figure(1); clf;
SUB=210;
%%
ax(1)=subplot(SUB+1);
plot(linspace(0,durate,durate/Ts), zeros(1,durate/Ts)); hold all;
set(ax(1),'Xlim',[0,durate],'XTick',...
      0:ceil(10*durate/  20  )/10:durate ,'XLimMode','manual')
%%

for k=1:durate*fs/frs
   dtt{k} = linspace(k*Ts*frs, (k+1)*Ts*frs,frs);
end
%%
while(loops) 
   NN=(loopsStatic -loops);
   if (nextFrame)
      plot(dtt{NN}, s(NN*frs:(NN+1)*frs));    
      nextFrame=0;
   end
   
   drawnow;
end

% linspace(0,(loopsStatic - loops)*frs*Ts
disp('END')
