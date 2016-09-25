function [varargout] = rewriteWav(varargin)

    list = varargin{1};

    for k=1:length(list) 
        f=fopen(list{k},'r+');% wave als raw file öffnen
        fseek(f,20,0);         % filedescriptor f auf byte 20 im waveheader setzen
        fwrite(f,[3 0]);       % "compression code" mit 0x03 überschreiben
        fclose(f);             
        [A{k},~,~,B{k}]=wavread(list{k});
    end

    temp = struct('fmt',B{:,1}.fmt,'info',B{:,1}.info,'list',B{:,1}.list, 'disp',B{:,1}.disp)
    varargout{1} = A;
    varargout{2} = B;



end