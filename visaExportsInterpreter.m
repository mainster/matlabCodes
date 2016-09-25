%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Interpreter for visa scope ascii output character files  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  M.DelBasso 01-05-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Export of logic analyzer waveforms, header: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f1='/media/storage/abbott_libre/visa_trf_first_SCK_actiontxt';

% Export of oscilloscope data - 29.April 2016 - 22:52:29 
% [preamble]
%  Decimal-sign = comma
%  Separator = Tab
%  X-Values = Time
%  Ch1+Ch1 = voltages
%  D0-D7 = hexadecimal
%  T = 1.365e-04
%  Nsamples = 2048
%  Ncolumns = 1
% [Data]
%  X	Digital

samps = system(['head -n 20 ' f1 ' | grep -iE ''nsamples.+=(.*)'' | grep -oE ''[0-9]{1,}''']);
linesAll = system(['wc -l' f1]);
