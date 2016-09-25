function [varargout] = readCutWav(varargin)
%% [OUT] = readCutWav(LIST)     @@@MDB
% 
% Importieren von Wave- Dateien
%
% Y:                Ausgangsmatrix 
%

% Beim erzeugen von wave- dateien gibt es programme, die im wave- header
% einen fehlerhaften (oder einen matlab- unbekannten) "compression code"
% hinterlegen. 
% Der unbekannte "compression code" löst folgende Fehlermeldung beim 
% enlesen mit wavread() aus:
%
% ////////////////////////////////////////////////////////////////////////
% Data compression format (Format #65534) is not supported
% ////////////////////////////////////////////////////////////////////////
%
% Ein einfacher Workaround ist hier beschrieben:
%
% ////////////////////////////////////////////////////////////////////////
% http://social.msdn.microsoft.com/Forums/en-US/f58b74b4-8903-4801-8671-b100b2ab975d/cannot-load-the-wav-file-captured-by-audiocaptureraw-in-matlab?forum=kinectsdkaudioapi
% Changing the "compression code" to 0x0003 (eg. in a hex editor), you can
% now read the wav in matlab and it actually looks like a wave file in 4
% channels... A small matlab hack, that does the trick is:
% ////////////////////////////////////////////////////////////////////////

% Flags
EQUAL = 1;
UNEQUAL = 0;
LENGTH = EQUAL;

cd /home/mainster/CODES_local/matlab_workspace/
%fname={ 'wavefiles/CoolEditPro/lampe_AUS_w.wav',...
%        'wavefiles/CoolEditPro/lampe_AN_w.wav'};
    
if nargin >= 1
   if iscell(varargin{1})
       wavlistC = varargin{1};
       if ~iscellstr(wavlistC)
           error('is not cellstr (wavlist)')
       end
   else
       wavpath = varargin{1};
       if ~ischar(wavpath)
           error('is not char (wavpath)')
       end
   end
end

%/////////////////////

clear yin yinc A

if exist('wavlistC', 'var') 
    fname = wavlistC;
else 
    fname = {wavpath};
end

for k=1:length(fname) 
    try 
        [yinc{k},~,~,optscTmp{k}]=wavread(fname{k});
    catch err
        fprintf('%s:  wave file BUG\n',err.identifier)
        fd=fopen(fname{k},'r+');% wave als raw file öffnen
        fseek(fd,20,0);         % filedescriptor f auf byte 20 im waveheader setzen
        fwrite(fd,[1 0]);       % "compression code" mit 0x03 überschreiben
        fclose(fd);             
        [yinc{k},~,~,optscTmp{k}]=wavread(fname{k});
    end
    
%     optsc(k) = struct('fmt', optscTmp{k})
end
for k=1:length(fname)
    optsc(k) = struct('fmt', optscTmp{k}.fmt);
end
% optsc(k)
%optsc{1}.info=[];

if LENGTH == EQUAL         % Alle waves auf minimale Länge kürzen
    mostLessSam = min(cell2mat(cellfun(@length, yinc, 'UniformOutput',false)));
    for k=1:length(yinc) 
        yincc(:,k) = yinc{k}(1:mostLessSam,1);
    end
end

if nargout >= 0 
    varargout{1} = yincc;
end
if nargout >= 2 
    varargout{2} = optsc;
end

end