function waveWriteBasicStruct (fname)
%% waveWriteBasicStruct(fname)     @@@MDB
%
% Wave dateien die ohne info- struktur erzeugt wurden können ua in LTspice
% nicht geladen werden.
%
% fname:     Cell array mit pfadangaben zu den wave dateien die überprüft
%           und ggf um ein standard info- struct erweitert werden.
%

if nargin ~= 1
    error('Only single parameter, cell array with paths to wave files')
end
% if ~iscell(varargin{1})
%     error('Only single parameter, CELL array with paths to wave files')
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

stdInfo = struct(   'iart','matlab default artist',...
                    'inam','matlab default nam',...
                    'icmt','matlab default comment');
% stdDisp = struct(   'name:','matlab default DisplayName',...
%                     'text:','matlab default Titel');
                
for k=1:length(fname)
    if isempty(strfind(fname{k},'.wav'))
        error(sprintf('file extension *.wav in %s not found!',fname{k}))
    end
    fd=fopen(fname{k},'r+');% wave als raw file öffnen
    fseek(fd,20,0);         % filedescriptor f auf byte 20 im waveheader setzen
%    fwrite(fd,[3 0]);       % "compression code" mit 0x03 überschreiben
     fwrite(fd,[1 0]);       % 10-11-14: ...mit 0x01 (no compression überschreiben
    fclose(fd);             
    [y,fs,nbit,opts{k}]=wavread(fname{k});    
%    opts{k}=audioinfo(fname{k});
    
    infofield=strfind(fieldnames(opts{k}),'info');    
%     dispfield=strfind(fieldnames(opts{k}),'disp');    
 
    if iscell(infofield)
        infofield=cell2mat(infofield);
    end
%     if iscell(dispfield)
%         dispfield=cell2mat(dispfield);
%     end
    
    if isempty( infofield )
        fprintf('NO INFO/DISP structure %s \n',fname{k});
        audiowrite(fname{k},y,fs,'BitsPerSample',nbit,'Title','tit','Artist','art','Comment','Com')
        
    else
        fprintf('INFO!!!  %s \n',fname{k});
    end
    
    au=audioinfo(fname{k});
    fprintf('fs = %d\tnSam = %d\tmSec = %g\n\n',au.SampleRate,au.TotalSamples,au.Duration)
end




end