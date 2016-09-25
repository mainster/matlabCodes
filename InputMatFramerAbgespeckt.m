function [MATRIX] = InputMatFramerAbgespeckt(C, R, len)
%% 10-12-2014
% Was macht Munkres?

%% test 1
% ref -> x1
% x2 = x1 verschoben
% m1 = inputMatFramer (abgespeckte variante)
% munkres(m1) -> cost=0 obwohl verschoben

%% test 2
% ref -> x1
% x2 = x1 verschoben
% x2(524) = x2(524) + 3.3
% m1 = inputMatFramer (abgespeckte variante)
% munkres(m1) -> cost=3.3


MODUS=1;
NPACS=1;
SYMPACLEN=len;
ctr = 1;
ds = '--';
A = zeros(10, 10);

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

            MATRIX = A;
    %         A = zeros(SYMPACLEN, SYMPACLEN);
        end
    end
% --------------------------------------------------------------------------
    

% --------------------------------------------------------------------------
    if MODUS == 0
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