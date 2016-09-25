function varargout = genSpectraMatrix(varargin)
%% [Y OPT] = genSpectraMatrix(WAVE_IN)     @@@MDB
% 
% Ausgangsmatrix mit FFT- Spektren von WAVE_IN 
% erzeugen
%
% WAVE_IN:  wavObj, cell of ROW- vectors or 
%           single vector
% Y:        Ausgangsmatrix 
%


    if nargin >= 1
        IN = varargin{1};

        if ~iscell(IN)          % Vector
            if ~isnumeric(IN)
                error('wavObj, cell or vector input needed! ')
            end
            if nargin < 2
                error('need a second parameter for fs ')
            end
            if ~isnumeric(varargin{2})
                error('need NUMERIC, second parameter for fs')
            end
            wavVec = IN;
            FsIn = varargin{2};
        else                    % Cell of vectors or wavObj
            if ~(ismatrix(IN{1}) && isstruct(IN{2}))  % Cell of vectors
                if iscell(IN) 
                    wavCell = IN;
                else
                    if ismatrix(IN) 
                        wavVec = IN;
                    end
                end
                if nargin < 2
                    error('need a second parameter for fs ')
                end
                
                if ~isnumeric(varargin{2})
                    error('need NUMERIC, second parameter for fs')
                end
                FsIn = varargin{2};
            else 
                wavObj = IN;
            end
        end
    end    
    


    if exist('wavObj','var')
        nSig = size(wavObj{1}, 2);
        vartype = 1;
    end
    if exist('wavCell','var') 
        nSig = size(wavCell, 2);
        vartype = 2;
    end
    if exist('wavVec','var') 
        nSig = size(wavVec, 2);
        vartype = 3;
    end

    for k=1:nSig

        switch (vartype)
            case 1
                fs = wavObj{2}(1).fmt.nSamplesPerSec;
                L = length(wavObj{1}(:,k));
                NFFT(k) = 2^nextpow2(L); % Next power of 2 from length of y
                Y(:,k) = fft(wavObj{1}(:,k), NFFT(k))/L;
            case 2
                fs = FsIn;
                L = length(wavCell{:,k});
                NFFT(k) = 2^nextpow2(L); % Next power of 2 from length of y
                Y(:,k) = fft(wavCell{:,k}, NFFT(k))/L;
            case 3
                fs = FsIn;
                L = length(wavVec(:,k));
                NFFT(k) = 2^nextpow2(L); % Next power of 2 from length of y
                Y(:,k) = fft(wavVec(:,k), NFFT(k))/L;
            otherwise
                error('Error switch')
        end

        fv(:,k) = fs/2*linspace(0,1,NFFT(k)/2+1);

    end

    objStruct = struct('NFFT',NFFT,'freqLin',fv,'fs', fs);

    if nargout >= 0
        varargout{1} = Y;
    end
    if nargout >=1
        varargout{2} = objStruct;
    end

end
    