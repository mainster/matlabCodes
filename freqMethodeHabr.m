function [varargout] = freqMethodeHabr (varargin)
%% [MI] = freqMethodeHabr(WAVE_CELL)     @@@MDB
% 
% Anwenden der Freq. Methode nach Habr
%

cd /home/mainster/CODES_local/matlab_workspace/

if nargin >= 1
    IN = varargin{1};
    
    if ~iscell(IN)
       error('wavObj input (cell) needed! ')
    end
    
    if ~(ismatrix(IN{1}) && isstruct(IN{2})) 
       error('wavObj input (cell) needed! ')
    end
    
    if ~isempty(find(~cellfun(@isempty, strfind(fieldnames(IN{2}),...
                repmat('NFFT',1,length(IN{2})))))) 
        specObj = IN;
    else 
        wavObj = IN;
    end
end
% 
% %/////////////////////
% 
% clear yin yinc A
% 
% if exist('wavlistC', 'var') 
%     fname = wavlistC;
% else 
%     fname = {wavpath};
% end
% 
% for k=1:length(fname) 
%     f=fopen(fname{k},'r+');% wave als raw file öffnen
%     fseek(f,20,0);         % filedescriptor f auf byte 20 im waveheader setzen
%     fwrite(f,[3 0]);       % "compression code" mit 0x03 überschreiben
%     fclose(f);             
%     [yinc{k} FsInc(k)]=wavread(fname{k});
% end

% if LENGTH == EQUAL         % Alle waves auf minimale Länge kürzen
%     mostLessSam = min(cell2mat(cellfun(@length, yinc, 'UniformOutput',false)));
%     for k=1:length(yinc) 
%         yincc(:,k) = yinc{k}(1:mostLessSam,1);
%     end
% end

% hold all
% plot(yincc(:,1))
% plot(yincc(:,2))
% hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%delete(findall(0,'type','line'));
%%
%y = wavObj{1};

if exist('wavObj','var')
    FsIn = wavObj{2}(1).fmt.nSamplesPerSec;
    yin = wavObj{1}(:,1);
    mpl = audioplayer(yin,FsIn);   % erzeuge audioplayer object mpl
    play(mpl)                     % play wave stored in y from beginning to end
    y = abs(wavObj{1});  % Gleichrichten ?!!!
else
    if exist('specObj','var')
        FsIn = specObj{2}.NFFT(1);
        y = abs(specObj{1});  % Gleichrichten ?!!!
    else
        error('not a wavObj, nor a specObj')
    end
end


nc = min(size(y));
nr = 5;                    % Anzahl Elemente in Matrix

if nc > nr
    error('nFILES > nEl')
end


MI=[];      % min sum speicher
% f99 = figure(99);
% hold all;


yref = y(:,1);

%yin = y(:,1);
    
SEL = 1;
%for SEL=2:nFILES % 2: weil nFiles inkl. referenz vektor gezählt wurde
    last = 1;
    for k=1:length(y(:,SEL))/nr
        A=[];                                           % leere habr matrix
        A(1:nr,1:nc) = [yref(last:last+nr-1),...        % vorhandene zeilen und 
                             y(last:last+nr-1,2:nc)];   % spalten mit nächstem Paket füllen 
%        A(1:nEl,1:nFILES) = y(last:last+nEl-1, 1:nFILES);
        if nc < nr                                      % dummy spalten einfügen
            A(1:nr, nc+1:nr) = [repmat(max(A(:)),...
                                nr, length(nc+1:nr))];
        end
        [tmp(k),cm(k,:),~,~] = habr(A);
        last = last+nr-1;
    end
    tmp=[];
    
%end
%%
if nargout >= 0
    varargout{1} = cm(:,1:end-(nr-nc));
end
%     if nargout >= 2
%         varargout{2} = C;
%     end
%     if nargout >= 3
%         varargout{3} = id;
%     end
%     if nargout >= 4
%         varargout{4} = Y;
%     end
return;

end