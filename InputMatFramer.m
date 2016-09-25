function [MATRIX] = InputMatFramer(yC, yR, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% costMatFramer.m                                                      @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kostenmatrix aufstellen und eventuell aufteilen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% [MATRIX] = InputMatFramer(yC, yR, frSize)
%
% yC:           Command input sequenze row vector
% yR:           Reference sequenze row vector
% frSize:       Frame size --> size(MATRIX) = frSize x frSize
% frSize:       -1  -->

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   parse function arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p = inputParser;

    valSeq = @(x) isnumeric(x) && ~isscalar(x); %&& isrow(x);

    addRequired(p,'yC',valSeq);
    addRequired(p,'yR',valSeq);
    addOptional(p,'frSize', -1, @isnumeric);

    parse(p,yC,yR,varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
ds = evalin('base','ds');

if ~isrow(yR)    % check for row/col vector
    R = yR';     % transpose to row if column vector given
    fprintf('INFO:InputMatFramer:\tyR has been transposed!!!\n')
else R = yR;    
end

if ~isrow(yC)    % check for row/col vector
    C = yC';     % transpose to row if column vector given
    fprintf('INFO:InputMatFramer:\tyC has been transposed!!!\n')
else C = yC;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   
if abs(length(R)-length(C)) > 0         % check for different sequence lengths
    warning('different seqence length')
	C = C(1:min(length(R),length(C)));  % truncate to smalest sequence vector
	R = R(1:min(length(R),length(C)));  % if different sizes 
end
% --------------------------------------------------------------------------
% Sequenzen in Symbolpakete aufteilen
% --------------------------------------------------------------------------
if p.Results.frSize < 0        % if frSize <= -1...
    SYMPACLEN = max(size(R));  % ... set packet length equal to sequence length
else                                
    SYMPACLEN = p.Results.frSize;
end

NPACS = round(length(R) / SYMPACLEN);   % number of packets must be integer
if NPACS > 1
    NPACS = NPACS - 1;                  % for fractional part >= 0.5, output 
end                                     % of round() rounds up
                                        
CLASSIFIED = 0; NON_CLASSIFIED = 1;     % enumerate defines
% --------------------------------------------------------------------------
%   MODUS = NON_CLASSIFIED:  
%           -->     differenzen der Abtastzeitpunkte werden direkt
%                   als Kostenmatrix an munkres übergeben
% --------------------------------------------------------------------------
%   MODUS = CLASSIFIED:  
%           -->     Klassifizierung in |min|R|max|F| und
%                   anschließen an munkres übergeben
% --------------------------------------------------------------------------

if round(yR(100:150)) == yR(100:150)
    MODUS = CLASSIFIED;
else
    MODUS = NON_CLASSIFIED;
end
% --------------------------------------------------------------------------

MATRIX{SYMPACLEN, SYMPACLEN, NPACS} = [];   % allocate memory
ctr = 1;                                    % reset packet counter

for ctr=1:NPACS
    k=ctr;
%     makeCost = zeros(1,NPACS);              % allocate/clear 
%     disp(ctr);
%     disp(NPACS);
    try 
        A = zeros(SYMPACLEN, SYMPACLEN);
    catch err
        disp(err);
        input('So what?')
    end
    % --------------------------------------------------------------------------
    if MODUS == NON_CLASSIFIED
    % --------------------------------------------------------------------------
%         for k=1:NPACS
            tic
            for m=1:SYMPACLEN
                for n=1:SYMPACLEN
                    try
%                        mi = m+(k-1)*NPACS;
%                        ni = n+(k-1)*NPACS;
                        mi = m+(k-1)*SYMPACLEN;
                        ni = n+(k-1)*SYMPACLEN;
                        A(m,n)=abs(R(mi)-C(ni));
    %                   fprintf('AA(%i,%i)=abs(R(%i)-C(%i))\n',mi,ni,mi,ni);
                    catch err
                        disp(err)
                        input('So what B?')
                    end
                end
            end
%             makeCost(k) = toc;
            ctr = ctr + 1;

            MATRIX{ctr} = A;
    %         A = zeros(SYMPACLEN, SYMPACLEN);
%         end
    end
end
% --------------------------------------------------------------------------
    

% --------------------------------------------------------------------------
    if MODUS == CLASSIFIED
        for k=1:NPACS
% --------------------------------------------------------------------------
            for m=1:SYMPACLEN
                for n=1:SYMPACLEN
            %        aa(i,j)=mod(s2(i),s1(j));
                    mi = m+(k-1)*SYMPACLEN;
                    ni = n+(k-1)*SYMPACLEN;
                    try
                        deltaEl = abs(R(mi)-C(ni));
                    catch err
                        disp (err)
                    end
                    switch(deltaEl)
            %         switch(kkk)
                        case 0
                            A(m,n) = 0;
                        case 1
                            A(m,n) = 5;
                        case 2
                            A(m,n) = 10;
                        case 3
                            A(m,n) = 8;
                        case 4
                            A(m,n) = 10;
                        otherwise
                    warning('bad solution')
                    end
                end
            end
%         else
%             if k==1
%                 fprintf('%s\n%s\nSignal is not classified\n%s\n%s\n',...
%                     ds,ds,ds,ds)
%             end
%         end
% --------------------------------------------------------------------------
        MATRIX{ctr} = A;
%         A = zeros(SYMPACLEN, SYMPACLEN);
    end
    
    if ~(MODUS==NON_CLASSIFIED || MODUS==CLASSIFIED) 
        error('Bad MODE selected')
    end
end

    
end
   

% 	fprintf('%ix%i Kostenmatrix erzeugen:\n\tmean(makeCost) = %.4gs\n\tsum(makeCost) = %.4gs\n',...
%         SYMPACLEN, SYMPACLEN, mean(makeCost), sum(makeCost))
% 	fprintf('%s\n',ds);
% 	fprintf('Munkres auf %ix%i Matrix anwenden:\n\tmean(makeAssign) = %.4gs\n\tsum(makeAssign) = %.4gs\n',...
%         SYMPACLEN, SYMPACLEN, mean(makeAssign), sum(makeAssign))
% 	fprintf('%s\n',ds);



%