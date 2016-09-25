function [MATRIX] = costMatFramer(yC, yR, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% costMatFramer.m                                                      @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kostenmatrix aufstellen und eventuell aufteilen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% [MATRIX] = costMatFramer(yC, yR, frSize)
%
% yC:           Command input sequenze row vector
% yR:           Reference sequenze row vector
% frSize:       Frame size --> size(MATRIX) = frSize x frSize
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Check function arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p = inputParser;

    valSeq = @(x) isnumeric(x) && isrow(x) && ~isscalar(x);

    addRequired(p,'yC',valSeq);
    addRequired(p,'yR',valSeq);
    addOptional(p,'frSize', -1, @isnumeric);

    parse(p,yC,yR,varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
ds = evalin('base','ds');

R = yR;
C = yC;
    
if abs(length(R)-length(C)) > 0
    warning('different seqence length')
	C = C(1:min(length(R),length(C)));
	R = R(1:min(length(R),length(C)));
end
% --------------------------------------------------------------------------
% klassifizierte Sequenzen in Symbolpakete aufteilen und munkres anwenden
% --------------------------------------------------------------------------
if p.Results.frSize < 0
    SYMPACLEN = max(size(R));
else
    SYMPACLEN = p.Results.frSize;
end

NPACS = round(length(R) / SYMPACLEN);
% --------------------------------------------------------------------------
%   MODUS = 0:  -->     differenzen der Abtastzeitpunkte werden direkt
%                       als Kostenmatrix an munkres übergeben
%   MODUS = 1:  -->     Klassifizierung in |min|R|max|F| und
%                       anschließen an munkres übergeben
% --------------------------------------------------------------------------
    MODUS = 1;
% --------------------------------------------------------------------------
MATRIX{SYMPACLEN, SYMPACLEN, NPACS} = [];

ctr = 1;

while ctr<NPACS
    makeCost = zeros(1,NPACS);

    A = zeros(SYMPACLEN, SYMPACLEN);
    % --------------------------------------------------------------------------
    if MODUS == 1
    % --------------------------------------------------------------------------
        for k=1:NPACS
            tic
            for m=1:SYMPACLEN
                for n=1:SYMPACLEN
                    try
                        mi = m+(k-1)*NPACS;
                        ni = n+(k-1)*NPACS;
                        A(m,n)=abs(R(mi)-C(ni));
    %                   fprintf('AA(%i,%i)=abs(R(%i)-C(%i))\n',mi,ni,mi,ni);
                    catch err
                        disp(err)
                    end
                end
            end
            makeCost(k) = toc;
            ctr = ctr + 1;

            MATRIX{ctr} = A;
    %         A = zeros(SYMPACLEN, SYMPACLEN);
        end
    end
% --------------------------------------------------------------------------
    

% --------------------------------------------------------------------------
    if MODUS == 1
        for k=1:NPACS
% --------------------------------------------------------------------------
            if round(A(1,1:10)) == A(1,1:10);   % ganzzahlig --> klassifiziert
                for m=1:SYMPACLEN
                    for n=1:SYMPACLEN
                %        aa(i,j)=mod(s2(i),s1(j));
                        mi = m+(k-1)*NPACS;
                        ni = n+(k-1)*NPACS;
                        switch(abs(R(mi)-C(ni)))
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
            else
                if k==1
                    fprintf('%s\n%s\nSignal is not classified\n%s\n%s\n',...
                        ds,ds,ds,ds)
                end
            end
        end
% --------------------------------------------------------------------------

        MATRIX{ctr} = A;
%         A = zeros(SYMPACLEN, SYMPACLEN);
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