%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stochastik 23-01-2016        SS12  A.2
%
% codes base directory:
% /home/mainster/CODES_local/
function noise_source_runcfg () 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Associated simulink/simRF block diagram
RFMODEL='stochastik/simrf_noise_source';      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Associated LTSpice netlist
LTSPICEPRJ='LTSpice_projects/noise_snr/wavRead_matlab.asc';

WAVOUT='/home/mainster/CODES_local/LTSpice_projects/noise_snr/matlabout.wav';
WAVIN='/home/mainster/CODES_local/LTSpice_projects/noise_snr/spiceout.wav';
delete(findall(0,'type', 'line'))

syms n integer
rng default
clear simout;

%%%%%%%%%%%%%%%%%%%%%%%%
%% base parameters
FS    =  256e3;
fsWav =  256e3;
x0a   =  1e-3;
f0    =  .1e3;
x0 = @(t) x0a*sin(2*pi*f0*t);
dotExpansion('x0');
kb = 1.38e-23;

%%%%%%%%%%%%%%%%%%%%%%%%
%% simRF parameters
%stepSiz_ =  1/1e6;
stepSiz_ =  1/FS;
Rnoise	=  620+200;
stopTime =  100e-3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% find a opened block diagram called RFMODEL; Open the model if it's not found
bd = [];

while isempty(bd)
   bds = find_system('type', 'block_diagram');
   bd=bds(~cellfun(@isempty, strfind(bds,...
      evalc('[~, modnam, ~]=fileparts(RFMODEL);fprintf(modnam)'))));

   if isempty(bd)
      open_system(RFMODEL)
   else
      blkss = find_system(bds(~cellfun(@isempty, strfind(bds,...
         evalc('[~, modnam, ~]=fileparts(RFMODEL);fprintf(modnam)')))...
         ),'type', 'Block');
      blkcfg = cell2mat(blkss( ~cellfun(@isempty, strfind(blkss,...
         'SimRF_config')) ));
      break;
   end
end

set_param(blkcfg,'StepSize',num2str(stepSiz_))
set_param(bd{:},'StopTime',num2str(stopTime))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run model RFMODEL 
clear simout;
sim(RFMODEL)

y.tim = simout.Time;
y.dat = x0(y.tim) + simout.Data;
%%
plot(y.tim, y.dat); 
[SNRout, noisepowOut] = snr(y.dat, stepSiz_);
%%
audiowrite(WAVOUT, y.dat, fsWav);

retv = [];
retv = input('Import wavefile exported by spice simulation? [Y/n]','s');
%%
if isempty(retv) || retv == 'y' || retv == 'Y'
   [s_out, fsin2] = audioread(WAVOUT);
   [s_in, fsin] = audioread(WAVIN);

   [matout, b] = snr(s_out);
   fprintf('\nsimulink wav: SNR=%g  noisepow=%g  fs=%g\n', matout, b, fsin2);

   [matin, b] = snr(s_in);
   fprintf('LTspice wav : SNR=%g  noisepow=%g  fs=%g\n', matin, b, fsin);
   
   snrMdb(x0(y.tim), s_out)
   snrMdb(x0(y.tim), s_in)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

function [SNR_] = snrMdb(signalPayload, noisySignal)
   ps = sqrt(mean(signalPayload.^2));
   pn = sqrt(mean((noisySignal - signalPayload).^2));
   SNR_ = 20*log10(ps/pn);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% f0=1e3;     t0=1/f0;
% fs=48e3;   ts=1/fs;
% N=1024*8;
% 
% t_=(1:N)*ts;
% 
% s0=@(t,x0,f0) x0*sin(2*pi*f0*t);
% dotExpansion('x0');
% 
% r=@(t) 1e-6*rand(size(t_));
% x0_=5e-3;
% f0_=1e3;
% 
% snr_=25;
% s = awgn(s0(t_,x0_,f0_),snr_,'measured');
% 
% figure(1)
% plot(t_,s,'x-'); 
% 
% xlim([0,2/f0]);
% 
% SNR = snr(s,fs)
% %%
% audiowrite(WAVOUT,s,fs);
% %%
% % spice filtered
% [s_in, fsin]=audioread(WAVIN);
% SNR = snr(s_in,fsin)
% 
% return

